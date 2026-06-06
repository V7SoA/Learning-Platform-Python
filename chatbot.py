from flask import Blueprint, request, jsonify, session, current_app
import requests
from database import query

chatbot_bp = Blueprint('chatbot', __name__)

SYSTEM_PROMPT = """You are CodeQuest AI, a friendly and encouraging programming tutor inside a Duolingo-style learning app.

Your personality:
- Warm, patient, and encouraging like a great teacher
- Use simple language for beginners
- Give short, clear explanations with examples
- Use emojis occasionally to keep it fun 🎉
- When explaining code, always use code blocks
- If someone is struggling, offer a simpler explanation
- Celebrate correct answers and progress

Topics you help with: Python, JavaScript, SQL, HTML/CSS, Java, and general programming concepts.

Keep responses concise (2-4 paragraphs max) unless a detailed explanation is needed."""

@chatbot_bp.route('/send', methods=['POST'])
def send_message():
    data = request.json
    user_message = data.get('message', '').strip()
    if not user_message:
        return jsonify({'error': 'Empty message'}), 400

    user_id = session.get('user_id')
    
    # Build conversation history
    messages = []
    if user_id:
        history = query(
            'SELECT role, message FROM chat_history WHERE user_id=%s ORDER BY created_at DESC LIMIT 10',
            (user_id,), fetchall=True
        )
        for h in reversed(history):
            messages.append({'role': h['role'], 'content': h['message']})

    messages.append({'role': 'user', 'content': user_message})

    ollama_host = current_app.config['OLLAMA_HOST']
    model = current_app.config['OLLAMA_MODEL']

    try:
        response = requests.post(
            f'{ollama_host}/api/chat',
            json={
                'model': model,
                'messages': [{'role': 'system', 'content': SYSTEM_PROMPT}] + messages,
                'stream': False
            },
            timeout=220
        )
        response.raise_for_status()
        result = response.json()
        assistant_message = result['message']['content']
    except requests.exceptions.ConnectionError:
        assistant_message = "⚠️ I can't connect to the AI model right now. Make sure Ollama is running with `ollama serve` and that llama3.2 is pulled with `ollama pull llama3.2`."
    except Exception as e:
        assistant_message = f"⚠️ Something went wrong: {str(e)}"

    # Save to history
    if user_id:
        query('INSERT INTO chat_history (user_id, role, message) VALUES (%s, %s, %s)',
              (user_id, 'user', user_message))
        query('INSERT INTO chat_history (user_id, role, message) VALUES (%s, %s, %s)',
              (user_id, 'assistant', assistant_message))

    return jsonify({'reply': assistant_message})

@chatbot_bp.route('/history', methods=['GET'])
def get_history():
    user_id = session.get('user_id')
    if not user_id:
        return jsonify([])
    history = query(
        'SELECT role, message, created_at FROM chat_history WHERE user_id=%s ORDER BY created_at ASC LIMIT 50',
        (user_id,), fetchall=True
    )
    return jsonify(history)

@chatbot_bp.route('/clear', methods=['POST'])
def clear_history():
    user_id = session.get('user_id')
    if user_id:
        query('DELETE FROM chat_history WHERE user_id=%s', (user_id,))
    return jsonify({'message': 'History cleared'})
