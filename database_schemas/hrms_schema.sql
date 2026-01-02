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
    address TEXT,
    phone VARCHAR(20),
    email VARCHAR(100),
    industry VARCHAR(50),
    currency_code VARCHAR(3) DEFAULT 'USD', -- Phase 3: Internationalization
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
    start_date DATE NOT NULL,
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
    year YEAR NOT NULL,
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
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    days_requested DECIMAL(5,2) NOT NULL,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
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
