#Practical 5

#Name and surname: Munzhelele Thsimangadzo

#Student number: u18142274


library(sqldf)
library(readr)
library(lubridate)
library(RH2)
library(stringr)
library(rJava)
library(RJDBC)

orion_employee_payroll <- read_csv("orion_employee_payroll.csv")
orion_staff <- read_csv("orion_staff.csv")
orion_employee_donations <- read_csv("orion_employee_donations.csv")
orion_employee_addresses <- read_csv("orion_employee_addresses2.csv")
orion_order_fact <- read_csv("orion_order_fact.csv")
orion_customer <- read_csv("orion_customer.csv")
orion_customer_type <- read_csv("orion_customer_type.csv")
orion_sales <- read_csv("orion_sales.csv")
orion_employee_organisation <- read_csv("orion_employee_organisation.csv")


# Question 1
# Question 1(a)
q1a <- sqldf("SELECT Employee_ID
              FROM orion_employee_payroll
              WHERE MONTH(Employee_Hire_Date) = 03")

# Question 1(b)
q1b <- sqldf("SELECT Employee_ID, FirstName, LastName
              FROM orion_employee_addresses
              WHERE Employee_ID IN
                              (SELECT Employee_ID
                               FROM orion_employee_payroll
                               WHERE MONTH(Employee_Hire_Date) = 03)
              ORDER BY LastName")


# Question 2
q2 <- sqldf("SELECT Employee_ID, Job_Title, Birth_Date, (2013- YEAR(Birth_Date)) AS Age
             FROM orion_staff
             WHERE Job_Title IN ('Purchasing Agent I', 'Purchasing Agent II') AND Birth_Date < ALL (SELECT Birth_Date
                                                                                               FROM orion_staff
                                                                                               WHERE Job_Title = 'Purchasing Agent III')")

# Question 3
q3 <- sqldf("SELECT a.Customer_ID, Order_Date
             FROM orion_customer_type AS b
             INNER JOIN orion_customer AS a
             ON b.Customer_Type_ID = a.Customer_Type_ID
             INNER JOIN  (SELECT Customer_ID, MAX(Order_Placed) AS Order_Date
                          FROM orion_order_fact
                          WHERE YEAR(Order_Placed) < '2012'
                          GROUP BY Customer_ID) AS c
            ON a.Customer_ID = c.Customer_ID
            WHERE Customer_Type_Name = 'Orion Club members low activity'
            ORDER BY Customer_ID")

# Question 4
# Question 4(a)
q4a <- sqldf("SELECT Department, SUM(Salary) AS Dept_Salary_Total
              FROM orion_employee_payroll AS a
              INNER JOIN orion_employee_organisation AS b
              ON b.Employee_ID = a.Employee_ID
              GROUP BY Department")

# Question 4(b)
q4b <- sqldf("SELECT a.Employee_ID, FirstName, LastName, b.Department
              FROM orion_employee_addresses AS a
              INNER JOIN orion_employee_organisation AS b
              ON a.Employee_ID = b.Employee_ID")

# Question 4(c)
q4c <-sqldf("SELECT emp.Department, emp.FirstName, emp.LastName, Salary, Salary/Dept_Salary_Total AS Percent
             FROM orion_employee_payroll AS pay
             INNER JOIN (SELECT adr.Employee_ID, FirstName, LastName, org.Department
                         FROM orion_employee_addresses as adr
                         INNER JOIN orion_employee_organisation AS org
                         ON adr.Employee_ID = org.Employee_ID)
             AS emp
             ON pay.Employee_ID = emp.Employee_ID
             INNER JOIN (SELECT Department, SUM(Salary) AS Dept_Salary_Total
                         FROM orion_employee_payroll AS pay
                         INNER JOIN orion_employee_organisation AS org
                         ON org.Employee_ID = pay.Employee_ID
                         GROUP BY Department)
            AS sum
            ON sum.Department = emp.Department
            ORDER BY Department, Percent DESC")







