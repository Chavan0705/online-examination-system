CREATE DATABASE IF NOT EXISTS online_exam_db;
USE online_exam_db;

-- 1. Admin Table
CREATE TABLE IF NOT EXISTS admin (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);

-- 2. Student Table
CREATE TABLE IF NOT EXISTS student (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    mobile VARCHAR(15) NOT NULL,
    password VARCHAR(255) NOT NULL,
    course VARCHAR(100),
    semester VARCHAR(50)
);

-- 3. Subject Table
CREATE TABLE IF NOT EXISTS subject (
    id INT AUTO_INCREMENT PRIMARY KEY,
    subject_name VARCHAR(100) NOT NULL UNIQUE
);

-- 4. Exam Table
CREATE TABLE IF NOT EXISTS exam (
    id INT AUTO_INCREMENT PRIMARY KEY,
    exam_name VARCHAR(100) NOT NULL,
    subject_id INT,
    duration INT NOT NULL, -- in minutes
    total_marks INT NOT NULL,
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    is_published BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (subject_id) REFERENCES subject(id) ON DELETE CASCADE
);

-- 5. Question Table
CREATE TABLE IF NOT EXISTS question (
    id INT AUTO_INCREMENT PRIMARY KEY,
    exam_id INT,
    question TEXT NOT NULL,
    option_a TEXT NOT NULL,
    option_b TEXT NOT NULL,
    option_c TEXT NOT NULL,
    option_d TEXT NOT NULL,
    correct_answer VARCHAR(5) NOT NULL, -- A, B, C, D
    marks INT NOT NULL,
    FOREIGN KEY (exam_id) REFERENCES exam(id) ON DELETE CASCADE
);

-- 6. Result Table
CREATE TABLE IF NOT EXISTS result (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    exam_id INT,
    total_questions INT NOT NULL,
    attempted INT NOT NULL,
    correct INT NOT NULL,
    wrong INT NOT NULL,
    marks INT NOT NULL,
    percentage DOUBLE NOT NULL,
    result_status VARCHAR(20) NOT NULL, -- Pass / Fail
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES student(id) ON DELETE CASCADE,
    FOREIGN KEY (exam_id) REFERENCES exam(id) ON DELETE CASCADE,
    UNIQUE KEY unique_student_exam (student_id, exam_id)
);

-- 7. Activity Log Table
CREATE TABLE IF NOT EXISTS activity_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_type VARCHAR(20) NOT NULL,
    user_name VARCHAR(100) NOT NULL,
    activity TEXT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Seed default Admin if not exists (username: admin, password: admin123)
-- BCrypt hash of 'admin123' is '$2a$10$Y1/n2pA4bNskhCcrJtFhDuy.NnF/N7m4qPpeX5W7Qh739C70nE70e'
INSERT INTO admin (username, password)
SELECT 'admin', '$2a$10$Y1/n2pA4bNskhCcrJtFhDuy.NnF/N7m4qPpeX5W7Qh739C70nE70e'
WHERE NOT EXISTS (SELECT 1 FROM admin WHERE username = 'admin');
