CREATE DATABASE ecommerce;
USE ecommerce;

CREATE TABLE Customers(
customer_id INT PRIMARY KEY,
name VARCHAR(50),
city VARCHAR(50),
age INT
);

INSERT INTO Customers VALUES
(1, 'Bhoomika', 'Bangalore', 22),
(2, 'Rahul', 'Mumbai', 25),
(3, 'Priya', 'Delhi', 23),
(4, 'Arjun', 'Bangalore', 28),
(5, 'Sneha', 'Pune', 24),
(6, 'Kiran', 'Hyderabad', 26);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10,2)
);

INSERT INTO Orders VALUES
(101, 1, '2026-08-01', 2500),
(102, 2, '2026-08-02', 1800),
(103, 1, '2026-08-03', 1200),
(104, 4, '2026-08-04', 3500),
(105, 3, '2026-08-05', 900);

SELECT c.name, o.order_id
FROM Customers AS c
RIGHT JOIN Orders AS o
ON c.customer_id = o.customer_id;

-- =========================
-- PRACTICE QUERIES
-- =========================

-- 1. Customers from Bangalore
SELECT name, city
FROM Customers
WHERE city = 'Bangalore';

-- 2. Customers who placed orders
SELECT c.name
FROM Customers AS c
INNER JOIN Orders AS o
    ON c.customer_id = o.customer_id;

-- 3. Customers who never placed an order
SELECT c.name, o.order_id
FROM Customers AS c
LEFT JOIN Orders AS o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- 4. Total Amount spent by each customer
SELECT c.customer_id,c.name, SUM(o.amount)AS total_spent
FROM Customers AS c
LEFT JOIN Orders AS o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id,c.name;

-- 5.Show the names of customers whose total spending is greater than ₹2000.
SELECT c.customer_id,c.name, SUM(o.amount)AS total_spent
FROM Customers AS c
LEFT JOIN Orders AS o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id,c.name
HAVING SUM(o.amount)>2000;

-- 6.Show all customers and their total spending, starting with the highest spender.
SELECT c.customer_id,c.name, SUM(o.amount)AS total_spent
FROM Customers AS c
LEFT JOIN Orders AS o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id,c.name
ORDER BY SUM(o.amount) DESC;

-- 7.Find the top 2 customers based on total spending.
SELECT c.customer_id,c.name, SUM(o.amount)AS total_spent
FROM Customers AS c
LEFT JOIN Orders AS o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id,c.name
ORDER BY total_spent DESC
LIMIT 2; 

-- 8.Find customers who have placed more than one order.
SELECT c.customer_id,c.name,COUNT(o.order_id) AS order_count
FROM Customers AS c 
LEFT JOIN Orders AS o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id,c.name
HAVING COUNT(o.order_id)>1;

USE ecommerce;

-- 9.Find the average order amount for each customer.
SELECT c.customer_id,c.name, AVG(o.amount) AS avg_order_amount
FROM Customers AS c
LEFT JOIN Orders AS o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id,c.name
ORDER BY avg_order_amount DESC;

-- 10."Find the names of customers who have never placed an order."
SELECT c.name FROM Customers AS C
LEFT JOIN Orders AS o
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- 11.Find the customer who has placed the highest number of orders.
SELECT c.name, COUNT(o.order_id) AS order_count
FROM Customers AS c
LEFT JOIN Orders AS o
ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY order_count DESC
LIMIT 1;

-- 12.Show each customer who has placed at least one order, along with their total number of orders and total amount spent.
SELECT c.name, COUNT(o.order_id) AS order_count, SUM(amount) AS total_spent
FROM Customers AS c
LEFT JOIN Orders AS o
ON c.customer_id = o.customer_id
GROUP BY c.name
HAVING  order_count >= 1;

-- RIGHT JOIN
-- 1.Find all orders along with the customer's name. Include orders even if they don't have a matching customer.
SELECT o.order_id, c.name,o.amount
FROM Customers AS c
RIGHT JOIN Orders AS o
ON c.customer_id = o.customer_id;

-- 2.Find orders that do NOT have a matching customer.
SELECT o.order_id, o.amount
FROM Customers AS c
RIGHT JOIN Orders AS o
ON c.customer_id = o.customer_id
WHERE c.customer_id IS NULL;

-- 3.Find all orders along with the customer name, but show only orders where a customer exists.
SELECT o.order_id, c.name, o.amount 
FROM Customers AS c
RIGHT JOIN Orders AS o
ON c.customer_id = o.customer_id
WHERE c.customer_id IS NOT NULL;

-- 4.Find the number of orders for each customer using RIGHT JOIN.
SELECT c.customer_id, c.name, COUNT(o.order_id) AS order_count
FROM Customers AS c
RIGHT JOIN Orders AS o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

USE ecommerce;

-- 5.Find all orders that have a matching customer AND show the customer's name and order amount.

SELECT o.order_id, c.name,o.amount
FROM Customers AS c
RIGHT JOIN Orders o
ON c.customer_id = o.customer_id
WHERE c.customer_id IS NOT NULL;

-- 7.Find the total number of orders for each customer, but only show customers who have placed at least 2 orders

SELECT c.customer_id,
       c.name,
       COUNT(o.order_id) AS order_count
