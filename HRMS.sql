-- Multi-Tenant Human Resources Management System (HRMS) - Master Submission Script
-- Course: Database Systems II
-- Project Submission Date: January 11, 2026

-- =====================================================
-- 1. DATABASE SCHEMA & STRUCTURE
-- =====================================================
-- Multi-Tenant Human Resources Management System (HRMS)
-- Database Schema
-- Created: December 6, 2025

-- Create database
CREATE DATABASE IF NOT EXISTS hrms_db;
USE hrms_db;

-- Set SQL mode and character set
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";
SET NAMES utf8mb4;

-- =====================================================
-- Table: users (Superadmin and admin accounts)
-- =====================================================
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('superadmin', 'admin') NOT NULL DEFAULT 'admin',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- Table: admin_profiles (Phase 4: Scalability)
-- =====================================================
CREATE TABLE admin_profiles (
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
-- Table: companies (Organization profiles)
-- =====================================================
CREATE TABLE companies (
    company_id INT AUTO_INCREMENT PRIMARY KEY,
    admin_id INT NOT NULL,
    company_name VARCHAR(100) NOT NULL,
    company_address TEXT,
    phone VARCHAR(20),
    email VARCHAR(100),
    industry VARCHAR(50),
    currency_code VARCHAR(3) DEFAULT 'GMD', -- Phase 3: Internationalization
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL, -- Phase 3: Soft Deletes
    FOREIGN KEY (admin_id) REFERENCES users(user_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    UNIQUE KEY unique_admin_company (admin_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- Table: departments (Department structure)
-- =====================================================
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    admin_id INT NOT NULL,
    department_name VARCHAR(100) NOT NULL,
    department_head VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL, -- Phase 3: Soft Deletes
    FOREIGN KEY (admin_id) REFERENCES users(user_id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- Table: employees (Employee information)
-- =====================================================
CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    admin_id INT NOT NULL,
    department_id INT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    hire_date DATE NOT NULL,
    position VARCHAR(100),
    salary_grade VARCHAR(10),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL, -- Phase 3: Soft Deletes
    FOREIGN KEY (admin_id) REFERENCES users(user_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- Table: employee_actions (Employee lifecycle events)
-- =====================================================
CREATE TABLE employee_actions (
    action_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    action_type ENUM('hire', 'promotion', 'transfer', 'termination') NOT NULL,
    action_date DATE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- Table: job_history (Phase 1: Historical Tracking)
-- =====================================================
CREATE TABLE job_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    department_id INT,
    position VARCHAR(100),
    employee_start_date DATE NOT NULL,
    end_date DATE DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- Table: leave_types (Leave categories)
-- =====================================================
CREATE TABLE leave_types (
    leave_type_id INT AUTO_INCREMENT PRIMARY KEY,
    admin_id INT NOT NULL,
    leave_name VARCHAR(50) NOT NULL,
    is_paid BOOLEAN DEFAULT TRUE,
    max_days_per_year INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (admin_id) REFERENCES users(user_id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- Table: leave_policies (Company leave policies)
-- =====================================================
CREATE TABLE leave_policies (
    policy_id INT AUTO_INCREMENT PRIMARY KEY,
    admin_id INT NOT NULL,
    leave_type_id INT NOT NULL,
    accrual_rate DECIMAL(5,2) DEFAULT 0.00,
    max_carryover INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (admin_id) REFERENCES users(user_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (leave_type_id) REFERENCES leave_types(leave_type_id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- Table: leave_balances (Employee leave balances)
-- =====================================================
CREATE TABLE leave_balances (
    balance_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    leave_type_id INT NOT NULL,
    balance_days DECIMAL(5,2) DEFAULT 0.00 CHECK (balance_days >= 0),
    used_days DECIMAL(5,2) DEFAULT 0.00,
    balance_year YEAR NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (leave_type_id) REFERENCES leave_types(leave_type_id) ON UPDATE CASCADE ON DELETE CASCADE,
    UNIQUE KEY unique_employee_leave_year (employee_id, leave_type_id, year)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- Table: leave_accrual_logs (Phase 3: Robustness)
-- =====================================================
CREATE TABLE leave_accrual_logs (
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
-- Table: leave_requests (Leave applications)
-- =====================================================
CREATE TABLE leave_requests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    leave_type_id INT NOT NULL,
    request_start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    days_requested DECIMAL(5,2) NOT NULL,
    request_status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    approved_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL, -- Phase 3: Soft Deletes
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (leave_type_id) REFERENCES leave_types(leave_type_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (approved_by) REFERENCES users(user_id) ON UPDATE CASCADE ON DELETE SET NULL,
    CHECK (start_date <= end_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- Table: attendance_records (Daily attendance)
-- =====================================================
CREATE TABLE attendance_records (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    clock_in TIME,
    clock_out TIME,
    status ENUM('present', 'absent', 'late', 'half_day') DEFAULT 'present',
    hours_worked DECIMAL(5,2) DEFAULT 0.00 CHECK (hours_worked >= 0 AND hours_worked <= 24),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON UPDATE CASCADE ON DELETE CASCADE,
    UNIQUE KEY unique_employee_date (employee_id, attendance_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- Table: pay_components (Salary components)
-- =====================================================
CREATE TABLE pay_components (
    component_id INT AUTO_INCREMENT PRIMARY KEY,
    admin_id INT NOT NULL,
    component_name VARCHAR(100) NOT NULL,
    component_type ENUM('earning', 'deduction') NOT NULL,
    is_taxable BOOLEAN DEFAULT TRUE,
    is_fixed BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (admin_id) REFERENCES users(user_id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- Table: salary_templates (Salary structures)
-- =====================================================
CREATE TABLE salary_templates (
    template_id INT AUTO_INCREMENT PRIMARY KEY,
    admin_id INT NOT NULL,
    template_name VARCHAR(100) NOT NULL,
    grade_level VARCHAR(20),
    base_salary DECIMAL(12,2) NOT NULL CHECK (base_salary >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (admin_id) REFERENCES users(user_id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- Table: employee_salaries (Employee salary assignments)
-- =====================================================
CREATE TABLE employee_salaries (
    salary_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    template_id INT NOT NULL,
    effective_date DATE NOT NULL,
    end_date DATE DEFAULT NULL, -- Phase 1: Historical Tracking
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (template_id) REFERENCES salary_templates(template_id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- Table: bonus_records (Bonuses and deductions)
-- =====================================================
CREATE TABLE bonus_records (
    bonus_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    component_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL CHECK (amount >= 0),
    bonus_date DATE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (component_id) REFERENCES pay_components(component_id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- Table: admin_settings (Admin preferences)
-- =====================================================
CREATE TABLE admin_settings (
    setting_id INT AUTO_INCREMENT PRIMARY KEY,
    admin_id INT NOT NULL,
    setting_key VARCHAR(100) NOT NULL,
    setting_value TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (admin_id) REFERENCES users(user_id) ON UPDATE CASCADE ON DELETE CASCADE,
    UNIQUE KEY unique_admin_setting (admin_id, setting_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- Indexes for Performance Optimization
-- =====================================================

-- -----------------------------------------------------
-- Index explanation and impact:
-- 1. idx_employees_admin_hire: Optimizes tenant-specific employee filtering. 
--    Reduces search space for HR reports filtered by organization.
-- 2. idx_attendance_employee_date: Dramatically speeds up monthly attendance 
--    lookups by employee ID. Essential for payroll and monthly summaries.
-- 3. idx_leave_balances_employee_year: Ensures fast retrieval of leave stats 
--    for dashboard and entitlement checks.
-- -----------------------------------------------------

-- Composite index for tenant-specific employee queries
CREATE INDEX idx_employees_admin_hire ON employees(admin_id, hire_date);

-- Composite index for attendance queries
CREATE INDEX idx_attendance_employee_date ON attendance_records(employee_id, attendance_date);

-- Index for leave balance queries
CREATE INDEX idx_leave_balances_employee_year ON leave_balances(employee_id, year);

-- Index for leave request queries
CREATE INDEX idx_leave_requests_employee_status ON leave_requests(employee_id, status);

-- Index for bonus records queries
CREATE INDEX idx_bonus_records_employee_date ON bonus_records(employee_id, bonus_date);

-- =====================================================
-- Phase 2: Multi-Tenant Security Views
-- =====================================================

-- View for Employees (Filters by session admin_id and excludes soft-deleted)
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

-- =====================================================
-- 2. SAMPLE DATA (Minimum 10 records per table)
-- =====================================================
-- Multi-Tenant Human Resources Management System (HRMS)
-- Sample Data (Minimum 10 records per table)
-- Created: December 6, 2025

USE hrms_db;

-- =====================================================
-- Sample Data: Users (Superadmin and Admins)
-- =====================================================
INSERT INTO users (username, password_hash, role, is_active) VALUES
('superadmin', '$2b$10$hashedpassword1', 'superadmin', TRUE),
('admin_company_a', '$2b$10$hashedpassword2', 'admin', TRUE),
('admin_company_b', '$2b$10$hashedpassword3', 'admin', TRUE),
('admin_company_c', '$2b$10$hashedpassword4', 'admin', TRUE),
('admin_company_d', '$2b$10$hashedpassword5', 'admin', TRUE),
('admin_company_e', '$2b$10$hashedpassword6', 'admin', TRUE),
('admin_company_f', '$2b$10$hashedpassword7', 'admin', TRUE),
('admin_company_g', '$2b$10$hashedpassword8', 'admin', TRUE),
('admin_company_h', '$2b$10$hashedpassword9', 'admin', TRUE),
('admin_company_i', '$2b$10$hashedpassword10', 'admin', TRUE),

-- =====================================================
-- Sample Data: Companies
-- =====================================================
INSERT INTO companies (admin_id, company_name, address, phone, email, industry) VALUES
(2, 'Tech Solutions Inc.', '123 Tech Street, Silicon Valley, CA', '+1-555-0101', 'info@techsolutions.com', 'Technology'),
(3, 'Global Manufacturing Ltd.', '456 Industrial Ave, Detroit, MI', '+1-555-0102', 'hr@globalmfg.com', 'Manufacturing'),
(4, 'Healthcare Plus', '789 Medical Center, Boston, MA', '+1-555-0103', 'admin@healthcareplus.com', 'Healthcare'),
(5, 'Retail Chain Corp.', '321 Commerce Blvd, New York, NY', '+1-555-0104', 'operations@retailchain.com', 'Retail'),
(6, 'Financial Services Group', '654 Finance Plaza, Chicago, IL', '+1-555-0105', 'hr@finservices.com', 'Finance'),
(7, 'Education Institute', '987 Learning Lane, Austin, TX', '+1-555-0106', 'admin@eduinstitute.com', 'Education'),
(8, 'Construction Builders', '147 Builder Road, Denver, CO', '+1-555-0107', 'management@construct.com', 'Construction'),
(9, 'Media Entertainment Co.', '258 Media Drive, Los Angeles, CA', '+1-555-0108', 'hr@mediaent.com', 'Media'),
(10, 'Food Services Inc.', '369 Culinary Street, Miami, FL', '+1-555-0109', 'admin@foodservices.com', 'Food Service'),
(11, 'Transportation LLC', '741 Transit Way, Seattle, WA', '+1-555-0110', 'operations@transport.com', 'Transportation'),

-- =====================================================
-- Sample Data: Departments
-- =====================================================
INSERT INTO departments (admin_id, department_name, department_head) VALUES
(2, 'Engineering', 'John Smith'),
(2, 'Human Resources', 'Sarah Johnson'),
(2, 'Finance', 'Mike Davis'),
(2, 'Marketing', 'Lisa Wilson'),
(2, 'Operations', 'Tom Brown'),
(3, 'Production', 'Robert Miller'),
(3, 'Quality Control', 'Jennifer Garcia'),
(3, 'Maintenance', 'David Rodriguez'),
(3, 'Supply Chain', 'Maria Martinez'),
(3, 'Safety', 'James Anderson');

-- =====================================================
-- Sample Data: Employees (Minimum 10 records per table)
-- =====================================================
INSERT INTO employees (admin_id, department_id, first_name, last_name, email, phone, hire_date, position, salary_grade, is_active) VALUES
-- Company A (Tech Solutions) - Admin ID 2
(2, 1, 'Alice', 'Johnson', 'alice.johnson@techsolutions.com', '+1-555-1001', '2023-01-15', 'Software Engineer', 'L2', TRUE),
(2, 2, 'Carol', 'Brown', 'carol.brown@techsolutions.com', '+1-555-1003', '2023-02-10', 'HR Manager', 'M1', TRUE),
(2, 3, 'David', 'Jones', 'david.jones@techsolutions.com', '+1-555-1004', '2023-04-05', 'Financial Analyst', 'L3', TRUE),
(2, 4, 'Eva', 'Garcia', 'eva.garcia@techsolutions.com', '+1-555-1005', '2023-05-12', 'Marketing Specialist', 'L2', TRUE),
(2, 5, 'Frank', 'Miller', 'frank.miller@techsolutions.com', '+1-555-1006', '2023-06-18', 'Operations Manager', 'M2', TRUE),

INSERT INTO employees (admin_id, department_id, first_name, last_name, email, phone, hire_date, position, salary_grade, is_active) VALUES

-- Company B (Global Manufacturing) - Admin ID 3
(3, 6, 'Karen', 'Taylor', 'karen.taylor@globalmfg.com', '+1-555-2001', '2022-11-15', 'Production Supervisor', 'M1', TRUE),
(3, 7, 'Mia', 'Jackson', 'mia.jackson@globalmfg.com', '+1-555-2003', '2023-02-25', 'Quality Inspector', 'L2', TRUE),
(3, 8, 'Noah', 'White', 'noah.white@globalmfg.com', '+1-555-2004', '2023-03-30', 'Maintenance Technician', 'L2', TRUE),
(3, 9, 'Olivia', 'Harris', 'olivia.harris@globalmfg.com', '+1-555-2005', '2023-04-15', 'Supply Chain Analyst', 'L3', TRUE),
(3, 10, 'Peter', 'Clark', 'peter.clark@globalmfg.com', '+1-555-2006', '2023-05-20', 'Safety Officer', 'M1', TRUE),



-- Company C (Healthcare Plus) - Admin ID 4
INSERT INTO employees (admin_id, department_id, first_name, last_name, email, phone, hire_date, position, salary_grade, is_active) VALUES

(4, 11, 'Uma', 'Young', 'uma.young@healthcareplus.com', '+1-555-3001', '2023-01-10', 'Registered Nurse', 'L2', TRUE),
(4, 12, 'Wendy', 'Wright', 'wendy.wright@healthcareplus.com', '+1-555-3003', '2023-03-20', 'Administrative Assistant', 'L1', TRUE),
(4, 13, 'Xavier', 'Lopez', 'xavier.lopez@healthcareplus.com', '+1-555-3004', '2023-04-25', 'Pharmacist', 'L3', TRUE),
(4, 14, 'Yara', 'Hill', 'yara.hill@healthcareplus.com', '+1-555-3005', '2023-05-30', 'Medical Records Clerk', 'L1', TRUE),
(4, 15, 'Zane', 'Green', 'zane.green@healthcareplus.com', '+1-555-3006', '2023-06-15', 'Patient Services Rep', 'L2', TRUE),
-- Additional employees for other companies (20 more to reach 50+ total)
INSERT INTO employees (admin_id, department_id, first_name, last_name, email, phone, hire_date, position, salary_grade, is_active) VALUES

(5, 16, 'Emma', 'Carter', 'emma.carter@retailchain.com', '+1-555-4001', '2023-01-05', 'Sales Associate', 'L1', TRUE),
(5, 17, 'Felix', 'Mitchell', 'felix.mitchell@retailchain.com', '+1-555-4002', '2023-02-10', 'Customer Service Rep', 'L1', TRUE),
(6, 21, 'Gloria', 'Perez', 'gloria.perez@finservices.com', '+1-555-5001', '2023-03-15', 'Bank Teller', 'L1', TRUE),
(6, 22, 'Hugo', 'Roberts', 'hugo.roberts@finservices.com', '+1-555-5002', '2023-04-20', 'Loan Officer', 'L2', TRUE),
(7, 26, 'Iris', 'Turner', 'iris.turner@eduinstitute.com', '+1-555-6001', '2023-05-25', 'Teacher', 'L2', TRUE),
(7, 27, 'Jake', 'Phillips', 'jake.phillips@eduinstitute.com', '+1-555-6002', '2023-06-30', 'Counselor', 'L2', TRUE),
(8, 31, 'Kylie', 'Campbell', 'kylie.campbell@construct.com', '+1-555-7001', '2023-07-05', 'Project Coordinator', 'L2', TRUE),
(8, 32, 'Liam', 'Parker', 'liam.parker@construct.com', '+1-555-7002', '2023-08-10', 'Site Engineer', 'L3', TRUE),
(9, 36, 'Maya', 'Evans', 'maya.evans@mediaent.com', '+1-555-8001', '2023-09-15', 'Content Producer', 'L2', TRUE),
(9, 37, 'Nolan', 'Edwards', 'nolan.edwards@mediaent.com', '+1-555-8002', '2023-10-20', 'Broadcast Technician', 'L2', TRUE),
(10, 41, 'Owen', 'Collins', 'owen.collins@foodservices.com', '+1-555-9001', '2023-11-25', 'Chef', 'L2', TRUE),
(10, 42, 'Piper', 'Stewart', 'piper.stewart@foodservices.com', '+1-555-9002', '2023-12-30', 'Server', 'L1', TRUE),
(11, 46, 'Quincy', 'Sanchez', 'quincy.sanchez@transport.com', '+1-555-0101', '2024-01-05', 'Driver', 'L1', TRUE),
(11, 47, 'Riley', 'Morris', 'riley.morris@transport.com', '+1-555-0102', '2024-02-10', 'Dispatcher', 'L2', TRUE),
(12, 51, 'Sophie', 'Rogers', 'sophie.rogers@consulting.com', '+1-555-0201', '2024-03-15', 'Consultant', 'L3', TRUE),
(12, 52, 'Tyler', 'Reed', 'tyler.reed@consulting.com', '+1-555-0202', '2024-04-20', 'Senior Consultant', 'M1', TRUE),
(2, 1, 'Ursula', 'Cook', 'ursula.cook@techsolutions.com', '+1-555-1011', '2024-05-25', 'Data Analyst', 'L2', TRUE),
(3, 6, 'Vincent', 'Morgan', 'vincent.morgan@globalmfg.com', '+1-555-2011', '2024-06-30', 'Process Engineer', 'L3', TRUE),
(4, 11, 'Willow', 'Bell', 'willow.bell@healthcareplus.com', '+1-555-3011', '2024-07-05', 'Medical Assistant', 'L1', TRUE),
(5, 16, 'Xander', 'Murphy', 'xander.murphy@retailchain.com', '+1-555-4011', '2024-08-10', 'Store Manager', 'M1', TRUE);

-- =====================================================
-- Sample Data: Employee Actions
-- =====================================================
INSERT INTO employee_actions (employee_id, action_type, action_date, description) VALUES
(1, 'hire', '2023-01-15', 'Initial hiring as Software Engineer'),
(50, 'hire','2024-08-10', 'Initial hiring as Store Manager'),
(1, 'promotion', '2024-01-15', 'Promoted to Senior Software Engineer'),
(2, 'promotion', '2024-03-20', 'Promoted to Tech Lead'),

-- =====================================================
-- Sample Data: Leave Types
-- =====================================================
INSERT INTO leave_types (admin_id, leave_name, is_paid, max_days_per_year) VALUES
(2, 'Annual Leave', TRUE, 25),
(3, 'Compassionate Leave', TRUE, 5),
(4, 'Annual Leave', TRUE, 30),
(5, 'Emergency Leave', TRUE, 3),
(6, 'Annual Leave', TRUE, 25),
(7, 'Sabbatical', TRUE, 180),
(8, 'Annual Leave', TRUE, 20),
(9, 'Creative Leave', TRUE, 10),
(10, 'Annual Leave', TRUE, 15),
(11, 'Training Leave', TRUE, 5),
(12, 'Annual Leave', TRUE, 25),
-- =====================================================
-- Sample Data: Leave Policies
-- =====================================================
INSERT INTO leave_policies (admin_id, leave_type_id, accrual_rate, max_carryover) VALUES
(2, 1, 2.08, 5), -- Annual Leave: ~2 days per month, max carryover 5
(2, 2, 0.83, 0), -- Sick Leave: ~1 day per month, no carryover
(2, 3, 0.42, 0), -- Personal Leave: ~0.5 days per month, no carryover
(2, 4, 0.00, 0), -- Maternity Leave: granted as needed
(2, 5, 0.00, 0), -- Paternity Leave: granted as needed
(3, 6, 1.67, 3), -- Annual Leave: ~1.67 days per month
(3, 7, 1.00, 0), -- Sick Leave: 1 day per month
(3, 8, 0.25, 0), -- Personal Leave: 0.25 days per month
(3, 9, 0.00, 0), -- Maternity Leave: granted as needed
(3, 10, 0.00, 0), -- Compassionate Leave: granted as needed
(4, 11, 2.50, 10), -- Annual Leave: 2.5 days per month
(4, 12, 1.25, 0), -- Sick Leave: 1.25 days per month
(4, 13, 0.42, 0), -- Personal Leave: ~0.5 days per month
(4, 14, 0.00, 0), -- Maternity Leave: granted as needed
(4, 15, 0.00, 0), -- Study Leave: granted as needed
(5, 16, 1.25, 2), -- Annual Leave: 1.25 days per month
(5, 17, 0.67, 0), -- Sick Leave: ~0.67 days per month
(5, 18, 0.25, 0), -- Personal Leave: 0.25 days per month
(5, 19, 0.00, 0), -- Maternity Leave: granted as needed
(5, 20, 0.00, 0), -- Emergency Leave: granted as needed
(6, 21, 2.08, 5), -- Annual Leave: ~2 days per month
(6, 22, 0.83, 0), -- Sick Leave: ~1 day per month
(6, 23, 0.42, 0), -- Personal Leave: ~0.5 days per month
(6, 24, 0.00, 0), -- Maternity Leave: granted as needed
(6, 25, 0.00, 0), -- Professional Development: granted as needed
(7, 26, 3.33, 15), -- Annual Leave: ~3.33 days per month
(7, 27, 1.67, 0), -- Sick Leave: ~1.67 days per month
(7, 28, 0.83, 0), -- Personal Leave: ~1 day per month
(7, 29, 0.00, 0), -- Maternity Leave: granted as needed
(7, 30, 0.00, 0), -- Sabbatical: granted as needed
(8, 31, 1.67, 4), -- Annual Leave: ~1.67 days per month
(8, 32, 1.00, 0), -- Sick Leave: 1 day per month
(8, 33, 0.42, 0), -- Personal Leave: ~0.5 days per month
(8, 34, 0.00, 0), -- Maternity Leave: granted as needed
(8, 35, 0.00, 0), -- Injury Leave: granted as needed
(9, 36, 1.50, 3), -- Annual Leave: 1.5 days per month
(9, 37, 0.83, 0), -- Sick Leave: ~1 day per month
(9, 38, 0.33, 0), -- Personal Leave: ~0.33 days per month
(9, 39, 0.00, 0), -- Maternity Leave: granted as needed
(9, 40, 0.00, 0), -- Creative Leave: granted as needed
(10, 41, 1.25, 2), -- Annual Leave: 1.25 days per month
(10, 42, 0.67, 0), -- Sick Leave: ~0.67 days per month
(10, 43, 0.25, 0), -- Personal Leave: 0.25 days per month
(10, 44, 0.00, 0), -- Maternity Leave: granted as needed
(10, 45, 0.00, 0), -- Family Leave: granted as needed
(11, 46, 1.83, 4), -- Annual Leave: ~1.83 days per month
(11, 47, 1.00, 0), -- Sick Leave: 1 day per month
(11, 48, 0.33, 0), -- Personal Leave: ~0.33 days per month
(11, 49, 0.00, 0), -- Maternity Leave: granted as needed
(11, 50, 0.00, 0), -- Training Leave: granted as needed
(12, 51, 2.08, 5), -- Annual Leave: ~2 days per month
(12, 52, 0.83, 0), -- Sick Leave: ~1 day per month
(12, 53, 0.42, 0), -- Personal Leave: ~0.5 days per month
(12, 54, 0.00, 0), -- Maternity Leave: granted as needed
(12, 55, 0.00, 0); -- Conference Leave: granted as needed

-- =====================================================
-- Sample Data: Leave Balances (50+ records)
-- =====================================================
INSERT INTO leave_balances (employee_id, leave_type_id, balance_days, used_days, year) VALUES
(49, 11, 24.5, 5.5, 2024), (49, 12, 12.0, 3.0, 2024), (49, 13, 4.5, 0.5, 2024),
(50, 16, 12.5, 2.5, 2024), (50, 17, 6.8, 1.2, 2024), (50, 18, 2.8, 0.2, 2024);

-- =====================================================
-- Sample Data: Leave Requests (50+ records)
-- =====================================================
INSERT INTO leave_requests (employee_id, leave_type_id, start_date, end_date, days_requested, status, approved_by) VALUES
(1, 1, '2024-12-20', '2024-12-24', 5.0, 'approved', 3),
(1, 2, '2024-11-15', '2024-11-15', 1.0, 'approved', 3),

-- =====================================================
-- Sample Data: Attendance Records (200+ records for November-December 2024)
-- =====================================================
INSERT INTO attendance_records (employee_id, attendance_date, clock_in, clock_out, status, hours_worked) VALUES
-- Tech Solutions employees (Admin 2) - November 2024
(1, '2024-11-01', '09:00:00', '17:00:00', 'present', 8.0),
(1, '2024-11-02', '09:15:00', '17:30:00', 'present', 8.25),

-- Some absent/late records for variety
(1, '2024-11-15', NULL, NULL, 'absent', 0.0),
(2, '2024-11-18', '09:30:00', '17:30:00', 'late', 8.0),
-- Half day records
(1, '2024-11-29', '09:00:00', '13:00:00', 'half_day', 4.0),
(2, '2024-11-30', '09:00:00', '13:00:00', 'half_day', 4.0),
-- =====================================================
-- Sample Data: Pay Components
-- =====================================================
INSERT INTO pay_components (admin_id, component_name, component_type, is_taxable, is_fixed) VALUES
(2, 'Basic Salary', 'earning', TRUE, TRUE),
(2, 'House Rent Allowance', 'earning', TRUE, TRUE),
(3, 'Production Bonus', 'earning', TRUE, FALSE),
(3, 'Overtime Pay', 'earning', TRUE, FALSE),
(4, 'Basic Salary', 'earning', TRUE, TRUE),
(4, 'House Rent Allowance', 'earning', TRUE, TRUE),
(5, 'Sales Bonus', 'earning', TRUE, FALSE),
(5, 'Overtime Pay', 'earning', TRUE, FALSE);

-- =====================================================
-- Sample Data: Salary Templates
-- =====================================================
INSERT INTO salary_templates (admin_id, template_name, grade_level, base_salary) VALUES
(2, 'Entry Level Engineer', 'L1', 30000.00),
(2, 'Junior Engineer', 'L2', 45000.00),
(3, 'Production Manager', 'M1', 65000.00),
(3, 'Plant Manager', 'M2', 85000.00),
(4, 'Staff Nurse', 'L1', 35000.00),
(4, 'Senior Nurse', 'L2', 45000.00),
(5, 'Store Manager', 'M1', 65000.00),
(5, 'Regional Manager', 'M2', 85000.00);

-- =====================================================
-- Sample Data: Employee Salaries
-- =====================================================
INSERT INTO employee_salaries (employee_id, template_id, effective_date, is_active) VALUES
(1, 2, '2023-01-15', TRUE),
(2, 3, '2023-03-20', TRUE),
(40, 21, '2023-10-20', TRUE);

-- =====================================================
-- Sample Data: Bonus Records
-- =====================================================
INSERT INTO bonus_records (employee_id, component_id, amount, bonus_date, description) VALUES
(1, 9, 5000.00, '2024-12-01', 'Q4 Performance Bonus'),
(2, 9, 7500.00, '2024-12-01', 'Q4 Performance Bonus'),
(40, 39, 2700.00, '2024-11-30', 'Sales Commission');

-- =====================================================
-- Sample Data: Admin Settings
-- =====================================================
INSERT INTO admin_settings (admin_id, setting_key, setting_value) VALUES
(2, 'company_timezone', 'America/Los_Angeles'),
(3, 'auto_leave_accrual', 'true'),
(4, 'company_timezone', 'America/New_York'),
(5, 'auto_leave_accrual', 'true');

COMMIT;

-- =====================================================
-- 3. REQUIRED SQL QUERIES (JOINs, Aggregates, etc.)
-- =====================================================
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

-- =====================================================
-- 4. CRUD OPERATIONS DEMONSTRATION
-- =====================================================
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

-- =====================================================
-- 5. TRANSACTION DEMONSTRATION (COMMIT/ROLLBACK)
-- =====================================================
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

COMMIT;
