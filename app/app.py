from flask import Flask, render_template, request
import mysql.connector
from dotenv import load_dotenv
import os

load_dotenv()

app = Flask(__name__)

db = mysql.connector.connect(
    host=os.getenv("DB_HOST"),
    user=os.getenv("DB_USER"),
    password=os.getenv("DB_PASSWORD"),
    database=os.getenv("DB_NAME"),
    use_pure=True
)

@app.route("/")
def home():
    cursor = db.cursor(dictionary=True)
    cursor.execute("""
        SELECT s.roll_no, s.name, sub.subject_name, t.teacher_name, a.date, a.status
        FROM attendance a
        JOIN students s ON a.student_id = s.student_id
        JOIN subjects sub ON a.subject_id = sub.subject_id
        JOIN teachers t ON a.teacher_id = t.teacher_id
    """)
    records = cursor.fetchall()
    return render_template("index.html", records=records)

@app.route("/student", methods=["GET", "POST"])
def student():
    records = []
    if request.method == "POST":
        roll_no = request.form["roll_no"]
        cursor = db.cursor(dictionary=True)
        cursor.callproc("GetStudentAttendance", [roll_no])
        for result in cursor.stored_results():
            records = result.fetchall()
    return render_template("student.html", records=records)

@app.route("/defaulters")
def defaulters():
    cursor = db.cursor(dictionary=True)
    cursor.execute("""
        SELECT
            s.roll_no,
            s.name,
            sub.subject_name,
            ROUND(SUM(a.status = 'Present') * 100.0 / COUNT(*), 2) AS attendance_percentage
        FROM attendance a
        JOIN students s ON a.student_id = s.student_id
        JOIN subjects sub ON a.subject_id = sub.subject_id
        GROUP BY s.student_id, sub.subject_id
        HAVING attendance_percentage < 75
    """)
    defaulters = cursor.fetchall()
    return render_template("defaulters.html", defaulters=defaulters)

@app.route("/mark", methods=["GET", "POST"])
def mark():
    cursor = db.cursor(dictionary=True)
    success = False
    error = None

    if request.method == "POST":
        student_id = request.form["student_id"]
        subject_id = request.form["subject_id"]
        teacher_id = request.form["teacher_id"]
        date = request.form["date"]
        status = request.form["status"]
        try:
            cursor.execute("""
                INSERT INTO attendance (student_id, subject_id, teacher_id, date, status)
                VALUES (%s, %s, %s, %s, %s)
            """, (student_id, subject_id, teacher_id, date, status))
            db.commit()
            success = True
        except Exception as e:
            error = "Attendance already marked for this student, subject and date."

    cursor.execute("SELECT student_id, name, roll_no FROM students")
    students = cursor.fetchall()
    cursor.execute("SELECT subject_id, subject_name FROM subjects")
    subjects = cursor.fetchall()
    cursor.execute("SELECT teacher_id, teacher_name FROM teachers")
    teachers = cursor.fetchall()

    return render_template("mark.html", students=students, subjects=subjects, teachers=teachers, success=success, error=error)

if __name__ == "__main__":
    app.run(debug=True)