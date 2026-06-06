-- CodeQuest Full Schema with Proper Lessons
-- Run this in MySQL: source D:/codequest/schema.sql

CREATE DATABASE IF NOT EXISTS codequest;
USE codequest;

-- Drop tables in correct order
DROP TABLE IF EXISTS chat_history;
DROP TABLE IF EXISTS user_progress;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS lessons;
DROP TABLE IF EXISTS languages;
DROP TABLE IF EXISTS users;

-- Users table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    xp INT DEFAULT 0,
    streak INT DEFAULT 0,
    last_activity DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Languages table
CREATE TABLE languages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    slug VARCHAR(50) UNIQUE NOT NULL,
    icon VARCHAR(10) NOT NULL,
    color VARCHAR(20) NOT NULL,
    description TEXT,
    total_lessons INT DEFAULT 0
);

-- Lessons table
CREATE TABLE lessons (
    id INT AUTO_INCREMENT PRIMARY KEY,
    language_id INT,
    title VARCHAR(100) NOT NULL,
    lesson_order INT NOT NULL,
    xp_reward INT DEFAULT 10,
    lesson_type ENUM('theory','quiz','code','final_quiz') DEFAULT 'theory',
    story_text TEXT,
    FOREIGN KEY (language_id) REFERENCES languages(id)
);

-- Questions table
CREATE TABLE questions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    lesson_id INT,
    question_text TEXT NOT NULL,
    question_type ENUM('mcq','fill','code') DEFAULT 'mcq',
    correct_answer TEXT NOT NULL,
    options JSON,
    explanation TEXT,
    question_order INT DEFAULT 1,
    FOREIGN KEY (lesson_id) REFERENCES lessons(id)
);

-- User progress table
CREATE TABLE user_progress (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    lesson_id INT,
    completed BOOLEAN DEFAULT FALSE,
    score INT DEFAULT 0,
    completed_at TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (lesson_id) REFERENCES lessons(id),
    UNIQUE KEY unique_progress (user_id, lesson_id)
);

-- Chat history table
CREATE TABLE chat_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    role ENUM('user','assistant') NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- ═══════════════════════════════════════════
-- SEED LANGUAGES
-- ═══════════════════════════════════════════
INSERT INTO languages (name, slug, icon, color, description, total_lessons) VALUES
('Python', 'python', '🐍', '#3776ab', 'Beginner-friendly language used in AI, data science and web development.', 6),
('JavaScript', 'javascript', '⚡', '#f7df1e', 'The language of the web. Runs in browsers and on servers.', 6),
('SQL', 'sql', '🗄️', '#336791', 'Query and manage databases like a pro.', 6),
('HTML & CSS', 'html', '🎨', '#e34f26', 'Build and style beautiful web pages from scratch.', 6),
('Java', 'java', '☕', '#ed8b00', 'Write once, run anywhere. Industry favorite for enterprise apps.', 6);

-- ═══════════════════════════════════════════
-- PYTHON LESSONS (language_id = 1)
-- ═══════════════════════════════════════════
INSERT INTO lessons (language_id, title, lesson_order, xp_reward, lesson_type) VALUES
(1, 'Level 1: Hello World & Print', 1, 10, 'code'),
(1, 'Level 2: Variables & Data Types', 2, 15, 'theory'),
(1, 'Level 3: If / Else Conditions', 3, 20, 'theory'),
(1, 'Level 4: Loops', 4, 20, 'code'),
(1, 'Level 5: Functions', 5, 25, 'code'),
(1, 'Final Quiz: Python Basics', 6, 50, 'final_quiz');

-- ── Python Level 1: Hello World & Print ──
INSERT INTO questions (lesson_id, question_text, question_type, correct_answer, options, explanation, question_order) VALUES
(1, 'What is Python?', 'mcq', 'A beginner-friendly programming language used for web, AI, and data science',
'["A beginner-friendly programming language used for web, AI, and data science","A type of snake only","A database software","A web browser"]',
'Python is a high-level, easy-to-read programming language created by Guido van Rossum. It is widely used in web development, data science, AI, and automation.', 1),

(1, 'Which function is used to display output on the screen in Python?', 'mcq', 'print()',
'["print()","show()","display()","output()"]',
'print() is the built-in Python function that outputs text or values to the terminal/console.', 2),

(1, 'What will this code output?\nprint("Hello, World!")', 'mcq', 'Hello, World!',
'["Hello, World!","hello, world!","\"Hello, World!\"","Nothing"]',
'print() outputs exactly what is inside the quotes. The text Hello, World! will be displayed as-is.', 3),

(1, 'What will this code output?\nprint(5 + 3)', 'mcq', '8',
'["8","5 + 3","53","Error"]',
'Python evaluates the expression 5 + 3 first, which equals 8, then prints the result.', 4),

(1, 'Which of these will print Hello on one line and World on the next line?', 'mcq', 'print("Hello")\nprint("World")',
'["print(\"Hello\")\nprint(\"World\")","print(\"Hello\", \"World\")","print(\"Hello\\nWorld\")","print(\"Hello\" + \"World\")"]',
'Each print() call outputs on a new line by default. So two print() calls give two lines.', 5),

(1, 'Complete the code to print your name:\n_____("My name is Python!")', 'fill', 'print',
NULL,
'print() is the function used to display output. Always use lowercase — Python is case-sensitive.', 6),

(1, 'What symbol is used to write a comment (ignored line) in Python?', 'mcq', '#',
'["#","//","--","**"]',
'In Python, the # symbol starts a comment. Python ignores everything after # on that line. Example: # This is a comment', 7),

(1, 'What will this print?\nprint("2 + 2")', 'mcq', '2 + 2',
'["2 + 2","4","\"2 + 2\"","Error"]',
'Because 2 + 2 is inside quotes, Python treats it as a string (text), not a calculation. It prints exactly: 2 + 2', 8);

-- ── Python Level 2: Variables & Data Types ──
INSERT INTO questions (lesson_id, question_text, question_type, correct_answer, options, explanation, question_order) VALUES
(2, 'What is a variable in Python?', 'mcq', 'A container that stores a value in memory',
'["A container that stores a value in memory","A type of function","A Python keyword","A mathematical symbol"]',
'A variable is like a labeled box that holds data. You give it a name and assign a value using =. Example: age = 20', 1),

(2, 'Which of these correctly creates a variable called name with value "Alice"?', 'mcq', 'name = "Alice"',
'["name = \"Alice\"","var name = \"Alice\"","string name = \"Alice\"","name := \"Alice\""]',
'Python uses simple = for assignment. No need to declare the type. Just write: variable_name = value', 2),

(2, 'What data type is the value 42?', 'mcq', 'int (integer)',
'["int (integer)","float","str (string)","bool"]',
'42 is a whole number with no decimal point, so it is an int (integer). Python automatically determines the type.', 3),

(2, 'What data type is the value 3.14?', 'mcq', 'float',
'["float","int","str","double"]',
'3.14 has a decimal point so it is a float. Float stands for floating-point number (decimal number).', 4),

(2, 'What data type is "Hello World"?', 'mcq', 'str (string)',
'["str (string)","text","char","word"]',
'Any text enclosed in quotes (single or double) is a string (str). Strings are sequences of characters.', 5),

(2, 'What will this code print?\nx = 10\ny = 3\nprint(x + y)', 'mcq', '13',
'["13","10 + 3","x + y","Error"]',
'x holds 10 and y holds 3. x + y = 13. Python evaluates the expression and prints 13.', 6),

(2, 'What is the output?\nname = "Alice"\nage = 20\nprint(name, age)', 'mcq', 'Alice 20',
'["Alice 20","Alice20","name age","Error"]',
'print() with multiple values separated by commas prints them with a space between them. So it prints: Alice 20', 7),

(2, 'Which function tells you the data type of a variable?', 'mcq', 'type()',
'["type()","typeof()","datatype()","kind()"]',
'type() returns the data type of any value. Example: type(42) returns <class "int">. Very useful for debugging!', 8);

-- ── Python Level 3: If / Else Conditions ──
INSERT INTO questions (lesson_id, question_text, question_type, correct_answer, options, explanation, question_order) VALUES
(3, 'What is an if statement used for?', 'mcq', 'To run code only when a condition is True',
'["To run code only when a condition is True","To repeat code multiple times","To define a function","To import a module"]',
'An if statement checks a condition. If the condition is True, the indented code block runs. If False, it is skipped.', 1),

(3, 'What will this print?\nx = 10\nif x > 5:\n    print("Big")', 'mcq', 'Big',
'["Big","Nothing","Error","Small"]',
'x is 10, and 10 > 5 is True, so the code inside the if block runs and prints Big.', 2),

(3, 'What will this print?\nx = 3\nif x > 5:\n    print("Big")\nelse:\n    print("Small")', 'mcq', 'Small',
'["Small","Big","Nothing","Error"]',
'3 > 5 is False, so the if block is skipped and the else block runs, printing Small.', 3),

(3, 'What keyword is used to check a second condition if the first is False?', 'mcq', 'elif',
'["elif","else if","elseif","otherwise"]',
'elif stands for "else if". It lets you check multiple conditions in sequence. Python uses elif (not "else if" like other languages).', 4),

(3, 'What symbol checks if two values are EQUAL in Python?', 'mcq', '==',
'["==","=","===","equals"]',
'== checks equality (comparison). A single = is assignment (storing a value). Always use == when comparing!', 5),

(3, 'What will this print?\nscore = 75\nif score >= 90:\n    print("A")\nelif score >= 70:\n    print("B")\nelse:\n    print("C")', 'mcq', 'B',
'["B","A","C","Error"]',
'75 is not >= 90, so A is skipped. 75 >= 70 is True, so B is printed. The else block is never reached.', 6),

(3, 'Which operator checks if two values are NOT equal?', 'mcq', '!=',
'["!=","<>","=/=","not ="]',
'!= means "not equal to". Example: 5 != 3 is True because 5 and 3 are different values.', 7),

(3, 'Complete the code:\nage = 18\n_____ age >= 18:\n    print("You can vote!")', 'fill', 'if',
NULL,
'if is the keyword that starts a conditional statement in Python. Always followed by a condition and a colon (:).', 8);

-- ── Python Level 4: Loops ──
INSERT INTO questions (lesson_id, question_text, question_type, correct_answer, options, explanation, question_order) VALUES
(4, 'What is a loop used for in Python?', 'mcq', 'To repeat a block of code multiple times',
'["To repeat a block of code multiple times","To store multiple values","To define conditions","To import libraries"]',
'Loops let you run the same code repeatedly without writing it multiple times. Python has two main loops: for and while.', 1),

(4, 'How many times will this loop run?\nfor i in range(5):\n    print(i)', 'mcq', '5 times (prints 0,1,2,3,4)',
'["5 times (prints 0,1,2,3,4)","4 times (prints 1,2,3,4)","6 times","Infinite times"]',
'range(5) generates numbers 0,1,2,3,4 — that is 5 numbers. The loop runs once for each number.', 2),

(4, 'What will this print?\nfor i in range(1, 4):\n    print(i)', 'mcq', '1\n2\n3',
'["1\n2\n3","0\n1\n2\n3","1\n2\n3\n4","Error"]',
'range(1, 4) starts at 1 and stops BEFORE 4, giving 1, 2, 3. The end value is always excluded.', 3),

(4, 'What is a while loop?', 'mcq', 'A loop that keeps running as long as a condition is True',
'["A loop that keeps running as long as a condition is True","A loop that runs exactly 10 times","A loop that runs once","A loop for strings only"]',
'A while loop checks its condition before each run. It keeps looping as long as the condition stays True. Be careful of infinite loops!', 4),

(4, 'What will this print?\ncount = 1\nwhile count <= 3:\n    print(count)\n    count += 1', 'mcq', '1\n2\n3',
'["1\n2\n3","1\n2\n3\n4","0\n1\n2\n3","Infinite loop"]',
'count starts at 1. Each loop prints count then adds 1. When count becomes 4, the condition 4 <= 3 is False and the loop stops.', 5),

(4, 'What does break do inside a loop?', 'mcq', 'Immediately stops the loop',
'["Immediately stops the loop","Skips to the next iteration","Restarts the loop","Causes an error"]',
'break exits the loop immediately, even if the condition is still True or there are items remaining. Useful for stopping when a condition is met.', 6),

(4, 'What will this print?\nfruits = ["apple", "banana", "cherry"]\nfor fruit in fruits:\n    print(fruit)', 'mcq', 'apple\nbanana\ncherry',
'["apple\nbanana\ncherry","fruits","[\"apple\",\"banana\",\"cherry\"]","Error"]',
'You can loop directly over a list. Each iteration, the variable fruit takes the next value from the list.', 7),

(4, 'Complete the code to print numbers 1 to 5:\nfor i in _____(1, 6):\n    print(i)', 'fill', 'range',
NULL,
'range(1, 6) generates 1,2,3,4,5. Remember: the second number in range() is excluded, so use 6 to get up to 5.', 8);

-- ── Python Level 5: Functions ──
INSERT INTO questions (lesson_id, question_text, question_type, correct_answer, options, explanation, question_order) VALUES
(5, 'What is a function in Python?', 'mcq', 'A reusable block of code that performs a specific task',
'["A reusable block of code that performs a specific task","A type of variable","A loop that runs once","A Python module"]',
'A function is a named block of code you can call (run) multiple times. It helps you avoid repeating code and keeps your program organized.', 1),

(5, 'Which keyword is used to define a function in Python?', 'mcq', 'def',
'["def","function","fun","define"]',
'def is short for "define". You write def followed by the function name, parentheses, and a colon. Example: def greet():', 2),

(5, 'What will this print?\ndef say_hello():\n    print("Hello!")\nsay_hello()', 'mcq', 'Hello!',
'["Hello!","Nothing","say_hello()","Error"]',
'Defining a function does not run it. You must CALL it by writing say_hello(). The call executes the function body.', 3),

