# Product Context

Describe the product.

## Overview

Provide a high-level overview of the project.

## Core Features

- Feature 1
- Feature 2

## Technical Stack

- Tech 1
- Tech 2

## Project Description

A database-driven Human Resources Management System supporting employee lifecycle management, leave tracking, time and attendance, and payroll operations across multiple organizations.



## Architecture

Multi-tenant database architecture with tenant isolation. Superadmin manages multiple admins (tenants), each admin manages their organization's data. Hierarchical access control: Superadmin → Admin → Employee data. All modules share tenant_id for data segregation.



## Technologies

- MySQL 8.0+
- MySQL Workbench
- ERD Design Tool (Lucidchart/Draw.io)
- Dashboard visualization tool (Excel, Power BI, Tableau, or web-based charts)



## Libraries and Dependencies

- MySQL JDBC Driver (if using Java for dashboard)
- Chart.js or similar (if using web-based dashboard)
- Pandas/Matplotlib (if using Python for dashboard)
- No backend frameworks required

