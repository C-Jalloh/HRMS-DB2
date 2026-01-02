-- Multi-Tenant Human Resources Management System (HRMS)
-- Dashboard Data Export Queries
-- For Excel/Power BI/Tableau Visualization
-- Created: December 6, 2025

USE hrms_db;

-- =====================================================
-- Dashboard 1: Employee Overview Dashboard
-- =====================================================

-- Query 1: Employee Count by Department (Bar Chart)
SELECT 
    d.department_name,
    COUNT(e.employee_id) AS employee_count,
    COUNT(CASE WHEN e.is_active = TRUE THEN 1 END) AS active_employees,
    COUNT(CASE WHEN e.is_active = FALSE THEN 1 END) AS inactive_employees
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id AND d.admin_id = e.admin_id
WHERE d.admin_id = 2  -- Filter by admin/tenant
GROUP BY d.department_id, d.department_name
ORDER BY employee_count DESC;

-- Query 2: Employee Distribution by Position (Pie Chart)
SELECT 
    position,
    COUNT(*) AS count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM employees WHERE admin_id = 2 AND is_active = TRUE)), 2) AS percentage
FROM employees 
WHERE admin_id = 2 AND is_active = TRUE
GROUP BY position
ORDER BY count DESC;

-- Query 3: Salary Distribution by Grade (Histogram)
SELECT 
    salary_grade,
    COUNT(*) AS employee_count,
    AVG(st.base_salary) AS avg_salary,
    MIN(st.base_salary) AS min_salary,
    MAX(st.base_salary) AS max_salary
FROM employees e
JOIN employee_salaries es ON e.employee_id = es.employee_id AND es.is_active = TRUE
JOIN salary_templates st ON es.template_id = st.template_id
WHERE e.admin_id = 2 AND e.is_active = TRUE
GROUP BY salary_grade
ORDER BY salary_grade;

-- Query 4: Employee Tenure Analysis (Line Chart)
SELECT 
    YEAR(hire_date) AS hire_year,
    COUNT(*) AS hired_count,
    AVG(DATEDIFF(CURDATE(), hire_date) / 365.25) AS avg_tenure_years
FROM employees 
WHERE admin_id = 2 AND is_active = TRUE
GROUP BY YEAR(hire_date)
ORDER BY hire_year;

-- =====================================================
-- Dashboard 2: Leave Management Dashboard
-- =====================================================

-- Query 5: Leave Balance Summary by Department
SELECT 
    d.department_name,
    lt.leave_type_name,
    SUM(lb.balance_days) AS total_balance,
    SUM(lb.used_days) AS total_used,
    SUM(lb.balance_days - lb.used_days) AS remaining_balance,
    AVG(lb.balance_days - lb.used_days) AS avg_remaining_per_employee
FROM departments d
JOIN employees e ON d.department_id = e.department_id AND d.admin_id = e.admin_id
JOIN leave_balances lb ON e.employee_id = lb.employee_id
JOIN leave_types lt ON lb.leave_type_id = lt.leave_type_id
WHERE e.admin_id = 2 AND e.is_active = TRUE AND lb.year = YEAR(CURDATE())
GROUP BY d.department_id, d.department_name, lt.leave_type_id, lt.leave_type_name
ORDER BY d.department_name, lt.leave_type_name;

-- Query 6: Leave Request Status Distribution (Pie Chart)
SELECT 
    status,
    COUNT(*) AS request_count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM leave_requests lr 
                                 JOIN employees e ON lr.employee_id = e.employee_id 
                                 WHERE e.admin_id = 2)), 2) AS percentage
FROM leave_requests lr
JOIN employees e ON lr.employee_id = e.employee_id
WHERE e.admin_id = 2
GROUP BY status;

-- Query 7: Monthly Leave Usage Trend (Line Chart)
SELECT 
    DATE_FORMAT(lr.start_date, '%Y-%m') AS month,
    COUNT(*) AS leave_requests,
    SUM(lr.days_requested) AS total_days_requested,
    AVG(lr.days_requested) AS avg_days_per_request