(5, 'What is a parameter in a function?', 'mcq', 'A variable that receives a value when the function is called',
'["A variable that receives a value when the function is called","The function name","The return value","A global variable"]',
'Parameters are placeholders in the function definition. When you call the function, you pass arguments that fill those placeholders.', 4),

(5, 'What will this print?\ndef greet(name):\n    print("Hello,", name)\ngreet("Alice")', 'mcq', 'Hello, Alice',
'["Hello, Alice","Hello, name","greet(\"Alice\")","Error"]',
'name is a parameter. When greet("Alice") is called, name becomes "Alice" inside the function, so it prints: Hello, Alice', 5),

(5, 'What does the return keyword do?', 'mcq', 'Sends a value back from the function to where it was called',
'["Sends a value back from the function to where it was called","Prints a value","Ends the program","Starts a loop"]',
'return sends a result back to the caller. Example: def add(a,b): return a+b. Then result = add(3,4) stores 7 in result.', 6),

(5, 'What will this print?\ndef square(n):\n    return n * n\nresult = square(4)\nprint(result)', 'mcq', '16',
'["16","n * n","4","square(4)"]',
'square(4) returns 4*4 = 16. That value is stored in result. Then print(result) prints 16.', 7),

(5, 'Complete the function definition:\n_____ add(a, b):\n    return a + b', 'fill', 'def',
NULL,
'def is the keyword to define a function in Python. Always followed by the function name and parentheses containing parameters.', 8);

-- ── Python Final Quiz ──
INSERT INTO questions (lesson_id, question_text, question_type, correct_answer, options, explanation, question_order) VALUES
(6, 'What will this print?\nprint("Hello" + " " + "World")', 'mcq', 'Hello World',
'["Hello World","HelloWorld","Hello + World","Error"]',
'The + operator joins (concatenates) strings together. So "Hello" + " " + "World" becomes "Hello World".', 1),

(6, 'What is the output?\nx = 5\nx = x + 3\nprint(x)', 'mcq', '8',
'["8","5","3","x + 3"]',
'x starts as 5. Then x = x + 3 means x = 5 + 3 = 8. The old value is replaced with the new one.', 2),

(6, 'What will this print?\nfor i in range(3):\n    if i == 1:\n        print("one")', 'mcq', 'one',
'["one","0\none\n2","one\none\none","Nothing"]',
'range(3) gives 0,1,2. Only when i==1 is the condition True, so "one" prints just once.', 3),

(6, 'What is the output?\ndef multiply(a, b):\n    return a * b\nprint(multiply(3, 4))', 'mcq', '12',
'["12","a * b","multiply(3,4)","7"]',
'multiply(3,4) returns 3*4=12. print() then displays 12.', 4),

(6, 'Which of these is the correct way to check if x equals 10?', 'mcq', 'if x == 10:',
'["if x == 10:","if x = 10:","if x === 10:","if x is 10:"]',
'== is the comparison operator. A single = is assignment. Always use == inside if statements to compare values.', 5),

(6, 'What data type is True in Python?', 'mcq', 'bool (boolean)',
'["bool (boolean)","str","int","float"]',
'True and False are boolean values in Python. Booleans represent yes/no, on/off, true/false states.', 6),

(6, 'What will this print?\nanimals = ["cat", "dog", "bird"]\nprint(len(animals))', 'mcq', '3',
'["3","animals","[\"cat\",\"dog\",\"bird\"]","Error"]',
'len() returns the number of items in a list. The animals list has 3 items, so len(animals) = 3.', 7),

(6, 'What will this code do?\ncount = 0\nwhile True:\n    count += 1\n    if count == 3:\n        break\nprint(count)', 'mcq', 'Print 3',
'["Print 3","Run forever","Print 0","Error"]',
'The while True loop runs forever but break stops it when count reaches 3. Then print(count) outputs 3.', 8),

(6, 'What will this print?\ndef check(n):\n    if n > 0:\n        return "positive"\n    else:\n        return "negative"\nprint(check(-5))', 'mcq', 'negative',
'["negative","positive","check(-5)","Error"]',
'-5 > 0 is False so the else block returns "negative". print() displays it.', 9),

(6, 'Which of these is NOT a valid Python data type?', 'mcq', 'decimal',
'["decimal","int","str","bool"]',
'Python has int, float, str, bool, list, dict, tuple etc. "decimal" is not a basic Python data type (though there is a decimal module, it is not a built-in type like int or str).', 10);

-- ═══════════════════════════════════════════
-- JAVASCRIPT LESSONS (language_id = 2)
-- ═══════════════════════════════════════════
INSERT INTO lessons (language_id, title, lesson_order, xp_reward, lesson_type) VALUES
(2, 'Level 1: Console & Variables', 1, 10, 'code'),
(2, 'Level 2: Data Types & Operators', 2, 15, 'theory'),
(2, 'Level 3: If / Else & Comparisons', 3, 20, 'theory'),
(2, 'Level 4: Loops', 4, 20, 'code'),
(2, 'Level 5: Functions & Arrow Functions', 5, 25, 'code'),
(2, 'Final Quiz: JavaScript Basics', 6, 50, 'final_quiz');

-- ── JS Level 1 ──
INSERT INTO questions (lesson_id, question_text, question_type, correct_answer, options, explanation, question_order) VALUES
(7, 'What is JavaScript used for?', 'mcq', 'Making web pages interactive and dynamic',
'["Making web pages interactive and dynamic","Styling web pages","Creating databases","Designing images"]',
'JavaScript runs in the browser and makes websites interactive — things like buttons, animations, forms, and live updates all use JavaScript.', 1),

(7, 'How do you print something to the browser console in JavaScript?', 'mcq', 'console.log()',
'["console.log()","print()","echo()","System.out.println()"]',
'console.log() outputs values to the browser developer console. Press F12 in your browser to open it and see the output.', 2),

(7, 'Which keyword declares a variable that CAN be changed later?', 'mcq', 'let',
'["let","const","var","fix"]',
'let declares a block-scoped variable that can be reassigned. Example: let age = 20; age = 21; — this works fine.', 3),

(7, 'Which keyword declares a variable that CANNOT be changed?', 'mcq', 'const',
'["const","let","var","fixed"]',
'const declares a constant — a value that cannot be reassigned after it is set. Example: const PI = 3.14;', 4),

(7, 'What will this print?\nlet name = "Alice";\nconsole.log(name);', 'mcq', 'Alice',
'["Alice","name","\"Alice\"","undefined"]',
'name stores the string "Alice". console.log(name) prints the VALUE of name, which is Alice (without quotes).', 5),

(7, 'JavaScript statements end with which symbol?', 'mcq', '; (semicolon)',
'["(semicolon)",". (period)","\\n (newline)",": (colon)"]',
'JavaScript statements end with a semicolon ;. While not always required, it is best practice to always include it to avoid bugs.', 6),

(7, 'Complete the code to print Hello:\n_____.log("Hello");', 'fill', 'console',
NULL,
'console.log() is the standard way to output values in JavaScript. console is the object, and log() is the method.', 7),

(7, 'What is the output?\nlet x = 10;\nlet y = 20;\nconsole.log(x + y);', 'mcq', '30',
'["30","10 + 20","x + y","1020"]',
'x is 10 and y is 20. x + y = 30. console.log() prints 30.', 8);

-- ── JS Level 2 ──
INSERT INTO questions (lesson_id, question_text, question_type, correct_answer, options, explanation, question_order) VALUES
(8, 'Which of these is a string in JavaScript?', 'mcq', '"Hello World"',
'["\"Hello World\"","42","true","null"]',
'A string is text enclosed in quotes — single, double, or backticks. "Hello World" is a string. Numbers and booleans are different types.', 1),

(8, 'What is the result of 10 % 3 in JavaScript?', 'mcq', '1',
'["1","3","0","10"]',
'% is the modulo (remainder) operator. 10 divided by 3 = 3 remainder 1. So 10 % 3 = 1. Very useful in programming!', 2),

(8, 'What does typeof "hello" return?', 'mcq', 'string',
'["string","String","text","str"]',
'typeof is an operator that returns the type of a value as a string. typeof "hello" returns "string", typeof 42 returns "number".', 3),

(8, 'What is a template literal in JavaScript?', 'mcq', 'A string using backticks that can embed variables with ${}',
'["A string using backticks that can embed variables with ${}","A type of function","A CSS template","A loop type"]',
'Template literals use backticks (`) and allow embedding variables: const name="Ali"; console.log(`Hello ${name}`); prints Hello Ali.', 4),

(8, 'What will this print?\nlet a = "5";\nlet b = 5;\nconsole.log(a == b);', 'mcq', 'true',
'["true","false","Error","undefined"]',
'== checks value only (loose equality). "5" and 5 have the same value so == returns true. Use === for strict comparison that also checks type.', 5),

(8, 'What is the result of "5" + 5 in JavaScript?', 'mcq', '"55" (string)',
'["\"55\" (string)","10 (number)","Error","55"]',
'When you use + with a string and a number, JavaScript converts the number to a string and concatenates. "5" + 5 = "55". This is called type coercion!', 6),

(8, 'What will this output?\nconsole.log(2 ** 3);', 'mcq', '8',
'["8","6","9","23"]',
'** is the exponentiation operator. 2 ** 3 means 2 to the power of 3 = 2×2×2 = 8.', 7),

(8, 'Which operator checks value AND type equality in JavaScript?', 'mcq', '===',
'["===","==","=","!=="]',
'=== is strict equality — checks both value and type. 5 === "5" is false (different types). Always prefer === over == to avoid bugs.', 8);

-- ── JS Level 3 ──
INSERT INTO questions (lesson_id, question_text, question_type, correct_answer, options, explanation, question_order) VALUES
(9, 'What will this print?\nlet x = 15;\nif (x > 10) {\n  console.log("big");\n}', 'mcq', 'big',
'["big","nothing","15","Error"]',
'15 > 10 is true, so the code inside the if block runs and prints big.', 1),

(9, 'In JavaScript, how do you start an if statement?', 'mcq', 'if (condition) {',
'["if (condition) {","if condition:","IF (condition)","if [condition]"]',
'JavaScript if syntax uses parentheses () for the condition and curly braces {} for the code block. Note: Python uses a colon, JavaScript uses braces.', 2),

(9, 'What does the else block do?', 'mcq', 'Runs when the if condition is false',
'["Runs when the if condition is false","Runs always","Runs before if","Repeats the if block"]',
'else provides an alternative when the if condition is false. If the if is true, else is skipped. If if is false, else runs.', 3),

(9, 'What will this print?\nlet score = 55;\nif (score >= 90) {\n  console.log("A");\n} else if (score >= 60) {\n  console.log("B");\n} else {\n  console.log("F");\n}', 'mcq', 'F',
'["F","A","B","Error"]',
'55 >= 90 is false. 55 >= 60 is false. So the else block runs and prints F.', 4),

(9, 'What does && mean in JavaScript?', 'mcq', 'AND — both conditions must be true',
'["AND — both conditions must be true","OR — at least one must be true","NOT — opposite of condition","EQUALS"]',
'&& is logical AND. Both sides must be true for the whole condition to be true. Example: age >= 18 && hasID checks both conditions.', 5),

(9, 'What does || mean in JavaScript?', 'mcq', 'OR — at least one condition must be true',
'["OR — at least one condition must be true","AND — both must be true","NOT","XOR"]',
'|| is logical OR. If either side is true, the whole condition is true. Example: isAdmin || isModerator — true if either role.', 6),

(9, 'What is a ternary operator?', 'mcq', 'A shorthand if-else: condition ? valueIfTrue : valueIfFalse',
'["A shorthand if-else: condition ? valueIfTrue : valueIfFalse","A loop with 3 iterations","An operator with 3 numbers","A three-way comparison"]',
'Ternary example: let msg = age >= 18 ? "adult" : "minor"; — much shorter than a full if-else block.', 7),

(9, 'What will this print?\nlet n = 7;\nconsole.log(n % 2 === 0 ? "even" : "odd");', 'mcq', 'odd',
'["odd","even","7","true"]',
'7 % 2 = 1. 1 === 0 is false. So the ternary returns "odd". This is a common trick to check if a number is even or odd.', 8);

-- ── JS Level 4 ──
INSERT INTO questions (lesson_id, question_text, question_type, correct_answer, options, explanation, question_order) VALUES
(10, 'What will this print?\nfor (let i = 0; i < 3; i++) {\n  console.log(i);\n}', 'mcq', '0\n1\n2',
'["0\n1\n2","1\n2\n3","0\n1\n2\n3","Error"]',
'The for loop starts at i=0, runs while i<3, and increments i by 1 each time. So it prints 0, 1, 2.', 1),

(10, 'What are the 3 parts of a for loop in JavaScript?', 'mcq', 'initialization; condition; increment',
'["initialization condition increment","start stop step","begin check update","declare compare change"]',
'for (let i=0; i<5; i++) has: initialization (let i=0), condition (i<5), and increment (i++). All separated by semicolons.', 2),

(10, 'What does i++ mean?', 'mcq', 'Increase i by 1 (same as i = i + 1)',
'["Increase i by 1 (same as i = i + 1)","Multiply i by 2","Square i","Decrease i by 1"]',
'i++ is shorthand for i = i + 1. It increments the variable by 1. Similarly, i-- decreases by 1.', 3),

(10, 'How do you loop over an array in JavaScript?', 'mcq', 'for...of loop',
'["for...of loop","for...in loop","forEach only","while only"]',
'for...of iterates over array values directly. Example: for (let fruit of fruits) { console.log(fruit); }', 4),

(10, 'What will this print?\nconst nums = [1, 2, 3];\nnums.forEach(n => console.log(n * 2));', 'mcq', '2\n4\n6',
'["2\n4\n6","1\n2\n3","2 4 6","Error"]',
'forEach runs a function for each array element. n takes each value (1,2,3) and n*2 gives 2,4,6 printed on separate lines.', 5),

(10, 'What does while loop do?', 'mcq', 'Keeps running as long as the condition is true',
'["Keeps running as long as the condition is true","Runs exactly once","Runs for each array item","Runs backwards"]',
'while (condition) { } — checks the condition before each run. If the condition is always true and never changed, you get an infinite loop!', 6),

