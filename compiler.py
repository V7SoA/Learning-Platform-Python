from flask import Blueprint, request, jsonify
import subprocess
import tempfile
import os
import sys

compiler_bp = Blueprint('compiler', __name__)

TIMEOUT = 5  # seconds

@compiler_bp.route('/run', methods=['POST'])
def run_code():
    data = request.json
    code = data.get('code', '')
    language = data.get('language', 'python').lower()

    if not code.strip():
        return jsonify({'output': '', 'error': 'No code provided'})

    if language == 'python':
        return run_python(code)
    elif language in ('javascript', 'js'):
        return run_javascript(code)
    elif language in ('html', 'css'):
        return jsonify({'output': 'HTML/CSS runs in the browser — use the preview tab!', 'error': ''})
    elif language == 'sql':
        return jsonify({'output': 'SQL execution requires a database connection.\nTry your queries in MySQL Workbench or the MySQL CLI.', 'error': ''})
    else:
        return jsonify({'output': '', 'error': f'Language "{language}" is not supported yet.'})

def run_python(code):
    try:
        with tempfile.NamedTemporaryFile(mode='w', suffix='.py', delete=False) as f:
            f.write(code)
            tmp_path = f.name

        result = subprocess.run(
            [sys.executable, tmp_path],
            capture_output=True,
            text=True,
            timeout=TIMEOUT
        )
        os.unlink(tmp_path)

        return jsonify({
            'output': result.stdout or '',
            'error': result.stderr or '',
            'exit_code': result.returncode
        })
    except subprocess.TimeoutExpired:
        return jsonify({'output': '', 'error': f'⏱️ Code timed out after {TIMEOUT} seconds.'})
    except Exception as e:
        return jsonify({'output': '', 'error': str(e)})

def run_javascript(code):
    # Check if Node.js is available
    try:
        node_check = subprocess.run(['node', '--version'], capture_output=True, text=True, timeout=3)
        if node_check.returncode != 0:
            raise FileNotFoundError
    except (FileNotFoundError, subprocess.TimeoutExpired):
        return jsonify({
            'output': '',
            'error': '⚠️ Node.js is not installed. Install it from https://nodejs.org to run JavaScript code.'
        })

    try:
        with tempfile.NamedTemporaryFile(mode='w', suffix='.js', delete=False) as f:
            f.write(code)
            tmp_path = f.name

        result = subprocess.run(
            ['node', tmp_path],
            capture_output=True,
            text=True,
            timeout=TIMEOUT
        )
        os.unlink(tmp_path)

        return jsonify({
            'output': result.stdout or '',
            'error': result.stderr or '',
            'exit_code': result.returncode
        })
    except subprocess.TimeoutExpired:
        return jsonify({'output': '', 'error': f'⏱️ Code timed out after {TIMEOUT} seconds.'})
    except Exception as e:
        return jsonify({'output': '', 'error': str(e)})
