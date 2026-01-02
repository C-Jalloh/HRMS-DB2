# HRMS Database ERD Design

## Overview
This document outlines the Entity-Relationship Diagram (ERD) design for the Multi-Tenant Human Resources Management System (HRMS).

## Tables and Relationships

### Core Tables (8+ Required)

1. **users** - Superadmin and admin accounts
   - user_id (PK)
   - username (UNIQUE)
   - password_hash
   - role (ENUM: 'superadmin', 'admin')
   - is_active (BOOLEAN, DEFAULT TRUE)
   - created_at (TIMESTAMP)
   - updated_at (TIMESTAMP)

2. **companies** - Organization profiles
   - company_id (PK)
   - admin_id (FK → users.user_id)
   - company_name
   - address
   - phone
   - email
   - industry
   - created_at (TIMESTAMP)

3. **departments** - Department structure
   - department_id (PK)
   - admin_id (FK → users.user_id)
   - department_name
   - department_head
   - created_at (TIMESTAMP)

4. **employees** - Employee information
   - employee_id (PK)
   - admin_id (FK → users.user_id)
   - department_id (FK → departments.department_id)
   - first_name
   - last_name
   - email
   - phone
   - hire_date (DATE)
   - position
   - salary_grade
   - is_active (BOOLEAN, DEFAULT TRUE)
   - created_at (TIMESTAMP)

5. **employee_actions** - Employee lifecycle events
   - action_id (PK)
   - employee_id (FK → employees.employee_id)
   - action_type (ENUM: 'hire', 'promotion', 'transfer', 'termination')
   - action_date (DATE)
   - description (TEXT)
   - created_at (TIMESTAMP)

6. **leave_types** - Leave categories
   - leave_type_id (PK)
   - admin_id (FK → users.user_id)
   - leave_name
   - is_paid (BOOLEAN)
   - max_days_per_year (INT)
   - created_at (TIMESTAMP)

7. **leave_policies** - Company leave policies
   - policy_id (PK)
   - admin_id (FK → users.user_id)
   - leave_type_id (FK → leave_types.leave_type_id)
   - accrual_rate (DECIMAL)
   - max_carryover (INT)
   - created_at (TIMESTAMP)

8. **leave_balances** - Employee leave balances
   - balance_id (PK)
   - employee_id (FK → employees.employee_id)
   - leave_type_id (FK → leave_types.leave_type_id)
   - balance_days (DECIMAL)
   - used_days (DECIMAL)
   - year (YEAR)
   - updated_at (TIMESTAMP)

9. **leave_requests** - Leave applications
   - request_id (PK)
   - employee_id (FK → employees.employee_id)
   - leave_type_id (FK → leave_types.leave_type_id)
   - start_date (DATE)
   - end_date (DATE)
   - days_requested (DECIMAL)
   - status (ENUM: 'pending', 'approved', 'rejected')
   - approved_by (FK → users.user_id, NULLABLE)
   - created_at (TIMESTAMP)

10. **attendance_records** - Daily attendance
    - attendance_id (PK)
    - employee_id (FK → employees.employee_id)
    - attendance_date (DATE)
    - clock_in (TIME, NULLABLE)
    - clock_out (TIME, NULLABLE)
    - status (ENUM: 'present', 'absent', 'late', 'half_day')
    - hours_worked (DECIMAL)
    - created_at (TIMESTAMP)

11. **pay_components** - Salary components
    - component_id (PK)
    - admin_id (FK → users.user_id)
    - component_name
    - component_type (ENUM: 'earning', 'deduction')
    - is_taxable (BOOLEAN)
    - is_fixed (BOOLEAN)
    - created_at (TIMESTAMP)

12. **salary_templates** - Salary structures
    - template_id (PK)
    - admin_id (FK → users.user_id)
    - template_name
    - grade_level
    - base_salary (DECIMAL)
    - created_at (TIMESTAMP)

13. **employee_salaries** - Employee salary assignments
    - salary_id (PK)
    - employee_id (FK → employees.employee_id)
    - template_id (FK → salary_templates.template_id)
    - effective_date (DATE)
    - is_active (BOOLEAN, DEFAULT TRUE)
    - created_at (TIMESTAMP)

14. **bonus_records** - Bonuses and deductions
    - bonus_id (PK)
    - employee_id (FK → employees.employee_id)
    - component_id (FK → pay_components.component_id)
    - amount (DECIMAL)
    - bonus_date (DATE)
    - description (TEXT)
    - created_at (TIMESTAMP)

15. **admin_settings** - Admin preferences
    - setting_id (PK)
    - admin_id (FK → users.user_id)
    - setting_key
    - setting_value
    - created_at (TIMESTAMP)

## Key Relationships

### Multi-Tenant Isolation
- All tenant-specific tables include admin_id foreign key
- Ensures data isolation between different admin accounts

### Employee Management
- employees → departments (Many-to-One)
- employees → employee_actions (One-to-Many)
- employees → leave_balances (One-to-Many)
- employees → leave_requests (One-to-Many)
- employees → attendance_records (One-to-Many)
- employees → employee_salaries (One-to-Many)
- employees → bonus_records (One-to-Many)

### Leave Management
- leave_types → leave_policies (One-to-Many)
- leave_types → leave_balances (One-to-Many)
- leave_types → leave_requests (One-to-Many)

### Payroll Management
- salary_templates → employee_salaries (One-to-Many)
- pay_components → bonus_records (One-to-Many)

### Admin Management
- users (superadmin) → users (admin) (One-to-Many, conceptual)
- users → companies (One-to-One)
- users → admin_settings (One-to-Many)

## Constraints and Indexes

### Primary Keys
- All tables have auto-increment primary keys

### Foreign Keys
- All foreign key relationships defined with CASCADE on UPDATE, RESTRICT on DELETE
- Ensures referential integrity

### Unique Constraints
- users.username (unique across system)
- companies.admin_id (one company per admin)
- leave_balances (employee_id, leave_type_id, year) - composite unique

### Indexes
- Primary key indexes (automatic)
- Foreign key indexes (automatic)
- Additional: employees(admin_id, hire_date) - composite index for tenant queries
- Additional: attendance_records(employee_id, attendance_date) - composite index

### Check Constraints
- leave_balances.balance_days >= 0
- attendance_records.hours_worked >= 0 AND hours_worked <= 24
- pay_components.amount >= 0 (for bonus_records)

## Normalization Level
- **3NF Compliance**: All tables are in Third Normal Form
- No transitive dependencies
- All non-key attributes depend only on the primary key

## ERD Visualization
[ERD Diagram would be created using Lucidchart/Draw.io]

### Legend:
- **PK**: Primary Key
- **FK**: Foreign Key
- **NN**: Not Null
- **UQ**: Unique
- **AI**: Auto Increment
