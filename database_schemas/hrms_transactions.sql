-- Multi-Tenant Human Resources Management System (HRMS)
-- Transaction Demonstrations
-- Employee Onboarding Process with COMMIT and ROLLBACK
-- Created: December 6, 2025

USE hrms_db;

-- =====================================================
-- Transaction 1: Successful Employee Onboarding
-- =====================================================

-- Start transaction for employee onboarding
START TRANSACTION;

-- Step 1: Insert new employee
INSERT INTO employees (admin_id, department_id, first_name, last_name, email, phone, hire_date, position, salary_grade, is_active) 
VALUES (2, 1, 'Sarah', 'Mitchell', 'sarah.mitchell@techsolutions.com', '+1-555-1020', '2024-12-06', 'Software Developer', 'L2', TRUE);

-- Get the new employee ID
SET @new_employee_id = LAST_INSERT_ID();

-- Step 2: Record the hire action
INSERT INTO employee_actions (employee_id, action_type, action_date, description) 
VALUES (@new_employee_id, 'hire', '2024-12-06', 'Initial hiring as Software Developer');

-- Step 3: Assign salary template
INSERT INTO employee_salaries (employee_id, template_id, effective_date, is_active) 
VALUES (@new_employee_id, 2, '2024-12-06', TRUE);

-- Step 4: Initialize leave balances for the new employee
INSERT INTO leave_balances (employee_id, leave_type_id, balance_days, used_days, year) VALUES
(@new_employee_id, 1, 0.0, 0.0, 2024),  -- Annual Leave
(@new_employee_id, 2, 0.0, 0.0, 2024),  -- Sick Leave
(@new_employee_id, 3, 0.0, 0.0, 2024);  -- Personal Leave

-- Step 5: Create initial attendance record for today
INSERT INTO attendance_records (employee_id, attendance_date, clock_in, status, hours_worked) 
VALUES (@new_employee_id, '2024-12-06', '09:00:00', 'present', 8.0);

-- If all steps succeed, commit the transaction
COMMIT;

SELECT 'Employee onboarding completed successfully!' AS result;

-- =====================================================
-- Transaction 2: Failed Onboarding with ROLLBACK
-- =====================================================

-- Start transaction for another employee onboarding
START TRANSACTION;

-- Step 1: Insert new employee
INSERT INTO employees (admin_id, department_id, first_name, last_name, email, phone, hire_date, position, salary_grade, is_active) 
VALUES (2, 1, 'Mike', 'Johnson', 'mike.johnson@techsolutions.com', '+1-555-1021', '2024-12-06', 'Senior Developer', 'L3', TRUE);

-- Get the new employee ID
SET @failed_employee_id = LAST_INSERT_ID();

-- Step 2: Record the hire action
INSERT INTO employee_actions (employee_id, action_type, action_date, description) 
VALUES (@failed_employee_id, 'hire', '2024-12-06', 'Initial hiring as Senior Developer');

-- Step 3: Try to assign a non-existent salary template (this will fail)
INSERT INTO employee_salaries (employee_id, template_id, effective_date, is_active) 
VALUES (@failed_employee_id, 999, '2024-12-06', TRUE);  -- This template_id doesn't exist

-- If we reach this point, all steps succeeded, but in a real scenario with error checking:
-- Since the above INSERT would fail due to foreign key constraint, we would rollback
-- For demonstration, we'll force a rollback condition

-- Check if the transaction should be rolled back (simulate error condition)
SET @error_occurred = 1;  -- In real code, this would be set based on actual error checking

-- If an error occurred, rollback the entire transaction
IF @error_occurred = 1 THEN
    ROLLBACK;
    SELECT 'Employee onboarding failed and was rolled back!' AS result;
ELSE
    -- Step 4: Initialize leave balances (only if no error)
    INSERT INTO leave_balances (employee_id, leave_type_id, balance_days, used_days, year) VALUES
    (@failed_employee_id, 1, 0.0, 0.0, 2024),
    (@failed_employee_id, 2, 0.0, 0.0, 2024),
    (@failed_employee_id, 3, 0.0, 0.0, 2024);
    
    COMMIT;
    SELECT 'Employee onboarding completed successfully!' AS result;
END IF;

-- =====================================================
-- Transaction 3: Leave Request Approval Process
-- =====================================================

-- Start transaction for leave approval
START TRANSACTION;

-- Step 1: Get a pending leave request
SELECT lr.request_id, lr.employee_id, lr.days_requested, lb.balance_id, lb.balance_days, lb.used_days
INTO @request_id, @emp_id, @requested_days, @balance_id, @current_balance, @used_days
FROM leave_requests lr
JOIN leave_balances lb ON lr.employee_id = lb.employee_id AND lr.leave_type_id = lb.leave_type_id
WHERE lr.status = 'pending' AND lr.request_id = 101;  -- Using a specific request ID

