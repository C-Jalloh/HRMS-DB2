-- HRMS Database Migration Script (v1 to v2)
-- Implements Phase 1-4 Improvements
-- Created: December 27, 2025

USE hrms_db;
START TRANSACTION;

-- =====================================================
-- Phase 4: Scalability (Admin Profiles)
-- =====================================================
CREATE TABLE IF NOT EXISTS admin_profiles (
    profile_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    full_name VARCHAR(100),
    contact_number VARCHAR(20),
    profile_image VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON UPDATE CASCADE ON DELETE CASCADE,
    UNIQUE KEY unique_user_profile (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- Phase 3: Robustness (Soft Deletes & Currency)
-- =====================================================

-- Update companies
ALTER TABLE companies ADD COLUMN IF NOT EXISTS currency_code VARCHAR(3) DEFAULT 'USD' AFTER industry;
ALTER TABLE companies ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMP NULL DEFAULT NULL;

-- Update departments
ALTER TABLE departments ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMP NULL DEFAULT NULL;

-- Update employees
ALTER TABLE employees ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMP NULL DEFAULT NULL;

-- Update leave_requests
ALTER TABLE leave_requests ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMP NULL DEFAULT NULL;

-- Create leave_accrual_logs
CREATE TABLE IF NOT EXISTS leave_accrual_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    leave_type_id INT NOT NULL,
    amount_added DECIMAL(5,2) NOT NULL,
    accrual_date DATE NOT NULL,
    reason VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (leave_type_id) REFERENCES leave_types(leave_type_id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- Phase 1: Data Integrity & History
-- =====================================================

-- Remove redundant salary_grade from employees
ALTER TABLE employees DROP COLUMN IF EXISTS salary_grade;

-- Add end_date to employee_salaries
ALTER TABLE employee_salaries ADD COLUMN IF NOT EXISTS end_date DATE DEFAULT NULL AFTER effective_date;

-- Create job_history table
CREATE TABLE IF NOT EXISTS job_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    department_id INT,
    position VARCHAR(100),
    start_date DATE NOT NULL,
    end_date DATE DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- Phase 2: Multi-Tenant Security Views
-- =====================================================

-- View for Employees
CREATE OR REPLACE VIEW vw_employees AS
SELECT * FROM employees 
WHERE (admin_id = @current_admin_id OR @current_admin_id IS NULL)
AND deleted_at IS NULL;

-- View for Departments
CREATE OR REPLACE VIEW vw_departments AS
SELECT * FROM departments 
WHERE (admin_id = @current_admin_id OR @current_admin_id IS NULL)
AND deleted_at IS NULL;

-- View for Leave Requests
CREATE OR REPLACE VIEW vw_leave_requests AS
SELECT lr.* FROM leave_requests lr
JOIN employees e ON lr.employee_id = e.employee_id
WHERE (e.admin_id = @current_admin_id OR @current_admin_id IS NULL)
AND lr.deleted_at IS NULL;

-- View for Attendance
CREATE OR REPLACE VIEW vw_attendance AS
SELECT ar.* FROM attendance_records ar
JOIN employees e ON ar.employee_id = e.employee_id
WHERE (e.admin_id = @current_admin_id OR @current_admin_id IS NULL);

COMMIT;
