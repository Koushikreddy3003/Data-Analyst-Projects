create database project;
use project;

# Returning DataSets
select * from BA1;
select * from BA2;

#checking datatypes
desc ba1;
desc ba2;

#Total Customers:
select count(id) as total_customers from ba1;
#Total Loan Amount:
select sum(loan_amnt) as total_loan_amount from ba1;
#Total Loans issued:
select count(member_id) as total_loans_issued from ba1;

#KPI-1 : Year wise Loan amount stats.............................

create view Year_wise_loan_stats as
select year(issue_d) as year1, sum(loan_amnt) as Loan_amount
from ba1
group by year1
order by year1 asc;

select * from year_wise_loan_stats;

#...............................................................................

# KPI-2 : Grade and Sub-Grade wise Revol_Balance .....................................
# A) grade wise rev balance
create view grade_wise_rev_balance as
select ba1.grade, sum(ba2.revol_bal) as revol_balance
from ba1 inner join ba2
on ba1.id = ba2.id
group by ba1.grade
order by grade asc;

select * from grade_wise_rev_balance;

# B) sub-grade wise rev balance
create view sub_grade_wise_rev_balance as
select ba1.sub_grade, sum(ba2.revol_bal) as revol_balance
from ba1 inner join ba2
on ba1.id = ba2.id
group by ba1.sub_grade
order by sub_grade asc;

select * from sub_grade_wise_rev_balance;

#c) grade and sub-grade wise revol_balance

create view kpi2_output as
select ba1.grade, ba1.sub_grade, sum(ba2.revol_bal) as revol_balance
from ba1 inner join ba2
on ba1.id = ba2.id
group by ba1.grade,ba1.sub_grade
order by grade asc;

select * from kpi2_output;

#........................................................................................

# KPI-3 : Total Payment for verified & non-verified Statu..........................................

create view kpi3_output as 
select ba1.verification_status, sum(ba2.total_pymnt) as Total_payment 
from ba1 inner join ba2
on ba1.id = ba2.id
group by ba1.verification_status;

select * from kpi3_output;

#........................................................................................................

# KPI-4: State wise and month wise loan status..........................................................
# state wise loan status
create view state_wise_loan_status as
select addr_state, loan_status, count(loan_status)
from ba1
group by addr_state, loan_status;

select * from state_wise_loan_status;

# month wise loan status

create view month_wise_loan_status as
select monthname(ba2.last_pymnt_d) as month_name, ba1.loan_status, count(ba1.loan_status)
from ba1 inner join ba2
on ba1.id = ba2.id
group by month_name, ba1.loan_status
order by month_name asc;

select * from month_wise_loan_status;

# KPI4 Output

create view kpi4_output as 
select ba1.addr_state, monthname(ba2.last_pymnt_d) as month_name, ba1.loan_status, count(ba1.loan_status) as count
from ba1 inner join ba2
on ba1.id = ba2.id
group by ba1.addr_state, month_name, loan_status;

select * from kpi4_output;

#....................................................................................................................

# KPI-5 Home Ownership vs Last payment date stats......................................................................

create view kpi5_output as
select year(ba2.last_pymnt_d) year_of_payment, ba1.home_ownership, count(ba1.home_ownership) as count
from ba1 inner join ba2
on ba1.id = ba2.id
group by year_of_payment, ba1.home_ownership
order by year_of_payment asc;

select * from kpi5_output;

#.........................................................................................................