FROM leave_requests lr
JOIN employees e ON lr.employee_id = e.employee_id
WHERE e.admin_id = 2 AND lr.status = 'approved' AND YEAR(lr.start_date) = YEAR(CURDATE())
GROUP BY DATE_FORMAT(lr.start_date, '%Y-%m')
ORDER BY month;

-- Query 8: Top Leave Users This Year
SELECT 
    e.first_name,
    e.last_name,
    d.department_name,
    SUM(lr.days_requested) AS total_leave_days,
    COUNT(lr.request_id) AS leave_requests_count
FROM employees e
JOIN departments d ON e.department_id = d.department_id AND e.admin_id = d.admin_id
LEFT JOIN leave_requests lr ON e.employee_id = lr.employee_id AND lr.status = 'approved' AND YEAR(lr.start_date) = YEAR(CURDATE())
WHERE e.admin_id = 2 AND e.is_active = TRUE
GROUP BY e.employee_id, e.first_name, e.last_name, d.department_name
ORDER BY total_leave_days DESC
LIMIT 10;

-- =====================================================
-- Dashboard 3: Attendance Dashboard
-- =====================================================

-- Query 9: Attendance Rate by Month (Line Chart)
SELECT 
    DATE_FORMAT(attendance_date, '%Y-%m') AS month,
    COUNT(*) AS total_records,
    COUNT(CASE WHEN status = 'present' THEN 1 END) AS present_count,
    COUNT(CASE WHEN status = 'absent' THEN 1 END) AS absent_count,
    COUNT(CASE WHEN status = 'late' THEN 1 END) AS late_count,
    ROUND((COUNT(CASE WHEN status = 'present' THEN 1 END) * 100.0 / COUNT(*)), 2) AS attendance_rate
FROM attendance_records ar
JOIN employees e ON ar.employee_id = e.employee_id
WHERE e.admin_id = 2 AND YEAR(attendance_date) = YEAR(CURDATE())
GROUP BY DATE_FORMAT(attendance_date, '%Y-%m')
ORDER BY month;

-- Query 10: Average Hours Worked by Department (Bar Chart)
SELECT 
    d.department_name,
    AVG(ar.hours_worked) AS avg_hours_worked,
    MIN(ar.hours_worked) AS min_hours,
    MAX(ar.hours_worked) AS max_hours,
    COUNT(ar.attendance_id) AS attendance_records
FROM departments d
JOIN employees e ON d.department_id = e.department_id AND d.admin_id = e.admin_id
JOIN attendance_records ar ON e.employee_id = ar.employee_id
WHERE e.admin_id = 2 AND ar.status = 'present' AND YEAR(ar.attendance_date) = YEAR(CURDATE())
GROUP BY d.department_id, d.department_name
ORDER BY avg_hours_worked DESC;

-- Query 11: Employee Attendance Summary
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    d.department_name,
    COUNT(ar.attendance_id) AS total_days,
    COUNT(CASE WHEN ar.status = 'present' THEN 1 END) AS present_days,
    COUNT(CASE WHEN ar.status = 'absent' THEN 1 END) AS absent_days,
    COUNT(CASE WHEN ar.status = 'late' THEN 1 END) AS late_days,
    ROUND((COUNT(CASE WHEN ar.status = 'present' THEN 1 END) * 100.0 / COUNT(ar.attendance_id)), 2) AS attendance_percentage,
    ROUND(AVG(ar.hours_worked), 2) AS avg_hours_worked
FROM employees e
JOIN departments d ON e.department_id = d.department_id AND e.admin_id = d.admin_id
LEFT JOIN attendance_records ar ON e.employee_id = ar.employee_id AND YEAR(ar.attendance_date) = YEAR(CURDATE())
WHERE e.admin_id = 2 AND e.is_active = TRUE
GROUP BY e.employee_id, e.first_name, e.last_name, d.department_name
ORDER BY attendance_percentage DESC;

-- Query 12: Weekly Attendance Pattern
SELECT 
    DAYNAME(attendance_date) AS day_of_week,
    COUNT(*) AS total_records,
    COUNT(CASE WHEN status = 'present' THEN 1 END) AS present_count,
    ROUND(AVG(hours_worked), 2) AS avg_hours
