-- Step 1: Create Database
CREATE DATABASE IF NOT EXISTS student_db;
USE student_db;

-- Step 2: Create Tables

-- Student Table
CREATE TABLE IF NOT EXISTS student (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50) NOT NULL,
    department VARCHAR(30)
);

-- Course Table
CREATE TABLE IF NOT EXISTS course (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50) NOT NULL,
    credits INT CHECK (credits > 0)
);

-- Enrollment Table
CREATE TABLE IF NOT EXISTS enrollment (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    semester VARCHAR(10),
    FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES course(course_id) ON DELETE CASCADE
);

-- Attendance Table
CREATE TABLE IF NOT EXISTS attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id INT,
    total_classes INT NOT NULL,
    attended_classes INT NOT NULL,
    attendance_percentage DECIMAL(5,2) GENERATED ALWAYS AS ((attended_classes / total_classes) * 100) STORED,
    FOREIGN KEY (enrollment_id) REFERENCES enrollment(enrollment_id) ON DELETE CASCADE,
    CHECK (attended_classes <= total_classes)
);

-- Marks Table
CREATE TABLE IF NOT EXISTS marks (
    mark_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id INT,
    marks_obtained INT NOT NULL,
    total_marks INT NOT NULL,
    grade VARCHAR(5), 
    FOREIGN KEY (enrollment_id) REFERENCES enrollment(enrollment_id) ON DELETE CASCADE,
    CHECK (marks_obtained <= total_marks)
);
