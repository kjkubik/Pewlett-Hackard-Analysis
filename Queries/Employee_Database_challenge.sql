------------ Challenge 1 ------------
SELECT e.emp_no,
       e.first_name,
	     e.last_name,
  FROM employees;
  
SELECT title, 
       from_date, 
	     to_date
  FROM titles;

SELECT emp.emp_no,
	     emp.first_name,
	     emp.last_name,
	     title.title, 
       title.from_date, 
	     title.to_date
  INTO retirement_titles 
  FROM employees as emp
 INNER JOIN titles as title
    ON (emp.emp_no = title.emp_no)
  WHERE (emp.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp.emp_no;

select * from retirement_titles;

SELECT DISTINCT ON (rt.emp_no) rt.emp_no,
       rt.first_name,
	   rt.last_name,
	   rt.title
INTO unique_titles 
FROM   retirement_titles AS rt
ORDER BY rt.emp_no ASC, rt.to_date DESC;

SELECT title, COUNT(title) as count 
INTO retiring_title_counts
FROM unique_titles
GROUP BY title
ORDER BY count DESC;

------------ Challenge 2 ------------
-- initial selection of mentors: 
SELECT 	DISTINCT ON (emp.emp_no) emp.emp_no, 
		emp.first_name, 
		emp.last_name, 
		emp.birth_date,
		de.from_date,
		de.to_date,
		title.title
   INTO mentorship_eligibilty
   FROM employees AS emp
INNER JOIN dept_emp AS de
     ON (emp.emp_no = de.emp_no)
INNER JOIN titles AS title
	 ON (emp.emp_no = title.emp_no)
  WHERE (de.to_date = '9999-01-01') AND 
        (emp.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY emp.emp_no;   

-- how many employees as mentors:
select count(*) from mentorship_eligibilty;

------------ Challenge 3 ------------

-- These are the current manager/department match
SELECT d.dept_name,
       dm.emp_no,
	     emp.first_name,
	     emp.last_name,
       dm.from_date,
       dm.to_date
  FROM departments AS d,
       dept_manager AS dm,
		   dept_emp AS de,
		   employees AS emp
 WHERE d.dept_no = dm.dept_no
	 AND de.dept_no = dm.dept_no
	 AND dm.emp_no = de.emp_no	
	 AND dm.to_date = ('9999-01-01')
	 AND dm.emp_no = emp.emp_no;

-- By Department: All employees, retiring employees, percent of retiring employees 
SELECT de.dept_no, 
		dept.dept_name, 
		COUNT(emp.emp_no) as all_emps,
		COUNT(ce.emp_no) as emps_ready_for_retirement 
  INTO by_department_counts
  FROM dept_emp AS de
LEFT JOIN employees AS emp
  ON (emp.emp_no = de.emp_no)
LEFT JOIN departments AS dept	 
  ON (dept.dept_no = de.dept_no)
LEFT JOIN current_emp as ce
	ON ce.emp_no = de.emp_no
 WHERE (de.to_date = '9999-01-01')  
GROUP BY de.dept_no, dept.dept_name
ORDER BY de.dept_no;

SELECT dept_no, 
	     dept_name, 
	     all_emps,
	     emps_ready_for_retirement, 
	     to_char(div(emps_ready_for_retirement * 100, all_emps),'99.99') AS percent_ready_to_retire
INTO by_department_percent
FROM by_department_counts;

SELECT dept_no, 
	   dept_name, 
	   all_emps,
	   emps_ready_for_retirement, 
	   to_char(percent_ready_to_retire),'99.99')  
into by_department_readable
FROM by_department_percent;

-- give me all titles in the departments
SELECT distinct dept.dept_name, title.title  
  FROM employees as emp,
       titles as title,
	     departments as dept,
	     dept_emp as de
where emp.emp_no = title.emp_no
  and emp.emp_no = de.emp_no
  and de.dept_no = dept.dept_no
order by dept.dept_name, title.title;

-- count the number of titles an employee has had (the number of times they show up in the employee table)
