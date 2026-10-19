# Khayal Restaurant – Database Management System

A relational database system for a restaurant, built as a team project for the 
"Introduction to Databases" course at Umm Al-Qura University. The database manages 
customers, employees, menu items, reservations, orders, and payments.

## Overview
The system was designed using MySQL and includes 10 related tables with primary 
and foreign keys, data constraints, and 10 SQL queries demonstrating core database 
operations.

## Database Design
The schema covers the main entities of a restaurant:
- **Departments & Employees** – staff and their roles
- **Customers** – customer records
- **Menu & Categories** – food items grouped by category
- **Tables & Reservations** – seating and bookings
- **Orders & Order Details** – customer orders and their items
- **Payments** – payment records linked to orders

## Features
- 10 related tables with primary/foreign keys and CHECK constraints
- Sample data for all tables
- 10 SQL queries covering: DISTINCT, ORDER BY, GROUP BY, aggregate functions 
  (AVG, COUNT), subqueries, UNION, JOINs (including multi-table joins), and 
  logical operators

## Example Queries
```sql
-- Distinct table locations, sorted
SELECT DISTINCT Location FROM RestaurantTable ORDER BY Location ASC;

-- Average salary per employee role
SELECT Role, AVG(Salary) AS Average_Salary FROM Employee GROUP BY Role;
```

## How to Run
1. Open MySQL.
2. Run the `final_project.sql` file to create the database, tables, and sample data.
3. Execute the included queries to view the results.

## My Role
This was a team project. My contribution included designing one of the main tables, 
writing and explaining two of the SQL queries, and preparing the project 
presentation and part of the report.
