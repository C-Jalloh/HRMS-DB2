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
('admin_company_j', '$2b$10$hashedpassword11', 'admin', TRUE),
('admin_company_k', '$2b$10$hashedpassword12', 'admin', TRUE);

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
(12, 'Consulting Partners', '852 Advisory Ave, Atlanta, GA', '+1-555-0111', 'hr@consulting.com', 'Consulting');

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
(3, 'Safety', 'James Anderson'),
(4, 'Nursing', 'Patricia Taylor'),
(4, 'Administration', 'Christopher Lee'),
(4, 'Pharmacy', 'Barbara Harris'),
(4, 'Medical Records', 'Daniel Clark'),
(4, 'Patient Services', 'Nancy Lewis'),
(5, 'Sales', 'Paul Walker'),
(5, 'Customer Service', 'Karen Hall'),
(5, 'Inventory', 'Steven Young'),
(5, 'Store Management', 'Betty King'),
(5, 'Loss Prevention', 'Ronald Wright'),
(6, 'Investment Banking', 'Donna Scott'),
(6, 'Retail Banking', 'George Green'),
(6, 'Risk Management', 'Helen Adams'),
(6, 'Compliance', 'Frank Baker'),
(6, 'IT Security', 'Deborah Nelson'),
(7, 'Academic Affairs', 'Larry Carter'),
(7, 'Student Services', 'Sandra Mitchell'),
(7, 'Administration', 'Timothy Perez'),
(7, 'Library', 'Rebecca Roberts'),
(7, 'Facilities', 'Joshua Turner'),
(8, 'Project Management', 'Amanda Phillips'),
(8, 'Site Engineering', 'Kevin Campbell'),
(8, 'Procurement', 'Dorothy Parker'),
(8, 'Health & Safety', 'Jerry Evans'),
(8, 'Quality Assurance', 'Carol Edwards'),
(9, 'Content Creation', 'Arthur Collins'),
(9, 'Broadcasting', 'Rachel Stewart'),
(9, 'Digital Media', 'Henry Sanchez'),
(9, 'Public Relations', 'Theresa Morris'),
(9, 'Audience Development', 'Dennis Rogers'),
(10, 'Kitchen Operations', 'Alice Murphy'),
(10, 'Service Staff', 'Peter Rivera'),
(10, 'Food Safety', 'Christine Cooper'),
(10, 'Inventory Control', 'Ralph Richardson'),
(10, 'Catering', 'Frances Cox'),
(11, 'Fleet Operations', 'Louis Howard'),
(11, 'Logistics', 'Ann Ward'),
(11, 'Driver Management', 'Benjamin Torres'),
(11, 'Maintenance', 'Diana Peterson'),
(11, 'Dispatch', 'Harry Gray'),
(12, 'Strategy Consulting', 'Irene Ramirez'),
(12, 'Technology Consulting', 'Douglas James'),
(12, 'Operations Consulting', 'Joyce Watson'),
(12, 'Financial Consulting', 'Bobby Brooks'),
(12, 'Human Capital', 'Diana Kelly');

-- =====================================================
-- Sample Data: Employees (50+ employees across companies)
-- =====================================================
INSERT INTO employees (admin_id, department_id, first_name, last_name, email, phone, hire_date, position, salary_grade, is_active) VALUES
-- Company A (Tech Solutions) - Admin ID 2
(2, 1, 'Alice', 'Johnson', 'alice.johnson@techsolutions.com', '+1-555-1001', '2023-01-15', 'Software Engineer', 'L2', TRUE),
(2, 1, 'Bob', 'Williams', 'bob.williams@techsolutions.com', '+1-555-1002', '2023-03-20', 'Senior Developer', 'L3', TRUE),
(2, 2, 'Carol', 'Brown', 'carol.brown@techsolutions.com', '+1-555-1003', '2023-02-10', 'HR Manager', 'M1', TRUE),
(2, 3, 'David', 'Jones', 'david.jones@techsolutions.com', '+1-555-1004', '2023-04-05', 'Financial Analyst', 'L3', TRUE),
(2, 4, 'Eva', 'Garcia', 'eva.garcia@techsolutions.com', '+1-555-1005', '2023-05-12', 'Marketing Specialist', 'L2', TRUE),
(2, 5, 'Frank', 'Miller', 'frank.miller@techsolutions.com', '+1-555-1006', '2023-06-18', 'Operations Manager', 'M2', TRUE),
(2, 1, 'Grace', 'Davis', 'grace.davis@techsolutions.com', '+1-555-1007', '2023-07-22', 'DevOps Engineer', 'L3', TRUE),
(2, 1, 'Henry', 'Rodriguez', 'henry.rodriguez@techsolutions.com', '+1-555-1008', '2023-08-30', 'Frontend Developer', 'L2', TRUE),
(2, 2, 'Ivy', 'Martinez', 'ivy.martinez@techsolutions.com', '+1-555-1009', '2023-09-14', 'HR Coordinator', 'L1', TRUE),
(2, 3, 'Jack', 'Anderson', 'jack.anderson@techsolutions.com', '+1-555-1010', '2023-10-08', 'Accountant', 'L2', TRUE);

INSERT INTO employees (admin_id, department_id, first_name, last_name, email, phone, hire_date, position, salary_grade, is_active) VALUES

-- Company B (Global Manufacturing) - Admin ID 3
(3, 6, 'Karen', 'Taylor', 'karen.taylor@globalmfg.com', '+1-555-2001', '2022-11-15', 'Production Supervisor', 'M1', TRUE),
(3, 6, 'Leo', 'Thomas', 'leo.thomas@globalmfg.com', '+1-555-2002', '2023-01-20', 'Line Worker', 'L1', TRUE),
(3, 7, 'Mia', 'Jackson', 'mia.jackson@globalmfg.com', '+1-555-2003', '2023-02-25', 'Quality Inspector', 'L2', TRUE),
(3, 8, 'Noah', 'White', 'noah.white@globalmfg.com', '+1-555-2004', '2023-03-30', 'Maintenance Technician', 'L2', TRUE),
(3, 9, 'Olivia', 'Harris', 'olivia.harris@globalmfg.com', '+1-555-2005', '2023-04-15', 'Supply Chain Analyst', 'L3', TRUE),
(3, 10, 'Peter', 'Clark', 'peter.clark@globalmfg.com', '+1-555-2006', '2023-05-20', 'Safety Officer', 'M1', TRUE),
(3, 6, 'Quinn', 'Lewis', 'quinn.lewis@globalmfg.com', '+1-555-2007', '2023-06-10', 'Production Manager', 'M2', TRUE),
(3, 7, 'Rachel', 'Robinson', 'rachel.robinson@globalmfg.com', '+1-555-2008', '2023-07-05', 'Quality Manager', 'M2', TRUE),
(3, 8, 'Sam', 'Walker', 'sam.walker@globalmfg.com', '+1-555-2009', '2023-08-12', 'Senior Technician', 'L3', TRUE),
(3, 9, 'Tina', 'Hall', 'tina.hall@globalmfg.com', '+1-555-2010', '2023-09-18', 'Procurement Specialist', 'L2', TRUE);