FROM attendance_records ar
JOIN employees e ON ar.employee_id = e.employee_id
WHERE e.admin_id = 2 AND YEAR(attendance_date) = YEAR(CURDATE())
GROUP BY DAYOFWEEK(attendance_date), DAYNAME(attendance_date)
ORDER BY DAYOFWEEK(attendance_date);

-- =====================================================
-- Dashboard 4: Payroll & Compensation Dashboard
-- =====================================================

-- Query 13: Salary Range Distribution
SELECT 
    CASE 
        WHEN st.base_salary < 30000 THEN 'Under $30K'
        WHEN st.base_salary BETWEEN 30000 AND 50000 THEN '$30K-$50K'
        WHEN st.base_salary BETWEEN 50001 AND 70000 THEN '$50K-$70K'
        WHEN st.base_salary BETWEEN 70001 AND 90000 THEN '$70K-$90K'
        ELSE 'Over $90K'
    END AS salary_range,
    COUNT(*) AS employee_count,
    ROUND(AVG(st.base_salary), 2) AS avg_salary_in_range
FROM employees e
JOIN employee_salaries es ON e.employee_id = es.employee_id AND es.is_active = TRUE
JOIN salary_templates st ON es.template_id = st.template_id
WHERE e.admin_id = 2 AND e.is_active = TRUE
GROUP BY 
    CASE 
        WHEN st.base_salary < 30000 THEN 'Under $30K'
        WHEN st.base_salary BETWEEN 30000 AND 50000 THEN '$30K-$50K'
        WHEN st.base_salary BETWEEN 50001 AND 70000 THEN '$50K-$70K'
        WHEN st.base_salary BETWEEN 70001 AND 90000 THEN '$70K-$90K'
        ELSE 'Over $90K'
    END
ORDER BY avg_salary_in_range;

-- Query 14: Bonus Distribution This Year
SELECT 
    bc.component_name,
    COUNT(br.bonus_id) AS bonus_count,
    SUM(br.amount) AS total_amount,
    AVG(br.amount) AS avg_amount,
    MIN(br.amount) AS min_amount,
    MAX(br.amount) AS max_amount
FROM bonus_records br
JOIN bonus_components bc ON br.component_id = bc.component_id
JOIN employees e ON br.employee_id = e.employee_id
WHERE e.admin_id = 2 AND YEAR(br.bonus_date) = YEAR(CURDATE())
GROUP BY bc.component_id, bc.component_name
ORDER BY total_amount DESC;

-- Query 15: Department Salary Comparison
SELECT 
    d.department_name,
    COUNT(e.employee_id) AS employee_count,
    ROUND(AVG(st.base_salary), 2) AS avg_salary,
    ROUND(MIN(st.base_salary), 2) AS min_salary,
    ROUND(MAX(st.base_salary), 2) AS max_salary,
    ROUND(STDDEV(st.base_salary), 2) AS salary_std_dev
FROM departments d
JOIN employees e ON d.department_id = e.department_id AND d.admin_id = e.admin_id
JOIN employee_salaries es ON e.employee_id = es.employee_id AND es.is_active = TRUE
JOIN salary_templates st ON es.template_id = st.template_id
WHERE e.admin_id = 2 AND e.is_active = TRUE
GROUP BY d.department_id, d.department_name
ORDER BY avg_salary DESC;

-- Query 16: Salary Increase Trends
SELECT 
    YEAR(es.effective_date) AS year,
    COUNT(DISTINCT e.employee_id) AS employees_with_changes,
    ROUND(AVG(st.base_salary), 2) AS avg_salary_that_year,
    COUNT(es.salary_id) AS total_salary_records
FROM employee_salaries es
JOIN employees e ON es.employee_id = e.employee_id
JOIN salary_templates st ON es.template_id = st.template_id
WHERE e.admin_id = 2
GROUP BY YEAR(es.effective_date)
ORDER BY year;

-- =====================================================
-- Dashboard 5: HR Analytics Dashboard
-- =====================================================