(10, 'What will this print?\nlet i = 0;\nwhile (i < 3) {\n  console.log(i);\n  i++;\n}', 'mcq', '0\n1\n2',
'["0\n1\n2","1\n2\n3","infinite loop","Error"]',
'i starts at 0. Each loop prints i then increments it. When i becomes 3, the condition 3<3 is false and the loop stops.', 7),

(10, 'Complete the for loop:\nfor (let i = 1; i _____ 5; i++) {\n  console.log(i);\n}', 'fill', '<=',
NULL,
'<= means "less than or equal to". Using <= 5 prints 1,2,3,4,5. Using < 5 would only print 1,2,3,4.', 8);

-- ── JS Level 5 ──
INSERT INTO questions (lesson_id, question_text, question_type, correct_answer, options, explanation, question_order) VALUES
(11, 'How do you define a regular function in JavaScript?', 'mcq', 'function name() { }',
'["function name() { }","def name():","fun name() { }","func name() { }"]',
'JavaScript uses the function keyword. Example: function greet() { console.log("Hello"); }. Then call it: greet();', 1),

(11, 'What is an arrow function?', 'mcq', 'A shorter way to write functions using =>',
'["A shorter way to write functions using =>","A function that runs automatically","A function without parameters","A loop inside a function"]',
'Arrow functions: const add = (a, b) => a + b; — much shorter than a regular function. Great for simple, one-line functions.', 2),

(11, 'What will this print?\nfunction add(a, b) {\n  return a + b;\n}\nconsole.log(add(3, 4));', 'mcq', '7',
'["7","a + b","3 + 4","undefined"]',
'add(3,4) returns 3+4=7. console.log() prints 7.', 3),

(11, 'Convert this to an arrow function:\nfunction square(n) { return n * n; }', 'mcq', 'const square = n => n * n;',
'["const square = n => n * n;","const square = (n) { return n * n; }","square => n * n","const square = function n * n"]',
'Arrow function syntax: const name = (params) => expression. For single params, parentheses are optional. For single expression, return is implicit.', 4),

(11, 'What does a function return if it has no return statement?', 'mcq', 'undefined',
'["undefined","null","0","Error"]',
'If a function has no return statement (or return with no value), JavaScript automatically returns undefined.', 5),

(11, 'What is a callback function?', 'mcq', 'A function passed as an argument to another function',
'["A function passed as an argument to another function","A function that calls itself","A function in a class","A built-in function"]',
'Callbacks are functions passed to other functions. Example: setTimeout(() => console.log("done"), 1000) — the arrow function is the callback.', 6),

(11, 'What will this print?\nconst greet = name => `Hello, ${name}!`;\nconsole.log(greet("Bob"));', 'mcq', 'Hello, Bob!',
'["Hello, Bob!","Hello, name!","greet(\"Bob\")","undefined"]',
'The arrow function uses a template literal to embed name. greet("Bob") returns "Hello, Bob!" and console.log prints it.', 7),

(11, 'Complete the arrow function:\nconst double = n _____ n * 2;', 'fill', '=>',
NULL,
'=> is the arrow. It separates the parameters from the function body. const double = n => n * 2; doubles any number.', 8);

-- ── JS Final Quiz ──
INSERT INTO questions (lesson_id, question_text, question_type, correct_answer, options, explanation, question_order) VALUES
(12, 'What will this print?\nconsole.log(typeof 42);', 'mcq', 'number',
'["number","int","integer","42"]',
'typeof returns a string describing the type. In JavaScript all numbers (integers and decimals) are type "number".', 1),

(12, 'What is the output?\nlet arr = [10, 20, 30];\nconsole.log(arr[1]);', 'mcq', '20',
'["20","10","30","undefined"]',
'Arrays are zero-indexed. arr[0]=10, arr[1]=20, arr[2]=30. So arr[1] is 20.', 2),

(12, 'What will this print?\nfor (let i = 0; i < 5; i++) {\n  if (i === 3) break;\n  console.log(i);\n}', 'mcq', '0\n1\n2',
'["0\n1\n2","0\n1\n2\n3","0\n1\n2\n3\n4","Error"]',
'The loop prints 0,1,2. When i becomes 3, break stops the loop before printing 3.', 3),

(12, 'What does arr.length return?', 'mcq', 'The number of elements in the array',
'["The number of elements in the array","The last element","The first element","The array type"]',
'length is a property of arrays. [1,2,3].length returns 3. Useful in loops: for(let i=0; i<arr.length; i++)', 4),

(12, 'What will this print?\nconst x = 5;\nconsole.log(x === 5 ? "yes" : "no");', 'mcq', 'yes',
'["yes","no","true","5"]',
'x === 5 is true, so the ternary returns "yes". console.log prints yes.', 5),

(12, 'What does push() do to an array?', 'mcq', 'Adds an element to the end of the array',
'["Adds an element to the end of the array","Removes the last element","Adds to the beginning","Sorts the array"]',
'push() adds one or more elements to the END of an array and returns the new length. Example: arr.push(4) adds 4 to the end.', 6),

(12, 'What will this print?\nfunction outer() {\n  let x = 10;\n  function inner() { console.log(x); }\n  inner();\n}\nouter();', 'mcq', '10',
'["10","undefined","Error","x"]',
'inner() can access x from outer() because of closure — inner functions can access variables from their parent scope.', 7),

(12, 'Which method removes and returns the last element of an array?', 'mcq', 'pop()',
'["pop()","push()","shift()","splice()"]',
'pop() removes and returns the last element. push() adds to end. shift() removes from beginning. unshift() adds to beginning.', 8),

(12, 'What will this print?\nconst nums = [1,2,3,4,5];\nconst evens = nums.filter(n => n % 2 === 0);\nconsole.log(evens);', 'mcq', '[2, 4]',
'["[2, 4]","[1, 3, 5]","[1,2,3,4,5]","Error"]',
'filter() returns a new array with only elements that pass the test. n%2===0 is true for 2 and 4, so evens = [2,4].', 9),

(12, 'What is the output?\nconsole.log(Boolean(0));', 'mcq', 'false',
'["false","true","0","Error"]',
'Boolean(0) converts 0 to boolean. In JavaScript, 0, "", null, undefined, NaN are all "falsy" values that convert to false.', 10);

-- ═══════════════════════════════════════════
-- SQL LESSONS (language_id = 3)
-- ═══════════════════════════════════════════
INSERT INTO lessons (language_id, title, lesson_order, xp_reward, lesson_type) VALUES
(3, 'Level 1: What is SQL & SELECT', 1, 10, 'theory'),
(3, 'Level 2: WHERE Clause & Filtering', 2, 15, 'theory'),
(3, 'Level 3: ORDER BY, LIMIT & DISTINCT', 3, 20, 'theory'),
(3, 'Level 4: INSERT, UPDATE & DELETE', 4, 20, 'theory'),
(3, 'Level 5: JOINs & Relationships', 5, 25, 'theory'),
(3, 'Final Quiz: SQL Basics', 6, 50, 'final_quiz');

-- ── SQL Level 1 ──
INSERT INTO questions (lesson_id, question_text, question_type, correct_answer, options, explanation, question_order) VALUES
(13, 'What does SQL stand for?', 'mcq', 'Structured Query Language',
'["Structured Query Language","Simple Question Language","Standard Query Logic","System Query Language"]',
'SQL stands for Structured Query Language. It is the standard language for communicating with relational databases like MySQL, PostgreSQL, and SQLite.', 1),

(13, 'What does a SELECT statement do?', 'mcq', 'Retrieves data from a database table',
'["Retrieves data from a database table","Deletes records","Creates a new table","Updates existing records"]',
'SELECT is used to read/retrieve data from a table. It is the most commonly used SQL command and does NOT change any data.', 2),

(13, 'What does SELECT * mean?', 'mcq', 'Select ALL columns from the table',
'["Select ALL columns from the table","Select nothing","Select the first column only","Delete all records"]',
'The * (asterisk) is a wildcard meaning "all columns". SELECT * FROM users returns every column of every row in the users table.', 3),

(13, 'Complete the query to get all records from the students table:\nSELECT _____ FROM students;', 'fill', '*',
NULL,
'* selects all columns. You can also select specific columns by name: SELECT name, age FROM students;', 4),

(13, 'What does the FROM clause specify?', 'mcq', 'Which table to query',
'["Which table to query","Which database server to use","How many rows to return","The sort order"]',
'FROM specifies the table you want to get data from. SELECT * FROM employees; gets all data from the employees table.', 5),

(13, 'How do you select only the name and email columns from a users table?', 'mcq', 'SELECT name, email FROM users;',
'["SELECT name, email FROM users;","SELECT * FROM users;","GET name, email FROM users;","FETCH name, email IN users;"]',
'List the column names separated by commas after SELECT. This is called a column projection — you only retrieve the columns you need.', 6),

(13, 'What is a database table?', 'mcq', 'A structured collection of data organized in rows and columns',
'["A structured collection of data organized in rows and columns","A type of SQL query","A database backup","A programming function"]',
'A table is like a spreadsheet — it has columns (fields/attributes) and rows (records). Each row is one entry, each column is one type of data.', 7),

(13, 'What will this query return?\nSELECT name FROM products;', 'mcq', 'Only the name column from all rows in products',
'["Only the name column from all rows in products","All columns from products","Only the first row","Nothing"]',
'This selects just the name column from every row in the products table. Much more efficient than SELECT * when you only need one column.', 8);

-- ── SQL Level 2 ──
INSERT INTO questions (lesson_id, question_text, question_type, correct_answer, options, explanation, question_order) VALUES
(14, 'What does the WHERE clause do?', 'mcq', 'Filters rows based on a condition',
'["Filters rows based on a condition","Sorts the results","Groups the results","Selects specific columns"]',
'WHERE filters which rows are returned. Only rows where the condition is TRUE are included. Example: WHERE age > 18 returns only adult users.', 1),

(14, 'What will this query return?\nSELECT * FROM users WHERE age > 18;', 'mcq', 'All columns for users older than 18',
'["All columns for users older than 18","Users aged exactly 18","Users aged 18 or younger","All users"]',
'WHERE age > 18 means "only include rows where the age column value is greater than 18". All columns are returned due to *.', 2),

(14, 'How do you find a user with the exact name "Alice"?', 'mcq', "SELECT * FROM users WHERE name = 'Alice';",
'["SELECT * FROM users WHERE name = ''Alice'';","SELECT * FROM users WHERE name == ''Alice'';","SELECT * FROM users FIND name = ''Alice'';","SELECT name=''Alice'' FROM users;"]',
'In SQL, use a single = for comparison (not == like Python or JavaScript). String values must be in single quotes.', 3),

(14, 'What does LIKE do in SQL?', 'mcq', "Searches for a pattern in text (e.g. WHERE name LIKE 'A%')",
'["Searches for a pattern in text (e.g. WHERE name LIKE ''A%'')","Checks exact equality","Sorts alphabetically","Counts matching rows"]',
'LIKE is used for pattern matching. % is a wildcard meaning "any characters". WHERE name LIKE "A%" finds all names starting with A.', 4),

(14, 'What does % mean in a LIKE query?', 'mcq', 'Any sequence of characters (zero or more)',
'["Any sequence of characters (zero or more)","Exactly one character","A number","A special SQL command"]',
'% matches any string of any length. WHERE email LIKE "%@gmail.com" finds all Gmail addresses. _ matches exactly one character.', 5),

(14, 'How do you filter with two conditions (both must be true)?', 'mcq', 'Use AND between conditions',
'["Use AND between conditions","Use OR between conditions","Use TWO WHERE clauses","Use BOTH keyword"]',
'AND requires both conditions to be true. Example: WHERE age > 18 AND country = "India" finds adult users from India only.', 6),

(14, 'What will this query return?\nSELECT * FROM products WHERE price < 100 OR category = "sale";', 'mcq', 'Products cheaper than 100 OR in the sale category',
'["Products cheaper than 100 OR in the sale category","Products that are both cheap AND on sale","All products","No products"]',
'OR returns rows where EITHER condition is true. A product qualifies if its price < 100, OR its category is "sale", OR both.', 7),

(14, 'Complete the query to find users from India:\nSELECT * FROM users WHERE country _____ "India";', 'fill', '=',
NULL,
'In SQL, = is used for equality comparison in WHERE clauses. Unlike Python (==) or JavaScript (===), SQL uses a single = for both assignment and comparison in WHERE.', 8);

-- ── SQL Level 3 ──
INSERT INTO questions (lesson_id, question_text, question_type, correct_answer, options, explanation, question_order) VALUES
(15, 'What does ORDER BY do?', 'mcq', 'Sorts the results by a specified column',
'["Sorts the results by a specified column","Filters rows","Groups rows","Counts rows"]',
'ORDER BY sorts query results. Example: SELECT * FROM students ORDER BY grade; returns students sorted by grade alphabetically/numerically.', 1),

(15, 'What does DESC mean in ORDER BY?', 'mcq', 'Sort in descending order (Z to A, 9 to 0)',
'["Sort in descending order (Z to A, 9 to 0)","Sort in ascending order","Describe the table","Delete sorted rows"]',
'DESC = descending order (highest to lowest, Z to A). ASC = ascending (default, lowest to highest, A to Z). Example: ORDER BY price DESC shows most expensive first.', 2),

(15, 'What does LIMIT do?', 'mcq', 'Restricts the number of rows returned',
'["Restricts the number of rows returned","Limits who can access the database","Filters by value","Sets a maximum column size"]',
'LIMIT controls how many rows are returned. SELECT * FROM products LIMIT 5; returns only the first 5 products. Great for pagination!', 3),

(15, 'What will this query return?\nSELECT * FROM employees ORDER BY salary DESC LIMIT 3;', 'mcq', 'The 3 highest-paid employees',
'["The 3 highest-paid employees","The 3 lowest-paid employees","All employees sorted by salary","The first 3 employees added"]',
'ORDER BY salary DESC sorts highest salary first. LIMIT 3 takes only the first 3 rows. Together they give you the top 3 earners.', 4),