-- Company C (Healthcare Plus) - Admin ID 4
INSERT INTO employees (admin_id, department_id, first_name, last_name, email, phone, hire_date, position, salary_grade, is_active) VALUES

(4, 11, 'Uma', 'Young', 'uma.young@healthcareplus.com', '+1-555-3001', '2023-01-10', 'Registered Nurse', 'L2', TRUE),
(4, 11, 'Victor', 'King', 'victor.king@healthcareplus.com', '+1-555-3002', '2023-02-15', 'Nurse Practitioner', 'L3', TRUE),
(4, 12, 'Wendy', 'Wright', 'wendy.wright@healthcareplus.com', '+1-555-3003', '2023-03-20', 'Administrative Assistant', 'L1', TRUE),
(4, 13, 'Xavier', 'Lopez', 'xavier.lopez@healthcareplus.com', '+1-555-3004', '2023-04-25', 'Pharmacist', 'L3', TRUE),
(4, 14, 'Yara', 'Hill', 'yara.hill@healthcareplus.com', '+1-555-3005', '2023-05-30', 'Medical Records Clerk', 'L1', TRUE),
(4, 15, 'Zane', 'Green', 'zane.green@healthcareplus.com', '+1-555-3006', '2023-06-15', 'Patient Services Rep', 'L2', TRUE),
(4, 11, 'Amy', 'Adams', 'amy.adams@healthcareplus.com', '+1-555-3007', '2023-07-20', 'Charge Nurse', 'M1', TRUE),
(4, 12, 'Brian', 'Baker', 'brian.baker@healthcareplus.com', '+1-555-3008', '2023-07-25', 'Office Manager', 'M1', TRUE),
(4, 13, 'Cathy', 'Gonzalez', 'cathy.gonzalez@healthcareplus.com', '+1-555-3009', '2023-08-30', 'Pharmacy Tech', 'L1', TRUE),
(4, 14, 'Doug', 'Nelson', 'doug.nelson@healthcareplus.com', '+1-555-3010', '2023-09-15', 'Records Manager', 'L2', TRUE);

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
(2, 'hire', '2023-03-20', 'Initial hiring as Senior Developer'),
(3, 'hire', '2023-02-10', 'Initial hiring as HR Manager'),
(4, 'hire', '2023-04-05', 'Initial hiring as Financial Analyst'),
(5, 'hire', '2023-05-12', 'Initial hiring as Marketing Specialist'),
(6, 'hire', '2023-06-18', 'Initial hiring as Operations Manager'),
(7, 'hire', '2023-07-22', 'Initial hiring as DevOps Engineer'),
(8, 'hire', '2023-08-30', 'Initial hiring as Frontend Developer'),
(9, 'hire', '2023-09-14', 'Initial hiring as HR Coordinator'),
(10, 'hire', '2023-10-08', 'Initial hiring as Accountant'),
(11, 'hire', '2022-11-15', 'Initial hiring as Production Supervisor'),
(12, 'hire', '2023-01-20', 'Initial hiring as Line Worker'),
(13, 'hire', '2023-02-25', 'Initial hiring as Quality Inspector'),
(14, 'hire', '2023-03-30', 'Initial hiring as Maintenance Technician'),
(15, 'hire', '2023-04-15', 'Initial hiring as Supply Chain Analyst'),
(16, 'hire', '2023-05-20', 'Initial hiring as Safety Officer'),
(17, 'hire', '2023-06-10', 'Initial hiring as Production Manager'),
(18, 'hire', '2023-07-05', 'Initial hiring as Quality Manager'),
(19, 'hire', '2023-08-12', 'Initial hiring as Senior Technician'),
(20, 'hire', '2023-09-18', 'Initial hiring as Procurement Specialist'),
(21, 'hire', '2023-01-10', 'Initial hiring as Registered Nurse'),
(22, 'hire', '2023-02-15', 'Initial hiring as Nurse Practitioner'),
(23, 'hire', '2023-03-20', 'Initial hiring as Administrative Assistant'),
(24, 'hire', '2023-04-25', 'Initial hiring as Pharmacist'),
(25, 'hire', '2023-05-30', 'Initial hiring as Medical Records Clerk'),
(26, 'hire', '2023-06-15', 'Initial hiring as Patient Services Rep'),
(27, 'hire', '2023-07-20', 'Initial hiring as Charge Nurse'),
(28, 'hire', '2023-08-10', 'Initial hiring as Office Manager'),
(29, 'hire', '2023-09-15', 'Initial hiring as Pharmacy Tech'),
(30, 'hire', '2023-10-20', 'Initial hiring as Records Manager'),
(31, 'hire', '2023-01-05', 'Initial hiring as Sales Associate'),
(32, 'hire', '2023-02-10', 'Initial hiring as Customer Service Rep'),
(33, 'hire', '2023-03-15', 'Initial hiring as Bank Teller'),
(34, 'hire', '2023-04-20', 'Initial hiring as Loan Officer'),
(35, 'hire', '2023-05-25', 'Initial hiring as Teacher'),
(36, 'hire', '2023-06-30', 'Initial hiring as Counselor'),
(37, 'hire', '2023-07-05', 'Initial hiring as Project Coordinator'),
(38, 'hire', '2023-08-10', 'Initial hiring as Site Engineer'),
(39, 'hire', '2023-09-15', 'Initial hiring as Content Producer'),
(40, 'hire', '2023-10-20', 'Initial hiring as Broadcast Technician'),
(41, 'hire', '2023-11-25', 'Initial hiring as Chef'),
(42, 'hire', '2023-12-30', 'Initial hiring as Server'),
(43, 'hire','2024-01-05', 'Initial hiring as Driver'),
(44, 'hire','2024-02-10', 'Initial hiring as Dispatcher'),
(45, 'hire','2024-03-15', 'Initial hiring as Consultant'),
(46, 'hire','2024-04-20', 'Initial hiring as Senior Consultant'),
(47, 'hire','2024-05-25', 'Initial hiring as Data Analyst'),
(48, 'hire','2024-06-30', 'Initial hiring as Process Engineer'),
(49, 'hire','2024-07-05', 'Initial hiring as Medical Assistant'),
(50, 'hire','2024-08-10', 'Initial hiring as Store Manager'),
(1, 'promotion', '2024-01-15', 'Promoted to Senior Software Engineer'),
(2, 'promotion', '2024-03-20', 'Promoted to Tech Lead'),
(3, 'promotion', '2024-02-10', 'Promoted to Senior HR Manager'),
(4, 'promotion', '2024-04-05', 'Promoted to Senior Financial Analyst'),
(5, 'promotion', '2024-05-12', 'Promoted to Marketing Manager'),
(6, 'promotion', '2024-06-18', 'Promoted to Director of Operations'),
(7, 'promotion', '2024-07-22', 'Promoted to Senior DevOps Engineer'),
(8, 'promotion', '2024-08-30', 'Promoted to Senior Frontend Developer'),
(9, 'promotion', '2024-09-14', 'Promoted to HR Specialist'),
(10, 'promotion', '2024-10-08', 'Promoted to Senior Accountant');