-- Query 17: Employee Turnover Rate
SELECT 
    YEAR(CURDATE()) AS current_year,
    COUNT(CASE WHEN YEAR(hire_date) = YEAR(CURDATE()) THEN 1 END) AS hired_this_year,
    COUNT(CASE WHEN YEAR(updated_at) = YEAR(CURDATE()) AND is_active = FALSE THEN 1 END) AS terminated_this_year,
    ROUND(
        (COUNT(CASE WHEN YEAR(updated_at) = YEAR(CURDATE()) AND is_active = FALSE THEN 1 END) * 100.0) /
        NULLIF(AVG_employee_count, 0), 2
    ) AS turnover_rate_percentage
FROM employees e
CROSS JOIN (
    SELECT AVG(employee_count) AS AVG_employee_count
    FROM (
        SELECT COUNT(*) AS employee_count
        FROM employees 
        WHERE admin_id = 2 AND YEAR(hire_date) <= YEAR(CURDATE())
        GROUP BY MONTH(hire_date)
    ) AS monthly_counts
) AS avg_count
WHERE admin_id = 2;

-- Query 18: Performance Metrics Summary
SELECT 
    'Total Employees' AS metric,
    COUNT(*) AS value
FROM employees WHERE admin_id = 2 AND is_active = TRUE
UNION ALL
SELECT 
    'Active Leave Requests' AS metric,
    COUNT(*) AS value
FROM leave_requests lr
JOIN employees e ON lr.employee_id = e.employee_id
WHERE e.admin_id = 2 AND lr.status = 'pending'
UNION ALL
SELECT 
    'Average Attendance Rate' AS metric,
    ROUND(AVG(attendance_rate), 2) AS value
FROM (
    SELECT 
        e.employee_id,
        ROUND((COUNT(CASE WHEN ar.status = 'present' THEN 1 END) * 100.0 / COUNT(ar.attendance_id)), 2) AS attendance_rate
    FROM employees e
    LEFT JOIN attendance_records ar ON e.employee_id = ar.employee_id AND YEAR(ar.attendance_date) = YEAR(CURDATE())
    WHERE e.admin_id = 2 AND e.is_active = TRUE
    GROUP BY e.employee_id
) AS attendance_rates
UNION ALL
SELECT 
    'Total Salary Budget' AS metric,
    ROUND(SUM(st.base_salary), 0) AS value
FROM employees e
JOIN employee_salaries es ON e.employee_id = es.employee_id AND es.is_active = TRUE
JOIN salary_templates st ON es.template_id = st.template_id
WHERE e.admin_id = 2 AND e.is_active = TRUE;

-- Query 19: Department Performance Comparison
SELECT 
    d.department_name,
    COUNT(e.employee_id) AS headcount,
    ROUND(AVG(attendance_rate), 2) AS avg_attendance_rate,
    ROUND(AVG(leave_usage), 2) AS avg_leave_days_used,
    ROUND(AVG(st.base_salary), 2) AS avg_salary
FROM departments d
JOIN employees e ON d.department_id = e.department_id AND d.admin_id = e.admin_id
JOIN employee_salaries es ON e.employee_id = es.employee_id AND es.is_active = TRUE
JOIN salary_templates st ON es.template_id = st.template_id
LEFT JOIN (
    SELECT 
        e.employee_id,
        ROUND((COUNT(CASE WHEN ar.status = 'present' THEN 1 END) * 100.0 / COUNT(ar.attendance_id)), 2) AS attendance_rate
    FROM employees e
    LEFT JOIN attendance_records ar ON e.employee_id = ar.employee_id AND YEAR(ar.attendance_date) = YEAR(CURDATE())
    WHERE e.admin_id = 2
    GROUP BY e.employee_id
) AS att ON e.employee_id = att.employee_id
LEFT JOIN (
    SELECT 
        e.employee_id,
        SUM(lr.days_requested) AS leave_usage
    FROM employees e
    LEFT JOIN leave_requests lr ON e.employee_id = lr.employee_id AND lr.status = 'approved' AND YEAR(lr.start_date) = YEAR(CURDATE())
    WHERE e.admin_id = 2
    GROUP BY e.employee_id
) AS lv ON e.employee_id = lv.employee_id
WHERE e.admin_id = 2 AND e.is_active = TRUE
GROUP BY d.department_id, d.department_name
ORDER BY avg_attendance_rate DESC;

