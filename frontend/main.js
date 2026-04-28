const API_URL = 'http://localhost:3000/api';

document.addEventListener('DOMContentLoaded', () => {
  const btnFetchCourses = document.getElementById('btn-fetch-courses');
  const btnFetchResult = document.getElementById('btn-fetch-result');

  // Fetch Course Enrollments
  btnFetchCourses.addEventListener('click', async () => {
    try {
      const response = await fetch(`${API_URL}/course-details`);
      const data = await response.json();
      
      const tbody = document.getElementById('courses-body');
      tbody.innerHTML = ''; // clear existing
      
      if (data.length === 0) {
        tbody.innerHTML = '<tr><td colspan="4">No data found</td></tr>';
        return;
      }

      data.forEach(row => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
          <td>${row.enrollment_id}</td>
          <td>${row.student_name}</td>
          <td>${row.course_name}</td>
          <td>${row.semester}</td>
        `;
        tbody.appendChild(tr);
      });
    } catch (error) {
      console.error('Error fetching courses:', error);
      alert('Failed to connect to the backend. Is the Node server running?');
    }
  });

  // Fetch Student Result
  btnFetchResult.addEventListener('click', async () => {
    const sid = document.getElementById('input-student-id').value;
    if (!sid) {
      alert('Please enter a valid Student ID');
      return;
    }

    const resultDisplay = document.getElementById('result-display');
    resultDisplay.classList.add('hidden');

    try {
      const response = await fetch(`${API_URL}/results/${sid}`);
      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.message || 'Error fetching result');
      }

      // Display data
      resultDisplay.innerHTML = `
        <h3>${data[0].student_name}'s Result</h3>
        <p><strong>Course:</strong> ${data[0].course_name}</p>
        <p><strong>Marks Obtained:</strong> ${data[0].marks}</p>
        <div class="grade">Final Grade: ${data[0].Grade}</div>
      `;
      resultDisplay.classList.remove('hidden');

    } catch (error) {
      console.error('Error fetching result:', error);
      alert(error.message);
    }
  });

  // Add New Student
  const addStudentForm = document.getElementById('add-student-form');
  addStudentForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const student_id = document.getElementById('new-student-id').value;
    const student_name = document.getElementById('new-student-name').value;
    const department = document.getElementById('new-student-dept').value;
    const msgDiv = document.getElementById('add-student-msg');
    
    msgDiv.textContent = 'Adding...';
    msgDiv.style.color = '#e2e8f0';

    try {
      const response = await fetch(`${API_URL}/students`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ student_id, student_name, department })
      });
      
      const data = await response.json();
      
      if (!response.ok) {
        throw new Error(data.error || 'Failed to add student');
      }
      
      msgDiv.textContent = data.message;
      msgDiv.style.color = '#10b981';
      addStudentForm.reset();
    } catch (error) {
      msgDiv.textContent = error.message;
      msgDiv.style.color = '#ef4444';
    }
  });
});
