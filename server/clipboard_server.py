import os
import json
import threading
import time
from flask import Flask, request, jsonify
from datetime import datetime

app = Flask(__name__)

# 文件路径
CONFIG_FILE = "clipboard_config.json"
CONTENT_FILE = "clipboard_content.txt"


# 配置读写
def load_config():
    """加载或创建配置文件"""
    default = {"port": 5000, "max_history": 10, "password": ""}
    if os.path.exists(CONFIG_FILE):
        try:
            with open(CONFIG_FILE, "r", encoding="utf-8") as f:
                return json.load(f)
        except Exception:
            pass
    # 创建并写入默认值
    with open(CONFIG_FILE, "w", encoding="utf-8") as f:
        json.dump(default, f, indent=2)
    return default


def save_config():
    """把当前内存配置写回文件"""
    with open(CONFIG_FILE, "w", encoding="utf-8") as f:
        json.dump(config, f, indent=2)


# shared_content 持久化
def load_content():
    """启动时恢复 shared_content"""
    if os.path.exists(CONTENT_FILE):
        try:
            with open(CONTENT_FILE, "r", encoding="utf-8") as f:
                return f.read()
        except Exception:
            pass
    return ""


def save_content(text: str):
    """实时保存 shared_content"""
    with open(CONTENT_FILE, "w", encoding="utf-8") as f:
        f.write(text)


# 初始化
config = load_config()
shared_content = load_content()  # 启动时恢复 shared_content
last_updated = datetime.now().isoformat()
clients = {}
history = []
lock = threading.Lock()


# 历史记录
def add_history(content):
    global history
    history.append({"content": content, "timestamp": datetime.now().isoformat()})
    if len(history) > config["max_history"]:
        history = history[-config["max_history"] :]


# API
@app.route("/clipboard", methods=["GET"])
def get_clipboard():
    client_id = request.args.get("client_id", "unknown")
    with lock:
        clients[client_id] = datetime.now().isoformat()
    return jsonify({"content": shared_content, "last_updated": last_updated})


@app.route("/clipboard", methods=["POST"])
def update_clipboard():
    global shared_content, last_updated

    if config["password"]:
        if request.headers.get("X-Auth-Password", "") != config["password"]:
            return jsonify({"status": "error", "message": "Invalid password"}), 401

    data = request.get_json()
    if not data or "content" not in data:
        return jsonify({"status": "error", "message": "Missing content"}), 400

    new_content = data["content"]
    client_id = data.get("client_id", "unknown")

    with lock:
        shared_content = new_content
        last_updated = datetime.now().isoformat()
        clients[client_id] = last_updated
        add_history(new_content)
        save_content(new_content)

    return jsonify({"status": "success", "last_updated": last_updated})


@app.route("/history", methods=["GET"])
def get_history():
    return jsonify({"history": history})


@app.route("/clients", methods=["GET"])
def get_clients():
    return jsonify({"clients": clients})


@app.route("/status", methods=["GET"])
def get_status():
    return jsonify(
        {
            "status": "running",
            "last_updated": last_updated,
            "clients_count": len(clients),
            "history_count": len(history),
        }
    )


# 后台线程，清理不活跃客户端
def clean_inactive_clients():
    while True:
        time.sleep(60)
        now = datetime.now()
        with lock:
            cutoff = [
                cid
                for cid, lst in clients.items()
                if (now - datetime.fromisoformat(lst)).total_seconds() > 300
            ]
            for cid in cutoff:
                del clients[cid]


# 入口
if __name__ == "__main__":
    threading.Thread(target=clean_inactive_clients, daemon=True).start()
    port = config["port"]
    print(f"Starting clipboard sharing server on port {port} ...")
    app.run(host="0.0.0.0", port=port, threaded=True)
