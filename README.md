# 🎓 Simple College Management Database (MySQL)

A beginner-friendly relational database project to manage departments, students, courses, and student course enrollments.

---

## 📌 Tables Overview

* **`department`** — Stores department details (`dept_id`, `dept_name`).
* **`student`** — Stores student details and links to their department (`roll_no`, `name`, `email`, `aadhar_no`, `dept_id`).
* **`course`** — Stores available subjects offered by departments (`course_id`, `course_name`, `dept_id`).
* **`enrollment`** — Tracks student course registration, semester, and grade (`roll_no`, `course_id`, `semester`, `grade`).

---

## 🚀 Database Script

```sql
CREATE DATABASE college_demo;
USE college_demo;

-- 1. Department Table
CREATE TABLE department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) UNIQUE NOT NULL
);

-- 2. Student Table
CREATE TABLE student (
    roll_no INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(50) UNIQUE,
    aadhar_no VARCHAR(12) UNIQUE,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES department(dept_id)
);

-- 3. Course Table
CREATE TABLE course (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50) NOT NULL,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES department(dept_id)
);

-- 4. Enrollment Table (Composite Primary Key)
CREATE TABLE enrollment (
    roll_no INT,
    course_id INT,
    semester INT CHECK (semester BETWEEN 1 AND 8),
    grade CHAR(2),
    PRIMARY KEY (roll_no, course_id, semester),
    FOREIGN KEY (roll_no) REFERENCES student(roll_no),
    FOREIGN KEY (course_id) REFERENCES course(course_id)
);

-- Sample Data Insertion
INSERT INTO department (dept_id, dept_name) 
VALUES 
    (1, 'Electronics'),
    (2, 'Computer Science');

INSERT INTO student (roll_no, name, email, aadhar_no, dept_id) 
VALUES 
    (101, 'Alex', 'alex@example.com', '123456789012', 1),
    (102, 'Sam', 'sam@example.com', '987654321098', 2);

INSERT INTO course (course_id, course_name, dept_id) 
VALUES 
    (201, 'Digital Electronics', 1),
    (202, 'Data Structures', 2);

INSERT INTO enrollment (roll_no, course_id, semester, grade) 
VALUES 
    (101, 201, 1, 'A'),
    (102, 202, 2, 'B+');

NORMALIZATION
Your schema satisfies **Boyce-Codd Normal Form (BCNF)**. It is well-structured for a relational model, with a few small syntax typos and domain-specific edge cases to consider for higher-level normalization (4NF/5NF) and database integrity.

---

### Normalization Breakdown

| Normal Form | Status | Why / Notes |
| --- | --- | --- |
| **1NF** (First Normal Form) | **Achieved** | All columns hold atomic values (no multivalued attributes or repeating groups), and each table has an explicit primary key. |
| **2NF** (Second Normal Form) | **Achieved** | In tables with single-column keys (`department`, `student`, `course`), partial dependency is impossible. In `enrollment` (composite key: `roll_no, course_id, semester`), `grade` depends on the **entire** composite key (a student receives a grade for a specific course in a specific semester). |
| **3NF** (Third Normal Form) | **Achieved** | No transitive functional dependencies exist ($X \to Y \to Z$ where non-prime attributes determine other non-prime attributes). |
| **BCNF** (Boyce-Codd Normal Form) | **Achieved** | For every functional dependency $X \to Y$, the determinant $X$ is a superkey / candidate key (e.g., in `student`, `roll_no`, `email`, and `aadhar_no` are all candidate keys). |
| **4NF** (Fourth Normal Form) | **Achieved (Conditionally)** | Satisfied because there are no independent multi-valued dependencies (MVDs). However, if `enrollment` were modified to track independent attributes (e.g., student clubs/hobbies alongside enrolled courses in the same table), 4NF would be violated. |
| **5NF** (Fifth Normal Form) | **Not explicitly applied** | Join dependencies are trivial and preserved across primary-foreign key relationships. |

---

### How the Schema Can Be Better

* **Fix Database Name Typo:** You wrote `CREATE DATABASE college_demo;` but followed with `USE collage_demo;` (typo in `collage`).
* **Fix Foreign Key Case/Identifier:** In `course`, the reference `REFERENCES department(dept_ID)` has inconsistent casing (`dept_ID` vs `dept_id`).
* **Add Academic Year / Term to Enrollments:** A student repeating a course in the same semester number across different calendar years will collide on `PRIMARY KEY (roll_no, course_id, semester)`. Adding `academic_year` (e.g., `2025-2026`) creates an airtight composite key.
* **Faculty & Instructor Linkage:** Real college schemas typically link courses to faculty sections rather than assigning students directly to an abstract course.
* **Referential Action Policies:** Add `ON DELETE RESTRICT` or `ON DELETE CASCADE` to foreign keys so orphan records or unintended cascading deletes are handled explicitly.

---

### GitHub `README.md`

```markdown
# 🎓 College Management Database & Normalization Analysis

A relational database management system (RDBMS) schema designed to track academic departments, students, courses, and course enrollments, fully normalized up to **Boyce-Codd Normal Form (BCNF)**.

