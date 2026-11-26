#!/usr/bin/env python3
"""Local FPGA teaching workbench. Standard library + Icarus Verilog."""
import bisect, hashlib, json, pathlib, re, shutil, subprocess, tempfile, threading
from http.server import ThreadingHTTPServer, SimpleHTTPRequestHandler
ROOT = pathlib.Path(__file__).resolve().parent
CACHE = pathlib.Path(tempfile.mkdtemp(prefix='fpga-lab-cache-'))
COMPILE_LOCK = threading.Lock()
SIM_LOCK = threading.Semaphore(2)
MAX_EVENTS = 16384


def execute(args, cwd, timeout=15):
    try:
        p = subprocess.run(args, cwd=cwd, capture_output=True, text=True, timeout=timeout)
    except subprocess.TimeoutExpired:
        raise ValueError('仿真超过 15 秒；请检查组合环路、无限循环或减少运行周期。')
    if p.returncode:
        raise ValueError((p.stderr + p.stdout)[-16000:])
    return p.stdout, p.stderr


def parse_vcd(text):
    scopes, signals, changes = [], [], {}
    scale = re.search(r'\$timescale\s+(\d+)\s*(s|ms|us|ns|ps|fs)\s+\$end', text)
    unit = int(scale[1]) * {'s': 1e9, 'ms': 1e6, 'us': 1e3, 'ns': 1, 'ps': .001, 'fs': .000001}[scale[2]] if scale else 1
    header, time = True, 0
    for line in text.splitlines():
        line = line.strip()
        if header:
            a = line.split()
            if a[:1] == ['$scope']: scopes.append(a[2])
            elif a[:1] == ['$upscope']: scopes.pop()
            elif a[:1] == ['$var']:
                signals.append({'name': '.'.join(scopes + [a[4]]), 'width': int(a[2]), 'id': a[3], 'kind': a[1]})
                changes.setdefault(a[3], [])
            elif line.startswith('$enddefinitions'): header = False
            continue
        if line.startswith('#'):
            time = int(line[1:]) * unit
            continue
        m = re.fullmatch(r'([01xz])(.+)', line, re.I) or re.fullmatch(r'b([01xz]+)\s+(\S+)', line, re.I)
        if not m or m[2] not in changes: continue
        entries, value = changes[m[2]], m[1].lower()
        if entries and entries[-1][0] == time: entries[-1] = [time, value]
        elif not entries or entries[-1][1] != value: entries.append([time, value])
    return signals, changes


