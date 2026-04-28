USE student_db;

DELIMITER //

-- ---------------------------------------------------------
-- 1. Trigger to Enforce 75% Attendance Rule & Auto Grade-Generation
-- ---------------------------------------------------------
-- This trigger checks the student's attendance before inserting 
-- marks. If attendance is below 75%, it prevents the insertion.
-- It also automatically calculates the grade based on the marks.
CREATE TRIGGER trg_check_attendance_and_generate_grade
BEFORE INSERT ON marks
FOR EACH ROW
BEGIN
    DECLARE v_attendance_percentage DECIMAL(5,2);
    DECLARE v_percentage DECIMAL(5,2);
    
    -- Fetch the attendance percentage for the given enrollment
    SELECT attendance_percentage INTO v_attendance_percentage
    FROM attendance
    WHERE enrollment_id = NEW.enrollment_id;
    
    -- If attendance is less than 75%, raise an error
    IF v_attendance_percentage < 75.00 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot record marks: Attendance is below the 75% minimum requirement.';
    END IF;

    -- Calculate Percentage
    SET v_percentage = (NEW.marks_obtained / NEW.total_marks) * 100;
    
    -- Auto-generate Grade
    IF v_percentage >= 90 THEN
        SET NEW.grade = 'A+';
    ELSEIF v_percentage >= 75 THEN
        SET NEW.grade = 'A';
    ELSEIF v_percentage >= 60 THEN
        SET NEW.grade = 'B';
    ELSEIF v_percentage >= 50 THEN
        SET NEW.grade = 'C';
    ELSE
        SET NEW.grade = 'Fail';
    END IF;
END //

-- ---------------------------------------------------------
-- 2. Stored Procedure to Generate Student Result
-- ---------------------------------------------------------
CREATE PROCEDURE Student_Result(IN sid INT)
BEGIN
    SELECT 
        s.student_name,
        c.course_name,
        m.marks_obtained as marks,
        m.grade AS Grade
    FROM student s
    JOIN enrollment e ON s.student_id = e.student_id
    JOIN course c ON e.course_id = c.course_id
    JOIN marks m ON e.enrollment_id = m.enrollment_id
    WHERE s.student_id = sid;
END //

-- ---------------------------------------------------------
-- 3. Stored Procedure to Record Marks
-- ---------------------------------------------------------
CREATE PROCEDURE RecordMarks(
    IN p_enrollment_id INT,
    IN p_marks_obtained INT,
    IN p_total_marks INT
)
BEGIN
    -- The trigger 'trg_check_attendance_and_generate_grade' will run before this insert!
    INSERT INTO marks (enrollment_id, marks_obtained, total_marks)
    VALUES (p_enrollment_id, p_marks_obtained, p_total_marks);
END //

DELIMITER ;
