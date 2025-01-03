# ScienceQtech Employee Performance Mapping.

## Project Overview

**Project Title**: Employee Performance Mapping  
**Level**: Beginner  
**Database**: `employee`

ScienceQtech is a startup that works in the Data Science field. ScienceQtech has worked on fraud detection, market basket, self-driving cars, supply chain, algorithmic early detection of lung cancer, customer sentiment, and the drug discovery field. 
With the annual appraisal cycle around the corner, the HR department has asked you (Junior Database Administrator) to generate reports on employee details, their performance, and on the project that the employees have undertaken, to analyze 
the employee database and extract specific data based on different requirements.

## Objectives

To facilitate a better understanding, managers have provided ratings for each employee which will help the HR department to finalize the employee performance mapping. 
As a DBA, you should find the maximum salary of the employees and ensure that all jobs are meeting the organization's profile standard. 
You also need to calculate bonuses to find extra cost for expenses. This will raise the overall performance of the organization by ensuring that all required employees receive training.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `employee`.
- **Table Creation**: A table named `emp_record_table`. It contains the information of all the employees.

**EMP_ID - ID of the employee** 
**FIRST_NAME - First name of the employee**
**LAST_NAME - Last name of the employee**
**GENDER - Gender of the employee**
**ROLE - Post of the employee**
**DEPT - Field of the employee**
**EXP - Years of experience the employee has**
**COUNTRY - Country in which the employee is presently living**
**CONTINENT - Continent in which the country is**
**SALARY - Salary of the employee**
**EMP_RATING - Performance rating of the employee**
**MANAGER_ID - The manager under which the employee is assigned**
**PROJ_ID - The project on which the employee is working or has worked on**


# The task to be performed: 

1. **.Create a database named employee, then import emp_record_table.csv into the employee database from the given resources.**

```sql
create database employee;
```

2. **. Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table, and make a list of employees and details of their department.**

```sql
select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT 
from emp_record_table 
order by DEPT;
```

3. **. Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is: if less than two then 'Low', greater than four then 'High',between two and four 'Average'**

```SQL
select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING ,
case when EMP_RATING < 2 then 'Low'
	 when EMP_RATING <= 4 then 'Average' 
     else 'High'
     end as Rating_status
From emp_record_table;
```

4. **Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department from the employee table and then give the resultant column alias as NAME.**

```sql
select concat(FIRST_NAME,' ',LAST_NAME) as NAME 
from emp_record_table 
where DEPT = 'Finance';
```

5. **. Write a query to list only those employees who have someone reporting to them. Also, show the number of reporters (including the President)**:

```sql
select  distinct m.FIRST_NAME as Manager_Name,m.Role
from emp_record_table e JOIN emp_record_table m 
ON e.Manager_ID = m.EMP_ID;
```

6. **Write a query to list down all the employees from the healthcare and finance departments using union.Take data from the employee record table.**:

```sql
select * from emp_record_table 
where DEPT = 'HEALTHCARE'
UNION
select * from emp_record_table 
where DEPT = 'FINANCE';
```

7. **Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING grouped by dept. Also include the respective employee rating along with the max emp rating for the department.**:

```sql
select EMP_ID,FIRST_NAME,LAST_NAME,ROLE,DEPT,EMP_RATING,
Max(Emp_Rating) over(partition by DEPT ) as Max_Emp_Rating	
from emp_record_table;
```

8. **Write a query to calculate the minimum and the maximum salary of the employees in each role. Take data from the employee record table.**:

```sql
select Role, MIN(Salary) as Minimum, Max(Salary)as Maximum 
from emp_record_table
group by ROLE;
```

9. **Write a query to assign ranks to each employee based on their experience. Take data from the employee record table.**:

```sql
select EMP_ID,FIRST_NAME,LAST_NAME,EXP, 
Rank() over(order by Exp desc) 
as RankByExp 
from emp_record_table;
```

10. **Write a query to create a view that displays employees in various countries whose salary is more than six thousand. Take data from the employee record table.**:

```sql
create View V_Emp_6k
as
select EMP_ID,FIRST_NAME,LAST_NAME,COUNTRY 
from emp_record_table 
where Salary > 6000
ORDER bY COUNTRY;
SELECT * FROM V_Emp_6k;

```

11. **Write a nested query to find employees with experience of more than ten years. Take data from the employee record table.**

