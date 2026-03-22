# Attendance Management System

A full-stack web application to manage and track student attendance, built as a DBMS mini project. Designed with a dual verification system where both students and teachers mark attendance independently, eliminating proxy attendance and missed markings.

## Tech Stack
- **Frontend:** HTML, CSS (Bootstrap - coming soon)
- **Backend:** Python, Flask
- **Database:** MySQL

## Features
- Full attendance report with student, subject and teacher details
- Student lookup — search attendance history by roll number
- Defaulters list — auto generated list of students below 75% attendance
- Mark attendance — with duplicate entry protection
- Dual verification system — attendance confirmed only when both student and teacher mark (in progress)

## Database
- Normalized schema with students, subjects, teachers and attendance tables
- Integrity constraints — PRIMARY KEY, FOREIGN KEY, NOT NULL, UNIQUE, CHECK
- Stored procedures, functions, triggers, views and transactions implemented

## How to Run Locally
1. Clone the repo
2. Import `attendancemanagementsystem.sql` into MySQL
3. Create a `.env` file in the `app` folder with your MySQL credentials:
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=yourpassword
DB_NAME=attendance_db
4. Install dependencies:
pip install flask mysql-connector-python python-dotenv
5. Run the app:
python app.py
6. Open `http://127.0.0.1:5000` in your browser

## Planned Features
- Dual verification attendance — confirmed only when both student and teacher mark independently
- Login system with separate teacher and student roles
- Attendance percentage dashboard with charts
- Email alerts for students falling below 75%
- Mobile responsive design