(15, 'What does SELECT DISTINCT do?', 'mcq', 'Returns only unique (non-duplicate) values',
'["Returns only unique (non-duplicate) values","Selects a specific column","Filters null values","Counts distinct values"]',
'DISTINCT eliminates duplicate rows from results. SELECT DISTINCT country FROM users; returns each country only once, even if many users share a country.', 5),

(15, 'What does COUNT(*) do?', 'mcq', 'Counts the total number of rows',
'["Counts the total number of rows","Sums all values","Finds the maximum","Returns the first row"]',
'COUNT(*) is an aggregate function that counts rows. SELECT COUNT(*) FROM orders; tells you how many orders exist in the table.', 6),

(15, 'How do you get the most expensive product?', 'mcq', 'SELECT * FROM products ORDER BY price DESC LIMIT 1;',
'["SELECT * FROM products ORDER BY price DESC LIMIT 1;","SELECT MAX FROM products;","SELECT * FROM products WHERE price = MAX;","SELECT TOP 1 * FROM products;"]',
'ORDER BY price DESC puts the highest price first. LIMIT 1 takes just that one row. This is a common pattern to find the maximum row.', 7),

(15, 'Complete the query to get top 5 students by score:\nSELECT * FROM students ORDER BY score _____ LIMIT 5;', 'fill', 'DESC',
NULL,
'DESC (descending) puts the highest scores first. Then LIMIT 5 takes only those top 5 rows.', 8);

-- ── SQL Level 4 ──
INSERT INTO questions (lesson_id, question_text, question_type, correct_answer, options, explanation, question_order) VALUES
(16, 'What does INSERT INTO do?', 'mcq', 'Adds a new row of data to a table',
'["Adds a new row of data to a table","Updates an existing row","Deletes a row","Creates a new table"]',
'INSERT INTO adds new records. Syntax: INSERT INTO table_name (col1, col2) VALUES (val1, val2); Each INSERT creates one new row.', 1),

(16, 'What is the correct syntax to insert a new user?', 'mcq', "INSERT INTO users (name, age) VALUES ('Bob', 25);",
'["INSERT INTO users (name, age) VALUES (''Bob'', 25);","ADD INTO users VALUES (''Bob'', 25);","INSERT users SET name=''Bob'', age=25;","PUT INTO users (''Bob'', 25);"]',
'INSERT INTO table (columns) VALUES (values); — columns and values must match in order and count. String values go in single quotes.', 2),

(16, 'What does UPDATE do?', 'mcq', 'Modifies existing data in a table',
'["Modifies existing data in a table","Adds new rows","Deletes rows","Creates a new column"]',
'UPDATE changes values in existing rows. Always use WHERE with UPDATE or you will change EVERY row in the table!', 3),

(16, 'What is wrong with this query?\nUPDATE users SET age = 30;', 'mcq', 'It will update ALL users ages to 30 — missing WHERE',
'["It will update ALL users ages to 30 — missing WHERE","Nothing is wrong","It has wrong syntax","It will cause an error"]',
'Without WHERE, UPDATE modifies EVERY row. Always add WHERE to target specific rows. Example: UPDATE users SET age=30 WHERE id=5;', 4),

(16, 'What does DELETE FROM do?', 'mcq', 'Removes rows from a table',
'["Removes rows from a table","Deletes the entire table","Removes a column","Clears all databases"]',
'DELETE FROM removes rows. Like UPDATE, always use WHERE! DELETE FROM users; with no WHERE deletes ALL users. Very dangerous!', 5),

(16, 'What is the correct way to delete a specific user?', 'mcq', 'DELETE FROM users WHERE id = 5;',
'["DELETE FROM users WHERE id = 5;","DELETE id=5 FROM users;","REMOVE FROM users WHERE id=5;","DROP users WHERE id=5;"]',
'DELETE FROM table WHERE condition; — the WHERE clause targets specific rows. Without it, all rows are deleted.', 6),

(16, 'What is the difference between DELETE and DROP?', 'mcq', 'DELETE removes rows, DROP removes the entire table',
'["DELETE removes rows, DROP removes the entire table","They are the same","DROP removes rows, DELETE removes tables","DELETE is faster"]',
'DELETE removes data (rows) from a table but keeps the table. DROP TABLE removes the table structure entirely — all data and the table are gone permanently.', 7),

(16, 'Complete the update query:\nUPDATE products _____ price = 99 WHERE id = 1;', 'fill', 'SET',
NULL,
'SET specifies which column to change and what value to set. Syntax: UPDATE table SET column = value WHERE condition;', 8);

-- ── SQL Level 5 ──
INSERT INTO questions (lesson_id, question_text, question_type, correct_answer, options, explanation, question_order) VALUES
(17, 'What is a JOIN in SQL?', 'mcq', 'Combines rows from two or more tables based on a related column',
'["Combines rows from two or more tables based on a related column","Adds a new column","Creates a backup","Merges two databases"]',
'JOINs let you query data from multiple related tables at once. For example, joining orders with customers to see who ordered what.', 1),

(17, 'What is a PRIMARY KEY?', 'mcq', 'A unique identifier for each row in a table',
'["A unique identifier for each row in a table","The first column of any table","A password for the database","The most important data"]',
'A PRIMARY KEY uniquely identifies each row. It cannot be NULL and cannot be duplicated. Usually an auto-incrementing integer id column.', 2),

(17, 'What is a FOREIGN KEY?', 'mcq', 'A column that references the PRIMARY KEY of another table',
'["A column that references the PRIMARY KEY of another table","A key from another database","An encryption key","A backup key"]',
'FOREIGN KEY creates a link between tables. For example, orders.customer_id is a foreign key referencing customers.id, linking each order to a customer.', 3),

(17, 'What does INNER JOIN return?', 'mcq', 'Only rows that have matching values in BOTH tables',
'["Only rows that have matching values in BOTH tables","All rows from both tables","All rows from the left table","All rows from the right table"]',
'INNER JOIN is the most common join. It only returns rows where the join condition matches in both tables. Non-matching rows are excluded.', 4),

(17, 'What does LEFT JOIN return?', 'mcq', 'All rows from the left table, and matching rows from the right (NULL if no match)',
'["All rows from the left table, and matching rows from the right (NULL if no match)","Only matching rows","All rows from right table","No rows"]',
'LEFT JOIN keeps all rows from the left (first) table. If there is no match in the right table, NULL is returned for right table columns.', 5),

(17, 'What is the ON clause used for in a JOIN?', 'mcq', 'Specifies the condition for matching rows between tables',
'["Specifies the condition for matching rows between tables","Sorts the joined results","Filters after joining","Names the result"]',
'ON tells SQL how to match rows between tables. Example: JOIN orders ON customers.id = orders.customer_id links customers to their orders.', 6),

(17, 'What does this query do?\nSELECT students.name, grades.score\nFROM students\nINNER JOIN grades ON students.id = grades.student_id;', 'mcq', 'Returns student names with their corresponding scores',
'["Returns student names with their corresponding scores","Returns all student data","Creates a new table","Deletes unmatched rows"]',
'This joins students and grades tables on the student id. It returns each student name paired with their grade score from the grades table.', 7),

(17, 'What does GROUP BY do?', 'mcq', 'Groups rows with the same value and allows aggregate functions per group',
'["Groups rows with the same value and allows aggregate functions per group","Sorts results","Filters rows","Creates subgroups"]',
'GROUP BY is used with aggregate functions like COUNT, SUM, AVG. Example: SELECT country, COUNT(*) FROM users GROUP BY country counts users per country.', 8);

-- ── SQL Final Quiz ──
INSERT INTO questions (lesson_id, question_text, question_type, correct_answer, options, explanation, question_order) VALUES
(18, 'Which SQL command retrieves data?', 'mcq', 'SELECT',
'["SELECT","GET","FETCH","READ"]',
'SELECT is the SQL command for reading/retrieving data from tables. It is the most frequently used SQL command.', 1),

(18, 'What does this return?\nSELECT COUNT(*) FROM orders WHERE status = "pending";', 'mcq', 'The number of pending orders',
'["The number of pending orders","All pending orders","The first pending order","Nothing"]',
'COUNT(*) counts rows matching the WHERE condition. This returns a single number: how many orders have status = "pending".', 2),

(18, 'Which clause filters GROUPS (used with GROUP BY)?', 'mcq', 'HAVING',
'["HAVING","WHERE","FILTER","GROUPWHERE"]',
'HAVING filters after grouping, like WHERE filters before grouping. Example: GROUP BY country HAVING COUNT(*) > 100 finds countries with more than 100 users.', 3),

(18, 'What will this return?\nSELECT DISTINCT department FROM employees;', 'mcq', 'A list of unique department names',
'["A list of unique department names","All employee records","Duplicate departments","Employee count per department"]',
'DISTINCT removes duplicates. Even if 50 employees are in "Engineering", it appears only once in the result.', 4),

(18, 'What is wrong?\nDELETE FROM products;', 'mcq', 'It deletes ALL products — no WHERE clause',
'["It deletes ALL products — no WHERE clause","Nothing is wrong","Syntax error","It only deletes one product"]',
'Without WHERE, DELETE removes every row. This is one of the most dangerous mistakes in SQL. Always double-check before running DELETE without WHERE!', 5),

(18, 'What does AVG() do?', 'mcq', 'Calculates the average value of a numeric column',
'["Calculates the average value of a numeric column","Finds the maximum","Counts rows","Sums all values"]',
'AVG() is an aggregate function. SELECT AVG(salary) FROM employees; returns the average salary across all employees.', 6),

(18, 'How do you sort results from most recent to oldest using a date column?', 'mcq', 'ORDER BY created_at DESC',
'["ORDER BY created_at DESC","ORDER BY created_at ASC","SORT BY created_at NEWEST","ORDER BY date REVERSE"]',
'ORDER BY column DESC sorts newest/highest first. For dates, DESC puts the most recent date at the top. ASC would put the oldest first.', 7),

(18, 'What type of JOIN shows all customers even if they have no orders?', 'mcq', 'LEFT JOIN',
'["LEFT JOIN","INNER JOIN","RIGHT JOIN","FULL JOIN"]',
'LEFT JOIN keeps all rows from the left table (customers) even when there is no match in the right table (orders). Those customers show NULL for order columns.', 8),

(18, 'What does this do?\nUPDATE users SET status = "inactive" WHERE last_login < "2023-01-01";', 'mcq', 'Sets status to inactive for users who have not logged in since before 2023',
'["Sets status to inactive for users who have not logged in since before 2023","Deletes old users","Creates new users","Counts inactive users"]',
'This UPDATE targets only users whose last_login date is before January 1, 2023, setting their status column to "inactive". WHERE makes it safe and targeted.', 9),

(18, 'What is the correct order of SQL clauses?', 'mcq', 'SELECT → FROM → WHERE → GROUP BY → HAVING → ORDER BY → LIMIT',
'["SELECT FROM WHERE GROUP BY HAVING ORDER BY LIMIT","FROM SELECT WHERE ORDER LIMIT","SELECT WHERE FROM ORDER","Any order works"]',
'SQL has a strict clause order. You must write them in this sequence or you will get a syntax error. SELECT and FROM are always required; the rest are optional.', 10);

-- ═══════════════════════════════════════════
-- HTML & CSS LESSONS (language_id = 4)
-- ═══════════════════════════════════════════
INSERT INTO lessons (language_id, title, lesson_order, xp_reward, lesson_type) VALUES
(4, 'Level 1: What is HTML & Basic Tags', 1, 10, 'theory'),
(4, 'Level 2: Links, Images & Lists', 2, 15, 'theory'),
(4, 'Level 3: HTML Forms & Input', 3, 20, 'theory'),
(4, 'Level 4: CSS Basics & Selectors', 4, 20, 'theory'),
(4, 'Level 5: CSS Box Model & Flexbox', 5, 25, 'theory'),
(4, 'Final Quiz: HTML & CSS Basics', 6, 50, 'final_quiz');

-- ── HTML Level 1 ──
INSERT INTO questions (lesson_id, question_text, question_type, correct_answer, options, explanation, question_order) VALUES
(19, 'What does HTML stand for?', 'mcq', 'HyperText Markup Language',
'["HyperText Markup Language","High Tech Modern Language","HyperText Modern Links","Home Tool Markup Language"]',
'HTML is the standard language for creating web pages. It uses tags to structure content like headings, paragraphs, images, and links.', 1),

(19, 'What is an HTML tag?', 'mcq', 'A keyword in angle brackets that defines an element',
'["A keyword in angle brackets that defines an element","A CSS style rule","A JavaScript function","A database command"]',
'HTML tags are written in angle brackets like <h1> or <p>. Most tags have an opening tag <tag> and a closing tag </tag>.', 2),

(19, 'Which tag creates the largest heading?', 'mcq', '<h1>',
'["<h1>","<h6>","<heading>","<big>"]',
'HTML has 6 heading levels: <h1> (largest/most important) to <h6> (smallest). Use <h1> for the main page title.', 3),

(19, 'Which tag creates a paragraph?', 'mcq', '<p>',
'["<p>","<para>","<paragraph>","<text>"]',
'<p> defines a paragraph of text. Browsers automatically add spacing above and below paragraphs. Example: <p>Hello World</p>', 4),

(19, 'What is the correct structure of an HTML document?', 'mcq', '<!DOCTYPE html>, <html>, <head>, <body>',
'["<!DOCTYPE html>, <html>, <head>, <body>","<html>, <page>, <style>, <content>","<html>, <title>, <main>","<head>, <body>, <footer>"]',
'Every HTML document starts with <!DOCTYPE html>, then <html> wraps everything. <head> contains metadata, <body> contains visible content.', 5),

(19, 'What does the <title> tag do?', 'mcq', 'Sets the text shown in the browser tab',
'["Sets the text shown in the browser tab","Creates a large title on the page","Makes text bold","Links to a stylesheet"]',
'<title> goes inside <head> and sets the browser tab/window title. It is not visible on the page itself but appears in the tab and search results.', 6),

