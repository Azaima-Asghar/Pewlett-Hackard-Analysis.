--- CHALLENGE 

-- Number of [title] retiring.
-- Current employees eligible for retirement.

SELECT e.emp_no,
	 e.first_name,
	 e.last_name,
	 ti.title,
	 ti.from_date,
	 s.salary
INTO employees_retiring_info
FROM employees AS e
INNER JOIN titles AS ti
ON (e.emp_no = ti.emp_no)
INNER JOIN salaries AS s
ON (e.emp_no = s.emp_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- View content of employees_retiring_info table.
SELECT * FROM employees_retiring_info;

-- Find duplicate rows in the employees_retiring_info table.
SELECT first_name, 
	 last_name,
	 COUNT(*)
FROM employees_retiring_info
GROUP BY
	 first_name,
	 last_name
HAVING count(*) >1;

-- Get all the information for the duplicate rows in the employees_retiring_info table.
SELECT * FROM 
	 (SELECT *, COUNT(*)
	 OVER (PARTITION BY
		  first_name,
		  last_name
		  )AS count
	 FROM employees_retiring_info) tableWithCount
	 WHERE tableWithCount.count >1;

-- Get absolute identical rows in employees_retiring_info table.
SELECT DISTINCT * FROM employees_retiring_info;

-- Get almost identical rows in employees_retiring_info table.
SELECT DISTINCT ON( first_name, last_name) * FROM employees_retiring_info;

-- Delete unwanted duplicates in employees_retiring_info table.
SELECT emp_no,
	 first_name,
	 last_name,
	 title,
	 from_date,
	 salary
INTO employees_duplicatefree_info
FROM ( SELECT emp_no,
	 first_name,
	 last_name,
	 title,
	 from_date,
	 salary,
	 ROW_NUMBER() OVER
	 (PARTITION BY (first_name, last_name) ORDER BY from_date DESC) rn
	  FROM employees_retiring_info
	 ) tmp WHERE rn = 1;

SELECT * FROM employees_duplicatefree_info;

-- Get the frequency count of employee title.
SELECT title, 
COUNT(*) 
INTO titles_frequency
FROM employees_duplicatefree_info
GROUP BY title;

SELECT * FROM titles_frequency;

-- Table for mentors.
SELECT e.emp_no,
	 e.first_name,
	 e.last_name,
	 ti.title,
	 ti.from_date,
	 ti.to_date
INTO mentors_info
FROM employees AS e
INNER JOIN titles AS ti
ON (e.emp_no = ti.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (ti.to_date = '9999-01-01');

-- View contents of mentors_info table. 
SELECT * FROM mentors_info;

-- Count the number of employees that are ready for to be mentors. 
SELECT COUNT(*) FROM mentors_info;

-- 691 employees are ready to mentor new hired people in the future. 