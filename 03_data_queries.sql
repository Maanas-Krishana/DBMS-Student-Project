USE student_db;

-- ---------------------------------------------------------
-- Data Insertion
-- ---------------------------------------------------------

-- 1. Insert Students
INSERT INTO student (student_id, student_name, department) VALUES
(1, 'Amit', 'CSE'),
(2, 'Neha', 'ECE'),
(3, 'Rahul', 'MECH'),
(4, 'Priya', 'CSE'),
(5, 'Karan', 'IT'),
(6, 'Anjali', 'ECE'),
(7, 'Rohan', 'CSE'),
(8, 'Simran', 'IT'),
(9, 'Vikram', 'MECH'),
(10, 'Sneha', 'CIVIL'),
(11, 'Aditya', 'CSE'),
(12, 'Pooja', 'IT'),
(13, 'Siddharth', 'ECE'),
(14, 'Kavya', 'CSE'),
(15, 'Arjun', 'IT'),
(16, 'Riya', 'ECE'),
(17, 'Manish', 'MECH'),
(18, 'Aarti', 'CIVIL');

-- 2. Insert Courses
INSERT INTO course (course_id, course_name, credits) VALUES
(101, 'DBMS', 4),
(102, 'Operating Systems', 3),
(103, 'Computer Networks', 4);

-- 3. Insert Enrollments
INSERT INTO enrollment (enrollment_id, student_id, course_id, semester) VALUES
(1, 1, 101, 'Sem 4'),
(2, 1, 102, 'Sem 4'),
(3, 2, 101, 'Sem 4'),
(4, 3, 103, 'Sem 4'),
(5, 4, 101, 'Sem 4'),
(6, 5, 102, 'Sem 4'),
(7, 6, 103, 'Sem 4'),
(8, 7, 101, 'Sem 4'),
(9, 8, 102, 'Sem 4'),
(10, 9, 103, 'Sem 4'),
(11, 10, 101, 'Sem 4'),
(12, 11, 102, 'Sem 4'),
(13, 12, 103, 'Sem 4'),
(14, 13, 101, 'Sem 4'),
(15, 14, 102, 'Sem 4'),
(16, 15, 103, 'Sem 4'),
(17, 16, 101, 'Sem 4'),
(18, 17, 102, 'Sem 4'),
(19, 18, 103, 'Sem 4');

-- 4. Insert Attendance 
-- Note: 'attendance_percentage' is automatically calculated
INSERT INTO attendance (enrollment_id, total_classes, attended_classes) VALUES
(1, 40, 35), -- Amit in DBMS: 87.5% (Eligible for exams)
(2, 30, 28), -- Amit in OS: 93.3% (Eligible for exams)
(3, 40, 20), -- Neha in DBMS: 50% (NOT Eligible for exams)
(4, 40, 32), -- Rahul in CN: 80% (Eligible for exams)
(5, 40, 36),
(6, 30, 28),
(7, 40, 32),
(8, 40, 38),
(9, 30, 25),
(10, 40, 35),
(11, 40, 39),
(12, 30, 29),
(13, 40, 31),
(14, 40, 36),
(15, 30, 27),
(16, 40, 33),
(17, 40, 37),
(18, 30, 26),
(19, 40, 34);


-- ---------------------------------------------------------
-- Stored Procedure Testing (Recording Marks)
-- ---------------------------------------------------------

-- Test 1: Amit in DBMS (Should Pass)
CALL RecordMarks(1, 85, 100);

-- Test 2: Amit in OS (Should Fail)
CALL RecordMarks(2, 30, 100);

-- Test 3: Neha in DBMS (Should throw an error due to 75% trigger)
-- UNCOMMENT TO TEST TRIGGER:
-- CALL RecordMarks(3, 90, 100); 

-- Test 4: Rahul in CN (Should Pass)
CALL RecordMarks(4, 75, 100);

CALL RecordMarks(5, 80, 100);
CALL RecordMarks(6, 75, 100);
CALL RecordMarks(7, 88, 100);
CALL RecordMarks(8, 92, 100);
CALL RecordMarks(9, 65, 100);
CALL RecordMarks(10, 78, 100);
CALL RecordMarks(11, 95, 100);
CALL RecordMarks(12, 82, 100);
CALL RecordMarks(13, 70, 100);
CALL RecordMarks(14, 85, 100);
CALL RecordMarks(15, 68, 100);
CALL RecordMarks(16, 74, 100);
CALL RecordMarks(17, 89, 100);
CALL RecordMarks(18, 62, 100);
CALL RecordMarks(19, 81, 100);


-- ---------------------------------------------------------
-- Data Retrieval (Queries)
-- ---------------------------------------------------------

-- Query 1: Display Student Course Details
SELECT s.student_name, c.course_name, e.semester
FROM student s
JOIN enrollment e ON s.student_id = e.student_id
JOIN course c ON e.course_id = c.course_id;

-- Query 2: Display Students Enrolled in DBMS
SELECT s.student_name
FROM student s
JOIN enrollment e ON s.student_id = e.student_id
WHERE e.course_id = 101;

-- Query 3: Display Student Attendance Report
SELECT s.student_name, c.course_name, a.total_classes, a.attended_classes, a.attendance_percentage
FROM student s
JOIN enrollment e ON s.student_id = e.student_id
JOIN course c ON e.course_id = c.course_id
JOIN attendance a ON e.enrollment_id = a.enrollment_id;

-- Query 4: Display Student Result Sheet
SELECT s.student_name, c.course_name, m.marks_obtained, m.total_marks, m.grade
FROM student s
JOIN enrollment e ON s.student_id = e.student_id
JOIN course c ON e.course_id = c.course_id
JOIN marks m ON e.enrollment_id = m.enrollment_id;

-- Query 5: Test the Student_Result Stored Procedure for Student 1 (Amit)
CALL Student_Result(1);