(19, 'Which tag makes text bold?', 'mcq', '<strong>',
'["<strong>","<bold>","<b>","<thick>"]',
'<strong> makes text bold AND marks it as important (better for accessibility). <b> also makes text bold but has no semantic meaning. Prefer <strong>.', 7),

(19, 'Complete the HTML tag to create a paragraph:\n<_____>Hello World</_____>', 'fill', 'p',
NULL,
'<p> is the paragraph tag. Most HTML elements have an opening tag <p> and a closing tag </p> with content in between.', 8);

-- ── HTML Level 2 ──
INSERT INTO questions (lesson_id, question_text, question_type, correct_answer, options, explanation, question_order) VALUES
(20, 'Which tag creates a hyperlink?', 'mcq', '<a>',
'["<a>","<link>","<href>","<url>"]',
'<a> stands for anchor. It creates clickable links. Example: <a href="https://google.com">Click here</a>. The href attribute specifies the URL.', 1),

(20, 'What does the href attribute do in an <a> tag?', 'mcq', 'Specifies the URL the link goes to',
'["Specifies the URL the link goes to","Sets the link color","Makes text bold","Opens a popup"]',
'href = "hypertext reference". It is the destination URL. Without href, the link goes nowhere. Example: <a href="page2.html">Next Page</a>', 2),

(20, 'Which tag displays an image?', 'mcq', '<img>',
'["<img>","<image>","<picture>","<photo>"]',
'<img> embeds an image. It is a self-closing tag (no closing tag needed). Example: <img src="photo.jpg" alt="A photo">. src is the image path, alt is description text.', 3),

(20, 'What does the alt attribute in <img> do?', 'mcq', 'Provides alternative text if the image cannot load',
'["Provides alternative text if the image cannot load","Sets image size","Makes image clickable","Adds a border"]',
'alt text is shown when an image fails to load and is read by screen readers for visually impaired users. Always include alt for accessibility!', 4),

(20, 'Which tag creates an unordered (bullet) list?', 'mcq', '<ul>',
'["<ul>","<ol>","<list>","<bl>"]',
'<ul> = unordered list (bullets). <ol> = ordered list (numbers). Each item inside goes in <li> tags. Example: <ul><li>Apple</li><li>Banana</li></ul>', 5),

(20, 'Which tag creates an ordered (numbered) list?', 'mcq', '<ol>',
'["<ol>","<ul>","<nl>","<list order>"]',
'<ol> creates a numbered list. Items are automatically numbered 1, 2, 3... in the browser. Each item still uses <li> tags.', 6),

(20, 'What does <br> do?', 'mcq', 'Inserts a line break',
'["Inserts a line break","Creates a border","Makes text bold","Links to another page"]',
'<br> is a self-closing tag that adds a line break. Unlike <p> which creates a whole new paragraph, <br> just moves to the next line.', 7),

(20, 'What is the correct way to open a link in a new tab?', 'mcq', '<a href="url" target="_blank">',
'["<a href=\"url\" target=\"_blank\">","<a href=\"url\" new-tab>","<a href=\"url\" open=\"new\">","<a href=\"url\" tab=\"new\">"]',
'target="_blank" makes the link open in a new browser tab. Always pair it with rel="noopener noreferrer" for security best practice.', 8);

-- ── HTML Level 3 ──
INSERT INTO questions (lesson_id, question_text, question_type, correct_answer, options, explanation, question_order) VALUES
(21, 'Which tag creates an HTML form?', 'mcq', '<form>',
'["<form>","<input>","<submit>","<data>"]',
'<form> wraps all form elements. The action attribute sets where data is sent, and method sets how (GET or POST). Example: <form action="/login" method="post">', 1),

(21, 'Which input type creates a text box?', 'mcq', '<input type="text">',
'["<input type=\"text\">","<input type=\"box\">","<textbox>","<input type=\"string\">"]',
'<input type="text"> creates a single-line text field. Other types include: password, email, number, checkbox, radio, submit, file.', 2),

(21, 'Which tag creates a submit button?', 'mcq', '<button type="submit"> or <input type="submit">',
'["<button type=\"submit\"> or <input type=\"submit\">","<submit>","<button>Click</button> only","<press type=\"submit\">"]',
'Both <button type="submit"> and <input type="submit"> create submit buttons. <button> is more flexible as it can contain HTML content.', 3),

(21, 'What does the placeholder attribute do?', 'mcq', 'Shows hint text inside an input field before the user types',
'["Shows hint text inside an input field before the user types","Sets the default value","Makes the field required","Limits character count"]',
'placeholder="Enter your name" shows light grey hint text inside the input. It disappears as soon as the user starts typing.', 4),

(21, 'Which input type hides the typed characters (like a password)?', 'mcq', '<input type="password">',
'["<input type=\"password\">","<input type=\"hidden\">","<input type=\"secret\">","<input type=\"secure\">"]',
'type="password" replaces typed characters with dots/asterisks so others cannot see what is being typed. The actual value is still accessible to the form.', 5),

(21, 'What does the <label> tag do?', 'mcq', 'Provides a clickable description for a form input',
'["Provides a clickable description for a form input","Creates a text heading","Styles the input","Validates the form"]',
'<label for="email">Email:</label> paired with <input id="email"> links them. Clicking the label focuses the input — important for accessibility!', 6),

(21, 'Which tag creates a multi-line text area?', 'mcq', '<textarea>',
'["<textarea>","<input type=\"multiline\">","<input type=\"textarea\">","<bigtext>"]',
'<textarea> creates a resizable multi-line text input. Unlike <input>, it has opening and closing tags. Great for comments, messages, or long text.', 7),

(21, 'What does the required attribute do on an input?', 'mcq', 'Makes the field mandatory — form will not submit if empty',
'["Makes the field mandatory — form will not submit if empty","Adds a red border","Prevents editing","Sets a default value"]',
'required is a boolean attribute. <input type="email" required> means the browser will prevent form submission and show an error if this field is empty.', 8);

-- ── CSS Level 1 ──
INSERT INTO questions (lesson_id, question_text, question_type, correct_answer, options, explanation, question_order) VALUES
(22, 'What does CSS stand for?', 'mcq', 'Cascading Style Sheets',
'["Cascading Style Sheets","Computer Style System","Creative Styling Software","Colorful Site Sheets"]',
'CSS controls the visual appearance of HTML elements — colors, fonts, spacing, layout, and animations. Without CSS, web pages are plain black text on white.', 1),

(22, 'How do you add CSS styles to an HTML file?', 'mcq', 'Using a <style> tag in <head> or a linked .css file',
'["Using a <style> tag in <head> or a linked .css file","Inside <body> only","Using a <css> tag","Only in external files"]',
'Three ways: 1) <style> block in <head>, 2) link to external .css file with <link>, 3) inline style attribute on individual elements.', 2),

(22, 'How do you change text color to red using CSS?', 'mcq', 'color: red;',
'["color: red;","text-color: red;","font-color: red;","colour: red;"]',
'The CSS property for text color is color (American spelling, not colour). Example: p { color: red; } makes all paragraph text red.', 3),

(22, 'What is a CSS selector?', 'mcq', 'The part that targets which HTML element to style',
'["The part that targets which HTML element to style","The CSS property name","The style value","The CSS file name"]',
'Selectors target elements. p {} targets all paragraphs. .classname {} targets elements with that class. #id {} targets element with that ID.', 4),

(22, 'How do you select elements with class "header" in CSS?', 'mcq', '.header { }',
'[".header { }","#header { }","header { }","class=header { }"]',
'A dot . before the name targets a class. <div class="header"> is targeted by .header {}. Multiple elements can share the same class.', 5),

(22, 'How do you select an element with id "main" in CSS?', 'mcq', '#main { }',
'["#main { }",".main { }","main { }","id=main { }"]',
'A hash # targets an ID. IDs should be unique — only one element per page should have a given id. #main {} targets <div id="main">.', 6),

(22, 'How do you change the background color of a page?', 'mcq', 'body { background-color: blue; }',
'["body { background-color: blue; }","page { background: blue; }","html { color: blue; }","background { blue }"]',
'background-color sets the background. Targeting body sets it for the whole page. You can use color names, hex codes (#ff0000), or rgb() values.', 7),

(22, 'Complete the CSS to make all h1 text blue:\nh1 {\n  _____: blue;\n}', 'fill', 'color',
NULL,
'color is the CSS property for text color. Note: it is "color" not "colour". The value can be a name (blue), hex (#0000ff), or rgb(0,0,255).', 8);

-- ── CSS Level 2 ──
INSERT INTO questions (lesson_id, question_text, question_type, correct_answer, options, explanation, question_order) VALUES
(23, 'What is the CSS Box Model?', 'mcq', 'Content + Padding + Border + Margin that surrounds every element',
'["Content + Padding + Border + Margin that surrounds every element","A 3D cube model","A CSS layout grid","A color model"]',
'Every HTML element is a box with 4 layers: content (the actual text/image), padding (space inside the border), border (the outline), and margin (space outside the border).', 1),

(23, 'What does padding do?', 'mcq', 'Adds space INSIDE the element, between content and border',
'["Adds space INSIDE the element, between content and border","Adds space outside the element","Creates a border","Adds space between elements"]',
'Padding is inside the box. padding: 20px adds 20px of breathing room between the content and the border on all four sides.', 2),

(23, 'What does margin do?', 'mcq', 'Adds space OUTSIDE the element, pushing other elements away',
'["Adds space OUTSIDE the element, pushing other elements away","Adds space inside","Creates a visible border","Changes text size"]',
'Margin is outside the box. margin: 20px pushes other elements 20px away from this element on all sides. Use it to space elements apart.', 3),

(23, 'What does display: flex do?', 'mcq', 'Makes the element a flex container, arranging children in a row',
'["Makes the element a flex container, arranging children in a row","Makes element invisible","Adds a border","Centers text"]',
'Flexbox is a layout system. display: flex on a parent arranges its children in a row by default. Add flex-direction: column for vertical stacking.', 4),

(23, 'How do you center elements horizontally with Flexbox?', 'mcq', 'justify-content: center',
'["justify-content: center","align-items: center","text-align: center","margin: auto"]',
'justify-content controls alignment along the MAIN axis (horizontal in row direction). center puts children in the middle. space-between puts them at the edges.', 5),

(23, 'What does font-size: 24px do?', 'mcq', 'Sets the text size to 24 pixels',
'["Sets the text size to 24 pixels","Sets the element width","Sets letter spacing","Sets line height"]',
'font-size controls text size. px = pixels. You can also use em (relative to parent), rem (relative to root), %, or vw (viewport width).', 6),

(23, 'Which CSS property makes text bold?', 'mcq', 'font-weight: bold',
'["font-weight: bold","text-bold: true","font-style: bold","font: bold"]',
'font-weight controls text thickness. Values: normal, bold, or numbers like 400 (normal), 700 (bold). font-style: italic makes text italic.', 7),

(23, 'What does border: 1px solid black do?', 'mcq', 'Adds a 1-pixel solid black border around the element',
'["Adds a 1-pixel solid black border around the element","Adds a shadow","Changes background","Adds padding"]',
'border shorthand: size style color. 1px = thickness, solid = line style (others: dashed, dotted), black = color. You can also use border-radius for rounded corners.', 8);

-- ── HTML/CSS Final Quiz ──
INSERT INTO questions (lesson_id, question_text, question_type, correct_answer, options, explanation, question_order) VALUES
(24, 'Which HTML tag defines the main content area of a page?', 'mcq', '<main>',
'["<main>","<content>","<section>","<article>"]',
'<main> is a semantic HTML5 element that wraps the primary content. It helps search engines and screen readers understand your page structure.', 1),

(24, 'What is the correct way to link an external CSS file?', 'mcq', '<link rel="stylesheet" href="style.css">',
'["<link rel=\"stylesheet\" href=\"style.css\">","<css src=\"style.css\">","<style src=\"style.css\">","<import css=\"style.css\">"]',
'<link rel="stylesheet" href="style.css"> goes inside <head>. rel="stylesheet" tells the browser it is a CSS file. href is the file path.', 2),

(24, 'Which CSS property controls the space between lines of text?', 'mcq', 'line-height',
'["line-height","line-space","text-spacing","row-height"]',
'line-height sets vertical spacing between lines. line-height: 1.6 is comfortable for reading body text. It can be a number, px, or percentage.', 3),

(24, 'What does position: absolute do?', 'mcq', 'Positions element relative to its nearest positioned ancestor',
'["Positions element relative to its nearest positioned ancestor","Positions element relative to the browser window","Fixes element when scrolling","Centers element on page"]',
'position: absolute removes the element from normal flow and positions it using top/left/right/bottom relative to its nearest ancestor that has position set.', 4),

(24, 'What does the <div> tag do?', 'mcq', 'Creates a generic container block with no visual meaning',
'["Creates a generic container block with no visual meaning","Creates a division line","Makes a table cell","Creates a heading"]',
'<div> is a generic container used to group elements for styling with CSS. It has no visual style by default. Use semantic tags when possible, div for generic grouping.', 5),

(24, 'Which CSS unit is relative to the viewport width?', 'mcq', 'vw',
'["vw","px","em","rem"]',
'vw = viewport width. 100vw is the full browser window width. 50vw is half. Great for responsive designs. vh works the same for viewport height.', 6),

(24, 'What does z-index do?', 'mcq', 'Controls which element appears on top when elements overlap',
'["Controls which element appears on top when elements overlap","Sets element size","Controls transparency","Sets animation speed"]',
'Higher z-index values appear on top. z-index only works on positioned elements (position: relative/absolute/fixed). z-index: 999 puts element on top of most things.', 7),

(24, 'What makes a website responsive?', 'mcq', 'CSS media queries that change styles based on screen size',
'["CSS media queries that change styles based on screen size","Using only px units","Making all images small","Using tables for layout"]',
'@media (max-width: 768px) { } lets you write CSS that only applies on small screens. This allows the same HTML to look good on desktop, tablet, and phone.', 8),

