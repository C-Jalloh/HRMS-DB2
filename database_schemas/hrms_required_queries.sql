-- Multi-Tenant Human Resources Management System (HRMS)
-- Required SQL Queries (10+ queries as per project requirements)
-- Includes: 3 JOIN queries, 2 aggregate queries, 1 ORDER BY/LIMIT, 1 subquery
-- Created: December 6, 2025

USE hrms_db;

-- =====================================================
-- Query 1: JOIN Query - Employee Details with Department and Company Info
-- =====================================================
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    e.email,
    e.position,
    e.salary_grade,
    e.hire_date,
    d.department_name,
    c.company_name,
    c.industry
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN companies c ON e.admin_id = c.admin_id
WHERE e.admin_id = 2 AND e.is_active = TRUE
ORDER BY e.last_name, e.first_name;

-- =====================================================
-- Query 2: JOIN Query - Leave Requests with Employee and Leave Type Details
-- =====================================================
SELECT 
    lr.request_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    lt.leave_name,
    lr.start_date,
    lr.end_date,
    lr.days_requested,
    lr.status,
    lr.created_at,
    CASE 
        WHEN lr.approved_by IS NOT NULL THEN CONCAT('Approved by: ', lr.approved_by)
        ELSE 'Pending Approval'
    END AS approval_status
FROM leave_requests lr
JOIN employees e ON lr.employee_id = e.employee_id
JOIN leave_types lt ON lr.leave_type_id = lt.leave_type_id
WHERE e.admin_id = 2
ORDER BY lr.created_at DESC;

-- =====================================================
-- Query 3: JOIN Query - Employee Attendance Summary with Department
-- =====================================================
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    d.department_name,
    COUNT(ar.attendance_id) AS total_days,
    SUM(CASE WHEN ar.status = 'present' THEN 1 ELSE 0 END) AS present_days,
    SUM(CASE WHEN ar.status = 'absent' THEN 1 ELSE 0 END) AS absent_days,
    SUM(CASE WHEN ar.status = 'late' THEN 1 ELSE 0 END) AS late_days,
    ROUND(AVG(ar.hours_worked), 2) AS avg_hours_worked,
    ROUND(SUM(ar.hours_worked), 2) AS total_hours_worked
FROM employees e
JOIN departments d ON e.department_id = d.department_id
LEFT JOIN attendance_records ar ON e.employee_id = ar.employee_id 
    AND ar.attendance_date BETWEEN '2024-11-01' AND '2024-11-30'
WHERE e.admin_id = 2 AND e.is_active = TRUE
GROUP BY e.employee_id, e.first_name, e.last_name, d.department_name
ORDER BY e.last_name, e.first_name;

-- =====================================================
-- Query 4: Aggregate Query - Department-wise Employee Count and Average Salary
-- =====================================================
SELECT 
    d.department_name,
    COUNT(e.employee_id) AS employee_count,
    ROUND(AVG(st.base_salary), 2) AS avg_salary,
    MIN(st.base_salary) AS min_salary,
    MAX(st.base_salary) AS max_salary,
    SUM(st.base_salary) AS total_salary_budget
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id AND e.is_active = TRUE
LEFT JOIN employee_salaries es ON e.employee_id = es.employee_id AND es.is_active = TRUE
LEFT JOIN salary_templates st ON es.template_id = st.template_id
WHERE d.admin_id = 2
GROUP BY d.department_id, d.department_name
ORDER BY employee_count DESC, avg_salary DESC;

-- =====================================================
-- Query 5: Aggregate Query - Monthly Leave Usage Statistics
-- =====================================================
SELECT 
    YEAR(lr.start_date) AS year,
    MONTH(lr.start_date) AS month,
    lt.leave_name,
    COUNT(lr.request_id) AS total_requests,
    SUM(CASE WHEN lr.status = 'approved' THEN lr.days_requested ELSE 0 END) AS approved_days,
    SUM(CASE WHEN lr.status = 'pending' THEN 1 ELSE 0 END) AS pending_requests,
    SUM(CASE WHEN lr.status = 'rejected' THEN 1 ELSE 0 END) AS rejected_requests,
    ROUND(AVG(CASE WHEN lr.status = 'approved' THEN lr.days_requested END), 2) AS avg_approved_days
FROM leave_requests lr
JOIN leave_types lt ON lr.leave_type_id = lt.leave_type_id
JOIN employees e ON lr.employee_id = e.employee_id
WHERE e.admin_id = 2 AND YEAR(lr.start_date) = 2024
GROUP BY YEAR(lr.start_date), MONTH(lr.start_date), lt.leave_type_id, lt.leave_name
ORDER BY year, month, total_requests DESC;

