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

-- Drop previously created retirement_info tabel. 
DROP TABLE retirement_info;

-- Recreate retirement_info table with unique identifier (emp_no).
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31'
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- View the content of retirement_info table.
SELECT * FROM retirement_info;

-- JOining Tables.

-- Joining deparments and managers tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- Joining deparments and managers tables using aliases.
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments AS d
INNER JOIN dept_manager AS dm
ON d.dept_no = dm.dept_no;

-- Joining retirement_info and dept_emp tables.
SELECT retirement_info.emp_no,
	retirement_info.first_name,
retirement_info.last_name,
	dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

-- Using aliases to join retirement_info and dept_emp tables.
SELECT ri.emp_no,
    ri.first_name,
	ri.last_name,
	de.to_date
FROM retirement_info AS ri
LEFT JOIN dept_emp AS de
ON ri.emp_no = de.emp_no;

-- Join retirement_info and dept_emp tables to get current employees who
-- are eligible for retirement
SELECT ri.emp_no,
     ri.first_name,
	 ri.last_name,
	 de.to_date
INTO current_emp
FROM retirement_info AS ri
LEFT JOIN dept_emp AS de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
INTO employee_count
FROM current_emp AS ce
LEFT JOIN dept_emp AS de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM employee_count;

-- Employee Information: A list of employees containing their unique employee 
-- number, their last name, first name, gender, and salary.

-- View data in salaries table to see the dates.
SELECT * FROM salaries
ORDER BY to_date DESC;

-- Get the updated information from employees tabel with the gender of employee also included. 
SELECT emp_no, first_name, last_name, gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Updating the previous code.
-- Join emp_info table to the salaries table to add the to_date and Salary columns.
SELECT e.emp_no,
	 e.first_name, 
	 e.last_name, 
	 e.gender, 
	 s.salary, 
	 de.to_date
INTO emp_info
FROM employees AS e
INNER JOIN salaries AS s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp AS de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

-- View the content of emp_info table. 
SELECT * FROM emp_info;

-- Management: A list of managers for each department, including the department number, 
-- name, and the manager’s employee number, last name,first name, and the starting
-- and ending employment dates.

-- List of managers per deparment.
SELECT dm.dept_no,
     d.dept_name,
	 dm.emp_no,
	 ce.first_name, 
	 ce.last_name,
	 dm.from_date,
	 dm.to_date
INTO manager_info
FROM dept_manager AS dm
INNER JOIN departments AS d
     ON (dm.dept_no = d.dept_no)
INNER JOIN current_emp AS ce
     ON (dm.emp_no = ce.emp_no);

-- View the content of manager_info table.
SELECT * FROM manager_info;

-- Department Retirees: An updated current_emp list 
-- that includes everything it currently has, but also the employee’s departments.

SELECT ce.emp_no,
	 ce.first_name,
	 ce.last_name,
	 ce.to_date,
	 d.dept_name
INTO dept_info
FROM current_emp AS ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (d.dept_no = de.dept_no);

SELECT * FROM dept_info;

-- QUESTION TO ASK THE MANAGER:

-- What’s going on with the salaries?
-- Why are there only five active managers for nine departments?
-- Why are some employees appearing twice?

-- Employees only in the sales department.

SELECT d.emp_no, d.first_name, d.last_name, d.dept_name
FROM dept_info AS d
WHERE (d.dept_name = 'Sales');

-- Employees in the sales and development department.
SELECT d.emp_no, d.first_name, d.last_name, d.dept_name
FROM dept_info AS d
 WHERE d.dept_name IN('Sales','Development');