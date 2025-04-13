-- Sample data for Library Management System

-- Insert Authors
INSERT INTO Authors (author_id, first_name, last_name, birth_date, nationality)
VALUES 
(1, 'Jane', 'Austen', '1775-12-16', 'British'),
(2, 'George', 'Orwell', '1903-06-25', 'British'),
(3, 'J.K.', 'Rowling', '1965-07-31', 'British'),
(4, 'Stephen', 'King', '1947-09-21', 'American'),
(5, 'Toni', 'Morrison', '1931-02-18', 'American');

-- Insert Books
INSERT INTO Books (book_id, title, author_id, isbn, publication_year, genre, total_copies, available_copies)
VALUES
(1, 'Pride and Prejudice', 1, '9780141439518', 1813, 'Classic', 5, 3),
(2, '1984', 2, '9780451524935', 1949, 'Dystopian', 7, 5),
(3, 'Harry Potter and the Philosopher''s Stone', 3, '9780747532743', 1997, 'Fantasy', 10, 7),
(4, 'The Shining', 4, '9780307743657', 1977, 'Horror', 4, 4),
(5, 'Beloved', 5, '9781400033416', 1987, 'Historical Fiction', 3, 2),
(6, 'Animal Farm', 2, '9780451526342', 1945, 'Satire', 6, 4),
(7, 'Harry Potter and the Chamber of Secrets', 3, '9780747538486', 1998, 'Fantasy', 8, 6),
(8, 'It', 4, '9781501142970', 1986, 'Horror', 5, 3),
(9, 'Sense and Sensibility', 1, '9780141439662', 1811, 'Classic', 4, 3),
(10, 'Song of Solomon', 5, '9781400033423', 1977, 'Fiction', 3, 2);

-- Insert Members
INSERT INTO Members (member_id, first_name, last_name, email, phone, address, join_date, membership_status)
VALUES
(1, 'John', 'Smith', 'john.smith@email.com', '555-1234', '123 Main St, Anytown', '2023-01-15', 'Active'),
(2, 'Emily', 'Johnson', 'emily.j@email.com', '555-2345', '456 Oak Ave, Somewhere', '2023-02-20', 'Active'),
(3, 'Michael', 'Williams', 'mike.w@email.com', '555-3456', '789 Pine Rd, Nowhere', '2023-03-10', 'Active'),
(4, 'Sarah', 'Brown', 'sarah.b@email.com', '555-4567', '321 Elm St, Anywhere', '2023-04-05', 'Inactive'),
(5, 'David', 'Jones', 'david.j@email.com', '555-5678', '654 Maple Dr, Everywhere', '2023-05-12', 'Active');

-- Insert Loans (some returned, some active, some overdue)
INSERT INTO Loans (loan_id, book_id, member_id, loan_date, due_date, return_date)
VALUES
-- Returned loans
(1, 1, 1, '2023-06-01', '2023-06-15', '2023-06-14'),
(2, 3, 2, '2023-06-05', '2023-06-19', '2023-06-18'),
(3, 5, 3, '2023-06-10', '2023-06-24', '2023-06-30'), -- Returned late
-- Active loans (not overdue)
(4, 2, 1, '2023-07-01', '2023-07-15', NULL),
(5, 7, 5, '2023-07-05', '2023-07-19', NULL),
-- Overdue loans (assuming current date is after due date)
(6, 8, 2, '2023-06-20', '2023-07-04', NULL),
(7, 10, 3, '2023-06-25', '2023-07-09', NULL),
-- Historical borrowing for popularity analysis
(8, 3, 4, '2023-05-01', '2023-05-15', '2023-05-10'),
(9, 3, 5, '2023-05-20', '2023-06-03', '2023-06-02'),
(10, 1, 2, '2023-05-05', '2023-05-19', '2023-05-18'),
(11, 1, 3, '2023-05-25', '2023-06-08', '2023-06-05'),
(12, 5, 1, '2023-05-10', '2023-05-24', '2023-05-23');

-- Insert Fines for late returns
INSERT INTO Fines (fine_id, loan_id, fine_amount, fine_date, payment_date)
VALUES
(1, 3, 6.00, '2023-06-30', '2023-07-05'); -- $1 per day for 6 days late 