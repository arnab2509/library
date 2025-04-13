-- Library Management System Schema
-- Tables: Books, Authors, Members, Loans, Fines

-- Create Authors table
CREATE TABLE Authors (
    author_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_date DATE,
    nationality VARCHAR(50)
);

-- Create Books table
CREATE TABLE Books (
    book_id INT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    author_id INT NOT NULL,
    isbn VARCHAR(20) UNIQUE,
    publication_year INT,
    genre VARCHAR(50),
    total_copies INT NOT NULL DEFAULT 1,
    available_copies INT NOT NULL DEFAULT 1,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id)
);

-- Create Members table
CREATE TABLE Members (
    member_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    address VARCHAR(200),
    join_date DATE NOT NULL DEFAULT CURRENT_DATE,
    membership_status VARCHAR(20) NOT NULL DEFAULT 'Active'
);

-- Create Loans table
CREATE TABLE Loans (
    loan_id INT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    loan_date DATE NOT NULL DEFAULT CURRENT_DATE,
    due_date DATE NOT NULL,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);

-- Create Fines table
CREATE TABLE Fines (
    fine_id INT PRIMARY KEY,
    loan_id INT NOT NULL,
    fine_amount DECIMAL(10, 2) NOT NULL,
    fine_date DATE NOT NULL DEFAULT CURRENT_DATE,
    payment_date DATE,
    FOREIGN KEY (loan_id) REFERENCES Loans(loan_id)
);

-- Add indexes for performance
CREATE INDEX idx_books_author ON Books(author_id);
CREATE INDEX idx_loans_book ON Loans(book_id);
CREATE INDEX idx_loans_member ON Loans(member_id);
CREATE INDEX idx_loans_due_date ON Loans(due_date);
CREATE INDEX idx_fines_loan ON Fines(loan_id); 