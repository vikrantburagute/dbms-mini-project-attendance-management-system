from flask import Flask, render_template, request, redirect, url_for, session 
import mysql.connector
from dotenv import load_dotenv
import os
from functools import wraps

load_dotenv()

app = Flask(__name__)
app.secret_key = os.getenv("SECRET_KEY")

db = mysql.connector.connect(
    host=os.getenv("DB_HOST"),
    user=os.getenv("DB_USER"),
    password=os.getenv("DB_PASSWORD"),
    database=os.getenv("DB_NAME"),
    use_pure=True
)

def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if "user_id" not in session:
            return redirect(url_for("login"))
        return f(*args, **kwargs)
    return decorated_function

@app.route("/")
@login_required
def home():
    cursor = db.cursor(dictionary=True)
    if session["role"] == "teacher":
        cursor.execute("""
            SELECT s.roll_no, s.name, sub.subject_name, t.teacher_name, a.date, a.status
            FROM attendance a
            JOIN students s ON a.student_id = s.student_id
            JOIN subjects sub ON a.subject_id = sub.subject_id
            JOIN teachers t ON a.teacher_id = t.teacher_id
        """)
        records = cursor.fetchall()
        return render_template("index.html", records=records, role="teacher", percentages=[])
    else:
        cursor.execute("""
            SELECT s.roll_no, s.name, sub.subject_name, t.teacher_name, a.date, a.status
            FROM attendance a
            JOIN students s ON a.student_id = s.student_id
            JOIN subjects sub ON a.subject_id = sub.subject_id
            JOIN teachers t ON a.teacher_id = t.teacher_id
            WHERE s.student_id = %s
        """, (session["ref_id"],))
        records = cursor.fetchall()

        cursor.execute("""
            SELECT sub.subject_name,
            ROUND(SUM(a.status = 'Present') * 100.0 / COUNT(*), 2) AS attendance_percentage
            FROM attendance a
            JOIN subjects sub ON a.subject_id = sub.subject_id
            WHERE a.student_id = %s
            GROUP BY sub.subject_id
        """, (session["ref_id"],))
        percentages = cursor.fetchall()

        return render_template("index.html", records=records, percentages=percentages, role="student")

@app.route("/student", methods=["GET", "POST"])
@login_required
def student():
    if session["role"] != "teacher":
        return redirect(url_for("home"))
    records = []
    if request.method == "POST":
        roll_no = request.form["roll_no"]
        cursor = db.cursor(dictionary=True)
        cursor.callproc("GetStudentAttendance", [roll_no])
        for result in cursor.stored_results():
            records = result.fetchall()
    return render_template("student.html", records=records, role=session["role"])

@app.route("/defaulters")
@login_required
def defaulters():
    if session["role"] != "teacher":
        return redirect(url_for("home"))
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
    return render_template("defaulters.html", defaulters=defaulters, role=session["role"])

@app.route("/mark", methods=["GET", "POST"])
@login_required
def mark():
    if session["role"] != "teacher":
        return redirect(url_for("home"))
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

    return render_template("mark.html", students=students, subjects=subjects, teachers=teachers, success=success, error=error, role=session["role"])

@app.route("/login", methods=["GET", "POST"])
def login():
    error = None
    if request.method == "POST":
        username = request.form["username"]
        password = request.form["password"]
        cursor = db.cursor(dictionary=True)
        cursor.execute("SELECT * FROM users WHERE username = %s AND password = %s", (username, password))
        user = cursor.fetchone()
        if user:
            session["user_id"] = user["user_id"]
            session["username"] = user["username"]
            session["role"] = user["role"]
            session["ref_id"] = user["ref_id"]
            return redirect(url_for("home"))
        else:
            error = "Invalid username or password."
    return render_template("login.html", error=error)

@app.route("/logout")
def logout():
    session.clear()
    return redirect(url_for("login"))

if __name__ == "__main__":
    app.run(debug=True)