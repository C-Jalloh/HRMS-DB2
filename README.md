# Multi-Tenant Human Resources Management System (HRMS)

## Database Systems II Project - Complete Implementation

**Date:** January 11, 2026  
**Authors:** 
- Mamadou Alieu Jallow (22316058)
- Ousainou Sanyang (22316027)
- Ebrima S Jallow (22213296)
**Course:** Database Systems II  
**Institution:** University of The Gambia (UTG)

---

## 📋 Project Overview

This project implements a comprehensive **Multi-Tenant Human Resources Management System (HRMS)** designed to meet all Database Systems II project requirements. The system provides complete employee management functionality with multi-tenant architecture, ensuring data isolation between different organizations.

### 🎯 Core Features

- **Multi-Tenant Architecture**: Complete data isolation between organizations using `admin_id` logic.
- **Employee Management**: Complete CRUD operations for employee data and history.
- **Leave Management**: Comprehensive request, approval, and balance tracking system.
- **Time & Attendance**: Real-time clock in/out tracking with status monitoring (Late, Absent, Half-day).
- **Payroll Management**: Advanced salary templates, bonus components, and compensation audit trails.
- **Dashboard Analytics**: Real-time visualization of HR KPIs via a Full-Stack Web Dashboard.

### 🏗️ System Architecture

- **Database**: MySQL 8.0+ with InnoDB engine
- **Tables**: 15 interconnected tables (exceeds 8 minimum requirement)
- **Normalization**: 3NF compliance throughout
- **Security**: Multi-tenant data isolation via admin_id foreign keys
- **Transactions**: ACID compliance with COMMIT/ROLLBACK demonstrations

---

## 📁 Project Structure

```
.
├── HRMS_Master_Submission.sql   # Consolidated SQL script (Schema, Data, Queries, Transactions)
├── HRMS_Final_Report.md        # Formatted academic report with screenshots
├── README.md                   # Project documentation and setup guide
├── dashboard/                  # Full-stack dashboard application
│   ├── server.js               # Node.js/Express backend API
│   ├── index.html              # Frontend UI with Chart.js
│   ├── script.js               # Dynamic charting logic
│   └── style.css               # Dashboard styling
├── database_schemas/           # Individual SQL modules (Original components)
│   ├── hrms_schema.sql         # 3NF Normalized schema
│   ├── hrms_sample_data.sql    # 10 records per table minimum
│   ├── hrms_transactions.sql   # COMMIT/ROLLBACK logic
│   └── hrms_validation_tests.sql
└── documentation/              # Supporting documents and diagrams
```

---

## 🗄️ Database Schema

### Core Tables (15 Total)

1. **super_admins** - System administrators
2. **companies** - Organization information
3. **admins** - Tenant administrators
4. **admin_permissions** - Admin access control
5. **departments** - Department management
6. **employees** - Employee master data
7. **employee_actions** - Audit trail for employee changes
8. **salary_templates** - Compensation structures
9. **employee_salaries** - Salary assignments
10. **bonus_components** - Bonus types
11. **bonus_records** - Bonus payments
12. **leave_types** - Leave categories
13. **leave_balances** - Leave entitlements
14. **leave_requests** - Leave applications
15. **attendance_records** - Time tracking

### Key Relationships

- Multi-tenant isolation via `admin_id` foreign keys
- Hierarchical access: Super Admin → Admin → Employees
- Complex relationships between employees, departments, and compensation

---

## 🚀 Quick Start

### Prerequisites

- MySQL 8.0 or higher
- MySQL Workbench (recommended)
- 500MB free disk space

### Installation Steps

1. **Create Database**
   ```sql
   CREATE DATABASE hrms_db;
   USE hrms_db;
   ```

2. **Execute Master Script**
   This script contains the schema, sample data, queries, and transaction demonstrations.
   ```bash
   mysql -u root -p hrms_db < HRMS_Master_Submission.sql
   ```

3. **Run Individual Components (Optional)**
   You can also run files from the `database_schemas/` directory if needed.

### Alternative: Using MySQL Workbench

1. Open MySQL Workbench
2. Connect to your MySQL server
3. Create new database: `hrms_db`
4. Open each SQL file in the `database_schemas/` folder
5. Execute files in this order:
   - `hrms_schema.sql`
   - `hrms_sample_data.sql`
   - `hrms_validation_tests.sql` (optional, for testing)

---

## 📊 Project Requirements Compliance

