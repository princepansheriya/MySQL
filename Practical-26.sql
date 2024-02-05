-- create databse
create database employee;	
use employee;
drop database employee;

-- hobby table
create table hobby(
  id int primary key auto_increment, 
  name varchar(255) not null unique
);

INSERT INTO hobby (name) 
VALUES 
  ('Reading'), 
  ('Gardening'), 
  ('Painting'), 
  ('Cooking'), 
  ('Traveling');

SELECT * FROM hobby;
DELETE FROM hobby WHERE id in(1,2);

UPDATE hobby SET name = 'Learning' WHERE id = 1;
UPDATE hobby SET name = 'Writing' WHERE id = 2;

TRUNCATE TABLE hobby;

-- employee table
 create table employee(
  id int primary key auto_increment, 
  first_name varchar(255) not null, 
  last_name varchar(255) not null, 
  age int not null, 
  mobile_number varchar(10) unique, 
  address varchar(255)
);

INSERT INTO employee (first_name, last_name, age, mobile_number, address)
VALUES 
    ('John', 'Doe', 30, '1239567890', '123 Main St'),
    ('Jane', 'Smith', 25, '9876543210', '456 Oak Ave'),
    ('Alice', 'Johnson', 28, '5551234567', '789 Maple St'),
    ('Bob', 'Anderson', 35, '9998887777', '101 Pine St'),
    ('Eva', 'Williams', 22, '1112223333', '303 Cedar Ave'),
    ('Tom', 'Clark', 32, '4445556666', '505 Elm St');

SELECT * FROM employee;

UPDATE employee SET age = 31 WHERE id = 1;
UPDATE employee SET address = '789 Pine St' WHERE id = 2;

DELETE FROM employee WHERE id = 1;
TRUNCATE TABLE employee;

-- employee_salary table
 create table employee_salary (
  id int primary key auto_increment, 
  employee_id int, 
  salary int, 
  date date, 
  foreign key (employee_id) references employee(id) ON DELETE CASCADE
);

INSERT INTO employee_salary (employee_id, salary, date) 
VALUES 
  (1, 50000, '2023-01-15'), 
  (2, 60000, '2023-01-20'), 
  (3, 55000, '2023-01-25'), 
  (4, 50000, '2023-01-15'), 
  (5, 60000, '2023-01-20'), 
  (3, 55000, '2023-01-25');
 
SELECT * FROM employee_salary;

UPDATE employee_salary SET salary = 55000 WHERE id = 1;
UPDATE employee_salary SET date = '2023-01-25' WHERE id = 2;

DELETE FROM employee_salary WHERE id = 1;
TRUNCATE TABLE employee_salary;

-- employee_hobby table
create table employee_hobby(
  id int primary key auto_increment, 
  employee_id int, 
  hobby_id int, 
  foreign key (employee_id) references employee(id) ON DELETE CASCADE, 
  foreign key (hobby_id) references hobby(id) ON DELETE CASCADE
);

INSERT INTO employee_hobby ( employee_id, hobby_id)
VALUES 
    ( 1, 1), 
    ( 2, 2),
    ( 1, 4), 
    ( 4, 3);

SELECT * FROM employee_hobby;

UPDATE employee_hobby SET hobby_id = 3 WHERE id = 1;  
UPDATE employee_hobby SET employee_id = 1 WHERE id = 2;

DELETE FROM employee_hobby WHERE id = 1;

TRUNCATE TABLE employee_hobby;

-- Create a select single query to get all employee name, all hobby_name in single column
SELECT    
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    GROUP_CONCAT(DISTINCT  h.name ORDER BY h.name desc ) AS employee_hobbies
FROM 
    employee as  e
LEFT JOIN 
    employee_hobby as eh ON e.id = eh.employee_id
LEFT JOIN 
    hobby as h ON eh.hobby_id = h.id 
GROUP BY 
    e.id;

SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS result
FROM 
    employee e

UNION

SELECT 
    h.name
FROM 
    hobby h
ORDER BY
    result;

-- Create a select query to get  employee name, his/her employee_salary
SELECT
    e.first_name AS employee_name,
    SUM(es.salary) AS total_salary
FROM
    employee e
left JOIN
    employee_salary es ON e.id = es.employee_id
GROUP BY
    e.id;
    
  /* Create a select query to get employee name, total salary of employee, 
  hobby name(comma-separated - you need to use subquery for hobby name).
  */
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    COALESCE(SUM(es.salary), 0) AS total_salary,
    (
        SELECT GROUP_CONCAT(DISTINCT h.name ORDER BY h.name desc SEPARATOR ', ') AS hobby_names
        FROM hobby h
        JOIN employee_hobby eh ON h.id = eh.hobby_id
        WHERE eh.employee_id = e.id
    ) AS hobby_names
FROM 
    employee e
LEFT JOIN 
    employee_salary es ON e.id = es.employee_id
GROUP BY 
    e.id;

SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    SUM(es.salary) AS total_salary,
    GROUP_CONCAT(DISTINCT h.name) AS hobby_names
FROM 
    employee e
LEFT JOIN 
    employee_salary es ON e.id = es.employee_id
LEFT JOIN 
    employee_hobby eh ON e.id = eh.employee_id
LEFT JOIN 
    hobby h ON eh.hobby_id = h.id
GROUP BY 
    e.id;

    