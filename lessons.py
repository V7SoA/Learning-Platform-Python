from flask import Blueprint, request, jsonify, session
from database import query
import json

lessons_bp = Blueprint('lessons', __name__)

@lessons_bp.route('/languages', methods=['GET'])
def get_languages():
    languages = query('SELECT * FROM languages', fetchall=True)
    return jsonify(languages)

@lessons_bp.route('/language/<slug>', methods=['GET'])
def get_language(slug):
    lang = query('SELECT * FROM languages WHERE slug=%s', (slug,), fetchone=True)
    if not lang:
        return jsonify({'error': 'Language not found'}), 404
    lessons = query('SELECT * FROM lessons WHERE language_id=%s ORDER BY lesson_order', (lang['id'],), fetchall=True)
    user_id = session.get('user_id')
    if user_id:
        for lesson in lessons:
            progress = query('SELECT completed, score FROM user_progress WHERE user_id=%s AND lesson_id=%s', (user_id, lesson['id']), fetchone=True)
            lesson['completed'] = bool(progress['completed']) if progress else False
            lesson['score'] = progress['score'] if progress else 0
    return jsonify({'language': lang, 'lessons': lessons})

@lessons_bp.route('/lesson/<int:lesson_id>', methods=['GET'])
def get_lesson(lesson_id):
    lesson = query('SELECT * FROM lessons WHERE id=%s', (lesson_id,), fetchone=True)
    if not lesson:
        return jsonify({'error': 'Lesson not found'}), 404
    questions = query('SELECT * FROM questions WHERE lesson_id=%s ORDER BY question_order', (lesson_id,), fetchall=True)
    for q in questions:
        if q.get('options') and isinstance(q['options'], str):
            q['options'] = json.loads(q['options'])
    return jsonify({'lesson': lesson, 'questions': questions})

@lessons_bp.route('/lesson/<int:lesson_id>/story', methods=['GET'])
def get_lesson_story(lesson_id):
    lesson = query(
        'SELECT l.*, lg.name as lang_name, lg.icon as lang_icon FROM lessons l JOIN languages lg ON l.language_id = lg.id WHERE l.id=%s',
        (lesson_id,), fetchone=True
    )
    if not lesson:
        return jsonify({'error': 'Lesson not found'}), 404
    return jsonify({
        'lesson_id': lesson_id,
        'title': lesson['title'],
        'language': lesson['lang_icon'] + ' ' + lesson['lang_name'],
        'story': lesson.get('story_text') or '[STORY] Welcome to this lesson!\n[CONCEPT] Get ready to learn something great.\n[CODE] ```\n# Code examples in the lesson\n```\n[TAKEAWAY] Every expert was once a beginner. You have got this!'
    })

@lessons_bp.route('/lesson/<int:lesson_id>/complete', methods=['POST'])
def complete_lesson(lesson_id):
    user_id = session.get('user_id')
    if not user_id:
        return jsonify({'error': 'Not logged in'}), 401
    data = request.json
    score = data.get('score', 0)
    lesson = query('SELECT * FROM lessons WHERE id=%s', (lesson_id,), fetchone=True)
    if not lesson:
        return jsonify({'error': 'Lesson not found'}), 404
    existing = query('SELECT id FROM user_progress WHERE user_id=%s AND lesson_id=%s', (user_id, lesson_id), fetchone=True)
    if existing:
        query('UPDATE user_progress SET completed=TRUE, score=%s, completed_at=NOW() WHERE user_id=%s AND lesson_id=%s', (score, user_id, lesson_id))
    else:
        query('INSERT INTO user_progress (user_id, lesson_id, completed, score, completed_at) VALUES (%s, %s, TRUE, %s, NOW())', (user_id, lesson_id, score))
    xp_earned = lesson['xp_reward']
    query('UPDATE users SET xp = xp + %s, last_activity = CURDATE() WHERE id=%s', (xp_earned, user_id))
    user = query('SELECT xp, streak FROM users WHERE id=%s', (user_id,), fetchone=True)
    return jsonify({'message': 'Lesson complete!', 'xp_earned': xp_earned, 'total_xp': user['xp']})
