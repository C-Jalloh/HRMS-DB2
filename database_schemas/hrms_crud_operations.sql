-- Multi-Tenant Human Resources Management System (HRMS)
-- CRUD Operations for All Tables
-- Created: December 6, 2025

USE hrms_db;

-- =====================================================
-- CRUD Operations: Users Table
-- =====================================================

-- CREATE: Insert new user (Superadmin/Admin)
INSERT INTO users (username, password_hash, role, is_active) 
VALUES ('new_admin', '$2b$10$newhashedpassword', 'admin', TRUE);

-- READ: Get all active users
SELECT user_id, username, role, is_active, created_at 
FROM users 
WHERE is_active = TRUE;

-- READ: Get user by ID
SELECT user_id, username, role, is_active, created_at, updated_at 
FROM users 
WHERE user_id = 1;

-- UPDATE: Update user information
UPDATE users 
SET username = 'updated_admin', updated_at = NOW() 
WHERE user_id = 13;

-- DELETE: Soft delete user (deactivate)
UPDATE users 
SET is_active = FALSE, updated_at = NOW() 
WHERE user_id = 13;

-- =====================================================
-- CRUD Operations: Companies Table
-- =====================================================

-- CREATE: Insert new company
INSERT INTO companies (admin_id, company_name, address, phone, email, industry) 
VALUES (13, 'New Tech Corp', '123 New Street, City, State', '+1-555-0123', 'info@newtech.com', 'Technology');

-- READ: Get all companies for an admin
SELECT company_id, company_name, address, phone, email, industry, created_at 
FROM companies 
WHERE admin_id = 2;

-- READ: Get company by ID
SELECT * FROM companies WHERE company_id = 1;

-- UPDATE: Update company information
UPDATE companies 
SET company_name = 'Updated Tech Corp', phone = '+1-555-0124', updated_at = NOW() 
WHERE company_id = 12;

-- DELETE: Soft delete company (Note: In real system, this would cascade or prevent deletion)
-- For demo purposes, we'll show the concept
-- UPDATE companies SET is_active = FALSE WHERE company_id = 12;

-- =====================================================
-- CRUD Operations: Departments Table
-- =====================================================

-- CREATE: Insert new department
INSERT INTO departments (admin_id, department_name, department_head) 
VALUES (2, 'Research & Development', 'Dr. Jane Smith');

-- READ: Get all departments for an admin
SELECT department_id, department_name, department_head, created_at 
FROM departments 
WHERE admin_id = 2 
ORDER BY department_name;

-- READ: Get department by ID
SELECT * FROM departments WHERE department_id = 1;

-- UPDATE: Update department information
UPDATE departments 
SET department_head = 'Dr. John Smith', updated_at = NOW() 
WHERE department_id = 56;

-- DELETE: Remove department (would need cascade handling in real system)
DELETE FROM departments WHERE department_id = 56;

-- =====================================================
-- CRUD Operations: Employees Table
-- =====================================================

-- CREATE: Insert new employee
INSERT INTO employees (admin_id, department_id, first_name, last_name, email, phone, hire_date, position, salary_grade, is_active) 
VALUES (2, 1, 'John', 'Doe', 'john.doe@techsolutions.com', '+1-555-1000', '2024-12-06', 'Junior Developer', 'L1', TRUE);

-- READ: Get all employees for an admin
SELECT e.employee_id, e.first_name, e.last_name, e.email, e.position, e.salary_grade, 
       d.department_name, e.hire_date, e.is_active
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.admin_id = 2
ORDER BY e.last_name, e.first_name;

-- READ: Get employee by ID with department info
SELECT e.*, d.department_name 
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.employee_id = 51;

-- UPDATE: Update employee information
UPDATE employees 
SET position = 'Senior Developer', salary_grade = 'L2', updated_at = NOW() 
WHERE employee_id = 51;

-- DELETE: Soft delete employee (deactivate)
UPDATE employees 
SET is_active = FALSE, updated_at = NOW() 
WHERE employee_id = 51;