-- =====================================================
-- Sample Data: Leave Types
-- =====================================================
INSERT INTO leave_types (admin_id, leave_name, is_paid, max_days_per_year) VALUES
(2, 'Annual Leave', TRUE, 25),
(2, 'Sick Leave', TRUE, 10),
(2, 'Personal Leave', TRUE, 5),
(2, 'Maternity Leave', TRUE, 90),
(2, 'Paternity Leave', TRUE, 10),
(3, 'Annual Leave', TRUE, 20),
(3, 'Sick Leave', TRUE, 12),
(3, 'Personal Leave', TRUE, 3),
(3, 'Maternity Leave', TRUE, 84),
(3, 'Compassionate Leave', TRUE, 5),
(4, 'Annual Leave', TRUE, 30),
(4, 'Sick Leave', TRUE, 15),
(4, 'Personal Leave', TRUE, 5),
(4, 'Maternity Leave', TRUE, 90),
(4, 'Study Leave', TRUE, 10),
(5, 'Annual Leave', TRUE, 15),
(5, 'Sick Leave', TRUE, 8),
(5, 'Personal Leave', TRUE, 3),
(5, 'Maternity Leave', TRUE, 60),
(5, 'Emergency Leave', TRUE, 3),
(6, 'Annual Leave', TRUE, 25),
(6, 'Sick Leave', TRUE, 10),
(6, 'Personal Leave', TRUE, 5),
(6, 'Maternity Leave', TRUE, 90),
(6, 'Professional Development', TRUE, 5),
(7, 'Annual Leave', TRUE, 40),
(7, 'Sick Leave', TRUE, 20),
(7, 'Personal Leave', TRUE, 10),
(7, 'Maternity Leave', TRUE, 120),
(7, 'Sabbatical', TRUE, 180),
(8, 'Annual Leave', TRUE, 20),
(8, 'Sick Leave', TRUE, 12),
(8, 'Personal Leave', TRUE, 5),
(8, 'Maternity Leave', TRUE, 90),
(8, 'Injury Leave', TRUE, 30),
(9, 'Annual Leave', TRUE, 18),
(9, 'Sick Leave', TRUE, 10),
(9, 'Personal Leave', TRUE, 4),
(9, 'Maternity Leave', TRUE, 84),
(9, 'Creative Leave', TRUE, 10),
(10, 'Annual Leave', TRUE, 15),
(10, 'Sick Leave', TRUE, 8),
(10, 'Personal Leave', TRUE, 3),
(10, 'Maternity Leave', TRUE, 60),
(10, 'Family Leave', TRUE, 5),
(11, 'Annual Leave', TRUE, 22),
(11, 'Sick Leave', TRUE, 12),
(11, 'Personal Leave', TRUE, 4),
(11, 'Maternity Leave', TRUE, 90),
(11, 'Training Leave', TRUE, 5),
(12, 'Annual Leave', TRUE, 25),
(12, 'Sick Leave', TRUE, 10),
(12, 'Personal Leave', TRUE, 5),
(12, 'Maternity Leave', TRUE, 90),
(12, 'Conference Leave', TRUE, 5);

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
-- Tech Solutions employees (Admin 2)
(1, 1, 20.5, 4.5, 2024), (1, 2, 8.0, 2.0, 2024), (1, 3, 4.0, 1.0, 2024),
(2, 1, 18.0, 7.0, 2024), (2, 2, 7.5, 2.5, 2024), (2, 3, 3.5, 1.5, 2024),
(3, 1, 22.0, 3.0, 2024), (3, 2, 9.0, 1.0, 2024), (3, 3, 4.5, 0.5, 2024),
(4, 1, 16.5, 8.5, 2024), (4, 2, 7.0, 3.0, 2024), (4, 3, 3.0, 2.0, 2024),
(5, 1, 14.0, 11.0, 2024), (5, 2, 6.5, 3.5, 2024), (5, 3, 2.5, 2.5, 2024),
(6, 1, 12.5, 12.5, 2024), (6, 2, 6.0, 4.0, 2024), (6, 3, 2.0, 3.0, 2024),
(7, 1, 10.0, 15.0, 2024), (7, 2, 5.5, 4.5, 2024), (7, 3, 1.5, 3.5, 2024),
(8, 1, 8.5, 16.5, 2024), (8, 2, 5.0, 5.0, 2024), (8, 3, 1.0, 4.0, 2024),
(9, 1, 24.0, 1.0, 2024), (9, 2, 9.5, 0.5, 2024), (9, 3, 4.8, 0.2, 2024),
(10, 1, 19.5, 5.5, 2024), (10, 2, 8.5, 1.5, 2024), (10, 3, 4.2, 0.8, 2024),

-- Global Manufacturing employees (Admin 3)
(11, 6, 15.0, 5.0, 2024), (11, 7, 10.0, 2.0, 2024), (11, 8, 2.5, 0.5, 2024),
(12, 6, 13.5, 6.5, 2024), (12, 7, 9.5, 2.5, 2024), (12, 8, 2.0, 1.0, 2024),
(13, 6, 12.0, 8.0, 2024), (13, 7, 9.0, 3.0, 2024), (13, 8, 1.5, 1.5, 2024),
(14, 6, 10.5, 9.5, 2024), (14, 7, 8.5, 3.5, 2024), (14, 8, 1.0, 2.0, 2024),
(15, 6, 9.0, 11.0, 2024), (15, 7, 8.0, 4.0, 2024), (15, 8, 0.5, 2.5, 2024),
(16, 6, 7.5, 12.5, 2024), (16, 7, 7.5, 4.5, 2024), (16, 8, 0.0, 3.0, 2024),
(17, 6, 6.0, 14.0, 2024), (17, 7, 7.0, 5.0, 2024), (17, 8, 0.0, 3.0, 2024),
(18, 6, 4.5, 15.5, 2024), (18, 7, 6.5, 5.5, 2024), (18, 8, 0.0, 3.0, 2024),
(19, 6, 3.0, 17.0, 2024), (19, 7, 6.0, 6.0, 2024), (19, 8, 0.0, 3.0, 2024),
(20, 6, 1.5, 18.5, 2024), (20, 7, 5.5, 6.5, 2024), (20, 8, 0.0, 3.0, 2024),

-- Healthcare Plus employees (Admin 4)
(21, 11, 25.0, 5.0, 2024), (21, 12, 12.5, 2.5, 2024), (21, 13, 4.0, 1.0, 2024),
(22, 11, 23.5, 6.5, 2024), (22, 12, 12.0, 3.0, 2024), (22, 13, 3.5, 1.5, 2024),
(23, 11, 22.0, 8.0, 2024), (23, 12, 11.5, 3.5, 2024), (23, 13, 3.0, 2.0, 2024),
(24, 11, 20.5, 9.5, 2024), (24, 12, 11.0, 4.0, 2024), (24, 13, 2.5, 2.5, 2024),
(25, 11, 19.0, 11.0, 2024), (25, 12, 10.5, 4.5, 2024), (25, 13, 2.0, 3.0, 2024),
(26, 11, 17.5, 12.5, 2024), (26, 12, 10.0, 5.0, 2024), (26, 13, 1.5, 3.5, 2024),
(27, 11, 16.0, 14.0, 2024), (27, 12, 9.5, 5.5, 2024), (27, 13, 1.0, 4.0, 2024),
(28, 11, 14.5, 15.5, 2024), (28, 12, 9.0, 6.0, 2024), (28, 13, 0.5, 4.5, 2024),
(29, 11, 13.0, 17.0, 2024), (29, 12, 8.5, 6.5, 2024), (29, 13, 0.0, 5.0, 2024),
(30, 11, 11.5, 18.5, 2024), (30, 12, 8.0, 7.0, 2024), (30, 13, 0.0, 5.0, 2024),