(24, 'What does opacity: 0.5 do?', 'mcq', 'Makes the element 50% transparent',
'["Makes the element 50% transparent","Hides the element completely","Makes text smaller","Adds a grey color"]',
'opacity ranges from 0 (completely invisible) to 1 (fully visible). 0.5 makes it semi-transparent. Unlike visibility: hidden, the element still takes up space.', 9),

(24, 'What is the purpose of <span>?', 'mcq', 'An inline container for styling a part of text',
'["An inline container for styling a part of text","A block container","A heading tag","A form element"]',
'<span> is like <div> but inline — it does not break to a new line. Use it to style a word or part of a sentence: <p>Hello <span style="color:red">World</span></p>', 10);

-- ═══════════════════════════════════════════
-- JAVA LESSONS (language_id = 5)
-- ═══════════════════════════════════════════
INSERT INTO lessons (language_id, title, lesson_order, xp_reward, lesson_type) VALUES
(5, 'Level 1: Hello World & Syntax', 1, 10, 'theory'),
(5, 'Level 2: Variables & Data Types', 2, 15, 'theory'),
(5, 'Level 3: If / Else & Operators', 3, 20, 'theory'),
(5, 'Level 4: Loops', 4, 20, 'theory'),
(5, 'Level 5: Methods & OOP Basics', 5, 25, 'theory'),
(5, 'Final Quiz: Java Basics', 6, 50, 'final_quiz');

-- ── Java Level 1 ──
INSERT INTO questions (lesson_id, question_text, question_type, correct_answer, options, explanation, question_order) VALUES
(25, 'What is Java known for?', 'mcq', '"Write once, run anywhere" — runs on any OS with JVM',
'["\"Write once, run anywhere\" — runs on any OS with JVM","Only runs on Windows","Used only for web pages","A scripting language"]',
'Java code compiles to bytecode that runs on the Java Virtual Machine (JVM). This means the same program runs on Windows, Mac, or Linux without changes.', 1),

(25, 'How do you print output in Java?', 'mcq', 'System.out.println()',
'["System.out.println()","print()","console.log()","echo()"]',
'System.out.println() prints text followed by a newline. System.out.print() prints without a newline. Both are used to output to the terminal.', 2),

(25, 'What is the entry point of every Java program?', 'mcq', 'public static void main(String[] args)',
'["public static void main(String[] args)","main()","void start()","run()"]',
'Every Java application must have a main method with this exact signature. Java starts executing from this method. It must be inside a class.', 3),

(25, 'What does every Java statement end with?', 'mcq', '; (semicolon)',
'["(semicolon)","(period)","(colon)","(nothing)"]',
'Every Java statement must end with a semicolon. Missing semicolons are one of the most common Java compilation errors for beginners.', 4),

(25, 'What wraps all Java code?', 'mcq', 'A class',
'["A class","A function","A module","A package"]',
'All Java code lives inside classes. Even the main method must be inside a class. Example: public class HelloWorld { public static void main... }', 5),

(25, 'What will this print?\nSystem.out.println("Hello, Java!");', 'mcq', 'Hello, Java!',
'["Hello, Java!","System.out.println","Hello Java","Error"]',
'System.out.println() outputs the string inside the quotes followed by a newline. It prints: Hello, Java!', 6),

(25, 'What does // do in Java?', 'mcq', 'Creates a single-line comment (ignored by Java)',
'["Creates a single-line comment (ignored by Java)","Divides two numbers","Starts a block comment","Calls a method"]',
'// starts a single-line comment. Java ignores everything after // on that line. Use /* */ for multi-line comments. Comments explain code to humans.', 7),

(25, 'Complete the print statement:\nSystem.out.___("Welcome to Java!");', 'fill', 'println',
NULL,
'println stands for "print line". It prints the text AND moves to the next line. print() does the same but without moving to a new line.', 8);

-- ── Java Level 2 ──
INSERT INTO questions (lesson_id, question_text, question_type, correct_answer, options, explanation, question_order) VALUES
(26, 'How do you declare an integer variable in Java?', 'mcq', 'int number = 5;',
'["int number = 5;","number = 5;","integer number = 5;","var number = 5;"]',
'Java is statically typed — you must declare the type. int for integers, double for decimals, String for text, boolean for true/false.', 1),

(26, 'Which data type stores decimal numbers in Java?', 'mcq', 'double',
'["double","decimal","float","int"]',
'double stores 64-bit floating-point numbers (decimals). float stores 32-bit. Use double by default for decimals as it is more precise.', 2),

(26, 'How do you declare a String in Java?', 'mcq', 'String name = "Alice";',
'["String name = \"Alice\";","string name = \"Alice\";","str name = \"Alice\";","text name = \"Alice\";"]',
'String starts with a capital S in Java (it is a class, not a primitive). Strings go in double quotes. Example: String city = "Mumbai";', 3),

(26, 'What does this print?\nint x = 10;\nint y = 3;\nSystem.out.println(x / y);', 'mcq', '3 (integer division)',
'["3 (integer division)","3.33","3.0","Error"]',
'When both numbers are int, Java does integer division and discards the decimal. 10/3 = 3 (not 3.33). For decimal result, use double: 10.0/3', 4),

(26, 'Which keyword makes a variable constant (unchangeable) in Java?', 'mcq', 'final',
'["final","const","constant","fixed"]',
'final prevents a variable from being reassigned. Example: final int MAX = 100; — trying to change MAX later causes a compilation error.', 5),

(26, 'What is the boolean data type used for?', 'mcq', 'Storing true or false values',
'["Storing true or false values","Storing numbers","Storing text","Storing multiple values"]',
'boolean stores only true or false. Example: boolean isLoggedIn = true; Used in conditions, loops, and flags. Note: lowercase in Java (unlike Boolean class).', 6),

(26, 'What is the output?\nString first = "Hello";\nString second = " World";\nSystem.out.println(first + second);', 'mcq', 'Hello World',
'["Hello World","Hello + World","firstsecond","Error"]',
'+ concatenates (joins) strings in Java. "Hello" + " World" = "Hello World". This is the same as Python but unlike SQL.', 7),

(26, 'How do you declare a boolean variable in Java?', 'mcq', 'boolean isActive = true;',
'["boolean isActive = true;","bool isActive = true;","Boolean isActive = true;","bool isActive = True;"]',
'boolean (lowercase) is the primitive type. true and false are lowercase in Java (unlike Python where they are capitalized True/False).', 8);

-- ── Java Level 3 ──
INSERT INTO questions (lesson_id, question_text, question_type, correct_answer, options, explanation, question_order) VALUES
(27, 'What is the correct if statement syntax in Java?', 'mcq', 'if (condition) { }',
'["if (condition) { }","if condition:","IF (condition) THEN","if [condition]"]',
'Java if syntax uses parentheses for the condition and curly braces for the code block. This is similar to JavaScript but different from Python.', 1),

(27, 'What will this print?\nint x = 10;\nif (x > 5) {\n    System.out.println("big");\n} else {\n    System.out.println("small");\n}', 'mcq', 'big',
'["big","small","10","Error"]',
'10 > 5 is true, so the if block runs and prints big. The else block is skipped.', 2),

(27, 'What does else if do in Java?', 'mcq', 'Checks a second condition if the first if was false',
'["Checks a second condition if the first if was false","Runs code after every if","Replaces the else block","Loops through conditions"]',
'else if checks an additional condition. Java uses else if (two words with a space), unlike Python which uses elif.', 3),

(27, 'What is the output?\nint score = 75;\nif (score >= 90) System.out.println("A");\nelse if (score >= 70) System.out.println("B");\nelse System.out.println("C");', 'mcq', 'B',
'["B","A","C","Error"]',
'75 >= 90 is false. 75 >= 70 is true, so B is printed. Once a true condition is found, the rest are skipped.', 4),

(27, 'What does the && operator mean in Java?', 'mcq', 'Logical AND — both conditions must be true',
'["Logical AND — both conditions must be true","Logical OR","Not equal","Bitwise AND only"]',
'&& is logical AND. Both sides must be true. Example: if (age >= 18 && hasID) — both must be true to enter.', 5),

(27, 'What is a switch statement used for?', 'mcq', 'Testing a variable against multiple specific values',
'["Testing a variable against multiple specific values","Replacing all if statements","Creating loops","Defining methods"]',
'switch is cleaner than many else-if chains when checking one variable against many values. Each case handles one value, and break exits the switch.', 6),

(27, 'What does break do in a switch statement?', 'mcq', 'Exits the switch block after a matching case runs',
'["Exits the switch block after a matching case runs","Stops the program","Skips to the next case","Loops back to start"]',
'Without break, Java falls through to the next case even if it does not match. Always use break at the end of each case to prevent this.', 7),

(27, 'What is the output?\nint n = 4;\nSystem.out.println(n % 2 == 0 ? "even" : "odd");', 'mcq', 'even',
'["even","odd","4","true"]',
'4 % 2 = 0. 0 == 0 is true. The ternary operator returns "even". This is a classic even/odd check pattern.', 8);

-- ── Java Level 4 ──
INSERT INTO questions (lesson_id, question_text, question_type, correct_answer, options, explanation, question_order) VALUES
(28, 'What is the Java for loop syntax?', 'mcq', 'for (int i = 0; i < n; i++) { }',
'["for (int i = 0; i < n; i++) { }","for i in range(n):","for (i = 0; i < n)","foreach i in n { }"]',
'Java for loop: initialization (int i=0), condition (i<n), update (i++), then the code block in {}. This is very similar to JavaScript.', 1),

(28, 'What will this print?\nfor (int i = 1; i <= 3; i++) {\n    System.out.println(i);\n}', 'mcq', '1\n2\n3',
'["1\n2\n3","0\n1\n2","1\n2\n3\n4","Error"]',
'Loop starts at i=1, runs while i<=3, increments by 1. Prints 1, then 2, then 3. When i becomes 4, condition 4<=3 is false and loop ends.', 2),

(28, 'What is an enhanced for loop (for-each) used for?', 'mcq', 'Iterating over arrays or collections without an index',
'["Iterating over arrays or collections without an index","Counting backwards","Looping a fixed number of times","Nested looping"]',
'Enhanced for: for (int num : numbers) { } — reads as "for each num in numbers". Simpler than using index, great when you do not need the position.', 3),

(28, 'What does a while loop do in Java?', 'mcq', 'Repeats code as long as the condition is true',
'["Repeats code as long as the condition is true","Runs exactly once","Runs a fixed number of times","Only works with arrays"]',
'while (condition) { code } — checks condition first, then runs code. If condition starts false, code never runs. Remember to update the condition inside to avoid infinite loops!', 4),

(28, 'What is a do-while loop?', 'mcq', 'A loop that runs at least once, then checks the condition',
'["A loop that runs at least once, then checks the condition","Same as while loop","A backwards loop","A loop for arrays only"]',
'do { code } while (condition); — code runs first, THEN condition is checked. Guarantees at least one execution. Unique to Java/C (Python has no do-while).', 5),

(28, 'What does continue do inside a loop?', 'mcq', 'Skips the rest of the current iteration and goes to the next',
'["Skips the rest of the current iteration and goes to the next","Stops the loop completely","Restarts from the beginning","Breaks out of if statement"]',
'continue skips to the next iteration. break stops the loop entirely. Example: if (i==3) continue; — skips iteration where i is 3 but keeps looping.', 6),

(28, 'What will this print?\nfor (int i = 0; i < 5; i++) {\n    if (i == 3) break;\n    System.out.println(i);\n}', 'mcq', '0\n1\n2',
'["0\n1\n2","0\n1\n2\n3","0\n1\n2\n3\n4","Error"]',
'Loop prints 0,1,2. When i=3, break exits the loop immediately without printing 3. So only 0,1,2 appear.', 7),

(28, 'Complete the for loop to print 1 to 5:\nfor (int i = 1; i _____ 5; i++) {\n    System.out.println(i);\n}', 'fill', '<=',
NULL,
'<= (less than or equal) includes 5 in the loop. Using < 5 would only print 1 to 4. <= is needed here because we want to include 5.', 8);

-- ── Java Level 5 ──
INSERT INTO questions (lesson_id, question_text, question_type, correct_answer, options, explanation, question_order) VALUES
(29, 'What is a method in Java?', 'mcq', 'A block of code inside a class that performs a specific task',
'["A block of code inside a class that performs a specific task","A variable","A loop","A data type"]',
'Methods are like Python functions, but they must live inside a class. They can take parameters, perform actions, and return values.', 1),

(29, 'What does void mean in a method declaration?', 'mcq', 'The method does not return any value',
'["The method does not return any value","The method is empty","The method is private","The method runs automatically"]',
'void means "returns nothing". If a method should return a value, replace void with the return type (int, String, boolean etc).', 2),

(29, 'What is a class in Java?', 'mcq', 'A blueprint for creating objects with properties and behaviors',
'["A blueprint for creating objects with properties and behaviors","A type of loop","A variable container","A database table"]',
'A class is the foundation of Object-Oriented Programming (OOP). It defines what data (fields) and actions (methods) objects of that type have.', 3),

(29, 'What is an object in Java?', 'mcq', 'An instance of a class created with the new keyword',
'["An instance of a class created with the new keyword","A primitive variable","A type of method","A module"]',
'Objects are instances of classes. Car myCar = new Car(); creates a Car object. You can create many objects from one class, each with their own data.', 4),

(29, 'What is a constructor?', 'mcq', 'A special method that runs when an object is created (new)',
'["A special method that runs when an object is created (new)","A method that destroys objects","A static method","A return method"]',
'Constructors initialize objects. They have the same name as the class and no return type. Example: public Person(String name) { this.name = name; }', 5),

(29, 'What does public mean in Java?', 'mcq', 'The method or variable can be accessed from anywhere',
'["The method or variable can be accessed from anywhere","It runs automatically","It cannot be changed","It belongs to the class not objects"]',
'public is an access modifier. public = accessible everywhere. private = only within the same class. protected = class and subclasses.', 6),