### ✅ Completed Requirements

| Requirement | Status | Implementation |
|-------------|--------|----------------|
| 8+ Tables | ✅ **PASS** | 15 tables implemented |
| Full CRUD Operations | ✅ **PASS** | `hrms_crud_operations.sql` |
| 10+ SQL Queries | ✅ **PASS** | 15 queries in `hrms_required_queries.sql` |
| 3 JOIN Queries | ✅ **PASS** | Employee-department-company relationships |
| 2 Aggregate Queries | ✅ **PASS** | Department stats, monthly summaries |
| 1 ORDER BY/LIMIT | ✅ **PASS** | Top 10 highest paid employees |
| 1 Subquery | ✅ **PASS** | Above department average salary |
| Indexing | ✅ **PASS** | 10+ indexes including composite |
| Transactions | ✅ **PASS** | `hrms_transactions.sql` with COMMIT/ROLLBACK |
| Dashboard Visualization | ✅ **PASS** | `hrms_dashboard_data.sql` for Excel/Power BI |
| Multi-Tenant Architecture | ✅ **PASS** | Admin_id isolation throughout |

### 🧪 Testing Results

All components validated through comprehensive testing:
- ✅ Schema integrity
- ✅ Data relationships
- ✅ CRUD operations
- ✅ Query functionality
- ✅ Transaction handling
- ✅ Multi-tenant security
- ✅ Business logic constraints

---

## 🔍 Key Features Demonstration

### Multi-Tenant Data Isolation

```sql
-- Admin ID 2 can only access their organization's data
SELECT * FROM employees WHERE admin_id = 2;
-- This ensures complete data separation between tenants
```

### Complex JOIN Queries

```sql
-- Employee with department and company information
SELECT e.first_name, e.last_name, d.department_name, c.company_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id AND e.admin_id = d.admin_id
JOIN admins a ON e.admin_id = a.admin_id
JOIN companies c ON a.company_id = c.company_id
WHERE e.admin_id = 2;
```

### Transaction Management

```sql
START TRANSACTION;
-- Multiple related operations
INSERT INTO employees (...) VALUES (...);
INSERT INTO employee_salaries (...) VALUES (...);
INSERT INTO leave_balances (...) VALUES (...);
COMMIT; -- Or ROLLBACK on error
```

---

## 📈 Dashboard & Visualization

### 🖥️ Web-Based Dashboard

A fully functional web-based dashboard is included in the `dashboard/` directory. It uses a Node.js/Express backend to query the live MySQL database and a Chart.js frontend for visualization.

**Features:**
- **Interactive Charts**: Real-time visualizations for employee distribution, attendance trends, and payroll.
- **KPI Cards**: Live counts of employees, active leave requests, and attendance stats.
- **Tenant Switching**: Dashboard updates based on the logged-in administrator context.
- **Responsive Design**: Clean UI with CSS Grid and Flexbox.

**How to Run:**
1. Navigate to the `dashboard/` directory.
2. Install dependencies:
   ```bash
   npm install
   ```
3. Update `db_config.php` (if using PHP) or the connection string in `server.js` with your MySQL credentials.
4. Start the server:
   ```bash
   node server.js
   ```
5. Open `http://localhost:3000` in your browser.

### Available Dashboards (SQL Queries)

1. **Employee Overview**
   - Employee count by department (Bar Chart)
   - Position distribution (Pie Chart)
   - Salary distribution (Histogram)
   - Tenure analysis (Line Chart)

2. **Leave Management**
   - Leave balance summaries (Stacked Bar)
   - Request status distribution (Pie Chart)
   - Monthly usage trends (Line Chart)

3. **Attendance Tracking**
   - Monthly attendance rates (Line Chart)
   - Department hours worked (Bar Chart)
   - Individual attendance summaries (Table)

4. **Payroll & Compensation**
   - Salary range distribution (Histogram)
   - Bonus analysis (Pie Chart)
   - Department salary comparisons (Bar Chart)

5. **HR Analytics**
   - Key performance metrics (KPIs)
   - Turnover calculations
   - Department performance comparisons

### Visualization Tools

- **Excel**: Import CSV exports for pivot tables and charts
- **Power BI**: Connect directly to MySQL database
- **Tableau**: Use the provided data export queries
- **Google Data Studio**: CSV upload capability

### Sample Dashboard Query

