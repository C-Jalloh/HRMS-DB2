const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const path = require('path');

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, '.'))); // Serve static files

// Database Connection
const db = mysql.createConnection({
    host: 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || 'ebrim@CJ@lloh25', 
    database: 'hrms_db'
});

db.connect(err => {
    if (err) {
        console.error('Error connecting to database:', err);
        return;
    }
    console.log('Connected to MySQL database');
});

// --- API Endpoints ---

// Get List of Companies (Tenants)
app.get('/api/companies', (req, res) => {
    db.query("SELECT admin_id, company_name FROM companies", (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
    });
});

// Middleware to get admin_id
const getAdminId = (req) => {
    return req.query.admin_id;
};

// 1. KPI Data
app.get('/api/kpi', (req, res) => {
    const adminId = getAdminId(req);
    if (!adminId) return res.status(400).json({ error: 'Admin ID required' });

    const queries = {
        total: "SELECT COUNT(*) as val FROM employees WHERE admin_id = ?",
        active: "SELECT COUNT(*) as val FROM employees WHERE admin_id = ? AND is_active = TRUE",
        pending_leaves: "SELECT COUNT(*) as val FROM leave_requests lr JOIN employees e ON lr.employee_id = e.employee_id WHERE e.admin_id = ? AND lr.status = 'pending'",
        payroll: "SELECT SUM(st.base_salary) as val FROM employees e JOIN employee_salaries es ON e.employee_id = es.employee_id AND es.is_active = TRUE JOIN salary_templates st ON es.template_id = st.template_id WHERE e.admin_id = ? AND e.is_active = TRUE"
    };

    const results = {};
    let completed = 0;
    const keys = Object.keys(queries);

    keys.forEach(key => {
        db.query(queries[key], [adminId], (err, data) => {
            if (err) results[key] = 0;
            else results[key] = data[0].val || 0;
            
            completed++;
            if (completed === keys.length) res.json(results);
        });
    });
});

// 2. Department Distribution
app.get('/api/dept-distribution', (req, res) => {
    const adminId = getAdminId(req);
    if (!adminId) return res.status(400).json({ error: 'Admin ID required' });

    const query = `
        SELECT d.department_name, COUNT(e.employee_id) as count 
        FROM departments d 
        LEFT JOIN employees e ON d.department_id = e.department_id AND d.admin_id = e.admin_id 
        WHERE d.admin_id = ? 
        GROUP BY d.department_name`;
    db.query(query, [adminId], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
    });
});

// 3. Attendance Trend
app.get('/api/attendance-trend', (req, res) => {
    const adminId = getAdminId(req);
    if (!adminId) return res.status(400).json({ error: 'Admin ID required' });

    const query = `
        SELECT DATE_FORMAT(attendance_date, '%b %Y') as month,
        ROUND((COUNT(CASE WHEN status = 'present' THEN 1 END) * 100.0 / COUNT(*)), 1) as rate
        FROM attendance_records ar
        JOIN employees e ON ar.employee_id = e.employee_id
        WHERE e.admin_id = ?
        GROUP BY DATE_FORMAT(attendance_date, '%Y-%m'), month
        ORDER BY DATE_FORMAT(attendance_date, '%Y-%m') DESC
        LIMIT 6`;
    db.query(query, [adminId], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results.reverse()); // Reverse to show chronological order
    });
});// 4. Recent Activities
app.get('/api/recent-activities', (req, res) => {
    const adminId = getAdminId(req);
    if (!adminId) return res.status(400).json({ error: 'Admin ID required' });

    const query = `
        SELECT action_type, description, action_date 
        FROM employee_actions ea
        JOIN employees e ON ea.employee_id = e.employee_id
        WHERE e.admin_id = ?
        ORDER BY action_date DESC LIMIT 5`;
    db.query(query, [adminId], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
    });
});

// 5. New Hires
app.get('/api/new-hires', (req, res) => {
    const adminId = getAdminId(req);
    if (!adminId) return res.status(400).json({ error: 'Admin ID required' });

    const query = `
        SELECT CONCAT(first_name, ' ', last_name) as name, d.department_name, position, hire_date
        FROM employees e
        JOIN departments d ON e.department_id = d.department_id
        WHERE e.admin_id = ?
        ORDER BY hire_date DESC LIMIT 5`;
    db.query(query, [adminId], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
    });
});

