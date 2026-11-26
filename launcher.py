#!/usr/bin/env python3
"""Open a course page only after a matching local service is ready."""
import argparse
import hashlib
import importlib.util
import json
import pathlib
import shutil
import socket
import threading
import time
import urllib.error
import urllib.request
import webbrowser

ROOT = pathlib.Path(__file__).resolve().parent
APP_ID = 'gbu-cs301'
WORKSPACE = hashlib.sha256(str(ROOT).encode()).hexdigest()[:20]
PAGES = {'workbench': '/', 'learn': '/learn.html', 'anatomy': '/learn.html?inside=board', 'game': '/gbu-game/'}

def request(base, path):
    # Loopback startup must not be routed through a configured HTTP proxy.
    opener = urllib.request.build_opener(urllib.request.ProxyHandler({}))
    with opener.open(base + path, timeout=0.8) as response:
        return response.read(8_000_001)

def identify(base, root=ROOT):
    """ready, foreign, or unresponsive; never stop an existing service."""
    try:
        health = json.loads(request(base, '/api/health'))
    except (urllib.error.HTTPError, ValueError):
        return 'foreign'
    except (OSError, urllib.error.URLError):
        return 'unresponsive'
    if not isinstance(health, dict) or health.get('ok') is not True:
        return 'foreign'
    if 'app' in health or 'workspace' in health:
        expected = hashlib.sha256(str(root.resolve()).encode()).hexdigest()[:20]
        return 'ready' if health.get('app') == APP_ID and health.get('workspace') == expected else 'foreign'
    # Compatibility with an already running pre-launcher course server. It has
    # no workspace identity, so require both current source files to match.
    if health.get('version') != '2.0':
        return 'foreign'
    try:
        for name in ['learn.html', 'server.py']:
            if hashlib.sha256(request(base, '/' + name)).digest() != hashlib.sha256((root / name).read_bytes()).digest():
                return 'foreign'
    except (OSError, urllib.error.URLError):
        return 'foreign'
    return 'ready'

def port_in_use(port):
    with socket.socket() as probe:
        probe.settimeout(0.3)
        return probe.connect_ex(('127.0.0.1', port)) == 0

def wait_ready(base, timeout=12):
    deadline = time.monotonic() + timeout
    while time.monotonic() < deadline:
        status = identify(base)
        if status == 'ready':
            return True
        if status == 'foreign':
            return False
        time.sleep(0.08)
    return False

def open_page(url, enabled):
    print('课程实验室已就绪：' + url, flush=True)
    if enabled:
        try:
            if not webbrowser.open(url):
                print('请复制上方地址到浏览器。', flush=True)
        except Exception:
            print('请复制上方地址到浏览器。', flush=True)

def main(argv=None):
    parser = argparse.ArgumentParser(description='启动GBU-CS301课程实验室')
    parser.add_argument('--page', choices=PAGES, default='anatomy')
    parser.add_argument('--port', type=int, default=8766)
    parser.add_argument('--no-browser', action='store_true')
    parser.add_argument('--check', action='store_true', help='仅检查当前课程服务，不启动或打开浏览器')
    args = parser.parse_args(argv)
    if not 0 <= args.port <= 65535:
        parser.error('端口须为0…65535；0仅供自动分配测试端口')
    base = 'http://127.0.0.1:' + str(args.port)
    if args.port and port_in_use(args.port):
        if wait_ready(base, timeout=3):
            open_page(base + PAGES[args.page], not args.no_browser and not args.check)
            return 0
        print('此端口不是当前课程服务，或服务未响应。未打开页面、未停止任何程序。请使用 --port 另选端口。', flush=True)
        return 1
    if args.check:
        print('课程服务尚未启动。请双击对应启动器。', flush=True)
        return 1
    spec = importlib.util.spec_from_file_location('cs301_launch_server', ROOT / 'server.py')
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    service = None
    try:
        try:
            service = module.LocalServer(('127.0.0.1', args.port), module.Handler)
        except OSError:
            # A second launcher may have won the bind while this one imported.
            if args.port and wait_ready(base, timeout=3):
                open_page(base + PAGES[args.page], not args.no_browser)
                return 0
            print('无法启动课程服务：端口已占用或不可用。未打开页面。', flush=True)
            return 1
        base = 'http://127.0.0.1:' + str(service.server_address[1])
        worker = threading.Thread(target=service.serve_forever, daemon=True)
        worker.start()
        if not wait_ready(base):
            print('课程服务未能就绪，未打开页面。请查看本窗口中的错误。', flush=True)
            return 1
        open_page(base + PAGES[args.page], not args.no_browser)
        print('保留本窗口以继续使用；按 Ctrl+C 停止本次启动的服务。', flush=True)
        try:
            worker.join()
        except KeyboardInterrupt:
            print('\n本次课程服务已停止。', flush=True)
        return 0
    finally:
        if service is not None:
            service.shutdown()
            service.server_close()
        shutil.rmtree(module.CACHE, ignore_errors=True)

if __name__ == '__main__':
    raise SystemExit(main())