```sql
-- Employee count by department for dashboard
SELECT 
    d.department_name,
    COUNT(e.employee_id) AS employee_count,
    ROUND(AVG(st.base_salary), 2) AS avg_salary
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id AND d.admin_id = e.admin_id
LEFT JOIN employee_salaries es ON e.employee_id = es.employee_id AND es.is_active = TRUE
LEFT JOIN salary_templates st ON es.template_id = st.template_id
WHERE d.admin_id = 2 AND e.is_active = TRUE
GROUP BY d.department_id, d.department_name
ORDER BY employee_count DESC;
```

---

## 🔧 Advanced Features

### Indexing Strategy

- **Primary Keys**: All tables have auto-increment primary keys
- **Foreign Keys**: Referential integrity with CASCADE/RESTRICT
- **Composite Indexes**: `(admin_id, department_id, is_active)` on employees
- **Performance Indexes**: On frequently queried columns

### Transaction Isolation

- **Isolation Level**: REPEATABLE READ for consistency
- **Savepoints**: For partial transaction rollback
- **Deadlock Prevention**: Consistent resource access ordering

### Data Integrity

- **Check Constraints**: Salary grades, leave balances
- **Unique Constraints**: Email addresses, employee IDs
- **Soft Deletes**: `is_active` flags preserve data integrity

---

## 🧪 Validation & Testing

### Automated Testing

Run the comprehensive validation script:

```bash
mysql -u root -p hrms_db < database_schemas/hrms_validation_tests.sql
```

### Test Coverage

- ✅ Schema validation (15 tables, constraints, indexes)
- ✅ Data integrity (referential integrity, multi-tenancy)
- ✅ CRUD operations (create, read, update, delete)
- ✅ Query validation (all required query types)
- ✅ Transaction testing (commit/rollback scenarios)
- ✅ Performance validation (index usage, EXPLAIN plans)
- ✅ Business logic (constraints, validations)
- ✅ Security testing (multi-tenant isolation)

---

## 📚 Documentation

### Project Files

- **`HRMS_Implementation_Plan.md`**: Complete project roadmap and requirements
- **`hrms_erd_design.md`**: Detailed ERD with relationships and constraints
- **`README.md`**: This comprehensive guide

### Database Files

- **`hrms_schema.sql`**: Complete CREATE TABLE statements
- **`hrms_sample_data.sql`**: Realistic test data
- **`hrms_crud_operations.sql`**: All CRUD operations
- **`hrms_required_queries.sql`**: 15 advanced queries
- **`hrms_transactions.sql`**: Transaction demonstrations
- **`hrms_dashboard_data.sql`**: Visualization queries
- **`hrms_validation_tests.sql`**: Testing suite

---

## 🎓 Academic Compliance

This implementation fully satisfies the Database Systems II project requirements:

- ✅ **Minimum 8 tables**: 15 tables implemented
- ✅ **Full CRUD operations**: Complete for all entities
- ✅ **10+ SQL queries**: 15 queries with required types
- ✅ **Advanced queries**: JOINs, aggregates, subqueries, ORDER BY/LIMIT
- ✅ **Indexing**: Proper indexing strategy implemented
- ✅ **Transactions**: ACID compliance demonstrated
- ✅ **Dashboard**: Visualization queries provided
- ✅ **Documentation**: Comprehensive project documentation
- ✅ **Testing**: Validation and testing suite included

---

## 🚀 Future Enhancements

### Potential Extensions

- **API Integration**: RESTful API for web/mobile applications
- **Advanced Analytics**: Predictive analytics for HR metrics
- **Workflow Automation**: Automated approval processes
- **Reporting Engine**: Scheduled report generation
- **Audit Logging**: Enhanced audit trails
- **Performance Optimization**: Query optimization and caching

### Scalability Considerations

- **Partitioning**: Table partitioning for large datasets
- **Replication**: Read replicas for reporting queries
- **Caching**: Redis integration for frequently accessed data
- **Archiving**: Data archiving strategies for old records

---

## 📞 Support & Contact

For questions or clarifications about this implementation:

- Review the comprehensive documentation in each SQL file
- Run the validation tests to ensure proper setup
- Check the ERD documentation for relationship understanding
- Use the dashboard queries for visualization setup

---

## 📄 License & Attribution

This project was created as part of Database Systems II coursework. All code and documentation are original work developed to meet academic requirements.

**Final Status**: ✅ **COMPLETE** - All project requirements met and validated.

---

*Created with comprehensive attention to database design principles, multi-tenant architecture, and academic requirements compliance.*