-- =====================================================
-- CRUD Operations: Employee Actions Table
-- =====================================================

-- CREATE: Record employee action
INSERT INTO employee_actions (employee_id, action_type, action_date, description) 
VALUES (1, 'transfer', '2024-12-06', 'Transferred to Engineering Department');

-- READ: Get all actions for an employee
SELECT action_id, action_type, action_date, description, created_at 
FROM employee_actions 
WHERE employee_id = 1 
ORDER BY action_date DESC;

-- READ: Get action by ID
SELECT * FROM employee_actions WHERE action_id = 1;

-- UPDATE: Update action details
UPDATE employee_actions 
SET description = 'Transferred to Engineering Department - Updated', updated_at = NOW() 
WHERE action_id = 61;

-- DELETE: Remove action record
DELETE FROM employee_actions WHERE action_id = 61;

-- =====================================================
-- CRUD Operations: Leave Types Table
-- =====================================================

-- CREATE: Insert new leave type
INSERT INTO leave_types (admin_id, leave_name, is_paid, max_days_per_year) 
VALUES (2, 'Bereavement Leave', TRUE, 5);

-- READ: Get all leave types for an admin
SELECT leave_type_id, leave_name, is_paid, max_days_per_year, created_at 
FROM leave_types 
WHERE admin_id = 2 
ORDER BY leave_name;

-- READ: Get leave type by ID
SELECT * FROM leave_types WHERE leave_type_id = 1;

-- UPDATE: Update leave type
UPDATE leave_types 
SET max_days_per_year = 7, updated_at = NOW() 
WHERE leave_type_id = 56;

-- DELETE: Remove leave type
DELETE FROM leave_types WHERE leave_type_id = 56;

-- =====================================================
-- CRUD Operations: Leave Policies Table
-- =====================================================

-- CREATE: Insert new leave policy
INSERT INTO leave_policies (admin_id, leave_type_id, accrual_rate, max_carryover) 
VALUES (2, 1, 2.0, 6);

-- READ: Get all leave policies for an admin
SELECT lp.policy_id, lt.leave_name, lp.accrual_rate, lp.max_carryover, lp.created_at 
FROM leave_policies lp
JOIN leave_types lt ON lp.leave_type_id = lt.leave_type_id
WHERE lp.admin_id = 2 
ORDER BY lt.leave_name;

-- READ: Get leave policy by ID
SELECT * FROM leave_policies WHERE policy_id = 1;

-- UPDATE: Update leave policy
UPDATE leave_policies 
SET accrual_rate = 2.5, max_carryover = 7, updated_at = NOW() 
WHERE policy_id = 56;

-- DELETE: Remove leave policy
DELETE FROM leave_policies WHERE policy_id = 56;

-- =====================================================
-- CRUD Operations: Leave Balances Table
-- =====================================================

-- CREATE: Insert new leave balance
INSERT INTO leave_balances (employee_id, leave_type_id, balance_days, used_days, year) 
VALUES (1, 1, 25.0, 0.0, 2025);

-- READ: Get all leave balances for an employee
SELECT lb.balance_id, lt.leave_name, lb.balance_days, lb.used_days, lb.year, lb.created_at 
FROM leave_balances lb
JOIN leave_types lt ON lb.leave_type_id = lt.leave_type_id
WHERE lb.employee_id = 1 
ORDER BY lb.year DESC, lt.leave_name;

-- READ: Get leave balance by ID
SELECT * FROM leave_balances WHERE balance_id = 1;

-- UPDATE: Update leave balance (e.g., after leave usage)
UPDATE leave_balances 
SET used_days = used_days + 5.0, updated_at = NOW() 
WHERE balance_id = 1;

-- DELETE: Remove leave balance record
DELETE FROM leave_balances WHERE balance_id = 151;

-- =====================================================
-- CRUD Operations: Leave Requests Table
-- =====================================================

