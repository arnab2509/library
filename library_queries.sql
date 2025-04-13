-- Library Management System Queries

-- 1. View all currently loaned books with their due dates and borrower information
SELECT 
    l.loan_id,
    b.title AS book_title,
    CONCAT(a.first_name, ' ', a.last_name) AS author_name,
    CONCAT(m.first_name, ' ', m.last_name) AS borrower_name,
    l.loan_date,
    l.due_date,
    CASE 
        WHEN l.due_date < CURRENT_DATE AND l.return_date IS NULL THEN 'Overdue'
        WHEN l.return_date IS NULL THEN 'On Loan'
        ELSE 'Returned'
    END AS status
FROM 
    Loans l
    JOIN Books b ON l.book_id = b.book_id
    JOIN Authors a ON b.author_id = a.author_id
    JOIN Members m ON l.member_id = m.member_id
WHERE 
    l.return_date IS NULL
ORDER BY 
    l.due_date;

-- 2. Find overdue books (not returned and past due date)
SELECT 
    l.loan_id,
    b.title AS book_title,
    CONCAT(m.first_name, ' ', m.last_name) AS borrower_name,
    m.email AS borrower_email,
    m.phone AS borrower_phone,
    l.loan_date,
    l.due_date,
    CURRENT_DATE - l.due_date AS days_overdue
FROM 
    Loans l
    JOIN Books b ON l.book_id = b.book_id
    JOIN Members m ON l.member_id = m.member_id
WHERE 
    l.return_date IS NULL 
    AND l.due_date < CURRENT_DATE
ORDER BY 
    days_overdue DESC;

-- 3. Calculate fines for overdue books (not yet returned)
-- Assuming $1 fine per day overdue
SELECT 
    l.loan_id,
    b.title AS book_title,
    CONCAT(m.first_name, ' ', m.last_name) AS borrower_name,
    l.due_date,
    CURRENT_DATE - l.due_date AS days_overdue,
    (CURRENT_DATE - l.due_date) * 1.00 AS fine_amount
FROM 
    Loans l
    JOIN Books b ON l.book_id = b.book_id
    JOIN Members m ON l.member_id = m.member_id
    LEFT JOIN Fines f ON l.loan_id = f.loan_id
WHERE 
    l.return_date IS NULL 
    AND l.due_date < CURRENT_DATE
    AND f.loan_id IS NULL  -- No fine recorded yet
ORDER BY 
    days_overdue DESC;

-- 4. Calculate fines for books returned late
-- This is for when a book is returned after the due date
SELECT 
    l.loan_id,
    b.title AS book_title,
    CONCAT(m.first_name, ' ', m.last_name) AS borrower_name,
    l.due_date,
    l.return_date,
    l.return_date - l.due_date AS days_late,
    (l.return_date - l.due_date) * 1.00 AS fine_amount
FROM 
    Loans l
    JOIN Books b ON l.book_id = b.book_id
    JOIN Members m ON l.member_id = m.member_id
    LEFT JOIN Fines f ON l.loan_id = f.loan_id
WHERE 
    l.return_date > l.due_date
    AND f.loan_id IS NULL  -- No fine recorded yet
ORDER BY 
    days_late DESC;

-- 5. Show the most borrowed books (popularity ranking)
SELECT 
    b.book_id,
    b.title,
    CONCAT(a.first_name, ' ', a.last_name) AS author_name,
    COUNT(l.loan_id) AS borrow_count
FROM 
    Books b
    JOIN Authors a ON b.author_id = a.author_id
    JOIN Loans l ON b.book_id = l.book_id
GROUP BY 
    b.book_id, b.title, author_name
ORDER BY 
    borrow_count DESC;

-- 6. Show members with the most loans
SELECT 
    m.member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    COUNT(l.loan_id) AS loan_count
FROM 
    Members m
    JOIN Loans l ON m.member_id = l.member_id
GROUP BY 
    m.member_id, member_name
ORDER BY 
    loan_count DESC;

-- 7. Check book availability
SELECT 
    b.book_id,
    b.title,
    CONCAT(a.first_name, ' ', a.last_name) AS author_name,
    b.total_copies,
    b.available_copies,
    (b.total_copies - b.available_copies) AS copies_on_loan
FROM 
    Books b
    JOIN Authors a ON b.author_id = a.author_id
ORDER BY 
    available_copies ASC;

-- 8. Update available copies trigger (This would be a trigger in the database)
-- This is pseudo-code for a trigger - implementation varies by SQL dialect
/*
CREATE TRIGGER update_available_copies
AFTER INSERT OR UPDATE ON Loans
FOR EACH ROW
BEGIN
    -- If a book is being loaned (no return date)
    IF NEW.return_date IS NULL THEN
        UPDATE Books
        SET available_copies = available_copies - 1
        WHERE book_id = NEW.book_id;
    -- If a book is being returned (return date is added)
    ELSE
        UPDATE Books
        SET available_copies = available_copies + 1
        WHERE book_id = NEW.book_id;
    END IF;
END;
*/

-- 9. Stored procedure to add a fine for an overdue book
-- This is pseudo-code for a stored procedure - implementation varies by SQL dialect
/*
CREATE PROCEDURE add_fine_for_overdue(IN loan_id_param INT)
BEGIN
    DECLARE days_overdue INT;
    DECLARE fine_amount DECIMAL(10, 2);
    
    -- Calculate days overdue
    SELECT 
        CASE
            WHEN return_date IS NULL THEN CURRENT_DATE - due_date
            ELSE return_date - due_date
        END INTO days_overdue
    FROM Loans
    WHERE loan_id = loan_id_param;
    
    -- Only process if overdue
    IF days_overdue > 0 THEN
        -- Calculate fine ($1 per day)
        SET fine_amount = days_overdue * 1.00;
        
        -- Insert fine record
        INSERT INTO Fines (loan_id, fine_amount, fine_date)
        VALUES (loan_id_param, fine_amount, CURRENT_DATE);
    END IF;
END;
*/ 