(29, 'What does static mean on a method?', 'mcq', 'The method belongs to the class, not to instances (objects)',
'["The method belongs to the class, not to instances (objects)","The method never changes","The method runs once","The method is public"]',
'static methods are called on the class itself, not objects. main() is static so Java can call it without creating an object first.', 7),

(29, 'What are the 4 pillars of OOP?', 'mcq', 'Encapsulation, Inheritance, Polymorphism, Abstraction',
'["Encapsulation, Inheritance, Polymorphism, Abstraction","Variables, Loops, Functions, Classes","Objects, Methods, Fields, Packages","Public, Private, Protected, Static"]',
'OOP stands on 4 pillars: Encapsulation (hiding data), Inheritance (child class extends parent), Polymorphism (one interface, many forms), Abstraction (hiding complexity).', 8);

-- ── Java Final Quiz ──
INSERT INTO questions (lesson_id, question_text, question_type, correct_answer, options, explanation, question_order) VALUES
(30, 'What will this print?\nSystem.out.println(10 / 3);', 'mcq', '3',
'["3","3.33","3.0","Error"]',
'Integer division in Java truncates decimals. 10/3 = 3 (the .33 is lost). To get 3.33, use double: System.out.println(10.0 / 3)', 1),

(30, 'What is the output?\nString s = "Hello";\nSystem.out.println(s.length());', 'mcq', '5',
'["5","Hello","6","Error"]',
'length() is a String method that returns the number of characters. "Hello" has 5 characters: H-e-l-l-o. Note: arrays use .length (no parentheses), strings use .length().', 2),

(30, 'What does this print?\nfor (int i = 0; i < 3; i++) {\n    System.out.print(i + " ");\n}', 'mcq', '0 1 2 ',
'["0 1 2 ","1 2 3 ","0\n1\n2","Error"]',
'print() (not println) does not add newlines. i + " " adds a space after each number. Result: 0 1 2 (with a trailing space).', 3),

(30, 'What does new int[5] create?', 'mcq', 'An integer array with 5 slots (indexes 0 to 4)',
'["An integer array with 5 slots (indexes 0 to 4)","An integer with value 5","5 separate integers","A list of 5 strings"]',
'new int[5] creates an array of 5 integers, all initialized to 0. Access with arr[0] to arr[4]. Arrays in Java have a fixed size once created.', 4),

(30, 'Which keyword is used to inherit from a parent class?', 'mcq', 'extends',
'["extends","inherits","implements","super"]',
'extends is used for class inheritance. class Dog extends Animal { } — Dog inherits all public/protected members of Animal and can add its own.', 5),

(30, 'What is an interface in Java?', 'mcq', 'A contract that defines methods a class must implement',
'["A contract that defines methods a class must implement","A type of class with data","A built-in class","A type of array"]',
'Interfaces define method signatures without implementation. Classes that implement an interface must provide the method bodies. Used for polymorphism.', 6),

(30, 'What does this print?\nint[] nums = {1, 2, 3, 4, 5};\nSystem.out.println(nums[2]);', 'mcq', '3',
'["3","2","4","Error"]',
'Arrays are zero-indexed. nums[0]=1, nums[1]=2, nums[2]=3. So nums[2] is 3.', 7),

(30, 'What is the difference between == and .equals() for Strings in Java?', 'mcq', '== checks memory reference, .equals() checks actual content',
'["== checks memory reference, .equals() checks actual content","They are the same","== is faster","equals() checks reference"]',
'For objects like String, == checks if they are the SAME object in memory. .equals() checks if the contents are the same. Always use .equals() to compare String values!', 8),

(30, 'What does try-catch do in Java?', 'mcq', 'Handles errors so the program does not crash',
'["Handles errors so the program does not crash","Runs code twice","Tests conditions","Imports libraries"]',
'try { risky code } catch (Exception e) { handle error } — if the code in try throws an error, catch handles it gracefully instead of crashing.', 9),

(30, 'What is the correct way to create an object from a class called Car?', 'mcq', 'Car myCar = new Car();',
'["Car myCar = new Car();","Car myCar = Car();","new Car myCar;","create Car myCar;"]',
'new creates an object. Car myCar declares the variable type and name. new Car() calls the constructor. Together: Car myCar = new Car();', 10);


