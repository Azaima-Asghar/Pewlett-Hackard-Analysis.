-- Create queries to analyze the data in the tabels and see which employees
-- will be retiring soon from the Pewlett Hackard company. 

-- Check employees birthday to determine when they will retire.
SELECT first_name, last_name 
FROM employees 
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

-- Get the birthdays of employees in 1952 only.
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31'

-- Get the birthdays of employees in 1953 only.
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31'

-- Get the birthdays of employees in 1954 only.
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31'

-- Get the birthdays of employees in 1955 only.
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31'

-- Check employees birthday to determine when they will retire given they 
-- hired between 1985 and 1988.
SELECT first_name, last_name 
FROM employees 
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31'
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Get the number of employees retiring.
SELECT COUNT(first_name) 
FROM employees 
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31'
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Create a table to contain information for employees who will be retiring soon.
SELECT first_name, last_name
INTO retirement_info
FROM employees 
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31'
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- View the contents of retirement_info tabel.
SELECT * FROM retirement_info;