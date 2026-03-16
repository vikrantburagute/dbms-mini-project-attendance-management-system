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
    student_id INT NOT NULL,
    subject_id INT NOT NULL,
    teacher_id INT NOT NULL,
    date DATE NOT NULL,
    status ENUM('Present','Absent') NOT NULL,
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
('Prof. Singh', 'singh@college.edu'),
('Prof. Joshi', 'joshi@college.edu'),
('Dr. Kulkarni', 'kulkarni@college.edu');

INSERT INTO attendance (student_id, subject_id, teacher_id, date, status)
VALUES
(1, 3, 3, '2026-03-01', 'Present'),
(2, 3, 3, '2026-03-01', 'Present'),
(3, 3, 3, '2026-03-01', 'Absent'),
(1, 4, 4, '2026-03-01', 'Present'),
(2, 4, 4, '2026-03-01', 'Absent'),
(3, 4, 4, '2026-03-01', 'Present');

SELECT
    s.roll_no,
    s.name,
    sub.subject_name,
    COUNT(*) AS total_classes,
    SUM(a.status = 'Present') AS present_count,
    ROUND(SUM(a.status = 'Present') * 100.0 / COUNT(*), 2) AS attendance_percentage
FROM attendance a
JOIN students s ON a.student_id = s.student_id
JOIN subjects sub ON a.subject_id = sub.subject_id
GROUP BY s.student_id, sub.subject_id;


-- Update a student's semester
UPDATE students
SET semester = 4
WHERE roll_no = 'SE001';

-- Update attendance status
UPDATE attendance
SET status = 'Present'
WHERE attendance_id = 2;

-- Delete a specific attendance record
DELETE FROM attendance
WHERE attendance_id = 2;

START TRANSACTION;

INSERT INTO attendance (student_id, subject_id, teacher_id, date, status)
VALUES (1, 1, 1, '2026-03-03', 'Present');

SAVEPOINT after_insert;

UPDATE attendance
SET status = 'Absent'
WHERE attendance_id = 1;

ROLLBACK TO after_insert;

COMMIT;