FROM Orders AS o
RIGHT JOIN Customers AS c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
HAVING COUNT(o.order_id) >= 2;

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10,2)
);

CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
INSERT INTO Products (product_id, product_name, price)
VALUES
(101, 'Laptop', 55000),
(102, 'Mouse', 800),
(103, 'Keyboard', 1500),
(104, 'Headphones', 2500),
(105, 'Monitor', 12000),
(106, 'USB Cable', 400);

INSERT INTO Order_Items (order_item_id, order_id, product_id, quantity)
VALUES
(1, 1, 101, 1),
(2, 1, 102, 2),
(3, 2, 103, 1),
(4, 3, 104, 1),
(5, 4, 105, 1),
(6, 5, 106, 3);
-- 1.Show every customer, their order ID, and the product name they ordered. Include customers who have not placed any orders.
SELECT c.customer_id, c.name,o.order_id,p.product_name
FROM Customers AS c
LEFT JOIN Orders AS o
ON c.customer_id = o.customer_id
LEFT JOIN Order_Items AS oi
ON o.order_id = oi.order_id
LEFT JOIN Products AS p
ON oi.product_id = p.product_id;

SELECT c.customer_id,c.name, o.order_id, p.product_name ,oi.quantity
FROM Customers AS c
LEFT JOIN Orders AS o
ON c.customer_id = o.customer_id
LEFT JOIN Order_Items AS oi
ON o.order_id = oi.order_id
LEFT JOIN Products AS p
ON oi.product_id = p.product_id;

SELECT * FROM Products;

SELECT oi.order_id,
       oi.product_id,
       oi.quantity,
       p.product_name
FROM Order_Items AS oi
LEFT JOIN Products AS p
    ON oi.product_id = p.product_id;
    
CREATE DATABASE EmployeeDB;

USE EmployeeDB;
-- SELF JOIN
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    job_title VARCHAR(50),
    salary DECIMAL(10,2),
    manager_id INT,
    FOREIGN KEY (manager_id) REFERENCES Employees(employee_id)
);

INSERT INTO Employees (employee_id, name, job_title, salary, manager_id)
VALUES
(1, 'Rahul', 'General Manager', 80000, NULL),
(2, 'Bhoomika', 'Team Lead', 60000, 1),
(3, 'Priya', 'Team Lead', 60000, 1),
(4, 'Arjun', 'Software Developer', 45000, 2),
(5, 'Sneha', 'Software Developer', 45000, 2),
(6, 'Kiran', 'Software Developer', 42000, 3),
(7, 'Amit', 'Tester', 40000, 3);

SELECT * FROM Employees;
-- 1.Display every employee along with their manager's name. Include Rahul even though he doesn't have a manager.
SELECT e.name AS employee,
m.name AS manager
FROM Employees AS e
LEFT JOIN Employees AS m
ON e.manager_id = m.employee_id;

-- 2.Find all employees who have a manager. Show the employee name and manager name.
SELECT e.name AS employee,
m.name AS manager
FROM Employees AS e
INNER JOIN Employees AS m
ON e.manager_id = m.employee_id;

-- 3.Find all employees who report directly to Rahul.
SELECT e.name AS employee
FROM Employees AS e
INNER JOIN Employees AS m
ON e.manager_id = m.employee_id
WHERE m.name = 'Rahul';

-- CROSS JOIN
CREATE DATABASE CrossJoinDB;

USE CrossJoinDB;
CREATE TABLE Customers1 (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(50)
);
INSERT INTO Customers1 (customer_id, name, city)
VALUES
(1, 'Bhoomika', 'Bangalore'),
(2, 'Rahul', 'Hyderabad'),
(3, 'Priya', 'Mumbai');

CREATE TABLE Products1(
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    price DECIMAL(10,2)
);

INSERT INTO Products1 (product_id, product_name, price)
VALUES
(101, 'Laptop', 55000),
(102, 'Mouse', 800),
(103, 'Keyboard', 1500),
(104, 'Headphones', 2500);

-- 1.Show every possible combination of customers and products.

SELECT c.name, p.product_name 
FROM Customers1 AS c
CROSS JOIN Products1 AS p;

-- 2.Show every possible combination of customers and products, but also display the product price.
SELECT c.name, p.product_name ,p.price
FROM Customers1 AS c
CROSS JOIN Products1 AS p;

-- 3.Find the total number of possible customer-product combinations.
SELECT COUNT(*) AS total_combinations
FROM Customers1 AS c
CROSS JOIN Products1 AS p;

-- 4.Show every customer-product combination where the product price is greater than ₹2,000.
SELECT c.name, p.product_name ,p.price
FROM Customers1 AS c
CROSS JOIN Products1 AS p
WHERE p.price > 2000;

-- 5.Show each customer and the number of products available to them.
SELECT c.name,COUNT(p.product_id) AS product_count
FROM Customers1 AS c
CROSS JOIN Products1 AS p
GROUP BY c.customer_id, c.name;

-- FULL OUTER JOIN
SELECT c.name,
       o.order_id,
       o.amount
FROM Customers AS c
LEFT JOIN Orders AS o
ON c.customer_id = o.customer_id

UNION

SELECT c.name,
       o.order_id,
       o.amount
FROM Customers AS c
RIGHT JOIN Orders AS o
ON c.customer_id = o.customer_id;
