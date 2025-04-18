# Library Management System

A SQL-based system for managing library operations including book loans, returns, and fine calculations.

## Project Structure

- `library_schema.sql`: Contains the database schema with tables for Books, Authors, Members, Loans, and Fines
- `sample_data.sql`: Sample data to populate the database
- `library_queries.sql`: SQL queries for common library operations

## Tables

1. **Authors**: Stores information about book authors
2. **Books**: Contains book details including availability
3. **Members**: Stores library member information
4. **Loans**: Tracks book loans, due dates, and returns
5. **Fines**: Records fines for overdue books

## Features

### Track Loans and Due Dates
- View all currently loaned books
- See who has borrowed which books
- Track due dates for returns

### Find Overdue Books
- Identify books that are past their due date
- Get borrower contact information for notifications

### Calculate Fines
- Automatically calculate fines based on days overdue
- Track fine payment status
- Apply $1 per day late fee

### Book Popularity Analysis
- See which books are borrowed most frequently
- Identify active members
- Monitor book availability

## Usage

1. Create the database structure:
   ```sql
   -- Run the schema creation script
   SOURCE library_schema.sql;
   ```

2. Load sample data:
   ```sql
   -- Populate with sample data
   SOURCE sample_data.sql;
   ```

3. Run queries from `library_queries.sql` to perform various operations.

## Query Examples

### Find Overdue Books
```sql
SELECT 
    l.loan_id,
    b.title AS book_title,
    CONCAT(m.first_name, ' ', m.last_name) AS borrower_name,
    m.email AS borrower_email,
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
```

### Show Most Popular Books
```sql
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
``` #   l i b r a r y  
 