# Attendance Management System

A full-stack web application to manage and track student attendance, built as a DBMS mini project for SPPU's SE Computer Engineering curriculum.

## Tech Stack
- **Frontend:** HTML, Bootstrap 5
- **Backend:** Python, Flask
- **Database:** MySQL

## Features
- Role based login — teachers and students see different views
- Teachers: full attendance report, student lookup by roll number, defaulters list, mark attendance
- Students: personal attendance report with subject wise percentage summary on login
- Defaulters list — auto generated list of students below 75%
- Duplicate attendance protection
- Route protection — all pages require login, restricted pages redirect unauthorized users

## Database
- Normalized schema with students, subjects, teachers, users and attendance tables
- Integrity constraints — PRIMARY KEY, FOREIGN KEY, NOT NULL, UNIQUE, CHECK
- Stored procedures, functions, triggers, views and transactions implemented

## Planned Features
- Attendance percentage dashboard with charts
- Email alerts for students falling below 75%
- Mobile responsive design
- Deployment on PythonAnywhere

## How to Run Locally
1. Clone the repo
2. Import `attendancemanagementsystem.sql` into MySQL
3. Create a `.env` file in the `app` folder:
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=yourpassword
DB_NAME=attendance_db
SECRET_KEY=yourkey
4. Install dependencies:
pip install flask mysql-connector-python python-dotenv
5. Run the app:
python app.py
6. Open `http://127.0.0.1:5000` in your browser

## Sample Login Credentials
| Username | Password | Role    |
|----------|----------|------   |
| aarav    | pass123  | Student |
| nj       | pass123  | Teacher |