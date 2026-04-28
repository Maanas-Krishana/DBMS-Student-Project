const express = require('express');
const cors = require('cors');
const db = require('./db');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Helper function to handle async routes
const asyncHandler = fn => (req, res, next) => {
    Promise.resolve(fn(req, res, next)).catch(next);
};

// Root endpoint so the browser doesn't show "Cannot GET /"
app.get('/', (req, res) => {
    res.send('Student Management System Backend API is running!');
});

// 1. Get All Students
app.get('/api/students', asyncHandler(async (req, res) => {
    const [rows] = await db.query('SELECT * FROM student');
    res.json(rows);
}));

// 1.5 Add New Student
app.post('/api/students', asyncHandler(async (req, res) => {
    const { student_id, student_name, department } = req.body;
    
    if (!student_id || !student_name || !department) {
        return res.status(400).json({ error: 'Missing required fields' });
    }

    try {
        await db.query('INSERT INTO student (student_id, student_name, department) VALUES (?, ?, ?)', [student_id, student_name, department]);
        res.status(201).json({ message: 'Student added successfully!' });
    } catch (error) {
        if (error.code === 'ER_DUP_ENTRY') {
            res.status(409).json({ error: 'Student ID already exists' });
        } else {
            throw error;
        }
    }
}));

// 2. Get Student Result (using Stored Procedure)
app.get('/api/results/:sid', asyncHandler(async (req, res) => {
    const sid = req.params.sid;
    // CALL Student_Result returns multiple result sets in mysql2
    const [rows] = await db.query('CALL Student_Result(?)', [sid]);
    
    if (rows && rows[0] && rows[0].length > 0) {
        res.json(rows[0]);
    } else {
        res.status(404).json({ message: 'No result found for this student.' });
    }
}));

// 3. Record Marks (Triggers auto-grade calculation)
app.post('/api/marks', asyncHandler(async (req, res) => {
    const { enrollment_id, marks_obtained, total_marks } = req.body;
    
    if (!enrollment_id || marks_obtained === undefined || !total_marks) {
        return res.status(400).json({ error: 'Missing required fields' });
    }

    try {
        await db.query('CALL RecordMarks(?, ?, ?)', [enrollment_id, marks_obtained, total_marks]);
        res.json({ message: 'Marks recorded successfully!' });
    } catch (error) {
        // This will catch the 75% attendance error thrown by our trigger
        if (error.sqlState === '45000') {
            res.status(400).json({ error: error.message });
        } else {
            throw error;
        }
    }
}));

// 4. Get Student Course Details
app.get('/api/course-details', asyncHandler(async (req, res) => {
    const query = `
        SELECT e.enrollment_id, s.student_name, c.course_name, e.semester
        FROM student s
        JOIN enrollment e ON s.student_id = e.student_id
        JOIN course c ON e.course_id = c.course_id
    `;
    const [rows] = await db.query(query);
    res.json(rows);
}));

// Error Handling Middleware
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({ error: 'Internal Server Error' });
});

app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
