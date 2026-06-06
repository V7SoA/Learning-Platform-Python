from flask import Flask, send_from_directory
from flask_cors import CORS
from config import Config
from database import init_db
import os

app = Flask(__name__)
app.config.from_object(Config)
CORS(app)

init_db(app)

from routes.auth import auth_bp
from routes.lessons import lessons_bp
from routes.chatbot import chatbot_bp
from routes.compiler import compiler_bp
from routes.progress import progress_bp
from routes.admin import admin_bp

app.register_blueprint(auth_bp, url_prefix='/api/auth')
app.register_blueprint(lessons_bp, url_prefix='/api/lessons')
app.register_blueprint(chatbot_bp, url_prefix='/api/chat')
app.register_blueprint(compiler_bp, url_prefix='/api/compiler')
app.register_blueprint(progress_bp, url_prefix='/api/progress')
app.register_blueprint(admin_bp)

TEMPLATE_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'templates')

@app.route('/')
def index():
    return send_from_directory(TEMPLATE_DIR, 'index.html')

@app.route('/<path:path>')
def serve_static(path):
    static_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'static', path)
    if os.path.exists(static_path):
        return send_from_directory(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'static'), path)
    return send_from_directory(TEMPLATE_DIR, 'index.html')

if __name__ == '__main__':
    app.run(debug=True, port=5000)
