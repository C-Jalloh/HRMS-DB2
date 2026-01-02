# HRMS Improvement & Robustness Plan

This document outlines the implementation steps to transition the current HRMS from an academic prototype to a production-ready, robust database system.

## Phase 1: Data Integrity & Historical Tracking
**Goal:** Eliminate redundancy and ensure the system can "travel back in time" to see historical data.

### 1.1 Refactor Employee Grade
- **Action:** Remove `salary_grade` from the `employees` table.
- **Rationale:** The grade is already defined in the `salary_templates` linked via `employee_salaries`.
- **Task:** Update `employees` table and adjust the dashboard queries to JOIN with `salary_templates` to fetch the grade.

### 1.2 Implement Job History
- **Action:** Create a `job_history` table.
- **Schema:** `history_id`, `employee_id`, `department_id`, `position`, `start_date`, `end_date`.
- **Rationale:** Allows tracking an employee's career progression (promotions/transfers) over time.

### 1.3 Enhance Salary History
- **Action:** Add `end_date` to `employee_salaries`.
- **Rationale:** Simplifies point-in-time salary reporting without needing complex "next record" logic.

---

## Phase 2: Advanced Multi-Tenancy Security
**Goal:** Prevent accidental data leaks between organizations.

### 2.1 Tenant-Scoped Views
- **Action:** Create a standard View for every major table (e.g., `vw_employees`, `vw_leaves`) that automatically filters by a session variable `current_admin_id`.
- **Task:** 
    1. Define a MySQL function to get/set the session tenant ID.
    2. Update the Node.js backend to set this session variable upon login.
    3. Point the dashboard API to the Views instead of raw tables.

---

## Phase 3: Business Logic & Robustness
**Goal:** Support global operations and prevent accidental data loss.

### 3.1 Leave Accrual Logging
- **Action:** Create a `leave_accrual_logs` table.
- **Schema:** `log_id`, `employee_id`, `leave_type_id`, `amount_added`, `accrual_date`, `reason`.
- **Rationale:** Provides transparency on why a leave balance increased (e.g., "Monthly Accrual", "Years of Service Bonus").

### 3.2 Internationalization (Currency)
- **Action:** Add `currency_code` (e.g., 'USD', 'EUR', 'SLL') to the `companies` table.
- **Rationale:** Allows the system to support tenants operating in different economic regions.

### 3.3 Soft Delete Mechanism
- **Action:** Add a `deleted_at` (TIMESTAMP, NULLABLE) column to all major tables (`employees`, `departments`, `leave_requests`).
- **Rationale:** Prevents permanent data loss from accidental deletions and maintains referential integrity for historical reports.

---

## Phase 4: Scalability & User Management
**Goal:** Prepare the system for complex administrative hierarchies.

### 4.1 User Table Separation
- **Action:** Create a separate `admin_profiles` table linked to `users`.
- **Rationale:** Keeps the `users` table lean for authentication while allowing `admins` to have complex, tenant-specific metadata without cluttering the core auth table.

---

## Implementation Schedule (Suggested)

| Week | Focus Area | Key Deliverable |
|:---|:---|:---|
| **1** | Phase 1 (History) | `job_history` table and `employee_salaries` update. |
| **2** | Phase 3 (Robustness) | Soft deletes and Currency support. |
| **3** | Phase 2 (Security) | Implementation of Tenant Views. |
| **4** | Phase 4 (Scalability) | User/Admin profile separation. |