-- =====================================================
-- Query 6: ORDER BY/LIMIT Query - Top 10 Highest Paid Employees
-- =====================================================
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    e.position,
    d.department_name,
    st.base_salary,
    st.grade_level
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN employee_salaries es ON e.employee_id = es.employee_id AND es.is_active = TRUE
JOIN salary_templates st ON es.template_id = st.template_id
WHERE e.admin_id = 2 AND e.is_active = TRUE
ORDER BY st.base_salary DESC
LIMIT 10;

-- =====================================================
-- Query 7: Subquery - Employees with Above Average Salary in Their Department
-- =====================================================
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    d.department_name,
    st.base_salary,
    st.grade_level
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN employee_salaries es ON e.employee_id = es.employee_id AND es.is_active = TRUE
JOIN salary_templates st ON es.template_id = st.template_id
WHERE e.admin_id = 2 
  AND e.is_active = TRUE
  AND st.base_salary > (
      SELECT AVG(st2.base_salary)
      FROM employees e2
      JOIN employee_salaries es2 ON e2.employee_id = es2.employee_id AND es2.is_active = TRUE
      JOIN salary_templates st2 ON es2.template_id = st2.template_id
      WHERE e2.department_id = e.department_id 
        AND e2.admin_id = 2 
        AND e2.is_active = TRUE
  )
ORDER BY d.department_name, st.base_salary DESC;

-- =====================================================
-- Query 8: Complex JOIN - Employee Performance Dashboard
-- =====================================================
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    d.department_name,
    st.base_salary,
    COALESCE(att.attendance_rate, 0) AS attendance_rate,
    COALESCE(lb.total_leave_days, 0) AS total_leave_taken,
    COALESCE(bonus.total_bonus, 0) AS total_bonus_received,
    COUNT(DISTINCT ea.action_id) AS total_actions
FROM employees e
JOIN departments d ON e.department_id = d.department_id
LEFT JOIN employee_salaries es ON e.employee_id = es.employee_id AND es.is_active = TRUE
LEFT JOIN salary_templates st ON es.template_id = st.template_id
LEFT JOIN (
    SELECT 
        employee_id,
        ROUND((SUM(CASE WHEN status = 'present' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS attendance_rate
    FROM attendance_records 
    WHERE attendance_date BETWEEN '2024-11-01' AND '2024-11-30'
    GROUP BY employee_id
) att ON e.employee_id = att.employee_id
LEFT JOIN (
    SELECT 
        employee_id,
        SUM(used_days) AS total_leave_days
    FROM leave_balances
    WHERE year = 2024
    GROUP BY employee_id
) lb ON e.employee_id = lb.employee_id
LEFT JOIN (
    SELECT 
        employee_id,
        SUM(amount) AS total_bonus
    FROM bonus_records
    WHERE YEAR(bonus_date) = 2024
    GROUP BY employee_id
) bonus ON e.employee_id = bonus.employee_id
LEFT JOIN employee_actions ea ON e.employee_id = ea.employee_id
WHERE e.admin_id = 2 AND e.is_active = TRUE
GROUP BY e.employee_id, e.first_name, e.last_name, d.department_name, st.base_salary, att.attendance_rate, lb.total_leave_days, bonus.total_bonus
ORDER BY st.base_salary DESC;

-- =====================================================
-- Query 9: Leave Balance Summary with Policy Information
-- =====================================================
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    lt.leave_name,
    lb.balance_days,
    lb.used_days,
    (lb.balance_days - lb.used_days) AS remaining_days,
    lp.accrual_rate,
    lp.max_carryover,
    ROUND((lb.balance_days / lp.accrual_rate), 1) AS months_worked
FROM employees e
JOIN leave_balances lb ON e.employee_id = lb.employee_id
JOIN leave_types lt ON lb.leave_type_id = lt.leave_type_id
LEFT JOIN leave_policies lp ON lt.leave_type_id = lp.leave_type_id AND e.admin_id = lp.admin_id
WHERE e.admin_id = 2 AND lb.year = 2024
ORDER BY e.last_name, e.first_name, lt.leave_name;

-- =====================================================
-- Query 10: Attendance Trends by Month
-- =====================================================
SELECT 
    YEAR(attendance_date) AS year,
    MONTH(attendance_date) AS month,
    COUNT(*) AS total_records,
    SUM(CASE WHEN status = 'present' THEN 1 ELSE 0 END) AS present_count,
    SUM(CASE WHEN status = 'absent' THEN 1 ELSE 0 END) AS absent_count,
    SUM(CASE WHEN status = 'late' THEN 1 ELSE 0 END) AS late_count,
    SUM(CASE WHEN status = 'half_day' THEN 1 ELSE 0 END) AS half_day_count,
    ROUND(AVG(hours_worked), 2) AS avg_hours_worked,
    ROUND((SUM(CASE WHEN status = 'present' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS attendance_percentage
FROM attendance_records ar
JOIN employees e ON ar.employee_id = e.employee_id
WHERE e.admin_id = 2 
  AND attendance_date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY YEAR(attendance_date), MONTH(attendance_date)
ORDER BY year, month;

-- =====================================================
-- Query 11: Employee Tenure Analysis
-- =====================================================
SELECT 
    CASE 
        WHEN TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) < 1 THEN '< 1 year'
        WHEN TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) BETWEEN 1 AND 2 THEN '1-2 years'
        WHEN TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) BETWEEN 3 AND 5 THEN '3-5 years'
        WHEN TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) BETWEEN 6 AND 10 THEN '6-10 years'
        ELSE '10+ years'
    END AS tenure_range,
    COUNT(*) AS employee_count,
    ROUND(AVG(st.base_salary), 2) AS avg_salary,
    MIN(st.base_salary) AS min_salary,
    MAX(st.base_salary) AS max_salary
FROM employees e
LEFT JOIN employee_salaries es ON e.employee_id = es.employee_id AND es.is_active = TRUE
LEFT JOIN salary_templates st ON es.template_id = st.template_id
WHERE e.admin_id = 2 AND e.is_active = TRUE
GROUP BY 
    CASE 
        WHEN TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) < 1 THEN '< 1 year'
        WHEN TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) BETWEEN 1 AND 2 THEN '1-2 years'
        WHEN TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) BETWEEN 3 AND 5 THEN '3-5 years'
        WHEN TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) BETWEEN 6 AND 10 THEN '6-10 years'
        ELSE '10+ years'
    END
