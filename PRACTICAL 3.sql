CREATE DATABASE college_demo;
USE collage_demo;
CREATE TABLE department (
dept_id INT PRIMARY KEY,
dept_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE student (
roll_no INT PRIMARY KEY,
name VARCHAR(50) NOT NULL,
email VARCHAR(50) UNIQUE,
aadhar_no VARCHAR(12) UNIQUE,
dept_id INT,
FOREIGN KEY (dept_id) REFERENCES department(dept_id)
);

CREATE TABLE course (
course_id INT PRIMARY KEY,
course_name VARCHAR(50) NOT NULL,
dept_id INT,
FOREIGN KEY (dept_id) REFERENCES department(dept_ID)
);

CREATE TABLE enrollment (
roll_no INT,
course_id INT,
semester INT CHECK (semester BETWEEN 1 AND 8),
grade CHAR(2),
PRIMARY KEY (roll_no, course_id, semester),
FOREIGN KEY (roll_no) REFERENCES student(roll_no),
FOREIGN KEY (course_id) REFERENCES course(course_id)
);
 
 -- 1. Insert into department
INSERT INTO department (dept_id, dept_name) 
VALUES 
  (1, 'Electronics'),
  (2, 'Computer Science');

-- 2. Insert into student
INSERT INTO student (roll_no, name, email, aadhar_no, dept_id) 
VALUES 
  (101, 'Alex', 'alex@example.com', '123456789012', 1),
  (102, 'Sam', 'sam@example.com', '987654321098', 2);

-- 3. Insert into course
INSERT INTO course (course_id, course_name, dept_id) 
VALUES 
  (201, 'Digital Electronics', 1),
  (202, 'Data Structures', 2);

-- 4. Insert into enrollment
INSERT INTO enrollment (roll_no, course_id, semester, grade) 
VALUES 
  (101, 201, 1, 'A'),
  (102, 202, 2, 'B+');

create index idx_student_dept on student(dept_id);
select*from student where dept_id = 1;
