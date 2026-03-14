DROP DATABASE IF EXISTS attendance_db;
CREATE DATABASE attendance_db;
USE attendance_db;

CREATE TABLE students (
	student_id INT PRIMARY KEY AUTO_INCREMENT, /*PRIMARY KEY automatically implies NOT NULL */
    roll_no VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(50) NOT NULL,
    semester INT NOT NULL CHECK (semester BETWEEN 1 AND 8)
);

CREATE TABLE subjects (
	subject_id INT PRIMARY KEY AUTO_INCREMENT,
    subject_name VARCHAR(100) NOT NULL,
    subject_code VARCHAR(20) NOT NULL
);

CREATE TABLE teachers (
	teacher_id INT PRIMARY KEY AUTO_INCREMENT,
    teacher_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL
);

CREATE TABLE attendance (
	attendance_id INT PRIMARY KEY AUTO_INCREMENT, 
    student_id INT,
    subject_id INT,
    teacher_id INT,
    date DATE,
    status ENUM('Present','Absent'),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id),
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
);

ALTER TABLE attendance
ADD CONSTRAINT unique_attendance
UNIQUE (student_id, subject_id, date);

INSERT INTO students (roll_no, name, department, semester)
VALUES
('SE001', 'Rahul Sharma', 'Computer', 3),
('SE002', 'Priya Patel', 'Computer', 3),
('SE003', 'Amit Verma', 'Computer', 3);

INSERT INTO subjects (subject_name, subject_code)
VALUES
('DBMS', 'CS301'),
('IOT', 'CS302'),
('CO&MP', 'CS303'),
('DM', 'CS304');

INSERT INTO teachers (teacher_name, email)
VALUES
('Dr. Mehta', 'mehta@college.edu'),
('Prof. Singh', 'singh@college.edu');

INSERT INTO attendance (student_id, subject_id, teacher_id, date, status)
VALUES
(1, 1, 1, '2026-03-02', 'Present'),
(2, 1, 1, '2026-03-02', 'Present'),
(3, 1, 1, '2026-03-02', 'Absent'),
(1, 2, 2, '2026-03-01', 'Absent'),
(2, 2, 2, '2026-03-01', 'Present'),
(3, 2, 2, '2026-03-01', 'Present'),
(1, 2, 2, '2026-03-02', 'Present'),
(2, 2, 2, '2026-03-02', 'Absent'),
(3, 2, 2, '2026-03-02', 'Present');

SELECT
	s.roll_no,
    s.name,
    sub.subject_name,
    t.teacher_name,
    a.date,
    a.status
FROM attendance a
JOIN students s ON a.student_id = s.student_id
JOIN subjects sub ON a.subject_id = sub.subject_id
JOIN teachers t ON a.teacher_id = t.teacher_id;