ORDER BY 
    CASE 
        WHEN tenure_range = '< 1 year' THEN 1
        WHEN tenure_range = '1-2 years' THEN 2
        WHEN tenure_range = '3-5 years' THEN 3
        WHEN tenure_range = '6-10 years' THEN 4
        ELSE 5
    END;

-- =====================================================
-- Query 12: Department Leave Utilization Report
-- =====================================================
SELECT 
    d.department_name,
    COUNT(DISTINCT e.employee_id) AS total_employees,
    COUNT(lr.request_id) AS total_leave_requests,
    SUM(CASE WHEN lr.status = 'approved' THEN lr.days_requested ELSE 0 END) AS total_approved_days,
    ROUND(
        (SUM(CASE WHEN lr.status = 'approved' THEN lr.days_requested ELSE 0 END) / 
         NULLIF(COUNT(DISTINCT e.employee_id), 0)) / 12, 2
    ) AS avg_leave_days_per_employee_per_month,
    ROUND(
        (SUM(CASE WHEN lr.status = 'approved' THEN lr.days_requested ELSE 0 END) / 
         NULLIF(SUM(CASE WHEN lr.status = 'approved' THEN lr.days_requested ELSE 0 END) + 
                SUM(CASE WHEN lr.status = 'pending' THEN lr.days_requested ELSE 0 END), 0)) * 100, 2
    ) AS approval_rate_percentage
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id AND e.is_active = TRUE
LEFT JOIN leave_requests lr ON e.employee_id = lr.employee_id 
    AND YEAR(lr.start_date) = 2024
WHERE d.admin_id = 2
GROUP BY d.department_id, d.department_name
ORDER BY total_approved_days DESC;

-- =====================================================
-- Query 13: Salary Distribution Analysis
-- =====================================================
SELECT 
    CASE 
        WHEN base_salary < 30000 THEN '< $30,000'
        WHEN base_salary BETWEEN 30000 AND 49999 THEN '$30,000 - $49,999'
        WHEN base_salary BETWEEN 50000 AND 69999 THEN '$50,000 - $69,999'
        WHEN base_salary BETWEEN 70000 AND 89999 THEN '$70,000 - $89,999'
        WHEN base_salary BETWEEN 90000 AND 119999 THEN '$90,000 - $119,999'
        ELSE '$120,000+'
    END AS salary_range,
    COUNT(*) AS employee_count,
    ROUND((COUNT(*) / (SELECT COUNT(*) FROM employees e2 
                       JOIN employee_salaries es2 ON e2.employee_id = es2.employee_id AND es2.is_active = TRUE
                       JOIN salary_templates st2 ON es2.template_id = st2.template_id
                       WHERE e2.admin_id = 2 AND e2.is_active = TRUE)) * 100, 2) AS percentage