def simulate(q):
    if not shutil.which('iverilog') or not shutil.which('vvp'):
        raise ValueError('缺少 Icarus Verilog，请安装后启动。macOS: brew install icarus-verilog')
    code, events, profile = q.get('code', ''), q.get('events', []), q.get('profile', 'teaching')
    if profile not in ('teaching', 'basys3'): raise ValueError('未知板卡接口模式')
    if not isinstance(code, str) or len(code.encode()) > 1000000: raise ValueError('代码上限 1 MB')
    if not events or len(events) > MAX_EVENTS: raise ValueError(f'输入记录必须为 1–{MAX_EVENTS} 个事件')
    checked = []
    for e in events:
        values = {k: int(e.get(k, 0)) for k in ('sw', 'btn', 'reset', 'tick')}
        if not (0 <= values['sw'] <= 65535 and 0 <= values['btn'] <= 31 and values['reset'] in (0, 1) and values['tick'] in (0, 1)):
            raise ValueError('开关、按键、复位或时钟值越界')
        checked.append(values)
    program = q.get('program', '')
    if not isinstance(program, str) or len(program) > 20000: raise ValueError('程序镜像过大')
    if program and not all(re.fullmatch(r'(?:[0-9a-fA-F]{1,8}|@[0-9a-fA-F]{1,8})', x) for x in program.split()):
        raise ValueError('程序镜像仅支持空白分隔的十六进制机器字与 @地址')
    if profile == 'teaching':
        pins = 'wire [15:0] led; wire [31:0] display;\nboard_top dut(.clk(clk),.reset(reset),.sw(sw),.btn(btn),.led(led),.display(display));'
    else:
        pins = 'wire [15:0] led; wire [6:0] seg; wire [3:0] an; wire dp;\nbasys_top dut(.clk(clk),.sw(sw),.btnC(btn[0]),.btnU(btn[1]),.btnL(btn[2]),.btnR(btn[3]),.btnD(btn[4]),.led(led),.seg(seg),.an(an),.dp(dp));'
    # Cache the design binary; stimuli live in a text file and are replayed by $fscanf.
    fmt = '%b %b' if profile == 'teaching' else '%b %b %b %b'
    args = 'led,display' if profile == 'teaching' else 'led,seg,an,dp'
    tb = '''`timescale 1ns/1ps
module tb;
reg clk,reset; reg [15:0] sw; reg [4:0] btn;
integer f,rc,i=0,tick; real stamp;
''' + pins + '''
initial begin
 $dumpfile("wave.vcd"); $dumpvars(0,tb);
 f=$fopen("events.txt","r");
 #1; clk=0; reset=0;
 while(!$feof(f)) begin
  rc=$fscanf(f,"%d %d %d %d\\n",sw,btn,reset,tick);
  if(rc==4) begin
   if(tick) begin clk=0; #4.999; clk=1; #5; clk=0; #0.001; end
   else begin #1; end
   $display("SAMPLE %0d %.3f ''' + fmt + '",i,$realtime,' + args + ''');
   i=i+1;
  end
 end
 $fclose(f); $finish;
end
endmodule
'''
    key = hashlib.sha256((code + tb).encode()).hexdigest()
    compiled = CACHE / key
    with COMPILE_LOCK:
        if not compiled.exists():
            with tempfile.TemporaryDirectory() as d:
                p = pathlib.Path(d)
                (p / 'design.sv').write_text(code)
                (p / 'tb.sv').write_text(tb)
                _, warnings = execute(['iverilog', '-g2012', '-Wall', '-s', 'tb', '-o', 'sim', 'design.sv', 'tb.sv'], d)
                shutil.copy(p / 'sim', compiled)
                (CACHE / (key + '.warnings')).write_text(warnings)
    with SIM_LOCK, tempfile.TemporaryDirectory() as d:
        p = pathlib.Path(d)
        (p / 'events.txt').write_text('\n'.join(' '.join(str(e[k]) for k in ('sw', 'btn', 'reset', 'tick')) for e in checked) + '\n')
        if program: (p / 'program.hex').write_text(program)
        stdout, warnings = execute(['vvp', str(compiled)], d)
        if any(line.startswith(('ERROR:', 'FATAL:')) for line in stdout.splitlines()):
            raise ValueError('RTL 运行错误 / 断言失败：\n' + stdout[-12000:])
        wave = p / 'wave.vcd'
        if not wave.exists(): raise ValueError('设计没有产生波形')
        if wave.stat().st_size > 32000000: raise ValueError('波形超过 32 MB，请减少周期或跟踪信号；本次不会返回截断波形。')
        vcd = wave.read_text()
        samples = []
        for line in stdout.splitlines():
            a = line.split()
            if a[:1] != ['SAMPLE']: continue
            sample = {'index': int(a[1]), 'time': float(a[2]), 'led': a[3].zfill(16)}
            if profile == 'teaching': sample['display'] = a[4].zfill(32)
            else: sample.update(seg=a[4].zfill(7), an=a[5].zfill(4), dp=a[6])
            samples.append(sample)
        if len(samples) != len(events): raise ValueError('设计提前终止，或输出了错误的采样记录。请移除 $finish/$stop 等测试平台语句。')
        signals, changes = parse_vcd(vcd)
        internal = [s for s in signals if s['name'].startswith('tb.dut.')]
        by_name = {s['name']: s for s in internal}
        # Compact per-sample snapshots: values for scalar RTL state and debug aliases.
        watch = q.get('watch', [])
        if not isinstance(watch, list) or len(watch)>512 or not all(isinstance(n,str) for n in watch):
            raise ValueError('watch 应为最多 512 个信号名称的数组')
        def priority(signal):
            name=signal['name']
            if any(name==n or name.endswith('.'+n) for n in watch): return 0
            return 1 if signal['kind'] in ('reg','integer') or '.dbg_' in name else 2
        state_signals = sorted(internal, key=priority)
        truncated = len(state_signals) > 512
        if truncated: state_signals = state_signals[:512]
        sample_times = [s['time'] for s in samples]
        states = [{} for _ in samples]
        for signal in state_signals:
            arr = changes.get(signal['id'], [])
            times = [v[0] for v in arr]
            for i, t in enumerate(sample_times):
                ix = bisect.bisect_right(times, t + .0000001) - 1
                v = arr[ix][1] if ix >= 0 else 'x'
                states[i][signal['name']] = v.rjust(signal['width'], v[0] if v[0] in 'xz' else '0')
        for i, s in enumerate(samples): s['state'] = states[i]
        return {'samples': samples, 'vcd': vcd, 'signals': signals,
                'warnings': ((CACHE / (key + '.warnings')).read_text() + warnings)[-12000:],
                'log': stdout[-3000:], 'profile': profile, 'clockPeriodNs': 10,
                'stateSignalsTruncated': truncated, 'maxEvents': MAX_EVENTS}


class Handler(SimpleHTTPRequestHandler):
    def __init__(self, *a, **kw): super().__init__(*a, directory=str(ROOT), **kw)
    def do_GET(self):
        if self.path == '/api/health':
            self.reply(200, {'ok': True, 'app': 'gbu-cs301', 'workspace': hashlib.sha256(str(ROOT).encode()).hexdigest()[:20], 'iverilog': bool(shutil.which('iverilog')), 'vvp': bool(shutil.which('vvp')), 'version': '2.0'})
        else: super().do_GET()
    def end_headers(self):
        self.send_header('Cache-Control', 'no-cache')
        super().end_headers()
    def do_POST(self):
        if self.path != '/api/sim': self.send_error(404); return
        try:
            length = int(self.headers.get('Content-Length', 0))
            if length < 1 or length > 4000000: raise ValueError('请求上限 4 MB')
            self.reply(200, simulate(json.loads(self.rfile.read(length))))
        except Exception as e: self.reply(400, {'error': str(e)})
    def reply(self, status, obj):
        body = json.dumps(obj).encode()
        self.send_response(status); self.send_header('Content-Type', 'application/json; charset=utf-8')
        self.send_header('Content-Length', str(len(body))); self.end_headers(); self.wfile.write(body)


class LocalServer(ThreadingHTTPServer):
    request_queue_size = 64
    daemon_threads = True


if __name__ == '__main__':
    print('FPGA Lab 2 · http://127.0.0.1:8766', flush=True)
    try: LocalServer(('127.0.0.1', 8766), Handler).serve_forever()
    finally: shutil.rmtree(CACHE, ignore_errors=True)