-- CREATE: Insert new leave request
INSERT INTO leave_requests (employee_id, leave_type_id, start_date, end_date, days_requested, status) 
VALUES (1, 1, '2025-01-15', '2025-01-19', 5.0, 'pending');

-- READ: Get all leave requests for an employee
SELECT lr.request_id, lt.leave_name, lr.start_date, lr.end_date, lr.days_requested, 
       lr.status, lr.approved_by, lr.created_at 
FROM leave_requests lr
JOIN leave_types lt ON lr.leave_type_id = lt.leave_type_id
WHERE lr.employee_id = 1 
ORDER BY lr.created_at DESC;

-- READ: Get pending leave requests for approval (for managers)
SELECT lr.request_id, e.first_name, e.last_name, lt.leave_name, 
       lr.start_date, lr.end_date, lr.days_requested, lr.created_at 
FROM leave_requests lr
JOIN employees e ON lr.employee_id = e.employee_id
JOIN leave_types lt ON lr.leave_type_id = lt.leave_type_id
WHERE lr.status = 'pending' AND e.admin_id = 2;

-- READ: Get leave request by ID
SELECT * FROM leave_requests WHERE request_id = 1;

-- UPDATE: Approve leave request
UPDATE leave_requests 
SET status = 'approved', approved_by = 3, updated_at = NOW() 
WHERE request_id = 101;

-- UPDATE: Reject leave request
UPDATE leave_requests 
SET status = 'rejected', approved_by = 3, updated_at = NOW() 
WHERE request_id = 102;

-- DELETE: Remove leave request
DELETE FROM leave_requests WHERE request_id = 151;

-- =====================================================
-- CRUD Operations: Attendance Records Table
-- =====================================================

-- CREATE: Insert attendance record (clock in)
INSERT INTO attendance_records (employee_id, attendance_date, clock_in, status, hours_worked) 
VALUES (1, '2024-12-06', '09:00:00', 'present', 8.0);

-- CREATE: Update with clock out
UPDATE attendance_records 
SET clock_out = '17:00:00', hours_worked = 8.0, updated_at = NOW() 
WHERE employee_id = 1 AND attendance_date = '2024-12-06';

-- READ: Get attendance for an employee in a month
SELECT attendance_date, clock_in, clock_out, status, hours_worked 
FROM attendance_records 
WHERE employee_id = 1 
  AND attendance_date BETWEEN '2024-12-01' AND '2024-12-31' 
ORDER BY attendance_date;

-- READ: Get attendance record by ID
SELECT * FROM attendance_records WHERE attendance_id = 1;

-- UPDATE: Update attendance record (e.g., correct time)
UPDATE attendance_records 
SET clock_out = '17:30:00', hours_worked = 8.5, updated_at = NOW() 
WHERE attendance_id = 201;

-- DELETE: Remove attendance record
DELETE FROM attendance_records WHERE attendance_id = 251;

-- =====================================================
-- CRUD Operations: Pay Components Table
-- =====================================================

-- CREATE: Insert new pay component
INSERT INTO pay_components (admin_id, component_name, component_type, is_taxable, is_fixed) 
VALUES (2, 'Travel Allowance', 'earning', TRUE, FALSE);

-- READ: Get all pay components for an admin
SELECT component_id, component_name, component_type, is_taxable, is_fixed, created_at 
FROM pay_components 
WHERE admin_id = 2 
ORDER BY component_type, component_name;

-- READ: Get pay component by ID
SELECT * FROM pay_components WHERE component_id = 1;

-- UPDATE: Update pay component
UPDATE pay_components 
SET component_name = 'Travel Reimbursement', updated_at = NOW() 
WHERE component_id = 41;

-- DELETE: Remove pay component
DELETE FROM pay_components WHERE component_id = 41;

-- =====================================================
-- CRUD Operations: Salary Templates Table
-- =====================================================

-- CREATE: Insert new salary template
INSERT INTO salary_templates (admin_id, template_name, grade_level, base_salary) 
VALUES (2, 'Principal Engineer', 'L5', 120000.00);