// 6. Leave Status
app.get('/api/leave-status', (req, res) => {
    const adminId = getAdminId(req);
    if (!adminId) return res.status(400).json({ error: 'Admin ID required' });

    const query = `
        SELECT status, COUNT(*) as count 
        FROM leave_requests lr
        JOIN employees e ON lr.employee_id = e.employee_id
        WHERE e.admin_id = ?
        GROUP BY status`;
    db.query(query, [adminId], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        // Ensure we have all status types even if count is 0
        const statusTypes = ['pending', 'approved', 'rejected'];
        const completeResults = statusTypes.map(status => {
            const found = results.find(r => r.status === status);
            return found || { status, count: 0 };
        });
        res.json(completeResults);
    });
});

// 8. Position Distribution
app.get('/api/position-distribution', (req, res) => {
    const adminId = getAdminId(req);
    if (!adminId) return res.status(400).json({ error: 'Admin ID required' });

    const query = `
        SELECT position, COUNT(*) as count 
        FROM employees 
        WHERE admin_id = ? AND is_active = TRUE
        GROUP BY position
        ORDER BY count DESC`;
    db.query(query, [adminId], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
    });
});

// 9. Salary Distribution
app.get('/api/salary-distribution', (req, res) => {
    const adminId = getAdminId(req);
    if (!adminId) return res.status(400).json({ error: 'Admin ID required' });

    const query = `
        SELECT 
            CASE 
                WHEN st.base_salary < 30000 THEN '< $30,000'
                WHEN st.base_salary BETWEEN 30000 AND 49999 THEN '$30,000 - $49,999'
                WHEN st.base_salary BETWEEN 50000 AND 69999 THEN '$50,000 - $69,999'
                WHEN st.base_salary BETWEEN 70000 AND 89999 THEN '$70,000 - $89,999'
                WHEN st.base_salary BETWEEN 90000 AND 119999 THEN '$90,000 - $119,999'
                ELSE '$120,000+'
            END AS salary_range,
            COUNT(*) AS count
        FROM employees e
        JOIN employee_salaries es ON e.employee_id = es.employee_id AND es.is_active = TRUE
        JOIN salary_templates st ON es.template_id = st.template_id
        WHERE e.admin_id = ? AND e.is_active = TRUE
        GROUP BY 
            CASE 
                WHEN st.base_salary < 30000 THEN '< $30,000'
                WHEN st.base_salary BETWEEN 30000 AND 49999 THEN '$30,000 - $49,999'
                WHEN st.base_salary BETWEEN 50000 AND 69999 THEN '$50,000 - $69,999'
                WHEN st.base_salary BETWEEN 70000 AND 89999 THEN '$70,000 - $89,999'
                WHEN st.base_salary BETWEEN 90000 AND 119999 THEN '$90,000 - $119,999'
                ELSE '$120,000+'
            END
        ORDER BY 
            CASE 
                WHEN salary_range = '< $30,000' THEN 1
                WHEN salary_range = '$30,000 - $49,999' THEN 2
                WHEN salary_range = '$50,000 - $69,999' THEN 3
                WHEN salary_range = '$70,000 - $89,999' THEN 4
                WHEN salary_range = '$90,000 - $119,999' THEN 5
                ELSE 6
            END`;
    db.query(query, [adminId], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
    });
});

// 10. Leave Balance Overview
app.get('/api/leave-balance', (req, res) => {
    const adminId = getAdminId(req);
    if (!adminId) return res.status(400).json({ error: 'Admin ID required' });

    const query = `
        SELECT 
            lt.leave_name,
            SUM(lb.balance_days) as total_balance,
            SUM(lb.used_days) as total_used
        FROM leave_balances lb
        JOIN leave_types lt ON lb.leave_type_id = lt.leave_type_id
        JOIN employees e ON lb.employee_id = e.employee_id
        WHERE e.admin_id = ? AND lb.year = YEAR(CURDATE())
        GROUP BY lt.leave_type_id, lt.leave_name`;
    db.query(query, [adminId], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
    });
});

