-- Завдання 1. Підключення до бази даних

-- Завдання 1.3
SELECT COUNT(*) AS employees_total FROM employees;

--Завдання 2. Фільтрація, сортування та обмеження вибірки

--Завдання 2.1.
select first_name, last_name
from employees
where manager_id = 101
order by employee_id;

--Завдання 2.2.
select first_name, last_name, salary
from employees 
where salary < 4000
order by salary;

--Завдання 2.3. 
select employee_id, first_name, last_name, hire_date 
from employees 
where extract(year from hire_date) = 1996
order by hire_date;

--Завдання 2.4. 
select employee_id, first_name, last_name, email  
from employees 
where email like '%example.com'
order by email;

--Завдання 2.5.
select employee_id, first_name, last_name, department_id 
from employees
where department_id in (20, 30)
order by department_id, employee_id;

--Завдання 2.6.
select employee_id, first_name 
from employees 
where lower(first_name) like '%a'
order by first_name;

--Завдання 2.7.
select employee_id, first_name, last_name, salary, commission_pct
from employees
where salary > 6000 and commission_pct = 0.15
order by salary desc;

--Завдання 2.8.
select employee_id, first_name, last_name, phone_number
from employees
where phone_number like '515%'
order by phone_number;

--Завдання 2.9.
select employee_id, first_name, last_name, salary
from employees
where department_id = 20
order by salary desc;

--Завдання 2.10.
select employee_id, first_name, last_name, hire_date
from employees
order by hire_date, employee_id
limit 7;

--Завдання 2.11. 
select employee_id, first_name, last_name, salary
from employees
where salary > 4000 
order by employee_id 
limit 5;

--Завдання 2.12.
select employee_id, first_name, last_name,
	cast(salary as text) || ' EUR' as salary_eur
from employees 
order by employee_id;

--Завдання 2.13.
select employee_id, first_name, last_name
from employees
where manager_id = 101
order by last_name;

--Завдання 2.14.
select employee_id, first_name, last_name, salary
from employees
order by salary desc
offset 3 limit 10;

--Завдання 2.15.
select employee_id, first_name, last_name, hire_date
from employees
where hire_date > '2000-01-01'
order by hire_date desc;

-- Завдання 3. Агрегація та групування

--Завдання 3.1.
select 
	round(avg(salary), 2) as avg_salary
from employees 
where job_id like 'S%';

--Завдання 3.2. 
select 
	department_id,
	min(salary) as min_salary,
	max(salary) as max_salary
from employees
group by department_id
order by department_id;

--Завдання 3.3.
select 
	count(employee_id) as employees_count
from employees
where salary > 3000;

--Завдання 3.4. 
select 
	department_id,
	sum(salary) as total_salary
from employees
group by department_id 
having sum(salary) > 10000
order by total_salary desc;

--Завдання 3.5.
select 
	employee_id, 
	first_name,
	last_name,
	coalesce(commission_pct, 0) as comission
from employees
order by employee_id;

--Завдання 3.6. 
select 
	employee_id, 
	last_name, 
	salary + salary * COALESCE(commission_pct, 0) as total_income
from employees
where salary + salary * COALESCE(commission_pct, 0) > 5000
order by total_income desc;

--Завдання 4. З'єднання таблиць (JOIN)

--Завдання 4.1.
select e.first_name, e.last_name, j.job_title 
from employees e   
join jobs j on e.job_id  = j.job_id 
order by e.last_name;

--Завдання 4.2.
select e.first_name, e.last_name, e.salary, j.job_title 
from employees e
join jobs j on e.job_id  = j.job_id 
where e.salary > 5000
order by e.salary desc;

--Завдання 4.3.
select e.first_name, e.last_name, d.department_name
from employees e 
left join departments d on d.department_id = e.department_id 
order by e.last_name;

--Завдання 4.4.
select d.department_name, e.first_name, e.last_name
from employees e 
right join departments d on d.department_id = e.department_id 
order by D.department_name;

--Завдання 4.5.
select first_name, last_name, d.department_name
from employees e 
full outer join departments d on d.department_id = e.department_id 
order by department_name, last_name;

--Завдання 4.6.
select e.first_name, e.last_name, j.job_title, d.department_name
from employees e
left join jobs j on e.job_id = j.job_id 
left join departments d on e.department_id = d.department_id 
order by department_name, last_name;

--Завдання 4.7.
select 
	d.department_name, 
	count(e.employee_id) as employees_count
from departments d 
left join employees e on e.department_id = d.department_id 
group by d.department_name
order by employees_count desc;

--Завдання 4.8.
select 
	d.department_name,
	count(e.employee_id) as employees_count
from employees e 
join departments d on d.department_id = e.department_id 
group by d.department_name 
having count(e.employee_id) > 3
order by employees_count desc;

--Завдання 4.9.
select d.department_name, country_name
from departments d 
left join locations l on d.location_id = l.location_id
left join countries c on c.country_id = l.country_id
order by c.country_name, d.department_name;

--Завдання 4.10. 
select e.first_name, e.last_name, department_name
from employees e 
join departments d on e.department_id = d.department_id
join locations l on d.location_id = l.location_id
join countries c on l.country_id = c.country_id
join regions r on c.region_id = r.region_id
where r.region_name  = 'Europe'
order by e.last_name;

--order by e.last_name;

--Завдання 5.1.
select employee_id, first_name, last_name, salary
from employees
where salary > (select avg(salary) from employees)
order by salary desc;

--Завдання 5.2. 
select d.department_id, d.department_name
from departments d
join employees e on e.employee_id = d.department_id 
where d.department_id in (
	select e2.department_id
	from employees e2  
	group by department_id 
	having sum(salary) > 100000
)
order by department_id;

--Завдання 5.3.
select e.employee_id, e.first_name, e.last_name
from employees e 
join departments d on e.department_id = d.department_id
join locations l on d.location_id = l.location_id
where l.city in (
	select l2.city 
	from hr.locations l2 
	where city like 'S%'
	)
order by e.employee_id;

--Завдання 5.4. 
select employee_id, last_name, salary, j.job_id
from employees e
left join jobs j on e.job_id = j.job_id
where salary > (select j.max_salary 
				from jobs j 
				where j.job_id = e.job_id
			   )
order by salary desc;

--Завдання 5.5.
select d.department_id, d.department_name
from departments d 
left join employees e on d.department_id = e.department_id
where e.employee_id not in (
	select e.employee_id 
	from employees e2 
	where e.employee_id is not null)
order by d.department_id;

--Завдання 5.6.
select 
	department_id,
	count(*) as employees_count
from employees
where department_id  in (
	select department_id
	from employees
	group by department_id 
	having avg(salary) > 15000
)
group by department_id
order by department_id;