-- READ: Get all salary templates for an admin
SELECT template_id, template_name, grade_level, base_salary, created_at 
FROM salary_templates 
WHERE admin_id = 2 
ORDER BY base_salary;

-- READ: Get salary template by ID
SELECT * FROM salary_templates WHERE template_id = 1;

-- UPDATE: Update salary template
UPDATE salary_templates 
SET base_salary = 125000.00, updated_at = NOW() 
WHERE template_id = 22;

-- DELETE: Remove salary template
DELETE FROM salary_templates WHERE template_id = 22;

-- =====================================================
-- CRUD Operations: Employee Salaries Table
-- =====================================================

-- CREATE: Assign salary template to employee
INSERT INTO employee_salaries (employee_id, template_id, effective_date, is_active) 
VALUES (51, 2, '2024-12-06', TRUE);

-- READ: Get current salary for an employee
SELECT es.salary_id, st.template_name, st.grade_level, st.base_salary, es.effective_date 
FROM employee_salaries es
JOIN salary_templates st ON es.template_id = st.template_id
WHERE es.employee_id = 1 AND es.is_active = TRUE;

-- READ: Get salary history for an employee
SELECT es.salary_id, st.template_name, st.grade_level, st.base_salary, 
       es.effective_date, es.is_active 
FROM employee_salaries es
JOIN salary_templates st ON es.template_id = st.template_id
WHERE es.employee_id = 1 
ORDER BY es.effective_date DESC;

-- READ: Get employee salary by ID
SELECT * FROM employee_salaries WHERE salary_id = 1;

-- UPDATE: Update salary assignment
UPDATE employee_salaries 
SET template_id = 3, effective_date = '2024-12-06', updated_at = NOW() 
WHERE salary_id = 41;

-- DELETE: Remove salary assignment (deactivate)
UPDATE employee_salaries 
SET is_active = FALSE, updated_at = NOW() 
WHERE salary_id = 41;

-- =====================================================
-- CRUD Operations: Bonus Records Table
-- =====================================================

-- CREATE: Record bonus payment
INSERT INTO bonus_records (employee_id, component_id, amount, bonus_date, description) 
VALUES (1, 9, 3000.00, '2024-12-06', 'Project Completion Bonus');

-- READ: Get all bonuses for an employee
SELECT br.bonus_id, pc.component_name, br.amount, br.bonus_date, br.description, br.created_at 
FROM bonus_records br
JOIN pay_components pc ON br.component_id = pc.component_id
WHERE br.employee_id = 1 
ORDER BY br.bonus_date DESC;

-- READ: Get bonus record by ID
SELECT * FROM bonus_records WHERE bonus_id = 1;

-- UPDATE: Update bonus record
UPDATE bonus_records 
SET amount = 3500.00, description = 'Project Completion Bonus - Updated', updated_at = NOW() 
WHERE bonus_id = 41;

-- DELETE: Remove bonus record
DELETE FROM bonus_records WHERE bonus_id = 41;

-- =====================================================
-- CRUD Operations: Admin Settings Table
-- =====================================================

-- CREATE: Insert new admin setting
INSERT INTO admin_settings (admin_id, setting_key, setting_value) 
VALUES (2, 'leave_notification_email', 'true');

-- READ: Get all settings for an admin
SELECT setting_id, setting_key, setting_value, created_at 
FROM admin_settings 
WHERE admin_id = 2 
ORDER BY setting_key;

-- READ: Get specific setting
SELECT setting_value 
FROM admin_settings 
WHERE admin_id = 2 AND setting_key = 'working_hours_start';

-- READ: Get admin setting by ID
SELECT * FROM admin_settings WHERE setting_id = 1;

-- UPDATE: Update admin setting
UPDATE admin_settings 
SET setting_value = 'false', updated_at = NOW() 
WHERE setting_id = 21;

-- DELETE: Remove admin setting
DELETE FROM admin_settings WHERE setting_id = 21;

COMMIT;
