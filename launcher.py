"""BrowserRMBG 桌面启动器

被 PyInstaller 打包成 Windows exe 后：
- 启动时把内置的 dist-demo 静态资源目录用本地 HTTP 服务器提供出来
- 自动打开系统默认浏览器（Edge/Chrome）访问该地址
- browser-rmbg 是纯前端 WebGPU 应用，在系统浏览器里运行可获得最成熟的 WebGPU 支持

注意：PyInstaller 打包时使用 --add-data "dist-demo:dist-demo"，
运行时静态资源位于 sys._MEIPASS/dist-demo；未打包时回退到脚本同级的 dist-demo。
"""

import http.server
import socketserver
import threading
import webbrowser
import os
import sys


class Handler(http.server.SimpleHTTPRequestHandler):
    """确保 .wasm 以正确的 MIME 返回（onnxruntime-web 需要）"""

    def guess_type(self, path):
        if path.lower().endswith(".wasm"):
            return "application/wasm"
        return super().guess_type(path)

    def log_message(self, format, *args):
        pass  # 静默日志，避免刷屏


def resource_path(relative: str) -> str:
    base = getattr(sys, "_MEIPASS", os.path.dirname(os.path.abspath(__file__)))
    return os.path.join(base, relative)


def main():
    print("BrowserRMBG 启动中 ...")
    dist_dir = resource_path("dist-demo")
    if not os.path.isdir(dist_dir):
        print("错误：未找到打包的静态资源目录 dist-demo")
        input("按回车退出 ...")
        return

    os.chdir(dist_dir)

    PORT = 8765
    httpd = socketserver.TCPServer(("127.0.0.1", PORT), Handler)
    url = f"http://127.0.0.1:{PORT}/"
    print(f"本地服务已启动：{url}")

    threading.Thread(target=httpd.serve_forever, daemon=True).start()

    try:
        webbrowser.open(url)
        print("已为你打开浏览器，请在浏览器中使用去背景工具。")
    except Exception:
        print(f"自动打开浏览器失败，请手动访问：{url}")

    try:
        input("服务运行中。关闭此窗口或按回车即可退出。")
    except KeyboardInterrupt:
        pass
    finally:
        httpd.shutdown()


if __name__ == "__main__":
    main()
