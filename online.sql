CREATE DATABASE IF NOT EXISTS online_exam;

USE online_exam;

CREATE TABLE users (
    id BIGINT NOT NULL AUTO_INCREMENT,
    username VARCHAR(255) UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(255),
    email VARCHAR(255) UNIQUE,
    role VARCHAR(255),
    active TINYINT(1) DEFAULT 1,
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    updated_on DATETIME(6),
    roll_no VARCHAR(255),
    class_name VARCHAR(255),
    section VARCHAR(255),
    display_password VARCHAR(255),
    PRIMARY KEY (id)
);

CREATE TABLE audit_log (
    id BIGINT NOT NULL AUTO_INCREMENT,
    user_id BIGINT,
    action VARCHAR(200),
    details TEXT,
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE exams (
    id BIGINT NOT NULL AUTO_INCREMENT,
    exam_name VARCHAR(255),
    description VARCHAR(255),
    duration_minutes INT NOT NULL,
    total_marks INT DEFAULT 0,
    start_time DATETIME,
    end_time DATETIME,
    status VARCHAR(255),
    created_by BIGINT NOT NULL,
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    class_name VARCHAR(255),
    question_count INT,
    PRIMARY KEY (id),
    FOREIGN KEY (created_by) REFERENCES users(id)
);

CREATE TABLE questions (
    id BIGINT NOT NULL AUTO_INCREMENT,
    exam_id BIGINT NOT NULL,
    question_text VARCHAR(5000),
    question_type ENUM('MCQ','TRUE_FALSE') DEFAULT 'MCQ',
    marks INT DEFAULT 1,
    correct_option VARCHAR(255),
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE CASCADE
);

CREATE TABLE question_options (
    id BIGINT NOT NULL AUTO_INCREMENT,
    question_id BIGINT NOT NULL,
    option_code VARCHAR(255),
    option_text VARCHAR(255),
    PRIMARY KEY (id),
    FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
);

CREATE TABLE refresh_tokens (
    id BIGINT NOT NULL AUTO_INCREMENT,
    expiry_date DATETIME(6),
    token VARCHAR(255),
    user_id BIGINT,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE student_exam_attempt (
    id BIGINT NOT NULL AUTO_INCREMENT,
    student_id BIGINT NOT NULL,
    exam_id BIGINT NOT NULL,
    start_time DATETIME,
    end_time DATETIME,
    status VARCHAR(255),
    score DOUBLE,
    PRIMARY KEY (id),
    FOREIGN KEY (student_id) REFERENCES users(id),
    FOREIGN KEY (exam_id) REFERENCES exams(id)
);

CREATE TABLE student_answers (
    id BIGINT NOT NULL AUTO_INCREMENT,
    attempt_id BIGINT NOT NULL,
    question_id BIGINT NOT NULL,
    selected_option VARCHAR(255),
    answered_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_correct TINYINT(1),
    marks_obtained DOUBLE,
    selected_option_text VARCHAR(255),
    PRIMARY KEY (id),
    FOREIGN KEY (attempt_id) REFERENCES student_exam_attempt(id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE student_attempt_questions (
    id BIGINT NOT NULL AUTO_INCREMENT,
    attempt_id BIGINT NOT NULL,
    question_id BIGINT NOT NULL,
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (attempt_id) REFERENCES student_exam_attempt(id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE student_exam_assignment (
    id BIGINT NOT NULL AUTO_INCREMENT,
    student_id BIGINT NOT NULL,
    exam_id BIGINT NOT NULL,
    assigned_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE (student_id, exam_id),
    FOREIGN KEY (student_id) REFERENCES users(id),
    FOREIGN KEY (exam_id) REFERENCES exams(id)
);

CREATE TABLE results (
    id BIGINT NOT NULL AUTO_INCREMENT,
    student_id BIGINT NOT NULL,
    exam_id BIGINT NOT NULL,
    total_marks INT NOT NULL,
    obtained_marks INT NOT NULL,
    percentage DECIMAL(38,2),
    result_status VARCHAR(255),
    generated_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (student_id) REFERENCES users(id),
    FOREIGN KEY (exam_id) REFERENCES exams(id)
);



INSERT INTO users
(username,password,full_name,email,role,display_password)
VALUES
('admin','$2a$10$okU0YaU2yy/l769yVNZCU.zjkxlJiHTeZfBdLn9iyy3GqjeaYb6Um','System Admin',
 'admin@test.com','ADMIN','password'),
('teacher','$2a$10$okU0YaU2yy/l769yVNZCU.zjkxlJiHTeZfBdLn9iyy3GqjeaYb6Um','Teacher',
 'teacher1@test.com','TEACHER','password');