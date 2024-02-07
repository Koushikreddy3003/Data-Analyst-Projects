create database project_1;
use project_1;
select * from hr_1;
select * from hr_2;

#  Total Employee ---------------------------

create view Total_employee as
select count(*) total_employee from hr_1;

select * from Total_employee;

# Gender Count ------------------------------------------

create view gender as
select gender, count(gender) Coutn_gender from hr_1
group by gender;

select * from gender;

# Current Employee ---------------------------------------------------------

create view `current employee` as
Select count(attrition) current_employee from hr_1 where attrition = 'No';

select * from `current employee`;

# Attrition Employee ------------------------------------------------------

create view Attrition AS
SELECT count(attrition) Ex_Employee from hr_1 where attrition = 'Yes';

select * from Attrition;

# ----------------------------- KPI 1 ---------------------------------------

# 1. Average Attrition rate for all Departments ----------------------------


select * from hr_1;
select Department,count(attrition) `Number of Attrition`from hr_1
where attrition = 'yes'
group by Department;


create view Dept_average as
select department, round(count(attrition)/(select count(employeenumber) from hr_1)*100,2)  as attrtion_rate
from hr_1
where attrition = "yes"
group by department;
select * from dept_average;


# ---------------------------------- KPI 2  --------------------------------------------

# 2. Average Hourly rate of Male Research Scientist


DELIMITER //
create procedure emp_role (in input_gender varchar(20), in input_jobrole varchar(30))
begin
 select Gender, round(avg(HourlyRate),2) `Avg Hourly Rate` from hr_1
 where gender = input_gender and jobrole = input_jobrole
 group by gender;
end //
DELIMITER ;
drop procedure emp_role;
call emp_role('male',"Research Scientist");


# ------------------------------ KPI 3 ----------------------------------------------


# 3. Attrition rate Vs Monthly income stats

select h1.department,
round(count(h1.attrition)/(select count(h1.employeenumber) from hr_1 h1)*100,2) `Attrtion rate`,
round(avg(h2.MonthlyIncome),2) average_incom from hr_1 h1 join hr_2 h2
on h1.EmployeeNumber = h2.`employee id`
where attrition = 'Yes'
group by h1.department;

create view Attrition_employeeincome as
select h1.department,
round(count(h1.attrition)/(select count(h1.employeenumber) from hr_1 h1)*100,2) `Attrtion rate`,
round(avg(h2.MonthlyIncome),2) average_income from hr_1 h1 join hr_2 h2
on h1.EmployeeNumber = h2.`employee id`
where attrition = 'Yes'
group by h1.department;

select * from attrition_employeeincome;

# ------------------------------------ KPI 4 ----------------------------------------------

# 4. Average working years for each Department

select h1.department,Round(avg(h2.totalworkingyears),0) from hr_1 h1
join hr_2 h2 on h1.employeenumber = h2.`Employee ID`
group by h1.department;

Create view `Employee Age` as 
select h1.department,Round(avg(h2.totalworkingyears),0) from hr_1 h1
join hr_2 h2 on h1.employeenumber = h2.`Employee ID`
group by h1.department;

select * from `employee age`;
#------------------------------- kip 5-------------------------------------
select * from hr_2;

select h1.jobrole,h2.worklifebalance_status, count(h2.worklifebalance_status) Employee_count
from hr_1 h1 join hr_2 h2
on h1.employeenumber = h2.`Employee ID`
group by h1.jobrole,h2.worklifebalance_status
order by h1.jobrole;

DELIMITER //
Create procedure Get_Count (in job_role varchar(30),in Work_balance varchar(30),out Ecount int)
begin
select count(h2.worklifebalance_status)  Employee_count into ecount
from hr_1 h1 join hr_2 h2
on h1.employeenumber = h2.`Employee ID`
where h1.jobrole = job_role and h2.worklifebalance_status = Work_balance
group by job_role,work_balance;
end //
DELIMITER ;
 
 call get_count('developer','Good',@Ecount);
 select @Ecount;
 # KPI 5

 select distinct 
 Jobrole,
 sum(hr2.excellent) as Excellent,
 sum(hr2.good) as Good,
 sum(hr2.average) as Average,
 sum(hr2.poor) as poor
 from
     hr1
       inner join 
	 hr2 on hr1.employee_id = hr2.employee_id 
 group by  hr1.jobrole;
#------------------ 6. Attrition rate Vs Year since last promotion relation----------------
use project_1;
SELECT
    YearsSinceLastPromotion,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS AttritionCount,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS AttritionRate
FROM
    hr_1_2
GROUP BY
    YearsSinceLastPromotion
ORDER BY
    YearsSinceLastPromotion;