-- Query 20: Monthly HR Activity Summary
SELECT 
    DATE_FORMAT(activity_date, '%Y-%m') AS month,
    COUNT(CASE WHEN action_type = 'hire' THEN 1 END) AS hires,
    COUNT(CASE WHEN action_type = 'termination' THEN 1 END) AS terminations,
    COUNT(CASE WHEN action_type = 'leave_approved' THEN 1 END) AS leave_approvals,
    COUNT(CASE WHEN action_type = 'salary_change' THEN 1 END) AS salary_changes,
    COUNT(*) AS total_actions
FROM employee_actions ea
JOIN employees e ON ea.employee_id = e.employee_id
WHERE e.admin_id = 2 AND YEAR(ea.action_date) = YEAR(CURDATE())
GROUP BY DATE_FORMAT(ea.action_date, '%Y-%m')
ORDER BY month;

-- =====================================================
-- Export Data for Excel/Power BI/Tableau
-- =====================================================

-- Create views for easy data export
CREATE OR REPLACE VIEW employee_overview AS
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    e.email,
    e.phone,
    e.hire_date,
    e.position,
    e.salary_grade,
    d.department_name,
    st.template_name,
    st.base_salary,
    TIMESTAMPDIFF(YEAR, e.hire_date, CURDATE()) AS years_of_service
FROM employees e
JOIN departments d ON e.department_id = d.department_id AND e.admin_id = d.admin_id
LEFT JOIN employee_salaries es ON e.employee_id = es.employee_id AND es.is_active = TRUE
LEFT JOIN salary_templates st ON es.template_id = st.template_id
WHERE e.admin_id = 2 AND e.is_active = TRUE;

CREATE OR REPLACE VIEW leave_summary AS
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    d.department_name,
    lt.leave_type_name,
    lb.balance_days,
    lb.used_days,
    (lb.balance_days - lb.used_days) AS remaining_days,
    lb.year
FROM employees e
JOIN departments d ON e.department_id = d.department_id AND e.admin_id = e.admin_id
JOIN leave_balances lb ON e.employee_id = lb.employee_id
JOIN leave_types lt ON lb.leave_type_id = lt.leave_type_id
WHERE e.admin_id = 2 AND e.is_active = TRUE;

CREATE OR REPLACE VIEW attendance_summary AS
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    d.department_name,
    ar.attendance_date,
    ar.clock_in,
    ar.clock_out,
    ar.status,
    ar.hours_worked,
    DAYNAME(ar.attendance_date) AS day_name,
    MONTHNAME(ar.attendance_date) AS month_name,
    YEAR(ar.attendance_date) AS year
FROM employees e
JOIN departments d ON e.department_id = d.department_id AND e.admin_id = e.admin_id
JOIN attendance_records ar ON e.employee_id = ar.employee_id
WHERE e.admin_id = 2;

-- Export instructions for dashboard tools
SELECT 'To create dashboards in Excel/Power BI/Tableau:
1. Export the above query results to CSV files
2. Import CSV files into your visualization tool
3. Create the following dashboard components:

Employee Overview Dashboard:
- Employee count by department (Bar Chart)
- Employee distribution by position (Pie Chart) 
- Salary distribution by grade (Histogram)
- Employee tenure analysis (Line Chart)

Leave Management Dashboard:
- Leave balance summary by department (Stacked Bar Chart)
- Leave request status distribution (Pie Chart)
- Monthly leave usage trend (Line Chart)
- Top leave users (Table/Bar Chart)

Attendance Dashboard:
- Attendance rate by month (Line Chart)
- Average hours worked by department (Bar Chart)
- Employee attendance summary (Table)
- Weekly attendance pattern (Bar Chart)

Payroll Dashboard:
- Salary range distribution (Histogram)
- Bonus distribution (Pie Chart)
- Department salary comparison (Bar Chart)
- Salary increase trends (Line Chart)

HR Analytics Dashboard:
- Key performance metrics (KPI Cards)
- Department performance comparison (Table)
- Monthly HR activity summary (Line Chart)
- Turnover rate calculation (KPI Card)

Use the created views (employee_overview, leave_summary, attendance_summary) 
for simplified data access in your dashboard tools.' AS dashboard_instructions;
