-- Create database
CREATE DATABASE Employee;
USE Employee;

-- Hobby table
CREATE TABLE Hobby (
  id INT PRIMARY KEY AUTO_INCREMENT, 
  name VARCHAR(255) NOT NULL UNIQUE
);

INSERT INTO Hobby (name) 
VALUES 
  ('Reading'), 
  ('Gardening'), 
  ('Painting'), 
  ('Cooking'), 
  ('Traveling');

SELECT * FROM Hobby;
DELETE FROM Hobby WHERE id IN (1,2);

UPDATE Hobby SET name = 'Learning' WHERE id = 1;
UPDATE Hobby SET name = 'Writing' WHERE id = 2;

TRUNCATE TABLE Hobby;

-- Employee table
CREATE TABLE Employee (
  id INT PRIMARY KEY AUTO_INCREMENT, 
  first_name VARCHAR(255) NOT NULL, 
  last_name VARCHAR(255) NOT NULL, 
  age INT NOT NULL, 
  mobile_number VARCHAR(10) UNIQUE, 
  address VARCHAR(255)
);

INSERT INTO Employee (first_name, last_name, age, mobile_number, address)
VALUES 
    ('John', 'Doe', 30, '1239567890', '123 Main St'),
    ('Jane', 'Smith', 25, '9876543210', '456 Oak Ave'),
    ('Alice', 'Johnson', 28, '5551234567', '789 Maple St'),
    ('Bob', 'Anderson', 35, '9998887777', '101 Pine St'),
    ('Eva', 'Williams', 22, '1112223333', '303 Cedar Ave'),
    ('Tom', 'Clark', 32, '4445556666', '505 Elm St');

SELECT * FROM Employee;

UPDATE Employee SET age = 31 WHERE id = 1;
UPDATE Employee SET address = '789 Pine St' WHERE id = 2;

DELETE FROM Employee WHERE id = 1;
TRUNCATE TABLE Employee;

-- Employee_Salary table
CREATE TABLE Employee_Salary (
  id INT PRIMARY KEY AUTO_INCREMENT, 
  employee_id INT, 
  salary INT, 
  date DATE, 
  FOREIGN KEY (employee_id) REFERENCES Employee(id) ON DELETE CASCADE
);

INSERT INTO Employee_Salary (employee_id, salary, date) 
VALUES 
  (1, 50000, '2023-01-15'), 
  (2, 60000, '2023-01-20'), 
  (3, 55000, '2023-01-25'), 
  (4, 50000, '2023-01-15'), 
  (5, 60000, '2023-01-20'), 
  (3, 55000, '2023-01-25');
 
SELECT * FROM Employee_Salary;

UPDATE Employee_Salary SET salary = 55000 WHERE id = 1;
UPDATE Employee_Salary SET date = '2023-01-25' WHERE id = 2;

DELETE FROM Employee_Salary WHERE id = 1;
TRUNCATE TABLE Employee_Salary;

-- Employee_Hobby table
CREATE TABLE Employee_Hobby (
  id INT PRIMARY KEY AUTO_INCREMENT, 
  employee_id INT, 
  hobby_id INT, 
  FOREIGN KEY (employee_id) REFERENCES Employee(id) ON DELETE CASCADE, 
  FOREIGN KEY (hobby_id) REFERENCES Hobby(id) ON DELETE CASCADE
);

INSERT INTO Employee_Hobby ( employee_id, hobby_id)
VALUES 
    ( 1, 1), 
    ( 2, 2),
    ( 1, 4), 
    ( 4, 3);

SELECT * FROM Employee_Hobby;

UPDATE Employee_Hobby SET hobby_id = 3 WHERE id = 1;  
UPDATE Employee_Hobby SET employee_id = 1 WHERE id = 2;

DELETE FROM Employee_Hobby WHERE id = 1;

TRUNCATE TABLE Employee_Hobby;

-- Create a select single query to get all employee name, all hobby_name in single column
SELECT    
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    GROUP_CONCAT(DISTINCT  h.name ORDER BY h.name DESC ) AS employee_hobbies
FROM 
    Employee as  e
LEFT JOIN 
    Employee_Hobby as eh ON e.id = eh.employee_id
LEFT JOIN 
    Hobby as h ON eh.hobby_id = h.id 
GROUP BY 
    e.id;

SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS result
FROM 
    Employee e

UNION

SELECT 
    h.name
FROM 
    Hobby h
ORDER BY
    result;

-- Create a select query to get  employee name, his/her employee_salary
SELECT
    e.first_name AS employee_name,
    SUM(es.salary) AS total_salary
FROM
    Employee e
LEFT JOIN
    Employee_Salary es ON e.id = es.employee_id
GROUP BY
    e.id;
    
  /* Create a select query to get employee name, total salary of employee, 
  hobby name(comma-separated - you need to use subquery for hobby name).
  */
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    COALESCE(SUM(es.salary), 0) AS total_salary,
    (
        SELECT GROUP_CONCAT(DISTINCT h.name ORDER BY h.name DESC SEPARATOR ', ') AS hobby_names
        FROM Hobby h
        JOIN Employee_Hobby eh ON h.id = eh.hobby_id
        WHERE eh.employee_id = e.id
    ) AS hobby_names
FROM 
    Employee e
LEFT JOIN 
    Employee_Salary es ON e.id = es.employee_id
GROUP BY 
    e.id;

SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    SUM(es.salary) AS total_salary,
    GROUP_CONCAT(DISTINCT h.name) AS hobby_names
FROM 
    Employee e
LEFT JOIN 
    Employee_Salary es ON e.id = es.employee_id
LEFT JOIN 
    Employee_Hobby eh ON e.id = eh.employee_id
LEFT JOIN 
    Hobby h ON eh.hobby_id = h.id
GROUP BY 
    e.id;
