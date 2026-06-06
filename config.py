import os

class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY', 'codequest-secret-key-change-in-production')
    
    # MySQL Configuration — update these with your credentials
    MYSQL_HOST = os.environ.get('MYSQL_HOST', 'localhost')
    MYSQL_USER = os.environ.get('MYSQL_USER', 'root')
    MYSQL_PASSWORD = os.environ.get('MYSQL_PASSWORD', 'root')  # ← Put your MySQL password here
    MYSQL_DB = os.environ.get('MYSQL_DB', 'codequest')
    
    # Ollama Configuration
    OLLAMA_HOST = os.environ.get('OLLAMA_HOST', 'http://localhost:11434')
    OLLAMA_MODEL = os.environ.get('OLLAMA_MODEL', 'llama3.2')
    
    # Session
    SESSION_TYPE = 'filesystem'
    PERMANENT_SESSION_LIFETIME = 86400  # 1 day
