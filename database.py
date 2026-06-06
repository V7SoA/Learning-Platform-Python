import mysql.connector
from flask import g, current_app

def init_db(app):
    """Register database teardown with the app."""
    @app.teardown_appcontext
    def close_db(error):
        db = g.pop('db', None)
        if db is not None:
            db.close()

def get_db():
    """Get or create a database connection for this request."""
    if 'db' not in g:
        g.db = mysql.connector.connect(
            host=current_app.config['MYSQL_HOST'],
            user=current_app.config['MYSQL_USER'],
            password=current_app.config['MYSQL_PASSWORD'],
            database=current_app.config['MYSQL_DB'],
            autocommit=True
        )
    # Reconnect if connection dropped
    if not g.db.is_connected():
        g.db.reconnect()
    return g.db

def query(sql, params=None, fetchone=False, fetchall=False):
    """Helper to run SQL and return results."""
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute(sql, params or ())
    if fetchone:
        result = cursor.fetchone()
    elif fetchall:
        result = cursor.fetchall()
    else:
        result = cursor.lastrowid
    cursor.close()
    return result