-- ═══════════════════════════════════════════
-- ADD STORY TEXT TO LESSONS
-- ═══════════════════════════════════════════
UPDATE lessons SET story_text = '[STORY] Imagine you want to pass a note to your friend in class. You write something on paper and hand it over — that''s exactly what print() does! It''s Python''s way of passing a message to the screen. Every programmer''s first line of code in any language is Hello World, and now it''s your turn!
[CONCEPT] Python uses the print() function to display output. Whatever you put inside the brackets (in quotes for text) gets shown on screen. You can print words, numbers, or even math results. Every print() call starts a new line automatically.
[CODE] ```python
print("Hello, World!")
print("My name is Python!")
print(2 + 3)
```
[TAKEAWAY] print() is your voice in Python — it''s how your program talks to the world! 🗣️' WHERE title = 'Level 1: Hello World & Print';
UPDATE lessons SET story_text = '[STORY] Java is like a very organised filing system. Before you store anything, you must label the folder with its type: "This folder only holds whole numbers (int)." "This one holds text (String)." Unlike Python which figures it out automatically, Java makes you declare types upfront — which actually prevents many bugs!
[CONCEPT] Java primitive types: int (whole numbers), double (decimals), boolean (true/false), char (single character). String is a class (capital S). Declare as: type name = value; Use final to make a constant. Java is statically typed — the type is fixed at declaration.
[CODE] ```java
int age = 20;
double price = 9.99;
boolean isStudent = true;
String name = "Alice";
final int MAX_SCORE = 100;
System.out.println(name + " is " + age);
System.out.println("Price: " + price);
```
[TAKEAWAY] Java makes you declare types explicitly — it feels strict at first but it catches bugs before your program even runs! 🛡️' WHERE title = 'Level 2: Variables & Data Types';
UPDATE lessons SET story_text = '[STORY] Every day you make decisions: "If it''s raining, I''ll take an umbrella. Otherwise, I''ll wear sunglasses." Your brain runs if/else logic all the time! Python does the same thing — it checks a condition and decides which path to take.
[CONCEPT] if checks a condition. If True, the indented code runs. else handles the False case. elif lets you check multiple conditions in order. Always end the condition line with a colon : and indent the code inside.
[CODE] ```python
temperature = 35
if temperature > 30:
    print("It''s hot! Drink water.")
elif temperature > 20:
    print("Nice weather!")
else:
    print("It''s cold, wear a jacket.")
```
[TAKEAWAY] if/else is how your program makes decisions — just like your brain does every single day! 🧠' WHERE title = 'Level 3: If / Else Conditions';
UPDATE lessons SET story_text = '[STORY] An ATM machine checks your PIN up to 3 times. A printer prints 50 copies of a document. A game updates 60 times per second. All of these use loops! Java has four loop types: for (when you know how many times), while (while a condition is true), do-while (at least once), and enhanced for (for arrays).
[CONCEPT] for loop: for(int i=0; i<n; i++) {}. Enhanced for: for(type item : array) {}. while: while(condition) {}. do-while: do {} while(condition); — runs at least once. break exits the loop. continue skips to next iteration. i++ means i=i+1.
[CODE] ```java
for (int i = 1; i <= 5; i++) {
    System.out.println("Step " + i);
}
int[] nums = {10, 20, 30};
for (int n : nums) {
    System.out.println(n);
}
```
[TAKEAWAY] Java has four loop types — for when you need a counter, enhanced for when you have a collection, while for unknown repetitions! 🔄' WHERE title = 'Level 4: Loops';
UPDATE lessons SET story_text = '[STORY] Imagine you make a great cup of tea. Your friends love it and ask for it every day. Instead of explaining the recipe every time, you write it down once as "Make Tea" — and anyone can follow it anytime. That''s a function! Write once, use forever.
[CONCEPT] def defines a function. Parameters are inputs. return sends back a result. Call the function by its name with arguments in brackets. Functions keep your code organised and prevent repetition (DRY: Don''t Repeat Yourself).
[CODE] ```python
def greet(name):
    return f"Hello, {name}! Welcome!"

def add(a, b):
    return a + b

print(greet("Alice"))
print(add(5, 3))
```
[TAKEAWAY] Functions are reusable recipes — write the instructions once and call them whenever you need! 🍵' WHERE title = 'Level 5: Functions';
UPDATE lessons SET story_text = '[STORY] You''ve come so far! You''ve learned to talk to Python with print(), store data in variables, make decisions with if/else, automate tasks with loops, and organise code with functions. Now it''s time to prove you''ve got it all!
[CONCEPT] This final quiz covers everything from all 5 Python levels: print(), variables and data types, if/elif/else conditions, for and while loops, and functions with parameters and return values. Take your time and think carefully!
[CODE] ```python
def check_grade(score):
    if score >= 90:
        return "A"
    elif score >= 70:
        return "B"
    else:
        return "C"

for s in [95, 75, 55]:
    print(f"Score {s}: Grade {check_grade(s)}")
```
[TAKEAWAY] You''ve learned the core building blocks of Python. Every complex program is just these basics combined cleverly! 🏆' WHERE title = 'Final Quiz: Python Basics';
UPDATE lessons SET story_text = '[STORY] Imagine you''re a detective leaving notes at a crime scene. console.log() is your way of leaving clues — little messages that only appear in the browser''s secret developer console (press F12!). Every JavaScript developer uses it constantly to understand what their code is doing.
[CONCEPT] console.log() outputs values to the browser console. let declares a variable that can change. const declares one that cannot change. Always prefer const unless you know the value will change. JavaScript statements end with a semicolon ;
[CODE] ```javascript
const name = "Alice";
let score = 0;
score = 100;
console.log(name);
console.log("Score:", score);
console.log(2 + 3);
```
[TAKEAWAY] console.log() is your best debugging friend — print everything, understand everything! 🔍' WHERE title = 'Level 1: Console & Variables';
UPDATE lessons SET story_text = '[STORY] JavaScript is like a very flexible helper who can work with all kinds of things: words (strings), numbers, yes/no answers (booleans), and even nothing (null/undefined). The tricky part? Sometimes it tries to be TOO helpful and mixes types in surprising ways!
[CONCEPT] JavaScript has: string ("text"), number (42 or 3.14), boolean (true/false), null (empty on purpose), undefined (not set yet). The + operator adds numbers but JOINS strings. Always use === (triple equals) to compare — never == which can give surprises.
[CODE] ```javascript
const age = 20;
const name = "Bob";
const msg = `Hello ${name}, you are ${age}!`;
console.log(msg);
console.log(typeof age);
console.log("5" === 5);
```
[TAKEAWAY] In JavaScript, always use === for comparisons and template literals (backticks) for building strings! 🎯' WHERE title = 'Level 2: Data Types & Operators';
UPDATE lessons SET story_text = '[STORY] A bouncer at a club checks your age at the door: "Are you 18 or older? Yes — come in. No — sorry, not tonight." Then checks if you''re on the VIP list. That''s exactly if/else if/else in JavaScript — a chain of checks with different outcomes for each.
[CONCEPT] JavaScript if syntax uses parentheses () for the condition and curly braces {} for the code block. else if (two words, unlike Python''s elif) checks additional conditions. The ternary operator condition ? valueIfTrue : valueIfFalse is a one-line shortcut.
[CODE] ```javascript
const age = 20;
if (age >= 18) {
  console.log("Welcome in!");
} else {
  console.log("Sorry, too young.");
}
const label = age >= 18 ? "Adult" : "Minor";
console.log(label);
```
[TAKEAWAY] if/else controls your program''s flow — master it and you control what your code does in every situation! 🚦' WHERE title = 'Level 3: If / Else & Comparisons';
UPDATE lessons SET story_text = '[STORY] A vending machine is a perfect function — you put in money (input/arguments), press a button (call the function), and get a snack (return value). The machine''s internal mechanism is hidden from you. Functions work the same way: defined once, used many times, internals hidden!
[CONCEPT] Regular functions use the function keyword. Arrow functions use => and are shorter. Both take parameters and can return values. If a function body is one expression, arrow functions can skip the curly braces and return keyword entirely.
[CODE] ```javascript
function multiply(a, b) {
  return a * b;
}
const square = n => n * n;
const greet = name => `Hello, ${name}!`;
console.log(multiply(4, 5));
console.log(square(7));
console.log(greet("World"));
```
[TAKEAWAY] Arrow functions are the modern, cleaner way to write functions in JavaScript — learn both styles! ➡️' WHERE title = 'Level 5: Functions & Arrow Functions';
UPDATE lessons SET story_text = '[STORY] From console.log() detective work to arrow functions, you''ve learned the real language of the web! Every website you visit runs JavaScript. Now let''s see how well you''ve absorbed all five levels — variables, types, conditions, loops, and functions!
[CONCEPT] This quiz tests all five JS levels: console.log and variables (let/const), data types and operators (===, typeof, template literals), if/else and ternary, for/while/forEach loops, and regular vs arrow functions.
[CODE] ```javascript
const nums = [1, 2, 3, 4, 5];
const evens = nums.filter(n => n % 2 === 0);
const doubled = evens.map(n => n * 2);
console.log(doubled);
```
[TAKEAWAY] JavaScript powers the entire web — you now speak its language! 🌐' WHERE title = 'Final Quiz: JavaScript Basics';
UPDATE lessons SET story_text = '[STORY] Imagine a massive school library with 10,000 books. SQL is like asking the librarian a very specific question: "Can you find me all books about dinosaurs written after 2010?" The librarian (database) searches through everything and brings back exactly what you asked for. That''s SELECT!
[CONCEPT] SQL (Structured Query Language) talks to databases. SELECT retrieves data. * means all columns. FROM specifies the table. You can select specific columns by naming them. SQL is not case-sensitive for keywords but it''s good practice to CAPITALISE them.
[CODE] ```sql
SELECT * FROM students;
SELECT name, age FROM students;
SELECT name, email FROM users;
```
[TAKEAWAY] SELECT is how you ask the database a question — be specific about what you want and it delivers instantly! 📚' WHERE title = 'Level 1: What is SQL & SELECT';
UPDATE lessons SET story_text = '[STORY] Back at the library: instead of getting ALL 10,000 books, you say "Only books about dinosaurs WHERE the year is after 2010." The WHERE clause is your filter — it narrows down millions of records to exactly the ones you need, like a search bar but much more powerful!
[CONCEPT] WHERE filters rows by condition. Use = for exact match (not == like Python). LIKE with % wildcard searches text patterns. AND requires both conditions true. OR requires at least one. String values go in single quotes.
[CODE] ```sql
SELECT * FROM users WHERE age > 18;
SELECT * FROM products WHERE price < 500;
SELECT * FROM users WHERE name LIKE ''A%'';
SELECT * FROM users WHERE age > 18 AND country = ''India'';
```
[TAKEAWAY] WHERE is your superpower filter — never fetch all data when you only need some of it! 🎯' WHERE title = 'Level 2: WHERE Clause & Filtering';
UPDATE lessons SET story_text = '[STORY] You asked for all action movies and got 500 results. Now you want them sorted by rating (best first) and only the top 10. ORDER BY sorts your results, LIMIT cuts them down to size, and DISTINCT removes duplicates — together they turn a flood of data into exactly what you need!
[CONCEPT] ORDER BY sorts results (ASC = A to Z / low to high, DESC = Z to A / high to low). LIMIT restricts how many rows return. DISTINCT removes duplicate values. COUNT(*) counts rows. Combine them to get "top 5" or "unique categories" queries.
[CODE] ```sql
SELECT * FROM products ORDER BY price DESC LIMIT 5;
SELECT DISTINCT category FROM products;
SELECT COUNT(*) FROM orders WHERE status = ''pending'';
SELECT name, score FROM students ORDER BY score DESC LIMIT 3;
```
[TAKEAWAY] ORDER BY + LIMIT is the classic combo for finding "the best" or "the most recent" in any dataset! 🏆' WHERE title = 'Level 3: ORDER BY, LIMIT & DISTINCT';
UPDATE lessons SET story_text = '[STORY] A library doesn''t just let you read books — you can also ADD new books, UPDATE the card catalogue, and REMOVE old books. SQL''s INSERT adds new records, UPDATE changes existing ones, and DELETE removes them. But beware — UPDATE and DELETE without WHERE affects EVERY row!
[CONCEPT] INSERT INTO table (columns) VALUES (values) adds a new row. UPDATE table SET column=value WHERE condition changes existing rows. DELETE FROM table WHERE condition removes rows. NEVER run UPDATE or DELETE without a WHERE clause unless you really mean it!
[CODE] ```sql
INSERT INTO students (name, age) VALUES (''Riya'', 20);
UPDATE students SET age = 21 WHERE name = ''Riya'';
DELETE FROM students WHERE name = ''Riya'';
```
[TAKEAWAY] Always use WHERE with UPDATE and DELETE — forgetting it is one of the most dangerous mistakes in SQL! ⚠️' WHERE title = 'Level 4: INSERT, UPDATE & DELETE';
UPDATE lessons SET story_text = '[STORY] Imagine two spreadsheets: one with customer names, one with their orders. To see "who ordered what" you need to CONNECT them. That''s a JOIN — it combines rows from two tables wherever a column matches, like zipping two lists together based on a shared ID.
[CONCEPT] INNER JOIN returns only matching rows from both tables. LEFT JOIN keeps all left table rows even without a match (right side shows NULL). ON specifies the matching condition. GROUP BY groups rows for aggregate functions like COUNT and SUM.
[CODE] ```sql
SELECT students.name, grades.score
FROM students
INNER JOIN grades ON students.id = grades.student_id;

SELECT country, COUNT(*) as total
FROM users
GROUP BY country;
```
[TAKEAWAY] JOINs are what make relational databases powerful — connecting data across tables is where SQL truly shines! 🔗' WHERE title = 'Level 5: JOINs & Relationships';
UPDATE lessons SET story_text = '[STORY] You started with a simple SELECT and now you can filter, sort, insert, update, delete, and even JOIN multiple tables! SQL is used by every app that stores data — Instagram, WhatsApp, banks, hospitals. You''ve learned one of the most valuable skills in tech!
[CONCEPT] This final quiz covers all five SQL levels: SELECT and FROM, WHERE filtering with AND/OR/LIKE, ORDER BY/LIMIT/DISTINCT/COUNT, INSERT/UPDATE/DELETE, and JOINs with INNER JOIN and LEFT JOIN.
[CODE] ```sql
SELECT u.name, COUNT(o.id) as order_count
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
WHERE u.country = ''India''
GROUP BY u.name
ORDER BY order_count DESC
LIMIT 5;
```
[TAKEAWAY] SQL is the language of data — and data is everywhere. You now have a skill used in every tech company on the planet! 🗄️' WHERE title = 'Final Quiz: SQL Basics';
UPDATE lessons SET story_text = '[STORY] Imagine building a house. HTML is the skeleton — the walls, floors, and roof. CSS will paint it later. JavaScript will add electricity. But first, you need the structure! Every website you''ve ever visited is built on HTML tags, and now you''re going to write your first ones.
[CONCEPT] HTML uses tags in angle brackets like <h1> for headings and <p> for paragraphs. Most tags have an opening <tag> and closing </tag>. The document structure is: <!DOCTYPE html> → <html> → <head> (metadata) → <body> (visible content).
[CODE] ```html
<!DOCTYPE html>
<html>
<head>
  <title>My First Page</title>
</head>
<body>
  <h1>Hello World!</h1>
  <p>This is my first webpage.</p>
</body>
</html>
```
[TAKEAWAY] HTML is the skeleton of every webpage — master the structure first and everything else builds on top! 🏗️' WHERE title = 'Level 1: What is HTML & Basic Tags';
UPDATE lessons SET story_text = '[STORY] A webpage without links is like a book with no table of contents — you''re stuck on one page! Links let you travel the entire internet. Images make pages come alive. Lists organise information clearly. These three elements appear on virtually every webpage ever made.
[CONCEPT] <a href="url"> creates a hyperlink. target="_blank" opens in a new tab. <img src="path" alt="description"> embeds images (self-closing, no </img>). <ul> makes bullet lists, <ol> makes numbered lists, each item in <li> tags.
[CODE] ```html
<a href="https://google.com" target="_blank">Visit Google</a>
<img src="photo.jpg" alt="A beautiful photo">
<ul>
  <li>Python</li>
  <li>JavaScript</li>
  <li>HTML</li>
</ul>
```
[TAKEAWAY] Links, images, and lists are the holy trinity of web content — you''ll use them on every single page! 🔗' WHERE title = 'Level 2: Links, Images & Lists';
UPDATE lessons SET story_text = '[STORY] Every time you log in to Instagram, search on Google, or fill a sign-up form — you''re using HTML forms! Forms are how users send data to websites. The login box, search bar, checkout form — all HTML inputs collecting your information and sending it somewhere.
[CONCEPT] <form> wraps all inputs. <input type="text"> for text, type="password" for hidden text, type="email" for email validation. <textarea> for multi-line text. <button type="submit"> or <input type="submit"> submits the form. placeholder shows hint text, required makes field mandatory.
[CODE] ```html
<form>
  <label>Name: <input type="text" placeholder="Your name" required></label>
  <label>Email: <input type="email" placeholder="you@email.com"></label>
  <textarea placeholder="Your message..."></textarea>
  <button type="submit">Send</button>
</form>
```
[TAKEAWAY] Forms are how users communicate with websites — every login, search, and signup you''ve ever done used these elements! 📝' WHERE title = 'Level 3: HTML Forms & Input';
UPDATE lessons SET story_text = '[STORY] You''ve built the skeleton (HTML). Now it''s time to dress it up! CSS is like a stylist — you point at elements and say "make this blue, make that bigger, put a border here." Without CSS every website would be black text on a white background. CSS is what makes the web beautiful!
[CONCEPT] CSS targets elements with selectors: element name (p {}), class (.myclass {}), or ID (#myid {}). Properties control the style: color for text, background-color for background, font-size for text size. CSS goes in a <style> tag in <head> or an external .css file.
[CODE] ```css
body {
  background-color: #1a1a2e;
  color: white;
  font-family: Arial, sans-serif;
}
h1 { color: #00e5a0; font-size: 2rem; }
.card { background: #16213e; padding: 20px; border-radius: 10px; }
```
[TAKEAWAY] CSS is the stylist of the web — it transforms plain HTML skeletons into beautiful, colourful, modern websites! 🎨' WHERE title = 'Level 4: CSS Basics & Selectors';
UPDATE lessons SET story_text = '[STORY] Every HTML element is secretly a box. Like boxes stacked in a warehouse — each has content inside, padding around the content, a border around the padding, and margin pushing other boxes away. Understanding this box model unlocks complete control over layout. Then Flexbox lets you arrange those boxes however you like!
[CONCEPT] The Box Model: content → padding (space inside) → border (outline) → margin (space outside). Flexbox: display:flex on a parent arranges children in a row. justify-content centres horizontally. align-items centres vertically. flex-direction:column stacks vertically.
[CODE] ```css
.container {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 16px;
}
.card {
  padding: 20px;
  margin: 10px;
  border: 1px solid #ccc;
  border-radius: 8px;
}
```
[TAKEAWAY] Master the Box Model and Flexbox and you can build ANY layout you can imagine — they are the two most important CSS concepts! 📐' WHERE title = 'Level 5: CSS Box Model & Flexbox';
UPDATE lessons SET story_text = '[STORY] You started with a blank white page and now you can build complete, styled web pages with structure, links, images, forms, and beautiful CSS layouts! Every website you see was built by someone who knew exactly what you know now. You''re a web developer!
[CONCEPT] This quiz covers all five levels: HTML structure and basic tags, links/images/lists, forms and inputs, CSS selectors and properties, and the Box Model with Flexbox layout.
[CODE] ```html
<div class="card">
  <h2>Hello World</h2>
  <p>Built with HTML & CSS</p>
  <a href="#" class="btn">Click Me</a>
</div>
```
[TAKEAWAY] HTML + CSS are the foundation of the entire visual web. You now have the power to build anything you can see in a browser! 🌐' WHERE title = 'Final Quiz: HTML & CSS Basics';
UPDATE lessons SET story_text = '[STORY] Java was created with one incredible promise: "Write Once, Run Anywhere." In 1995 this was revolutionary — the same code could run on Windows, Mac, Linux, phones, even smartwatches. Today Java powers Android apps, banking systems, and giant enterprise software. And it all starts with one line: System.out.println!
[CONCEPT] Every Java program lives inside a class. The entry point is the main method with this exact signature: public static void main(String[] args). System.out.println() prints with a newline, System.out.print() prints without. Every statement ends with a semicolon ;
[CODE] ```java
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
        System.out.println("Welcome to Java!");
        System.out.print("No newline here ");
        System.out.println("same line continues");
    }
}
```
[TAKEAWAY] Every Java program needs a class and a main method — this is your program''s front door and Java always enters here! 🚪' WHERE title = 'Level 1: Hello World & Syntax';
UPDATE lessons SET story_text = '[STORY] A traffic light system in Java: if the light is red, stop. else if it''s yellow, slow down. else (it''s green), go! Java''s conditional logic is almost identical to JavaScript — curly braces, parentheses, else if (not elif). Once you know one C-style language, the others feel familiar!
[CONCEPT] Java if syntax: if (condition) { } else if (condition) { } else { }. Comparison operators: ==, !=, >, <, >=, <=. Logical operators: && (AND), || (OR), ! (NOT). The switch statement handles multiple specific values cleanly. Ternary: condition ? valueIfTrue : valueIfFalse.
[CODE] ```java
int score = 75;
if (score >= 90) {
    System.out.println("Grade A");
} else if (score >= 70) {
    System.out.println("Grade B");
} else {
    System.out.println("Grade C");
}
String result = score >= 60 ? "Pass" : "Fail";
System.out.println(result);
```
[TAKEAWAY] Java''s if/else is almost identical to JavaScript — learn one, and the other comes naturally! 🚦' WHERE title = 'Level 3: If / Else & Operators';
UPDATE lessons SET story_text = '[STORY] Imagine a blueprint for a house. The blueprint (class) describes what every house has: rooms (fields/variables) and actions (methods). When you actually build a house from the blueprint, that''s creating an object. Java is built entirely on this idea — everything is a class, every action is a method. This is Object-Oriented Programming!
[CONCEPT] Methods are functions inside a class. void means no return value. static means it belongs to the class not an object. A class is a blueprint, an object is a real instance (new keyword). Constructors initialise objects. The 4 OOP pillars: Encapsulation, Inheritance, Polymorphism, Abstraction.
[CODE] ```java
public class Dog {
    String name;
    public Dog(String name) {
        this.name = name;
    }
    public void bark() {
        System.out.println(name + " says: Woof!");
    }
}
Dog myDog = new Dog("Bruno");
myDog.bark();
```
[TAKEAWAY] Classes are blueprints, objects are real things built from them — this is the heart of Java and all OOP languages! 🏛️' WHERE title = 'Level 5: Methods & OOP Basics';
UPDATE lessons SET story_text = '[STORY] You''ve gone from Hello World to writing classes and objects! Java is used to build Android apps, Netflix''s backend, Minecraft, and millions of enterprise applications. The concepts you''ve learned — variables, conditions, loops, methods, and OOP — are the same ones professional Java developers use every day.
[CONCEPT] This final quiz tests all five Java levels: System.out.println and basic syntax, data types and variables, if/else and operators, for/while/enhanced-for loops, and methods with OOP basics (classes, objects, constructors).
[CODE] ```java
public class Quiz {
    static int square(int n) { return n * n; }
    public static void main(String[] args) {
        for (int i = 1; i <= 5; i++) {
            System.out.println(i + " squared = " + square(i));
        }
    }
}
```
[TAKEAWAY] Java is one of the most in-demand programming languages in the world. You now speak it! ☕' WHERE title = 'Final Quiz: Java Basics';