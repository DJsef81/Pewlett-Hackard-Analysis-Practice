
-- List of employees born 1952-1955
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

-- List of employees born in 1952
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

-- List of employees born in 1953
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

-- List of employees born in 1954
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

-- List of employees born in 1955
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') 
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Create list of retiring employees
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;

-- retirement info doesn't have enough info. Delete and lets start again. 
DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- Joining retirement_info and dept_emp tables
SELECT ri.emp_no,
    ri.first_name,
ri.last_name,
    de.to_date
-- assign the left table with FROM	
FROM retirement_info as ri
LEFT JOIN dept_emp as de
-- tell Postgres where the two tables are linked with the ON
ON ri.emp_no = de.emp_no;

-- Joining departments and dept_manager tables
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

-- Create table of current employees who are eligible for retirement 
SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
INTO dept_no_emp_count
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- NEW LISTS TO MAKE 
-- 1. Employee Information: A list of employees containing their unique employee number, 
-- their last name, first name, gender, and salary

-- 2. Management: A list of managers for each department, including the department number,
--  name, and the manager's employee number, last name, first name, and the starting and
--  ending employment dates

-- 3. Department Retirees: An updated current_emp list that includes everything it 
-- currently has, but also the employee's departments

-- Check if salaries.csv "to_date" column aligns with the employment date or something else. 
SELECT * FROM salaries
ORDER BY to_date DESC;
-- It's certainly not the most recent date of employment, so it must have 
-- something to do with salaries.
-- We made code to filter the Employees table

-- Employee Information List 
SELECT e.emp_no,
    e.first_name,
e.last_name,
    e.gender,
    s.salary,
    de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	      AND (de.to_date = '9999-01-01');
		  
-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);
		
-- Department Retirees
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

-- Questions raised from our 3 lists
-- What's going on with the salaries?
-- Why are there only five active managers for nine departments?
-- Why are some employees appearing twice?


--Create a query that will return only the information relevant to the Sales team.
SELECT re.emp_no,
	re.first_name,
	re.last_name,
	de.dept_name
INTO sales_info
FROM retirement_info AS re
INNER JOIN dept_info AS de
	ON(re.emp_no = de.emp_no)
WHERE de.dept_name = 'Sales'

-- view sales_info table
SELECT*FROM sales_info


-- sales and development merge
-- with th WHERE clause The IN condition is necessary because you're creating two items +
-- in the same column.
SELECT re.emp_no,
	re.first_name,
	re.last_name,
	de.dept_name
INTO sales_and_dev_info
FROM retirement_info AS re
INNER JOIN dept_info AS de
	ON(re.emp_no = de.emp_no)
WHERE de.dept_name IN ('Sales', 'Development')

-- view sales_and_dev info
SELECT*FROM sales_and_dev_info