-- Additional balances for remaining employees
(31, 16, 12.0, 3.0, 2024), (31, 17, 6.5, 1.5, 2024), (31, 18, 2.5, 0.5, 2024),
(32, 16, 10.5, 4.5, 2024), (32, 17, 6.0, 2.0, 2024), (32, 18, 2.0, 1.0, 2024),
(33, 21, 20.0, 5.0, 2024), (33, 22, 8.0, 2.0, 2024), (33, 23, 4.0, 1.0, 2024),
(34, 21, 18.5, 6.5, 2024), (34, 22, 7.5, 2.5, 2024), (34, 23, 3.5, 1.5, 2024),
(35, 26, 32.0, 8.0, 2024), (35, 27, 16.0, 4.0, 2024), (35, 28, 8.0, 2.0, 2024),
(36, 26, 30.5, 9.5, 2024), (36, 27, 15.5, 4.5, 2024), (36, 28, 7.5, 2.5, 2024),
(37, 31, 16.0, 4.0, 2024), (37, 32, 9.5, 2.5, 2024), (37, 33, 4.0, 1.0, 2024),
(38, 31, 14.5, 5.5, 2024), (38, 32, 9.0, 3.0, 2024), (38, 33, 3.5, 1.5, 2024),
(39, 36, 14.0, 4.0, 2024), (39, 37, 8.0, 2.0, 2024), (39, 38, 3.2, 0.8, 2024),
(40, 36, 12.5, 5.5, 2024), (40, 37, 7.5, 2.5, 2024), (40, 38, 2.8, 1.2, 2024),
(41, 41, 12.0, 3.0, 2024), (41, 42, 6.5, 1.5, 2024), (41, 43, 2.5, 0.5, 2024),
(42, 41, 10.5, 4.5, 2024), (42, 42, 6.0, 2.0, 2024), (42, 43, 2.0, 1.0, 2024),
(43, 46, 17.5, 4.5, 2024), (43, 47, 9.5, 2.5, 2024), (43, 48, 3.2, 0.8, 2024),
(44, 46, 16.0, 6.0, 2024), (44, 47, 9.0, 3.0, 2024), (44, 48, 2.8, 1.2, 2024),
(45, 51, 20.0, 5.0, 2024), (45, 52, 8.0, 2.0, 2024), (45, 53, 4.0, 1.0, 2024),
(46, 51, 18.5, 6.5, 2024), (46, 52, 7.5, 2.5, 2024), (46, 53, 3.5, 1.5, 2024),
(47, 1, 16.5, 8.5, 2024), (47, 2, 7.0, 3.0, 2024), (47, 3, 3.0, 2.0, 2024),
(48, 6, 14.0, 6.0, 2024), (48, 7, 9.0, 3.0, 2024), (48, 8, 2.2, 0.8, 2024),
(49, 11, 24.5, 5.5, 2024), (49, 12, 12.0, 3.0, 2024), (49, 13, 4.5, 0.5, 2024),
(50, 16, 12.5, 2.5, 2024), (50, 17, 6.8, 1.2, 2024), (50, 18, 2.8, 0.2, 2024);