---

## 🏛️ Entity-Relationship Architecture

```text
[ department ] (1) ──< (N) [ student ] (1) ──< (N) [ enrollment ]
      │                                                   │
      └──────────────< (N) [ course ] (1) ────────────────┘

```

### Table Dictionary

| Table | Primary Key | Candidate Keys / Constraints | Foreign Keys | Purpose |
| --- | --- | --- | --- | --- |
| **`department`** | `dept_id` | `dept_name` (UNIQUE) | *None* | Academic departments offering degree programs. |
| **`student`** | `roll_no` | `email` (UNIQUE), `aadhar_no` (UNIQUE) | `dept_id` | Student profiles and identification records. |
| **`course`** | `course_id` | *None* | `dept_id` | Curricular subjects offered by departments. |
| **`enrollment`** | `(roll_no, course_id, semester)` | *Composite Key* | `roll_no`, `course_id` | Course registration and grading ledger. |

---

## 🔬 Normalization Analysis

### 1️⃣ First Normal Form (1NF) — ✅ Satisfied

* **Atomicity:** All attributes contain indivisible scalar data.
* **Key Definition:** Every table contains a well-defined primary key.
* **No Repeating Groups:** Multi-course registrations are handled as separate rows in a junction table (`enrollment`), not flat arrays.

### 2️⃣ Second Normal Form (2NF) — ✅ Satisfied

* Tables with single-column keys (`department`, `student`, `course`) naturally have no partial dependencies.
* In `enrollment`, the composite key is `(roll_no, course_id, semester)`. The non-key attribute `grade` depends on the complete triplet: a grade cannot be determined by `roll_no` or `course_id` alone.

### 3️⃣ Third Normal Form (3NF) — ✅ Satisfied

* There are no transitive functional dependencies ($X \to Y \to Z$).
* Non-key columns depend directly and strictly on candidate keys.

### 4️⃣ Boyce-Codd Normal Form (BCNF) — ✅ Satisfied

* In all relations, every functional determinant is a superkey.
* In the `student` table, multiple candidate keys exist (`roll_no`, `email`, `aadhar_no`), and each uniquely identifies the record without creating partial or overlapping dependencies.

---

## 🚀 SQL Implementation & DDL

```sql
CREATE DATABASE IF NOT EXISTS college_demo;
USE college_demo;

-- 1. Departments
CREATE TABLE department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) UNIQUE NOT NULL
);

-- 2. Students
CREATE TABLE student (
    roll_no INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    aadhar_no VARCHAR(12) UNIQUE NOT NULL,
    dept_id INT NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES department(dept_id) ON DELETE RESTRICT
);

-- 3. Courses
CREATE TABLE course (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50) NOT NULL,
    dept_id INT NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES department(dept_id) ON DELETE RESTRICT
);

-- 4. Enrollments (Junction Table)
CREATE TABLE enrollment (
    roll_no INT NOT NULL,
    course_id INT NOT NULL,
    semester INT NOT NULL CHECK (semester BETWEEN 1 AND 8),
    academic_year VARCHAR(9) NOT NULL, -- e.g., '2025-2026'
    grade VARCHAR(2),
    PRIMARY KEY (roll_no, course_id, semester, academic_year),
    FOREIGN KEY (roll_no) REFERENCES student(roll_no) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES course(course_id) ON DELETE RESTRICT
);

```

---

## 📥 Sample Seed Data

```sql
INSERT INTO department (dept_id, dept_name) 
VALUES 
  (1, 'Electronics'),
  (2, 'Computer Science');

INSERT INTO student (roll_no, name, email, aadhar_no, dept_id) 
VALUES 
  (101, 'Alex', 'alex@example.com', '123456789012', 1),
  (102, 'Sam', 'sam@example.com', '987654321098', 2);

INSERT INTO course (course_id, course_name, dept_id) 
VALUES 
  (201, 'Digital Electronics', 1),
  (202, 'Data Structures', 2);

INSERT INTO enrollment (roll_no, course_id, semester, academic_year, grade) 
VALUES 
  (101, 201, 1, '2025-2026', 'A'),
  (102, 202, 2, '2025-2026', 'B+');

```

---

## 💡 Recommended Enhancements

1. **Course Prerequisites:** Add a self-referential `prerequisites` table (`course_id`, `prerequisite_course_id`) to enforce curriculum pathways.
2. **Faculty Assignments:** Introduce a `faculty` table and an intermediary `course_offering` entity to capture instructor assignments per semester.
3. **Grade Point Mapping:** Create a lookup table for letter grades and corresponding GPA weights (e.g., `A = 10`, `B+ = 8`).

```

<ElicitationsGroup message="To develop this schema further:">
  <Elicitation label="Add course prerequisites and faculty assignments" query="Refactor this college database schema to include faculty assignments, course sections, and a prerequisite table."/>
  <Elicitation label="Write SQL queries for GPA and department analytics" query="Write SQL queries to compute student semester GPAs, departmental pass rates, and course enrollment totals."/>
</ElicitationsGroup>

```
