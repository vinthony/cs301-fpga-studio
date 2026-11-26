#!/usr/bin/env python3
import contextlib,hashlib,importlib.util,io,json,pathlib,queue,re,signal,subprocess,sys,threading,unittest,urllib.request
from http.server import BaseHTTPRequestHandler,ThreadingHTTPServer
from unittest.mock import patch
ROOT=pathlib.Path(__file__).resolve().parents[1]
spec=importlib.util.spec_from_file_location('course_launcher',ROOT/'launcher.py');launch=importlib.util.module_from_spec(spec);spec.loader.exec_module(launch)

class Fixture:
 def __init__(self,health,files=None):
  files=files or {}
  class Handler(BaseHTTPRequestHandler):
   def do_GET(self):
    body=json.dumps(health).encode() if self.path=='/api/health' else files.get(self.path)
    if body is None:self.send_error(404);return
    self.send_response(200);self.send_header('Content-Length',str(len(body)));self.end_headers();self.wfile.write(body)
   def log_message(self,*args):pass
  self.server=ThreadingHTTPServer(('127.0.0.1',0),Handler);self.thread=threading.Thread(target=self.server.serve_forever,daemon=True);self.thread.start();self.port=self.server.server_address[1];self.base='http://127.0.0.1:'+str(self.port)
 def __enter__(self):return self
 def __exit__(self,*args):self.server.shutdown();self.server.server_close();self.thread.join()

class LaunchChecks(unittest.TestCase):
 def test_exact_identity(self):
  with Fixture({'ok':True,'app':launch.APP_ID,'workspace':launch.WORKSPACE}) as f:self.assertEqual(launch.identify(f.base),'ready')
 def test_foreign_and_wrong_workspace_never_open(self):
  for health in [{'ok':True,'app':'other','workspace':launch.WORKSPACE},{'ok':True,'app':launch.APP_ID,'workspace':'different-copy'},{'ok':False}]:
   with Fixture(health) as f,patch.object(launch.webbrowser,'open') as browser,contextlib.redirect_stdout(io.StringIO()):
    self.assertEqual(launch.main(['--port',str(f.port)]),1);browser.assert_not_called();self.assertEqual(launch.identify(f.base),'foreign')
 def test_legacy_content_verified(self):
  files={'/'+name:(ROOT/name).read_bytes() for name in ['learn.html','server.py']}
  with Fixture({'ok':True,'version':'2.0'},files) as f:self.assertEqual(launch.identify(f.base),'ready')
  files['/learn.html']=b'wrong course'
  with Fixture({'ok':True,'version':'2.0'},files) as f:self.assertEqual(launch.identify(f.base),'foreign')
 def test_fresh_start_and_reuse(self):
  proc=subprocess.Popen([sys.executable,str(ROOT/'launcher.py'),'--port','0','--page','anatomy','--no-browser'],stdout=subprocess.PIPE,stderr=subprocess.PIPE,text=True)
  try:
   lines=queue.Queue();threading.Thread(target=lambda:lines.put(proc.stdout.readline()),daemon=True).start();line=lines.get(timeout=12);match=re.search(r'http://127\.0\.0\.1:(\d+)/learn\.html\?inside=board',line);self.assertIsNotNone(match,line);port=match[1];base='http://127.0.0.1:'+port
   health=json.loads(launch.request(base,'/api/health'));self.assertEqual(health['app'],launch.APP_ID);self.assertEqual(health['workspace'],launch.WORKSPACE);self.assertTrue(health['ok']);self.assertIn('vvp',health)
   reuse=subprocess.run([sys.executable,str(ROOT/'launcher.py'),'--port',port,'--page','learn','--check','--no-browser'],capture_output=True,text=True,timeout=8);self.assertEqual(reuse.returncode,0,reuse.stderr);self.assertIn('/learn.html',reuse.stdout);self.assertIsNone(proc.poll());self.assertEqual(launch.identify(base),'ready')
   proc.send_signal(signal.SIGINT);out,err=proc.communicate(timeout=8);self.assertEqual(proc.returncode,0,err);self.assertIn('服务已停止',out)
  finally:
   if proc.poll() is None:proc.kill();proc.communicate(timeout=5)
 def test_existing_current_service_check(self):
  with Fixture({'ok':True,'app':launch.APP_ID,'workspace':launch.WORKSPACE}) as f,patch.object(launch.webbrowser,'open') as browser,contextlib.redirect_stdout(io.StringIO()):
   self.assertEqual(launch.main(['--port',str(f.port),'--check','--no-browser']),0);browser.assert_not_called()

if __name__=='__main__':unittest.main(verbosity=2)