FROM employees e
JOIN employee_salaries es ON e.employee_id = es.employee_id AND es.is_active = TRUE
JOIN salary_templates st ON es.template_id = st.template_id
WHERE e.admin_id = 2 AND e.is_active = TRUE
GROUP BY 
    CASE 
        WHEN base_salary < 30000 THEN '< $30,000'
        WHEN base_salary BETWEEN 30000 AND 49999 THEN '$30,000 - $49,999'
        WHEN base_salary BETWEEN 50000 AND 69999 THEN '$50,000 - $69,999'
        WHEN base_salary BETWEEN 70000 AND 89999 THEN '$70,000 - $89,999'
        WHEN base_salary BETWEEN 90000 AND 119999 THEN '$90,000 - $119,999'
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
    END;

-- =====================================================
-- Query 14: Employee Onboarding Status (Subquery)
-- =====================================================
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    e.hire_date,
    TIMESTAMPDIFF(DAY, e.hire_date, CURDATE()) AS days_since_hire,
    CASE 
        WHEN TIMESTAMPDIFF(DAY, e.hire_date, CURDATE()) <= 30 THEN 'New Hire (< 30 days)'
        WHEN TIMESTAMPDIFF(DAY, e.hire_date, CURDATE()) <= 90 THEN 'Recent Hire (31-90 days)'
        ELSE 'Established Employee (> 90 days)'
    END AS onboarding_status,
    (
        SELECT COUNT(*) 
        FROM employee_actions ea 
        WHERE ea.employee_id = e.employee_id 
          AND ea.action_type IN ('hire', 'orientation', 'training')
    ) AS onboarding_actions_count,
    (
        SELECT COUNT(*) 
        FROM attendance_records ar 
        WHERE ar.employee_id = e.employee_id 
          AND ar.attendance_date >= e.hire_date
    ) AS attendance_records_count
FROM employees e
WHERE e.admin_id = 2 AND e.is_active = TRUE
ORDER BY e.hire_date DESC;

-- =====================================================
-- Query 15: Comprehensive HR Dashboard Summary
-- =====================================================
SELECT 
    'Total Employees' AS metric,
    COUNT(*) AS value
FROM employees 
WHERE admin_id = 2 AND is_active = TRUE

UNION ALL

SELECT 
    'Total Departments' AS metric,
    COUNT(*) AS value
FROM departments 
WHERE admin_id = 2

UNION ALL

SELECT 
    'Active Leave Requests' AS metric,
    COUNT(*) AS value
FROM leave_requests lr
JOIN employees e ON lr.employee_id = e.employee_id
WHERE e.admin_id = 2 AND lr.status = 'pending'

UNION ALL

SELECT 
    'Average Monthly Salary' AS metric,
    ROUND(AVG(st.base_salary), 0) AS value
FROM employees e
JOIN employee_salaries es ON e.employee_id = es.employee_id AND es.is_active = TRUE
JOIN salary_templates st ON es.template_id = st.template_id
WHERE e.admin_id = 2 AND e.is_active = TRUE

UNION ALL

SELECT 
    'Total Salary Budget' AS metric,
    ROUND(SUM(st.base_salary), 0) AS value
FROM employees e
JOIN employee_salaries es ON e.employee_id = es.employee_id AND es.is_active = TRUE
JOIN salary_templates st ON es.template_id = st.template_id
WHERE e.admin_id = 2 AND e.is_active = TRUE

UNION ALL

SELECT 
    'Average Attendance Rate' AS metric,
    ROUND(
        (SELECT SUM(CASE WHEN status = 'present' THEN 1 ELSE 0 END) 
         FROM attendance_records ar
         JOIN employees e ON ar.employee_id = e.employee_id
         WHERE e.admin_id = 2 AND ar.attendance_date BETWEEN '2024-11-01' AND '2024-11-30') /
        NULLIF(
            (SELECT COUNT(*) 
             FROM attendance_records ar
             JOIN employees e ON ar.employee_id = e.employee_id
             WHERE e.admin_id = 2 AND ar.attendance_date BETWEEN '2024-11-01' AND '2024-11-30'), 0
        ) * 100, 1
    ) AS value;

COMMIT;
