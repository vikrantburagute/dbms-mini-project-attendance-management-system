from flask import Flask, render_template
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

if __name__ == "__main__":
    app.run(debug=True)