-- =====================================================
-- Sample Data: Leave Requests (50+ records)
-- =====================================================
INSERT INTO leave_requests (employee_id, leave_type_id, start_date, end_date, days_requested, status, approved_by) VALUES
(1, 1, '2024-12-20', '2024-12-24', 5.0, 'approved', 3),
(1, 2, '2024-11-15', '2024-11-15', 1.0, 'approved', 3),
(2, 1, '2024-12-16', '2024-12-20', 5.0, 'approved', 3),
(2, 3, '2024-10-30', '2024-10-30', 1.0, 'approved', 3),
(3, 1, '2024-12-09', '2024-12-13', 5.0, 'approved', 3),
(3, 2, '2024-09-20', '2024-09-20', 1.0, 'approved', 3),
(4, 1, '2024-11-25', '2024-11-29', 5.0, 'approved', 3),
(4, 3, '2024-08-15', '2024-08-15', 1.0, 'approved', 3),
(5, 1, '2024-10-21', '2024-10-25', 5.0, 'approved', 3),
(5, 2, '2024-07-10', '2024-07-10', 1.0, 'approved', 3),
(6, 1, '2024-09-16', '2024-09-20', 5.0, 'approved', 3),
(6, 3, '2024-06-05', '2024-06-05', 1.0, 'approved', 3),
(7, 1, '2024-08-12', '2024-08-16', 5.0, 'approved', 3),
(7, 2, '2024-05-01', '2024-05-01', 1.0, 'approved', 3),
(8, 1, '2024-07-08', '2024-07-12', 5.0, 'approved', 3),
(8, 3, '2024-03-27', '2024-03-27', 1.0, 'approved', 3),
(9, 1, '2024-12-02', '2024-12-06', 5.0, 'pending', 2),
(9, 2, '2024-11-01', '2024-11-01', 1.0, 'pending', 2),
(10, 1, '2024-12-23', '2024-12-27', 5.0, 'pending', 2),
(10, 3, '2024-10-15', '2024-10-15', 1.0, 'pending', 2),
(11, 6, '2024-12-18', '2024-12-20', 3.0, 'approved', 11),
(11, 7, '2024-11-12', '2024-11-12', 1.0, 'approved', 11),
(12, 6, '2024-12-14', '2024-12-16', 3.0, 'approved', 11),
(12, 8, '2024-10-28', '2024-10-28', 1.0, 'approved', 11),
(13, 6, '2024-12-10', '2024-12-12', 3.0, 'approved', 11),
(13, 7, '2024-09-25', '2024-09-25', 1.0, 'approved', 11),
(14, 6, '2024-11-06', '2024-11-08', 3.0, 'approved', 11),
(14, 8, '2024-08-20', '2024-08-20', 1.0, 'approved', 11),
(15, 6, '2024-10-02', '2024-10-04', 3.0, 'approved', 11),
(15, 7, '2024-07-15', '2024-07-15', 1.0, 'approved', 11),
(16, 6, '2024-08-28', '2024-08-30', 3.0, 'approved', 11),
(16, 8, '2024-06-10', '2024-06-10', 1.0, 'approved', 11),
(17, 6, '2024-07-24', '2024-07-26', 3.0, 'approved', 11),
(17, 7, '2024-05-06', '2024-05-06', 1.0, 'approved', 11),
(18, 6, '2024-06-20', '2024-06-22', 3.0, 'approved', 11),
(18, 8, '2024-04-01', '2024-04-01', 1.0, 'approved', 11),
(19, 6, '2024-05-16', '2024-05-18', 3.0, 'approved', 11),
(19, 7, '2024-02-25', '2024-02-25', 1.0, 'approved', 11),
(20, 6, '2024-04-12', '2024-04-14', 3.0, 'approved', 11),
(20, 8, '2024-01-20', '2024-01-20', 1.0, 'approved', 11),
(21, 11, '2024-12-19', '2024-12-23', 5.0, 'approved', 23),
(21, 12, '2024-11-14', '2024-11-14', 1.0, 'approved', 23),
(22, 11, '2024-12-15', '2024-12-19', 5.0, 'approved', 23),
(22, 13, '2024-10-29', '2024-10-29', 1.0, 'approved', 23),
(23, 11, '2024-12-11', '2024-12-15', 5.0, 'approved', 23),
(23, 12, '2024-09-24', '2024-09-24', 1.0, 'approved', 23),
(24, 11, '2024-11-27', '2024-12-01', 5.0, 'approved', 23),
(24, 13, '2024-08-19', '2024-08-19', 1.0, 'approved', 23),
(25, 11, '2024-10-23', '2024-10-27', 5.0, 'approved', 23),
(25, 12, '2024-07-14', '2024-07-14', 1.0, 'approved', 23),
(26, 11, '2024-09-18', '2024-09-22', 5.0, 'approved', 23),
(26, 13, '2024-06-09', '2024-06-09', 1.0, 'approved', 23),
(27, 11, '2024-08-14', '2024-08-18', 5.0, 'approved', 23),
(27, 12, '2024-05-05', '2024-05-05', 1.0, 'approved', 23),
(28, 11, '2024-07-10', '2024-07-14', 5.0, 'approved', 23),
(28, 13, '2024-03-31', '2024-03-31', 1.0, 'approved', 23),
(29, 11, '2024-06-06', '2024-06-10', 5.0, 'approved', 23),
(29, 12, '2024-02-24', '2024-02-24', 1.0, 'approved', 23),
(30, 11, '2024-05-02', '2024-05-06', 5.0, 'approved', 23),
(30, 13, '2024-01-17', '2024-01-17', 1.0, 'approved', 23),
(31, 16, '2024-12-21', '2024-12-22', 2.0, 'pending', NULL),
(31, 17, '2024-11-16', '2024-11-16', 1.0, 'pending', NULL),
(32, 16, '2024-12-17', '2024-12-18', 2.0, 'pending', NULL),
(32, 18, '2024-10-31', '2024-10-31', 1.0, 'pending', NULL),
(33, 21, '2024-12-13', '2024-12-15', 3.0, 'pending', NULL),
(33, 22, '2024-11-08', '2024-11-08', 1.0, 'pending', NULL),
(34, 21, '2024-12-09', '2024-12-11', 3.0, 'pending', NULL),
(34, 23, '2024-10-23', '2024-10-23', 1.0, 'pending', NULL),
(35, 26, '2024-12-05', '2024-12-09', 5.0, 'pending', NULL),
(35, 27, '2024-11-01', '2024-11-01', 1.0, 'pending', NULL),
(36, 26, '2024-12-01', '2024-12-05', 5.0, 'pending', NULL),
(36, 28, '2024-10-16', '2024-10-16', 1.0, 'pending', NULL),
(37, 31, '2024-11-27', '2024-11-29', 3.0, 'pending', NULL),
(37, 32, '2024-10-22', '2024-10-22', 1.0, 'pending', NULL),
(38, 31, '2024-11-23', '2024-11-25', 3.0, 'pending', NULL),
(38, 33, '2024-10-08', '2024-10-08', 1.0, 'pending', NULL),
(39, 36, '2024-11-19', '2024-11-21', 3.0, 'pending', NULL),
(39, 37, '2024-10-14', '2024-10-14', 1.0, 'pending', NULL),
(40, 36, '2024-11-15', '2024-11-17', 3.0, 'pending', NULL),
(40, 38, '2024-09-30', '2024-09-30', 1.0, 'pending', NULL),
(41, 41, '2024-11-11', '2024-11-12', 2.0, 'pending', NULL),
(41, 42, '2024-10-06', '2024-10-06', 1.0, 'pending', NULL),
(42, 41, '2024-11-07', '2024-11-08', 2.0, 'pending', NULL),
(42, 43, '2024-09-22', '2024-09-22', 1.0, 'pending', NULL),
(43, 46, '2024-11-03', '2024-11-05', 3.0, 'pending', NULL),
(43, 47, '2024-09-18', '2024-09-18', 1.0, 'pending', NULL),
(44, 46, '2024-10-30', '2024-11-01', 3.0, 'pending', NULL),
(44, 48, '2024-09-14', '2024-09-14', 1.0, 'pending', NULL),
(45, 51, '2024-10-26', '2024-10-28', 3.0, 'pending', NULL),
(45, 52, '2024-09-10', '2024-09-10', 1.0, 'pending', NULL),
(46, 51, '2024-10-22', '2024-10-24', 3.0, 'pending', NULL),
(46, 53, '2024-09-06', '2024-09-06', 1.0, 'pending', NULL),
(47, 1, '2024-10-18', '2024-10-20', 3.0, 'pending', NULL),
(47, 2, '2024-09-02', '2024-09-02', 1.0, 'pending', NULL),
(48, 6, '2024-10-14', '2024-10-16', 3.0, 'pending', NULL),
(48, 7, '2024-08-29', '2024-08-29', 1.0, 'pending', NULL),
(49, 11, '2024-10-10', '2024-10-12', 3.0, 'pending', NULL),
(49, 12, '2024-08-25', '2024-08-25', 1.0, 'pending', NULL),
(50, 16, '2024-10-06', '2024-10-07', 2.0, 'pending', NULL),
(50, 17, '2024-08-21', '2024-08-21', 1.0, 'pending', NULL);

