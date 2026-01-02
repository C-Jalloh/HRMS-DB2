# MemoriPilot: System Architect

## Overview
This file contains the architectural decisions and design patterns for the MemoriPilot project.

## Architectural Decisions

- Use MySQL InnoDB engine for transaction support and foreign key constraints
- Implement soft deletes where appropriate (is_active flags)
- Store monetary values as DECIMAL for precision
- Use ENUM or lookup tables for status fields
- Separate leave balance as a calculated/cached table for performance
- Admin settings stored as JSON or separate key-value table
- Dashboard will query aggregated data directly from MySQL without backend API



1. **Decision 1**: Description of the decision and its rationale.
2. **Decision 2**: Description of the decision and its rationale.
3. **Decision 3**: Description of the decision and its rationale.



## Design Considerations

- Multi-tenancy implemented via tenant_id/admin_id in all relevant tables
- Foreign key relationships ensure referential integrity across modules
- Normalization to at least 3NF to reduce redundancy
- Indexing on frequently queried columns (employee_id, admin_id, dates)
- Transaction support for critical operations (payroll processing, leave approval)
- Proper constraint definitions (NOT NULL, UNIQUE, CHECK constraints)
- Cascade delete considerations for tenant removal
- Date/timestamp tracking for audit purposes (created_at, updated_at)



## Components

### User Management System

Handles superadmin and admin user accounts with role-based access

**Responsibilities:**

- User authentication credentials storage
- Role assignment (superadmin/admin)
- Admin profile management
- Superadmin can manage all admins

### Organization/Tenant Management

Manages company/organization profiles for each admin tenant

**Responsibilities:**

- Company profile information
- Department structure
- Company settings and preferences
- Multi-tenant data isolation

### Employee Management

Core module for managing employee records, onboarding, and actions

**Responsibilities:**

- Employee personal information
- Employment details and history
- Onboarding workflow tracking
- Employee actions/events tracking
- Department assignment

### Leave Management

Complete leave tracking system with policies and balances

**Responsibilities:**

- Leave type definitions
- Leave policy management
- Employee leave balance tracking
- Leave request processing
- Leave approval workflow

### Time & Attendance Management

Tracks employee work hours and attendance

**Responsibilities:**

- Daily attendance recording
- Clock in/out times
- Work schedule management
- Attendance reports and summaries

### Payroll Management

Manages salary components, templates, and bonus calculations

**Responsibilities:**

- Pay component definitions
- Salary template creation
- Employee salary assignments
- Bonus and deduction management
- Payroll processing records

### Settings & Preferences

Customizable settings for each admin tenant

**Responsibilities:**

- Admin preferences storage
- System configuration per tenant
- Notification preferences
- Dashboard customization

### Dashboard & Reporting

Visualizes key HR metrics and data

**Responsibilities:**

- Employee statistics
- Leave utilization reports
- Attendance summaries
- Payroll overviews
- Visual charts and graphs



