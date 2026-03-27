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
('D13', 'VSB', 'Computer', 4),
('E64', 'CSK', 'Computer', 4),
('F42', 'DGM', 'Computer', 4),
('E01', 'Aarav Sharma', 'Computer', 4),
('E02', 'Priya Desai', 'Computer', 4),
('E03', 'Rohit Patil', 'Computer', 4),
('E04', 'Sneha Joshi', 'Computer', 4),
('E05', 'Arjun Kulkarni', 'Computer', 4),
('E06', 'Pooja Nair', 'Computer', 4),
('E07', 'Vivek Mehta', 'Computer', 4),
('E08', 'Anjali Pawar', 'Computer', 4),
('E09', 'Karan Rane', 'Computer', 4),
('E10', 'Neha Gaikwad', 'Computer', 4);

INSERT INTO subjects (subject_name, subject_code)
VALUES
('Database Management Systems', 'CS401'),
('Internet of Things', 'CS402'),
('Computer Organisation & Microprocessor', 'CS403'),
('Discrete Mathematics', 'CS404');

INSERT INTO teachers (teacher_name, email)
VALUES
('nj', 'nj@college.edu'),
('ask', 'ask@college.edu'),
('sk', 'sk@college.edu'),
('ss', 'ss@college.edu');

INSERT INTO attendance (student_id, subject_id, teacher_id, date, status)
VALUES
(1, 1, 1, '2026-03-01', 'Present'),
(2, 1, 1, '2026-03-01', 'Absent'),
(3, 1, 1, '2026-03-01', 'Present'),
(4, 1, 1, '2026-03-01', 'Present'),
(5, 1, 1, '2026-03-01', 'Present'),
(6, 1, 1, '2026-03-01', 'Absent'),
(7, 1, 1, '2026-03-01', 'Present'),
(8, 1, 1, '2026-03-01', 'Present'),
(9, 1, 1, '2026-03-01', 'Absent'),
(10, 1, 1, '2026-03-01', 'Present'),
(11, 1, 1, '2026-03-01', 'Present'),
(12, 1, 1, '2026-03-01', 'Absent'),
(13, 1, 1, '2026-03-01', 'Present'),
(1, 1, 1, '2026-03-02', 'Present'),
(2, 1, 1, '2026-03-02', 'Present'),
(3, 1, 1, '2026-03-02', 'Absent'),
(4, 1, 1, '2026-03-02', 'Present'),
(5, 1, 1, '2026-03-02', 'Absent'),
(6, 1, 1, '2026-03-02', 'Present'),
(7, 1, 1, '2026-03-02', 'Present'),
(8, 1, 1, '2026-03-02', 'Absent'),
(9, 1, 1, '2026-03-02', 'Present'),
(10, 1, 1, '2026-03-02', 'Present'),
(11, 1, 1, '2026-03-02', 'Absent'),
(12, 1, 1, '2026-03-02', 'Present'),
(13, 1, 1, '2026-03-02', 'Present'),
(1, 2, 2, '2026-03-03', 'Present'),
(2, 2, 2, '2026-03-03', 'Present'),
(3, 2, 2, '2026-03-03', 'Absent'),
(4, 2, 2, '2026-03-03', 'Present'),
(5, 2, 2, '2026-03-03', 'Present'),
(6, 2, 2, '2026-03-03', 'Present'),
(7, 2, 2, '2026-03-03', 'Absent'),
(8, 2, 2, '2026-03-03', 'Present'),
(9, 2, 2, '2026-03-03', 'Present'),
(10, 2, 2, '2026-03-03', 'Absent'),
(11, 2, 2, '2026-03-03', 'Present'),
(12, 2, 2, '2026-03-03', 'Present'),
(13, 2, 2, '2026-03-03', 'Absent'),
(1, 2, 2, '2026-03-05', 'Absent'),
(2, 2, 2, '2026-03-05', 'Present'),
(3, 2, 2, '2026-03-05', 'Present'),
(4, 2, 2, '2026-03-05', 'Present'),
(5, 2, 2, '2026-03-05', 'Absent'),
(6, 2, 2, '2026-03-05', 'Present'),
(7, 2, 2, '2026-03-05', 'Present'),
(8, 2, 2, '2026-03-05', 'Absent'),
(9, 2, 2, '2026-03-05', 'Present'),
(10, 2, 2, '2026-03-05', 'Present'),
(11, 2, 2, '2026-03-05', 'Absent'),
(12, 2, 2, '2026-03-05', 'Present'),
(13, 2, 2, '2026-03-05', 'Present'),
(1, 3, 3, '2026-03-02', 'Present'),
(2, 3, 3, '2026-03-02', 'Absent'),
(3, 3, 3, '2026-03-02', 'Present'),
(4, 3, 3, '2026-03-02', 'Present'),
(5, 3, 3, '2026-03-02', 'Present'),
(6, 3, 3, '2026-03-02', 'Absent'),
(7, 3, 3, '2026-03-02', 'Present'),
(8, 3, 3, '2026-03-02', 'Present'),
(9, 3, 3, '2026-03-02', 'Absent'),
(10, 3, 3, '2026-03-02', 'Present'),
(11, 3, 3, '2026-03-02', 'Present'),
(12, 3, 3, '2026-03-02', 'Absent'),
(13, 3, 3, '2026-03-02', 'Present'),
(1, 4, 4, '2026-03-03', 'Present'),
(2, 4, 4, '2026-03-03', 'Present'),
(3, 4, 4, '2026-03-03', 'Absent'),
(4, 4, 4, '2026-03-03', 'Present'),
(5, 4, 4, '2026-03-03', 'Present'),
(6, 4, 4, '2026-03-03', 'Present'),
(7, 4, 4, '2026-03-03', 'Absent'),
(8, 4, 4, '2026-03-03', 'Present'),
(9, 4, 4, '2026-03-03', 'Absent'),
(10, 4, 4, '2026-03-03', 'Present'),
(11, 4, 4, '2026-03-03', 'Present'),
(12, 4, 4, '2026-03-03', 'Present'),
(13, 4, 4, '2026-03-03', 'Absent');

INSERT INTO users (username, password, role, ref_id)
VALUES
('vsb', 'pass123', 'student', 1),
('csk', 'pass123', 'student', 2),
('dgm', 'pass123', 'student', 3),
('aarav', 'pass123', 'student', 4),
('priya', 'pass123', 'student', 5),
('rohit', 'pass123', 'student', 6),
('sneha', 'pass123', 'student', 7),
('arjun', 'pass123', 'student', 8),
('pooja', 'pass123', 'student', 9),
('vivek', 'pass123', 'student', 10),
('anjali', 'pass123', 'student', 11),
('karan', 'pass123', 'student', 12),
('neha', 'pass123', 'student', 13),
('nj', 'pass123', 'teacher', 1),
('ask', 'pass123', 'teacher', 2),
('sk', 'pass123', 'teacher', 3),
('ss', 'pass123', 'teacher', 4);

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