// 11. Monthly Leave Usage
app.get('/api/monthly-leave-usage', (req, res) => {
    const adminId = getAdminId(req);
    if (!adminId) return res.status(400).json({ error: 'Admin ID required' });

    const query = `
        SELECT
            DATE_FORMAT(lr.start_date, '%M %Y') as month,
            SUM(CASE WHEN lr.status = 'approved' THEN lr.days_requested ELSE 0 END) as days_used
        FROM leave_requests lr
        JOIN employees e ON lr.employee_id = e.employee_id
        WHERE e.admin_id = ? AND lr.start_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
        GROUP BY DATE_FORMAT(lr.start_date, '%Y-%m'), month
        ORDER BY DATE_FORMAT(lr.start_date, '%Y-%m')`;
    db.query(query, [adminId], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
    });
});

// 12. Average Hours by Department
app.get('/api/avg-hours-dept', (req, res) => {
    const adminId = getAdminId(req);
    if (!adminId) return res.status(400).json({ error: 'Admin ID required' });

    const query = `
        SELECT
            d.department_name,
            ROUND(AVG(ar.hours_worked), 2) as avg_hours
        FROM attendance_records ar
        JOIN employees e ON ar.employee_id = e.employee_id
        JOIN departments d ON e.department_id = d.department_id
        WHERE e.admin_id = ?
        GROUP BY d.department_id, d.department_name
        ORDER BY avg_hours DESC`;
    db.query(query, [adminId], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
    });
});

// 13. Weekly Attendance Pattern
app.get('/api/weekly-attendance', (req, res) => {
    const adminId = getAdminId(req);
    if (!adminId) return res.status(400).json({ error: 'Admin ID required' });

    const query = `
        SELECT
            DAYNAME(ar.attendance_date) as day,
            SUM(CASE WHEN ar.status = 'present' THEN 1 ELSE 0 END) as present,
            SUM(CASE WHEN ar.status = 'late' THEN 1 ELSE 0 END) as late
        FROM attendance_records ar
        JOIN employees e ON ar.employee_id = e.employee_id
        WHERE e.admin_id = ?
        GROUP BY DAYOFWEEK(ar.attendance_date), day
        ORDER BY DAYOFWEEK(ar.attendance_date)`;
    db.query(query, [adminId], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
    });
});

// 14. Department Salary Comparison
app.get('/api/dept-salary-comparison', (req, res) => {
    const adminId = getAdminId(req);
    if (!adminId) return res.status(400).json({ error: 'Admin ID required' });

    const query = `
        SELECT
            d.department_name,
            ROUND(AVG(st.base_salary), 0) as avg_salary
        FROM employees e
        JOIN departments d ON e.department_id = d.department_id
        LEFT JOIN employee_salaries es ON e.employee_id = es.employee_id AND es.is_active = TRUE
        LEFT JOIN salary_templates st ON es.template_id = st.template_id
        WHERE e.admin_id = ? AND e.is_active = TRUE AND st.base_salary IS NOT NULL
        GROUP BY d.department_id, d.department_name
        HAVING avg_salary > 0
        ORDER BY avg_salary DESC`;
    db.query(query, [adminId], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
    });
});

// 7. Paginated Employees List
app.get('/api/employees', (req, res) => {
    const adminId = getAdminId(req);
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const offset = (page - 1) * limit;

    if (!adminId) return res.status(400).json({ error: 'Admin ID required' });

    const countQuery = "SELECT COUNT(*) as total FROM employees WHERE admin_id = ?";
    const dataQuery = `
        SELECT e.employee_id, CONCAT(e.first_name, ' ', e.last_name) as name, 
               e.email, d.department_name, e.position, e.hire_date
        FROM employees e
        LEFT JOIN departments d ON e.department_id = d.department_id
        WHERE e.admin_id = ?
        ORDER BY e.hire_date DESC
        LIMIT ? OFFSET ?`;

    db.query(countQuery, [adminId], (err, countResult) => {
        if (err) return res.status(500).json({ error: err.message });
        const total = countResult[0].total;

        db.query(dataQuery, [adminId, limit, offset], (err, dataResults) => {
            if (err) return res.status(500).json({ error: err.message });
            res.json({
                data: dataResults,
                pagination: {
                    total,
                    page,
                    limit,
                    totalPages: Math.ceil(total / limit)
                }
            });
        });
    });
});

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server running at http://localhost:${PORT}`);
});
