-- VIEWING ALL DATABASEs
SHOW DATABASES;

-- CREATES DATABASE IF NOT EXISTS 
CREATE DATABASE IF NOT EXISTS Data_Transformer;

-- VEWING IS DATABASE IS CREATED SUCCESSFULLY
SHOW DATABASES;

-- USING DATABASE
USE Data_Transformer;

-- CREATING CUSTOMERS TABLE
CREATE TABLE Customers(
	CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(50) UNIQUE NOT NULL,
    RegistrationDate DATE NOT NULL
);

-- CREATING ORDERS TABLE
CREATE TABLE Orders(
	OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- CREATING EMPLOYEES TABLE
CREATE TABLE Employees(
	EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Department VARCHAR(20) NOT NULL,
    HireDate DATE NOT NULL,
    Salary DECIMAL(10,2)
);

-- INSERTING VALUES IN CUSTOMERS 
INSERT INTO Customers (FirstName, LastName, Email, RegistrationDate) VALUES 
('John', 'Doe', 'john.doe@gmail.com', '2026-03-15'),
('Jane', 'Smith', 'jane.smith@gmail.com', '2026-6-02');

-- INSERTING VALUES IN ORDERS
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount) VALUES
(1, '2026-04-01', 150.50),
(2, '2026-07-03', 200.75);

-- INSERTING VALUES IN ORDERS
INSERT INTO Employees (FirstName, Lastname, Department, HireDate, Salary) VALUES
('Mark', 'Johnson', 'Sales', '2020-01-15', 50000.00),
('Susan', 'Lee', 'HR', '2021-03-20', 55000.00);

-- Retrieve all orders and customer details where order exist
SELECT o.OrderID, o.OrderDate, o.TotalAmount, c.CustomerID, c.FirstName, c.LastName, c.Email, c.RegistrationDate
FROM Orders AS o
INNER JOIN Customers AS c ON o.CustomerID = c.CustomerID;

-- Retrieve all customers and their corresponding orders
SELECT c.CustomerID, c.FirstName, c.LastName, c.Email, c.RegistrationDate, o.OrderID, o.OrderDate, o.TotalAmount
FROM Customers AS c
LEFT JOIN Orders AS o ON c.CustomerID = o.CustomerID;

-- Retrieve all orders and their corresponding customers
SELECT o.OrderID, o.CustomerID, o.OrderDate, o.TotalAmount, c.FirstName, c.LastName, c.Email, c.RegistrationDate
FROM Customers AS c
RIGHT JOIN Orders AS o ON c.CustomerID = o.CustomerID;

-- Retrieve all customers and all orders, regardless of matching
SELECT c.CustomerID, c.FirstName, c.LastName, c.Email, c.RegistrationDate, o.OrderID, o.OrderDate, o.TotalAmount
FROM Orders AS o
LEFT JOIN Customers AS c ON o.CustomerID = c.CustomerID
UNION
SELECT c.CustomerID, c.FirstName, c.LastName, c.Email, c.RegistrationDate, o.OrderID, o.OrderDate, o.TotalAmount
FROM Orders AS o
RIGHT JOIN Customers AS c ON o.CustomerID = c.CustomerID;

-- Subquery to find customers who have placed orders worth more than the average amount
SELECT DISTINCT c.CustomerID, c.FirstName, c.LastName, c.Email
FROM Customers AS c
INNER JOIN Orders AS o ON c.CustomerID = o.CustomerID
WHERE o.TotalAmount > (SELECT AVG(TotalAmount)
					   FROM Orders);
                       
-- Subquery to find employees with salaries above the average salary
SELECT DISTINCT e.EmployeeID, e.FirstName, e.LastName, e.Salary
FROM Employees AS e
WHERE e.Salary > (SELECT AVG(E.Salary) FROM Employees AS E);

-- Extract the year and month from the OrderDate
SELECT YEAR(OrderDate) AS Year, MONTH(OrderDate) AS Month
FROM Orders;

-- Calculate the difference in dates between two dates (order date and current date)
SELECT OrderID, DATEDIFF(CURDATE(), OrderDate) AS DateDifference
FROM Orders;

-- Format the OrderDate to a more readable format (e.g., 'DD-MM-YYYY')
SELECT OrderID, DATE_FORMAT(OrderDate, '%d-%m-%Y') AS Formatted_Date
FROM Orders;

-- Concatenate FirstName and LastName to form a full name:
SELECT CONCAT(FirstName,' ',LastName) AS Full_Name 
FROM Employees;

SELECT CONCAT(FirstName,' ',LastName) AS Full_Name
FROM Employees;

-- Replace part of a string (e.g., repalace 'John' with 'Jonathan')
SELECT CustomerID, FirstName AS OriginalName, REPLACE(FirstName,'John','Jonathan') as Replaced_Name
FROM Customers;

-- Convert FirstName to uppercase and LastName to lowercase:
SELECT CustomerID, UPPER(FirstName) AS F_Upper, LOWER(LastName) AS L_Lower
FROM Customers;

SELECT EmployeeID, UPPER(FirstName) AS F_Upper, LOWER(LastName) AS L_Lower
FROM Employees;

-- TRIM extra spaces from the Email field:
SELECT CustomerID, TRIM(Email) AS Trimmed_email
FROM Customers; 

-- Calculate the running total of TotalAmount for each order
SELECT OrderID, CustomerID, OrderDate, TotalAmount, 
SUM(TotalAmount) OVER(ORDER BY OrderDate, OrderID
					  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
                      AS RunningTotal
FROM Orders;

-- Rank orders based on TotalAmount using the RANK() function:
SELECT OrderID, CustomerID, OrderDate, TotalAmount,
RANK() OVER(ORDER BY TotalAmount DESC) AS OrderRank
FROM Orders;

-- Assign a discount based on TotalAmount in orders(e.g., >1000: 10% off, >500: 5% off)
SELECT OrderID, CustomerID, OrderDate, TotalAmount,
CASE
	WHEN TotalAmount > 1000 THEN TotalAmount * 0.90
    WHEN TotalAmount > 500 THEN TotalAmount * 0.95
    ELSE TotalAmount
END AS Discount_Price
FROM Orders;

-- Categorize employees' salaries as high, medium or low.
SELECT EmployeeID, FirstName, LastName, Salary,
CASE
	WHEN Salary > 100000 THEN 'High'
    WHEN Salary > 50000 THEN 'Medium'
    ELSE 'LOW'
END AS Salary_Category
FROM Employees;