-- =====================================================
-- Sample Data: Attendance Records (200+ records for November-December 2024)
-- =====================================================
INSERT INTO attendance_records (employee_id, attendance_date, clock_in, clock_out, status, hours_worked) VALUES
-- Tech Solutions employees (Admin 2) - November 2024
(1, '2024-11-01', '09:00:00', '17:00:00', 'present', 8.0),
(1, '2024-11-02', '09:15:00', '17:30:00', 'present', 8.25),
(1, '2024-11-03', '08:45:00', '16:45:00', 'present', 8.0),
(1, '2024-11-04', '09:00:00', '17:00:00', 'present', 8.0),
(1, '2024-11-05', '09:30:00', '18:00:00', 'present', 8.5),
(1, '2024-11-06', NULL, NULL, 'absent', 0.0),
(1, '2024-11-07', '09:00:00', '17:00:00', 'present', 8.0),
(1, '2024-11-08', '08:50:00', '16:50:00', 'present', 8.0),
(1, '2024-11-09', '09:20:00', '17:20:00', 'present', 8.0),
(1, '2024-11-10', '09:00:00', '17:00:00', 'present', 8.0),
(2, '2024-11-01', '09:00:00', '17:00:00', 'present', 8.0),
(2, '2024-11-02', '09:00:00', '17:00:00', 'present', 8.0),
(2, '2024-11-03', '09:00:00', '17:00:00', 'present', 8.0),
(2, '2024-11-04', '09:00:00', '17:00:00', 'present', 8.0),
(2, '2024-11-05', '09:00:00', '17:00:00', 'present', 8.0),
(2, '2024-11-06', '09:00:00', '17:00:00', 'present', 8.0),
(2, '2024-11-07', '09:00:00', '17:00:00', 'present', 8.0),
(2, '2024-11-08', '09:00:00', '17:00:00', 'present', 8.0),
(2, '2024-11-09', '09:00:00', '17:00:00', 'present', 8.0),
(2, '2024-11-10', '09:00:00', '17:00:00', 'present', 8.0),
(3, '2024-11-01', '08:30:00', '16:30:00', 'present', 8.0),
(3, '2024-11-02', '08:30:00', '16:30:00', 'present', 8.0),
(3, '2024-11-03', '08:30:00', '16:30:00', 'present', 8.0),
(3, '2024-11-04', '08:30:00', '16:30:00', 'present', 8.0),
(3, '2024-11-05', '08:30:00', '16:30:00', 'present', 8.0),
(3, '2024-11-06', '08:30:00', '16:30:00', 'present', 8.0),
(3, '2024-11-07', '08:30:00', '16:30:00', 'present', 8.0),
(3, '2024-11-08', '08:30:00', '16:30:00', 'present', 8.0),
(3, '2024-11-09', '08:30:00', '16:30:00', 'present', 8.0),
(3, '2024-11-10', '08:30:00', '16:30:00', 'present', 8.0),

-- Global Manufacturing employees (Admin 3) - November 2024
(11, '2024-11-01', '07:00:00', '15:00:00', 'present', 8.0),
(11, '2024-11-02', '07:00:00', '15:00:00', 'present', 8.0),
(11, '2024-11-03', '07:00:00', '15:00:00', 'present', 8.0),
(11, '2024-11-04', '07:00:00', '15:00:00', 'present', 8.0),
(11, '2024-11-05', '07:00:00', '15:00:00', 'present', 8.0),
(11, '2024-11-06', '07:00:00', '15:00:00', 'present', 8.0),
(11, '2024-11-07', '07:00:00', '15:00:00', 'present', 8.0),
(11, '2024-11-08', '07:00:00', '15:00:00', 'present', 8.0),
(11, '2024-11-09', '07:00:00', '15:00:00', 'present', 8.0),
(11, '2024-11-10', '07:00:00', '15:00:00', 'present', 8.0),
(12, '2024-11-01', '07:30:00', '15:30:00', 'present', 8.0),
(12, '2024-11-02', '07:30:00', '15:30:00', 'present', 8.0),
(12, '2024-11-03', '07:30:00', '15:30:00', 'present', 8.0),
(12, '2024-11-04', '07:30:00', '15:30:00', 'present', 8.0),
(12, '2024-11-05', '07:30:00', '15:30:00', 'present', 8.0),
(12, '2024-11-06', '07:30:00', '15:30:00', 'present', 8.0),
(12, '2024-11-07', '07:30:00', '15:30:00', 'present', 8.0),
(12, '2024-11-08', '07:30:00', '15:30:00', 'present', 8.0),
(12, '2024-11-09', '07:30:00', '15:30:00', 'present', 8.0),
(12, '2024-11-10', '07:30:00', '15:30:00', 'present', 8.0),

-- Healthcare Plus employees (Admin 4) - November 2024
(21, '2024-11-01', '08:00:00', '16:00:00', 'present', 8.0),
(21, '2024-11-02', '08:00:00', '16:00:00', 'present', 8.0),
(21, '2024-11-03', '08:00:00', '16:00:00', 'present', 8.0),
(21, '2024-11-04', '08:00:00', '16:00:00', 'present', 8.0),
(21, '2024-11-05', '08:00:00', '16:00:00', 'present', 8.0),
(21, '2024-11-06', '08:00:00', '16:00:00', 'present', 8.0),
(21, '2024-11-07', '08:00:00', '16:00:00', 'present', 8.0),
(21, '2024-11-08', '08:00:00', '16:00:00', 'present', 8.0),
(21, '2024-11-09', '08:00:00', '16:00:00', 'present', 8.0),
(21, '2024-11-10', '08:00:00', '16:00:00', 'present', 8.0),
(22, '2024-11-01', '07:00:00', '19:00:00', 'present', 12.0),
(22, '2024-11-02', '07:00:00', '19:00:00', 'present', 12.0),
(22, '2024-11-03', '07:00:00', '19:00:00', 'present', 12.0),
(22, '2024-11-04', '07:00:00', '19:00:00', 'present', 12.0),
(22, '2024-11-05', '07:00:00', '19:00:00', 'present', 12.0),
(22, '2024-11-06', '07:00:00', '19:00:00', 'present', 12.0),
(22, '2024-11-07', '07:00:00', '19:00:00', 'present', 12.0),
(22, '2024-11-08', '07:00:00', '19:00:00', 'present', 12.0),
(22, '2024-11-09', '07:00:00', '19:00:00', 'present', 12.0),
(22, '2024-11-10', '07:00:00', '19:00:00', 'present', 12.0),

-- December 2024 records for various employees
(1, '2024-12-01', '09:00:00', '17:00:00', 'present', 8.0),
(1, '2024-12-02', '09:00:00', '17:00:00', 'present', 8.0),
(1, '2024-12-03', '09:00:00', '17:00:00', 'present', 8.0),
(1, '2024-12-04', '09:00:00', '17:00:00', 'present', 8.0),
(1, '2024-12-05', '09:00:00', '17:00:00', 'present', 8.0),
(1, '2024-12-06', '09:00:00', '17:00:00', 'present', 8.0),
(2, '2024-12-01', '09:00:00', '17:00:00', 'present', 8.0),
(2, '2024-12-02', '09:00:00', '17:00:00', 'present', 8.0),
(2, '2024-12-03', '09:00:00', '17:00:00', 'present', 8.0),
(2, '2024-12-04', '09:00:00', '17:00:00', 'present', 8.0),
(2, '2024-12-05', '09:00:00', '17:00:00', 'present', 8.0),
(2, '2024-12-06', '09:00:00', '17:00:00', 'present', 8.0),
(3, '2024-12-01', '08:30:00', '16:30:00', 'present', 8.0),
(3, '2024-12-02', '08:30:00', '16:30:00', 'present', 8.0),
(3, '2024-12-03', '08:30:00', '16:30:00', 'present', 8.0),
(3, '2024-12-04', '08:30:00', '16:30:00', 'present', 8.0),
(3, '2024-12-05', '08:30:00', '16:30:00', 'present', 8.0),
(3, '2024-12-06', '08:30:00', '16:30:00', 'present', 8.0),
(11, '2024-12-01', '07:00:00', '15:00:00', 'present', 8.0),
(11, '2024-12-02', '07:00:00', '15:00:00', 'present', 8.0),
(11, '2024-12-03', '07:00:00', '15:00:00', 'present', 8.0),
(11, '2024-12-04', '07:00:00', '15:00:00', 'present', 8.0),
(11, '2024-12-05', '07:00:00', '15:00:00', 'present', 8.0),
(11, '2024-12-06', '07:00:00', '15:00:00', 'present', 8.0),
(21, '2024-12-01', '08:00:00', '16:00:00', 'present', 8.0),
(21, '2024-12-02', '08:00:00', '16:00:00', 'present', 8.0),
(21, '2024-12-03', '08:00:00', '16:00:00', 'present', 8.0),
(21, '2024-12-04', '08:00:00', '16:00:00', 'present', 8.0),
(21, '2024-12-05', '08:00:00', '16:00:00', 'present', 8.0),
(21, '2024-12-06', '08:00:00', '16:00:00', 'present', 8.0),
(22, '2024-12-01', '07:00:00', '19:00:00', 'present', 12.0),
(22, '2024-12-02', '07:00:00', '19:00:00', 'present', 12.0),
(22, '2024-12-03', '07:00:00', '19:00:00', 'present', 12.0),
(22, '2024-12-04', '07:00:00', '19:00:00', 'present', 12.0),
(22, '2024-12-05', '07:00:00', '19:00:00', 'present', 12.0),
(22, '2024-12-06', '07:00:00', '19:00:00', 'present', 12.0),