```sql
Select * from emp_record_table 
where EMP_ID in (
select EMP_ID from emp_record_table where EXP >10);
```

12. **Write a query to create a stored procedure to retrieve the details of the employees whose experience is more than three years. Take data from the employee record table.**:

```sql
DELIMITER $$
USE `employee`$$
CREATE PROCEDURE P_Emp_3YrsExp ()
BEGIN
	select * from emp_record_table where exp > 3;
END$$
DELIMITER ;
call P_Emp_3YrsExp;
```

13. **Write a query using stored functions in the project table to check whether the job profile assigned to each employee in the data science team matches the organization’s set standard.
The standard being:
For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST',
For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST',
For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST',
For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST',
For an employee with the experience of 12 to 16 years assign 'MANAGER'.**:

```sql
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
```
14. **Create an index to improve the cost and performance of the query to find the employee whose FIRST_NAME is ‘Eric’ in the employee table after checking the execution plan.**

```SQL
select * from emp_record_table 
where First_Name='Eric';
create Index idx_emp_Fname on emp_record_table(First_Name);
select * from emp_record_table 
where First_Name='Eric';
```

15. **Write a query to calculate the bonus for all the employees, based on their ratings and salaries (Use the formula: 5% of salary * employee rating).**

```SQL
select EMP_ID,FIRST_NAME,SALARY,EMP_RATING, 
round(Emp_rating * 0.05 * SALARY,0) as Bonus	
from emp_record_table;
```

16. **Write a query to calculate the average salary distribution based on the continent and country. Take data from the employee record table.**

```SQL
select CONTINENT,COUNTRY,round(Avg(Salary)) as Avg_sale 
from emp_record_table
group by CONTINENT,COUNTRY;
```


## Findings

**Employee Performance:** - Categorized employees by performance ratings (Low, Avg, High) for HR appraisal.
**Employee Names:** - Concatenated FIRST_NAME and LAST_NAME of employees in the Finance department.
**Reportees:** - Identified employees with direct reports and counted the number of reportees.
**Union Query:**- Retrieved employees from the Healthcare and Finance departments using UNION.
**Department Ratings:** - Grouped employees by department, including maximum rating per department.
**Salary Analysis:** - Calculated minimum and maximum salaries by role.
**Experience Ranks:** - Ranked employees by years of experience for performance and career planning.
**Salary View:** - Created a view to show employees earning more than 6,000 in different countries.
**Experience-based Query:** - Retrieved employees with over 10 years of experience.
**Stored Procedure:** - Created a stored procedure to fetch employees with more than 3 years of experience.
**Job Profile Standardization:** - Checked if employees in Data Science align with job profile standards.
**Index Creation:** - Optimized query performance for looking up employees by FIRST_NAME.
**Bonus Calculation:** - Calculated employee bonuses based on ratings and salaries.
**Salary Distribution:** - Calculated average salary distribution by country and continent.


## Reports

1. **Employee Performance Report:**
Employees have been categorized by performance ratings, and the reports indicate which employees fall under the 'Low', 'Avg', and 'High' categories based on their EMP_RATING. This will be crucial in deciding who needs additional training and who may deserve promotions.

2. **Employee Names Report:**
A list of names of employees in the Finance department was generated successfully, and this report is useful for HR purposes and for employee recognition.

3. **Reportees Report:**
A list of employees who have people reporting to them was compiled, along with the number of employees reporting to each. This will assist in understanding the leadership structure of the company.

4. **Department Performance Report:**
The report includes employee ratings by department, showing which departments have the highest and lowest performance levels.

5. **Salary Report:**
A report on the minimum and maximum salary by role was generated, giving HR valuable insights into compensation discrepancies and helping set appropriate salary benchmarks.

6. **Experience-based Employee Ranking Report:**
A ranking report of employees by experience was generated, helping managers and HR better understand the distribution of experience within the company.

7. **Salary and Bonus Calculation:**
The report includes the bonus amounts calculated for each employee based on their salary and performance rating. This report can be used to evaluate the financial impact of bonuses.

8. **Country and Continent Salary Distribution:**
The report shows the average salary distribution by country and continent, helping the company understand salary trends across different regions.


## Conclusion
the SQL tasks and the analysis provided a comprehensive overview of the company's workforce, their performance, salaries, and career progression. These reports will significantly aid HR and management in making informed decisions regarding promotions, bonuses, salary adjustments, and training programs.

