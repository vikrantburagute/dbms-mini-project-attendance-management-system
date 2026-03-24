DROP DATABASE IF EXISTS attendance_db;
CREATE DATABASE attendance_db;
USE attendance_db;

-- TABLE DEFINITIONS
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
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

CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('teacher', 'student') NOT NULL,
    ref_id INT NOT NULL
);

ALTER TABLE attendance
ADD CONSTRAINT unique_attendance
UNIQUE (student_id, subject_id, date);

-- SAMPLE DATA
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
(1, 1, 1, '2026-03-01', 'Present'),
(2, 1, 1, '2026-03-01', 'Absent'),
(3, 1, 1, '2026-03-01', 'Present'),
(1, 1, 1, '2026-03-02', 'Present'),
(2, 1, 1, '2026-03-02', 'Present'),
(3, 1, 1, '2026-03-02', 'Absent'),
(1, 2, 2, '2026-03-01', 'Absent'),
(2, 2, 2, '2026-03-01', 'Present'),
(3, 2, 2, '2026-03-01', 'Present'),
(1, 2, 2, '2026-03-02', 'Present'),
(2, 2, 2, '2026-03-02', 'Absent'),
(3, 2, 2, '2026-03-02', 'Present'),
(1, 3, 3, '2026-03-01', 'Present'),
(2, 3, 3, '2026-03-01', 'Present'),
(3, 3, 3, '2026-03-01', 'Absent'),
(1, 4, 4, '2026-03-01', 'Present'),
(2, 4, 4, '2026-03-01', 'Absent'),
(3, 4, 4, '2026-03-01', 'Present'),
(1, 3, 3, '2026-03-02', 'Absent'),
(2, 3, 3, '2026-03-02', 'Present'),
(3, 3, 3, '2026-03-02', 'Present'),
(1, 4, 4, '2026-03-02', 'Present'),
(2, 4, 4, '2026-03-02', 'Present'),
(3, 4, 4, '2026-03-02', 'Absent');

INSERT INTO users (username, password, role, ref_id)
VALUES
('rahul', 'pass123', 'student', 1),
('priya', 'pass123', 'student', 2),
('amit', 'pass123', 'student', 3),
('mehta', 'pass123', 'teacher', 1),
('singh', 'pass123', 'teacher', 2);

-- QUERIES
-- Full attendance report
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

-- Attendance percentage per student per subject
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

-- Defaulters list
SELECT
    s.roll_no,
    s.name,
    sub.subject_name,
    ROUND(SUM(a.status = 'Present') * 100.0 / COUNT(*), 2) AS attendance_percentage
FROM attendance a
JOIN students s ON a.student_id = s.student_id
JOIN subjects sub ON a.subject_id = sub.subject_id
GROUP BY s.student_id, sub.subject_id
HAVING attendance_percentage < 75;

-- Students ordered by attendance percentage
SELECT
    s.roll_no,
    s.name,
    sub.subject_name,
    ROUND(SUM(a.status = 'Present') * 100.0 / COUNT(*), 2) AS attendance_percentage
FROM attendance a
JOIN students s ON a.student_id = s.student_id
JOIN subjects sub ON a.subject_id = sub.subject_id
GROUP BY s.student_id, sub.subject_id
ORDER BY attendance_percentage DESC;

-- DML
UPDATE students
SET semester = 4
WHERE roll_no = 'SE001';

UPDATE attendance
SET status = 'Present'
WHERE attendance_id = 2;

DELETE FROM attendance
WHERE attendance_id = 2;

-- TCL
START TRANSACTION;
INSERT INTO attendance (student_id, subject_id, teacher_id, date, status)
VALUES (1, 1, 1, '2026-03-03', 'Present');
SAVEPOINT after_insert;
UPDATE attendance
SET status = 'Absent'
WHERE attendance_id = 1;
ROLLBACK TO after_insert;
COMMIT;

-- DCL
CREATE USER IF NOT EXISTS 'teacher'@'localhost' IDENTIFIED BY 'password123';
GRANT SELECT, INSERT ON attendance_db.attendance TO 'teacher'@'localhost';
REVOKE INSERT ON attendance_db.attendance FROM 'teacher'@'localhost';

-- SUBQUERY
SELECT name, roll_no
FROM students
WHERE student_id IN (
    SELECT DISTINCT student_id
    FROM attendance
    WHERE status = 'Absent'
);

-- VIEW
CREATE VIEW attendance_report AS
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

-- STORED PROCEDURE
DELIMITER //
CREATE PROCEDURE GetStudentAttendance(IN p_roll_no VARCHAR(20))
BEGIN
    SELECT s.name, sub.subject_name, a.date, a.status
    FROM attendance a
    JOIN students s ON a.student_id = s.student_id
    JOIN subjects sub ON a.subject_id = sub.subject_id
    WHERE s.roll_no = p_roll_no
    ORDER BY a.date;
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION GetAttendancePercentage(p_student_id INT, p_subject_id INT)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE total INT;
    DECLARE present_count INT;
    SELECT COUNT(*) INTO total FROM attendance
    WHERE student_id = p_student_id AND subject_id = p_subject_id;
    SELECT COUNT(*) INTO present_count FROM attendance
    WHERE student_id = p_student_id AND subject_id = p_subject_id AND status = 'Present';
    RETURN ROUND(present_count * 100.0 / total, 2);
END //
DELIMITER ;

-- Calling it like this
SELECT GetAttendancePercentage(1, 1);

CALL GetStudentAttendance('SE001');

-- TRIGGER
DELIMITER //
CREATE TRIGGER before_attendance_insert
BEFORE INSERT ON attendance
FOR EACH ROW
BEGIN
    IF NEW.date > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot mark attendance for future date';
    END IF;
END //
DELIMITER ;