-- Step 2: Check if employee has sufficient leave balance
SET @sufficient_balance = CASE WHEN (@current_balance - @used_days) >= @requested_days THEN 1 ELSE 0 END;

-- If sufficient balance, approve the request
IF @sufficient_balance = 1 THEN
    -- Update leave request status
    UPDATE leave_requests 
    SET status = 'approved', approved_by = 3, updated_at = NOW() 
    WHERE request_id = @request_id;
    
    -- Update leave balance
    UPDATE leave_balances 
    SET used_days = used_days + @requested_days, updated_at = NOW() 
    WHERE balance_id = @balance_id;
    
    -- Record the approval action
    INSERT INTO employee_actions (employee_id, action_type, action_date, description) 
    VALUES (@emp_id, 'leave_approved', CURDATE(), CONCAT('Leave request approved for ', @requested_days, ' days'));
    
    COMMIT;
    SELECT 'Leave request approved successfully!' AS result;
ELSE
    -- Reject the request due to insufficient balance
    UPDATE leave_requests 
    SET status = 'rejected', approved_by = 3, updated_at = NOW() 
    WHERE request_id = @request_id;
    
    -- Record the rejection action
    INSERT INTO employee_actions (employee_id, action_type, action_date, description) 
    VALUES (@emp_id, 'leave_rejected', CURDATE(), CONCAT('Leave request rejected - insufficient balance. Requested: ', @requested_days, ' days, Available: ', (@current_balance - @used_days)));
    
    COMMIT;
    SELECT 'Leave request rejected due to insufficient balance!' AS result;
END IF;

-- =====================================================
-- Transaction 4: Salary Update with Audit Trail
-- =====================================================

-- Start transaction for salary update
START TRANSACTION;

-- Step 1: Get current salary information
SELECT es.salary_id, es.employee_id, st.template_name, st.base_salary, e.first_name, e.last_name
INTO @salary_id, @emp_id_salary, @current_template, @current_salary, @first_name, @last_name
FROM employee_salaries es
JOIN salary_templates st ON es.template_id = st.template_id
JOIN employees e ON es.employee_id = e.employee_id
WHERE es.employee_id = 1 AND es.is_active = TRUE;

-- Step 2: Deactivate current salary record
UPDATE employee_salaries 
SET is_active = FALSE, updated_at = NOW() 
WHERE salary_id = @salary_id;

-- Step 3: Insert new salary record (promotion)
INSERT INTO employee_salaries (employee_id, template_id, effective_date, is_active) 
VALUES (@emp_id_salary, 3, '2024-12-01', TRUE);  -- Template 3 is Senior Engineer

-- Step 4: Record the salary change action
INSERT INTO employee_actions (employee_id, action_type, action_date, description) 
VALUES (@emp_id_salary, 'salary_change', '2024-12-01', 
        CONCAT('Salary updated from ', @current_template, ' ($', @current_salary, ') to Senior Engineer'));

-- Step 5: Add performance bonus for the promotion
INSERT INTO bonus_records (employee_id, component_id, amount, bonus_date, description) 
VALUES (@emp_id_salary, 9, 2000.00, '2024-12-01', 'Promotion Bonus');

-- If all steps succeed, commit the transaction
COMMIT;

SELECT CONCAT('Salary update completed for ', @first_name, ' ', @last_name) AS result;

-- =====================================================
-- Transaction 5: Bulk Attendance Update with Error Handling
-- =====================================================

-- Start transaction for bulk attendance update
START TRANSACTION;

-- Step 1: Create a temporary table to store attendance updates
CREATE TEMPORARY TABLE temp_attendance_updates (
    employee_id INT,
    attendance_date DATE,
    clock_in TIME,
    clock_out TIME,
    status ENUM('present', 'absent', 'late', 'half_day'),
    hours_worked DECIMAL(5,2)
);

-- Step 2: Insert bulk attendance data
INSERT INTO temp_attendance_updates VALUES
(1, '2024-12-07', '09:00:00', '17:00:00', 'present', 8.0),
(2, '2024-12-07', '09:15:00', '17:15:00', 'present', 8.0),
(3, '2024-12-07', '08:45:00', '16:45:00', 'present', 8.0),
(4, '2024-12-07', NULL, NULL, 'absent', 0.0),  -- Employee absent
(5, '2024-12-07', '09:30:00', '17:30:00', 'late', 8.0);

