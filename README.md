# Learning-Platform-Python
AI-powered programming learning platform with gamified lessons, quizzes, browser-based code compiler, progress tracking, and a LLaMA 3.2 chatbot tutor.
# CodeQuest – AI Powered Learning Platform 🚀

CodeQuest is an AI-powered programming learning platform designed to make coding education more engaging, interactive, and accessible. Inspired by modern learning platforms like Duolingo, CodeQuest combines structured lessons, gamification, coding practice, quizzes, and AI-assisted learning into a single unified environment.

The platform enables learners to study programming concepts, practice coding directly in the browser, track their progress through XP and streaks, and receive instant help from an AI-powered tutor.

---

## ✨ Features

### 📚 Interactive Learning Modules
- Structured programming lessons
- Concept explanations with examples
- Progressive learning path
- Multiple programming language support

### 🤖 AI Programming Tutor
- Powered by Ollama and LLaMA 3.2
- Context-aware conversations
- Programming guidance and doubt solving
- Multi-turn chat history support

### 💻 Integrated Code Compiler
- Execute code directly from the browser
- Supports Python and JavaScript
- Real-time output and error handling
- Secure temporary file execution

### 🎯 Quiz & Assessment System
- Multiple Choice Questions (MCQs)
- Fill-in-the-Blank Questions
- Code-Based Questions
- Instant feedback and explanations

### 🏆 Gamification
- XP Reward System
- Hearts/Lives Mechanism
- Learning Streaks
- Lesson Completion Tracking
- Progress-Based Unlocking

### 📈 Progress Tracking Dashboard
- Total XP Earned
- Lessons Completed
- Learning Progress
- Streak Tracking
- Personalized Statistics

### 🔐 User Authentication
- Secure Registration & Login
- Session Management
- Progress Persistence
- Personalized Learning Experience

---

## 🛠️ Technology Stack

### Backend
- Python
- Flask
- REST API Architecture

### Frontend
- HTML
- CSS
- JavaScript

### Database
- MySQL

### AI Integration
- Ollama
- LLaMA 3.2

### Additional Libraries
- Requests
- MySQL Connector
- Subprocess
- JSON

---

## 🏗️ System Architecture

```text
Frontend (HTML/CSS/JS)
            │
            ▼
       Flask Backend
            │
 ┌──────────┼──────────┐
 ▼          ▼          ▼
MySQL    Compiler    Ollama
Database  Engine     LLaMA 3.2
```

---

## 🚀 Core Functionalities

### Authentication Module
- User Registration
- User Login
- Session Validation
- Duplicate Account Detection

### Lesson Module
- Lesson Retrieval
- Question Management
- Quiz Validation
- XP Calculation
- Progress Persistence

### Compiler Module
- Python Code Execution
- JavaScript Code Execution
- Output Capture
- Runtime Error Handling
- Timeout Protection

### Chatbot Module
- AI-Powered Programming Assistance
- Chat History Storage
- Context-Aware Responses
- Multi-Turn Conversations

### Dashboard Module
- Progress Analytics
- XP Statistics
- Lesson Completion Tracking
- Learning Streak Monitoring

---

## 📊 Database Design

The platform uses MySQL with the following core tables:

- Users
- Languages
- Lessons
- Questions
- User Progress
- Chat History

The database is automatically seeded with:
- Programming Languages
- Lessons
- Quiz Questions
- Learning Content

---

## 📸 Screenshots

### Login & Registration
_Add Screenshot_

### Dashboard
_Add Screenshot_

### Learning Modules
_Add Screenshot_

### Quiz Interface
_Add Screenshot_

### Code Compiler
_Add Screenshot_

### AI Chatbot
_Add Screenshot_

---

## ⚙️ Installation

### Clone Repository

```bash
git clone https://github.com/yourusername/CodeQuest.git
cd CodeQuest
```

### Install Dependencies

```bash
pip install -r requirements.txt
```

### Configure MySQL

Create the database and run:

```sql
source schema.sql;
```

### Start Ollama

```bash
ollama serve
```

Pull the required model:

```bash
ollama pull llama3.2
```

### Run Application

```bash
python app.py
```

Open:

```text
http://localhost:5000
```

---

## 🎯 Project Objectives

- Make programming education engaging and interactive.
- Provide AI-powered assistance during learning.
- Encourage consistent learning through gamification.
- Allow learners to practice coding without installing tools.
- Deliver a complete learning ecosystem within a single platform.

---

## 🔮 Future Enhancements

- Voice-Based AI Tutor
- AI Generated Quizzes
- AI Generated Lessons
- More Programming Languages
- Leaderboards
- Course Recommendations
- Mobile Application
- Cloud Deployment
- Docker Support
- CI/CD Pipeline

---

## 📈 Results

The platform successfully integrates:

- Interactive Lessons
- Quiz-Based Learning
- Browser-Based Coding Practice
- AI Tutoring
- Progress Tracking
- Gamification

Testing confirmed reliable performance across authentication, lesson delivery, code execution, chatbot interaction, and database operations.

---

## 👩‍💻 Author

**V**

Final Year B.Tech Student | AI & Data Science

Passionate about Artificial Intelligence, Cybersecurity, Software Development, and Educational Technology.

---

## 📄 License

This project is developed for educational and research purposes.
