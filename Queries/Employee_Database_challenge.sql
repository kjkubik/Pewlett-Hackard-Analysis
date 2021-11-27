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