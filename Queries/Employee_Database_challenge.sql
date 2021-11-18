--Creating Retirement_titles
SELECT  
	e.emp_no,
	e.first_name,
	e.last_name,
	ti.title,
	ti.from_date,
	ti.to_date
INTO Retirement_titles
FROM employees AS e
INNER JOIN titles AS ti
ON (e.emp_no = ti.emp_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no
	
SELECT*FROM retirement_titles

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (rt.emp_no) rt.title,
	rt.emp_no,
	rt.first_name,
	rt.last_name
INTO change_table
FROM retirement_titles AS rt
ORDER BY rt.emp_no, rt.to_date DESC;

SELECT
	ch.emp_no,
	ch.first_name,
	ch.last_name,
	ch.title
Into unique_titles
FROM change_table AS ch

-- Create retiring Titles table (retrieve the number of employees by their most recent job title who are about to retire.)
SELECT COUNT (un.emp_no), un.title
INTO retiring_titles
FROM unique_titles AS un
GROUP by un.title
ORDER by un.count DESC;
SELECT*FROM retiring_titles

--Creating mentorship_eligibility
SELECT DISTINCT ON (e.emp_no) ti.title,
	e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date
INTO initial_table
FROM employees AS e
INNER JOIN dept_emp AS de
ON (e.emp_no = de.emp_no)
INNER JOIN titles AS ti
ON (e.emp_no = ti.emp_no)
WHERE (birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no

SELECT*FROM initial_table

SELECT 
	it.emp_no,
 	it.first_name,
 	it.last_name,
 	it.birth_date,
 	it.from_date,
 	it.to_date,
 	it.title
INTO mentorship_eligibility
FROM initial_table AS it

-- create a table that quantifies potential mentors from mentorship_eligibility.csv 
SELECT COUNT (me.emp_no), me.title
INTO mentor_title_count
FROM mentorship_eligibility AS me
GROUP by me.title
ORDER by me.count DESC;

SELECT*FROM mentor_title_count