-- Some absent/late records for variety
(1, '2024-11-15', NULL, NULL, 'absent', 0.0),
(2, '2024-11-18', '09:30:00', '17:30:00', 'late', 8.0),
(3, '2024-11-22', NULL, NULL, 'absent', 0.0),
(11, '2024-11-25', '07:45:00', '15:45:00', 'late', 8.0),
(21, '2024-11-28', NULL, NULL, 'absent', 0.0),
(22, '2024-12-07', '07:30:00', '19:30:00', 'late', 12.0),

-- Half day records
(1, '2024-11-29', '09:00:00', '13:00:00', 'half_day', 4.0),
(2, '2024-11-30', '09:00:00', '13:00:00', 'half_day', 4.0),
(3, '2024-12-07', '08:30:00', '12:30:00', 'half_day', 4.0),
(11, '2024-12-07', '07:00:00', '11:00:00', 'half_day', 4.0),
(21, '2024-12-07', '08:00:00', '12:00:00', 'half_day', 4.0),
(22, '2024-12-08', '07:00:00', '11:00:00', 'half_day', 4.0);

-- =====================================================
-- Sample Data: Pay Components
-- =====================================================
INSERT INTO pay_components (admin_id, component_name, component_type, is_taxable, is_fixed) VALUES
(2, 'Basic Salary', 'earning', TRUE, TRUE),
(2, 'House Rent Allowance', 'earning', TRUE, TRUE),
(2, 'Conveyance Allowance', 'earning', TRUE, TRUE),
(2, 'Medical Allowance', 'earning', TRUE, TRUE),
(2, 'LTA', 'earning', TRUE, TRUE),
(2, 'Professional Tax', 'deduction', FALSE, TRUE),
(2, 'Provident Fund', 'deduction', FALSE, TRUE),
(2, 'Income Tax', 'deduction', TRUE, FALSE),
(2, 'Performance Bonus', 'earning', TRUE, FALSE),
(2, 'Overtime Pay', 'earning', TRUE, FALSE),
(3, 'Basic Salary', 'earning', TRUE, TRUE),
(3, 'House Rent Allowance', 'earning', TRUE, TRUE),
(3, 'Conveyance Allowance', 'earning', TRUE, TRUE),
(3, 'Shift Allowance', 'earning', TRUE, TRUE),
(3, 'Danger Pay', 'earning', TRUE, TRUE),
(3, 'Professional Tax', 'deduction', FALSE, TRUE),
(3, 'Provident Fund', 'deduction', FALSE, TRUE),
(3, 'Income Tax', 'deduction', TRUE, FALSE),
(3, 'Production Bonus', 'earning', TRUE, FALSE),
(3, 'Overtime Pay', 'earning', TRUE, FALSE),
(4, 'Basic Salary', 'earning', TRUE, TRUE),
(4, 'House Rent Allowance', 'earning', TRUE, TRUE),
(4, 'Conveyance Allowance', 'earning', TRUE, TRUE),
(4, 'Night Shift Allowance', 'earning', TRUE, TRUE),
(4, 'On Call Allowance', 'earning', TRUE, TRUE),
(4, 'Professional Tax', 'deduction', FALSE, TRUE),
(4, 'Provident Fund', 'deduction', FALSE, TRUE),
(4, 'Income Tax', 'deduction', TRUE, FALSE),
(4, 'Clinical Excellence Bonus', 'earning', TRUE, FALSE),
(4, 'Overtime Pay', 'earning', TRUE, FALSE),
(5, 'Basic Salary', 'earning', TRUE, TRUE),
(5, 'House Rent Allowance', 'earning', TRUE, TRUE),
(5, 'Conveyance Allowance', 'earning', TRUE, TRUE),
(5, 'Uniform Allowance', 'earning', TRUE, TRUE),
(5, 'Commission', 'earning', TRUE, FALSE),
(5, 'Professional Tax', 'deduction', FALSE, TRUE),
(5, 'Provident Fund', 'deduction', FALSE, TRUE),
(5, 'Income Tax', 'deduction', TRUE, FALSE),
(5, 'Sales Bonus', 'earning', TRUE, FALSE),
(5, 'Overtime Pay', 'earning', TRUE, FALSE);

-- =====================================================
-- Sample Data: Salary Templates
-- =====================================================
INSERT INTO salary_templates (admin_id, template_name, grade_level, base_salary) VALUES
(2, 'Entry Level Engineer', 'L1', 30000.00),
(2, 'Junior Engineer', 'L2', 45000.00),
(2, 'Senior Engineer', 'L3', 65000.00),
(2, 'Tech Lead', 'L4', 85000.00),
(2, 'Engineering Manager', 'M1', 105000.00),
(2, 'Senior Manager', 'M2', 135000.00),
(3, 'Production Worker', 'L1', 25000.00),
(3, 'Senior Worker', 'L2', 35000.00),
(3, 'Supervisor', 'L3', 45000.00),
(3, 'Production Manager', 'M1', 65000.00),
(3, 'Plant Manager', 'M2', 85000.00),
(4, 'Staff Nurse', 'L1', 35000.00),
(4, 'Senior Nurse', 'L2', 45000.00),
(4, 'Nurse Practitioner', 'L3', 60000.00),
(4, 'Charge Nurse', 'M1', 70000.00),
(4, 'Nursing Director', 'M2', 95000.00),
(5, 'Sales Associate', 'L1', 28000.00),
(5, 'Senior Sales Associate', 'L2', 38000.00),
(5, 'Sales Supervisor', 'L3', 50000.00),
(5, 'Store Manager', 'M1', 65000.00),
(5, 'Regional Manager', 'M2', 85000.00);

