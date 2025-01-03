/*1. Create a database named employee, then import data_science_team.csv proj_table.csv and emp_record_table.csv 
into the employee database from the given resources.*/

create database employee;


/*3. Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table,
 and make a list of employees and details of their department.*/
 
select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT 
from emp_record_table 
order by DEPT;

/*4. Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is: 
if less than two then 'Low'
greater than four then 'High'
between two and four 'Average'*/

select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING ,
case when EMP_RATING < 2 then 'Low'
	 when EMP_RATING <= 4 then 'Average' 
     else 'High'
     end as Rating_status
From emp_record_table;

/*5. Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department 
from the employee table and then give the resultant column alias as NAME. */

select concat(FIRST_NAME,' ',LAST_NAME) as NAME 
from emp_record_table 
where DEPT = 'Finance';


/*6. Write a query to list only those employees who have someone reporting to them. 
Also, show the number of reporters (including the President).*/

select  distinct m.FIRST_NAME as Manager_Name,m.Role
from emp_record_table e JOIN emp_record_table m 
ON e.Manager_ID = m.EMP_ID;


/*7. Write a query to list down all the employees from the healthcare and finance departments using union.
 Take data from the employee record table.*/

select * from emp_record_table 
where DEPT = 'HEALTHCARE'
UNION
select * from emp_record_table 
where DEPT = 'FINANCE';


/*8. Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING grouped by dept.
 Also include the respective employee rating along with the max emp rating for the department.*/

select EMP_ID,FIRST_NAME,LAST_NAME,ROLE,DEPT,EMP_RATING,
Max(Emp_Rating) over(partition by DEPT ) as Max_Emp_Rating	
from emp_record_table;


-- 9. Write a query to calculate the minimum and the maximum salary of the employees in each role. Take data from the employee record table.

select Role, MIN(Salary) as Minimum, Max(Salary)as Maximum 
from emp_record_table
group by ROLE;


-- 10. Write a query to assign ranks to each employee based on their experience. Take data from the employee record table.

select EMP_ID,FIRST_NAME,LAST_NAME,EXP, 
Rank() over(order by Exp desc) 
as RankByExp 
from emp_record_table;


-- 11. Write a query to create a view that displays employees in various countries whose salary is more than six thousand. Take data from the employee record table.

create View V_Emp_6k
as
select EMP_ID,FIRST_NAME,LAST_NAME,COUNTRY 
from emp_record_table 
where Salary > 6000
ORDER bY COUNTRY;
SELECT * FROM V_Emp_6k;


-- 12. Write a nested query to find employees with experience of more than ten years. Take data from the employee record table.

Select * from emp_record_table 
where EMP_ID in (
select EMP_ID from emp_record_table where EXP >10
);


-- 13. Write a query to create a stored procedure to retrieve the details of the employees whose experience is more than three years. Take data from the employee record table.

DELIMITER $$
USE `employee`$$
CREATE PROCEDURE P_Emp_3YrsExp ()
BEGIN
	select * from emp_record_table where exp > 3;
END$$
DELIMITER ;
call P_Emp_3YrsExp;

/*14. Write a query using stored functions in the project table to check whether the job profile assigned to each employee in the data science team matches the organization’s set standard.

The standard being:

For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST',

For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST',

For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST',

For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST',

For an employee with the experience of 12 to 16 years assign 'MANAGER'. */

DELIMITER $$
USE `employee`$$
CREATE FUNCTION `Task14`(eid   varchar(5)) 
RETURNS varchar(100) 
    DETERMINISTIC
BEGIN
	declare ex int;
    declare r varchar(80);
    declare vrole varchar(100);
    declare flag varchar(10);
    select exp, ROLE into ex, VROLE from data_science_team where emp_ID = eid;
if ex > 12 and ex < 16 then
if VROLE = 'Manager' then
	set flag = 'Match';
	else
	set flag = 'Not Match';
	end if;
# set r = 'Manager';
	elseif ex > 10 and ex <= 12 then 

if VROLE = 'LEAD DATA SCIENTIST' then
	set flag = 'Match';
	else
	set flag = 'Not Match';
	end if;
#set r = 'LEAD DATA SCIENTIST';
elseif ex > 5 and ex <=10 then 
	if VROLE = 'SENIOR DATA SCIENTIST' then
	set flag = 'Match';
	else
	set flag = 'Not Match';
	end if;
#set r ='SENIOR DATA SCIENTIST';
	elseif ex > 2 and ex <=5 then
if VROLE = 'ASSOCIATE DATA SCIENTIST' then
	set flag = 'Match';
	else
	set flag = 'Not Match';
end if;
#set r = 'ASSOCIATE DATA SCIENTIST';
elseif ex <= 2 then
	if VROLE = 'JUNIOR DATA SCIENTIST' then
	set flag = 'Match';
	else
	set flag = 'Not Match';
end if;
#set r = 'JUNIOR DATA SCIENTIST';
		end if;
RETURN flag;
END$$
DELIMITER ;
SELECT *,Task14(Emp_ID) as Status 
FROM data_science_team;


-- 15. Create an index to improve the cost and performance of the query to find the employee whose FIRST_NAME is ‘Eric’ in the employee table after checking the execution plan.

select * from emp_record_table 
where First_Name='Eric';
create Index idx_emp_Fname on emp_record_table(First_Name);
select * from emp_record_table 
where First_Name='Eric';

-- 16. Write a query to calculate the bonus for all the employees, based on their ratings and salaries (Use the formula: 5% of salary * employee rating).

select EMP_ID,FIRST_NAME,SALARY,EMP_RATING, round(Emp_rating * 0.05 * SALARY,0) as Bonus	
from emp_record_table;

-- 17. Write a query to calculate the average salary distribution based on the continent and country. Take data from the employee record table.

select CONTINENT,COUNTRY,round(Avg(Salary)) as Avg_sale 
from emp_record_table
group by CONTINENT,COUNTRY;

-- End of Project--









