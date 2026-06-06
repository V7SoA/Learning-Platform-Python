from flask import Blueprint, jsonify, session
from database import query

progress_bp = Blueprint('progress', __name__)

@progress_bp.route('/dashboard', methods=['GET'])
def dashboard():
    user_id = session.get('user_id')
    if not user_id:
        return jsonify({'error': 'Not logged in'}), 401

    user = query('SELECT username, xp, streak FROM users WHERE id=%s', (user_id,), fetchone=True)
    completed = query(
        'SELECT COUNT(*) as count FROM user_progress WHERE user_id=%s AND completed=TRUE',
        (user_id,), fetchone=True
    )
    langs = query('''
        SELECT l.name, l.slug, l.icon, l.color, l.total_lessons,
               COUNT(up.id) as completed_lessons
        FROM languages l
        LEFT JOIN lessons ls ON ls.language_id = l.id
        LEFT JOIN user_progress up ON up.lesson_id = ls.id AND up.user_id=%s AND up.completed=TRUE
        GROUP BY l.id
    ''', (user_id,), fetchall=True)

    return jsonify({
        'user': user,
        'lessons_completed': completed['count'],
        'languages': langs
    })