-- =====================================================
-- Sample Data: Employee Salaries
-- =====================================================
INSERT INTO employee_salaries (employee_id, template_id, effective_date, is_active) VALUES
(1, 2, '2023-01-15', TRUE),
(2, 3, '2023-03-20', TRUE),
(3, 5, '2023-02-10', TRUE),
(4, 3, '2023-04-05', TRUE),
(5, 2, '2023-05-12', TRUE),
(6, 6, '2023-06-18', TRUE),
(7, 3, '2023-07-22', TRUE),
(8, 2, '2023-08-30', TRUE),
(9, 1, '2023-09-14', TRUE),
(10, 2, '2023-10-08', TRUE),
(11, 7, '2022-11-15', TRUE),
(12, 7, '2023-01-20', TRUE),
(13, 8, '2023-02-25', TRUE),
(14, 8, '2023-03-30', TRUE),
(15, 9, '2023-04-15', TRUE),
(16, 10, '2023-05-20', TRUE),
(17, 10, '2023-06-10', TRUE),
(18, 10, '2023-07-05', TRUE),
(19, 9, '2023-08-12', TRUE),
(20, 8, '2023-09-18', TRUE),
(21, 12, '2023-01-10', TRUE),
(22, 13, '2023-02-15', TRUE),
(23, 12, '2023-03-20', TRUE),
(24, 14, '2023-04-25', TRUE),
(25, 12, '2023-05-30', TRUE),
(26, 13, '2023-06-15', TRUE),
(27, 15, '2023-07-20', TRUE),
(28, 15, '2023-08-10', TRUE),
(29, 12, '2023-09-15', TRUE),
(30, 13, '2023-10-20', TRUE),
(31, 16, '2023-01-05', TRUE),
(32, 16, '2023-02-10', TRUE),
(33, 17, '2023-03-15', TRUE),
(34, 18, '2023-04-20', TRUE),
(35, 19, '2023-05-25', TRUE),
(36, 19, '2023-06-30', TRUE),
(37, 20, '2023-07-05', TRUE),
(38, 20, '2023-08-10', TRUE),
(39, 21, '2023-09-15', TRUE),
(40, 21, '2023-10-20', TRUE);

-- =====================================================
-- Sample Data: Bonus Records
-- =====================================================
INSERT INTO bonus_records (employee_id, component_id, amount, bonus_date, description) VALUES
(1, 9, 5000.00, '2024-12-01', 'Q4 Performance Bonus'),
(2, 9, 7500.00, '2024-12-01', 'Q4 Performance Bonus'),
(3, 9, 8000.00, '2024-12-01', 'Q4 Performance Bonus'),
(4, 9, 6000.00, '2024-12-01', 'Q4 Performance Bonus'),
(5, 9, 5500.00, '2024-12-01', 'Q4 Performance Bonus'),
(6, 9, 9000.00, '2024-12-01', 'Q4 Performance Bonus'),
(7, 9, 6500.00, '2024-12-01', 'Q4 Performance Bonus'),
(8, 9, 5000.00, '2024-12-01', 'Q4 Performance Bonus'),
(9, 9, 4500.00, '2024-12-01', 'Q4 Performance Bonus'),
(10, 9, 5500.00, '2024-12-01', 'Q4 Performance Bonus'),
(11, 19, 3000.00, '2024-11-30', 'Production Excellence Bonus'),
(12, 19, 2500.00, '2024-11-30', 'Production Excellence Bonus'),
(13, 19, 3500.00, '2024-11-30', 'Production Excellence Bonus'),
(14, 19, 2800.00, '2024-11-30', 'Production Excellence Bonus'),
(15, 19, 3200.00, '2024-11-30', 'Production Excellence Bonus'),
(16, 19, 4000.00, '2024-11-30', 'Production Excellence Bonus'),
(17, 19, 3800.00, '2024-11-30', 'Production Excellence Bonus'),
(18, 19, 3600.00, '2024-11-30', 'Production Excellence Bonus'),
(19, 19, 2900.00, '2024-11-30', 'Production Excellence Bonus'),
(20, 19, 3100.00, '2024-11-30', 'Production Excellence Bonus'),
(21, 29, 4000.00, '2024-12-01', 'Clinical Excellence Bonus'),
(22, 29, 5500.00, '2024-12-01', 'Clinical Excellence Bonus'),
(23, 29, 3500.00, '2024-12-01', 'Clinical Excellence Bonus'),
(24, 29, 6000.00, '2024-12-01', 'Clinical Excellence Bonus'),
(25, 29, 3800.00, '2024-12-01', 'Clinical Excellence Bonus'),
(26, 29, 4200.00, '2024-12-01', 'Clinical Excellence Bonus'),
(27, 29, 6500.00, '2024-12-01', 'Clinical Excellence Bonus'),
(28, 29, 5800.00, '2024-12-01', 'Clinical Excellence Bonus'),
(29, 29, 3600.00, '2024-12-01', 'Clinical Excellence Bonus'),
(30, 29, 4100.00, '2024-12-01', 'Clinical Excellence Bonus'),
(31, 39, 2000.00, '2024-11-30', 'Sales Commission'),
(32, 39, 1800.00, '2024-11-30', 'Sales Commission'),
(33, 39, 2500.00, '2024-11-30', 'Sales Commission'),
(34, 39, 3200.00, '2024-11-30', 'Sales Commission'),
(35, 39, 2800.00, '2024-11-30', 'Sales Commission'),
(36, 39, 2600.00, '2024-11-30', 'Sales Commission'),
(37, 39, 3500.00, '2024-11-30', 'Sales Commission'),
(38, 39, 4100.00, '2024-11-30', 'Sales Commission'),
(39, 39, 2900.00, '2024-11-30', 'Sales Commission'),
(40, 39, 2700.00, '2024-11-30', 'Sales Commission');

-- =====================================================
-- Sample Data: Admin Settings
-- =====================================================
INSERT INTO admin_settings (admin_id, setting_key, setting_value) VALUES
(2, 'company_timezone', 'America/Los_Angeles'),
(2, 'working_hours_start', '09:00:00'),
(2, 'working_hours_end', '17:00:00'),
(2, 'leave_approval_required', 'true'),
(2, 'auto_leave_accrual', 'true'),
(3, 'company_timezone', 'America/Detroit'),
(3, 'working_hours_start', '07:00:00'),
(3, 'working_hours_end', '15:00:00'),
(3, 'leave_approval_required', 'true'),
(3, 'auto_leave_accrual', 'true'),
(4, 'company_timezone', 'America/New_York'),
(4, 'working_hours_start', '08:00:00'),
(4, 'working_hours_end', '16:00:00'),
(4, 'leave_approval_required', 'true'),
(4, 'auto_leave_accrual', 'true'),
(5, 'company_timezone', 'America/New_York'),
(5, 'working_hours_start', '09:00:00'),
(5, 'working_hours_end', '17:00:00'),
(5, 'leave_approval_required', 'true'),
(5, 'auto_leave_accrual', 'true');

COMMIT;