-- Step 3: Validate data (check for duplicate entries)
SET @duplicate_count = (
    SELECT COUNT(*) 
    FROM temp_attendance_updates tau
    JOIN attendance_records ar ON tau.employee_id = ar.employee_id 
                               AND tau.attendance_date = ar.attendance_date
);

-- If duplicates exist, rollback
IF @duplicate_count > 0 THEN
    ROLLBACK;
    SELECT 'Bulk attendance update failed due to duplicate entries!' AS result;
ELSE
    -- Step 4: Insert valid attendance records
    INSERT INTO attendance_records (employee_id, attendance_date, clock_in, clock_out, status, hours_worked)
    SELECT employee_id, attendance_date, clock_in, clock_out, status, hours_worked
    FROM temp_attendance_updates;
    
    -- Step 5: Clean up temporary table
    DROP TEMPORARY TABLE temp_attendance_updates;
    
    COMMIT;
    SELECT 'Bulk attendance update completed successfully!' AS result;
END IF;

-- =====================================================
-- Transaction 6: Employee Termination Process
-- =====================================================

-- Start transaction for employee termination
START TRANSACTION;

-- Step 1: Get employee information
SET @terminate_employee_id = 50;  -- Employee to terminate

SELECT first_name, last_name INTO @term_first_name, @term_last_name
FROM employees 
WHERE employee_id = @terminate_employee_id;

-- Step 2: Record termination action
INSERT INTO employee_actions (employee_id, action_type, action_date, description) 
VALUES (@terminate_employee_id, 'termination', CURDATE(), 'Employee termination - End of employment');

-- Step 3: Deactivate employee (soft delete)
UPDATE employees 
SET is_active = FALSE, updated_at = NOW() 
WHERE employee_id = @terminate_employee_id;

-- Step 4: Deactivate current salary
UPDATE employee_salaries 
SET is_active = FALSE, updated_at = NOW() 
WHERE employee_id = @terminate_employee_id AND is_active = TRUE;

-- Step 5: Finalize any pending leave requests
UPDATE leave_requests 
SET status = 'cancelled', updated_at = NOW() 
WHERE employee_id = @terminate_employee_id AND status = 'pending';

-- Step 6: Record final attendance if needed
INSERT INTO attendance_records (employee_id, attendance_date, status, hours_worked) 
VALUES (@terminate_employee_id, CURDATE(), 'terminated', 0.0);

-- If all steps succeed, commit the transaction
COMMIT;

SELECT CONCAT('Employee termination completed for ', @term_first_name, ' ', @term_last_name) AS result;

-- =====================================================
-- Transaction Isolation Level Demonstration
-- =====================================================

-- Set transaction isolation level to demonstrate consistency
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

START TRANSACTION;

-- This transaction will see a consistent view of the data
-- even if other transactions modify data during execution
SELECT COUNT(*) AS employee_count_before FROM employees WHERE admin_id = 2 AND is_active = TRUE;

-- Simulate some processing time
DO SLEEP(2);

SELECT COUNT(*) AS employee_count_after FROM employees WHERE admin_id = 2 AND is_active = TRUE;

COMMIT;

-- =====================================================
-- Savepoint Demonstration
-- =====================================================

START TRANSACTION;

-- Step 1: Insert new department
INSERT INTO departments (admin_id, department_name, department_head) 
VALUES (2, 'Quality Assurance', 'Jane Doe');

-- Create a savepoint
SAVEPOINT after_department_insert;

-- Step 2: Try to add employees to the new department
INSERT INTO employees (admin_id, department_id, first_name, last_name, email, phone, hire_date, position, salary_grade, is_active) 
VALUES (2, LAST_INSERT_ID(), 'Test', 'User', 'test@example.com', '555-0000', CURDATE(), 'QA Tester', 'L1', TRUE);

-- If something goes wrong, rollback to savepoint
-- For demonstration, we'll assume success and commit
COMMIT;

SELECT 'Transaction with savepoint completed successfully!' AS result;

-- =====================================================
-- Deadlock Prevention Example
-- =====================================================

Transaction A (run this first in one session)
START TRANSACTION;
UPDATE employees SET position = 'Updated Position A' WHERE employee_id = 1;
DO SLEEP(5);  -- Wait for Transaction B to lock the other resource
UPDATE departments SET department_head = 'Updated Head A' WHERE department_id = 1;
COMMIT;

Transaction B (run this simultaneously in another session)
START TRANSACTION;
UPDATE departments SET department_head = 'Updated Head B' WHERE department_id = 1;
DO SLEEP(5);  -- Wait for Transaction A
UPDATE employees SET position = 'Updated Position B' WHERE employee_id = 1;
COMMIT;

-- To prevent deadlocks, always access resources in the same order:
-- 1. departments table first, then employees table

COMMIT;
