SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employee;
SELECT * FROM issued_status;
SELECT * FROM return_status;
SELECT * FROM members;

--Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')

INSERT INTO books( isbn, book_title,category,rental_price,status, author,publisher)
VALUES ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')

--Task 2: Update an Existing Member's Address

UPDATE members
SET member_address = '125 Main St'
WHERE member_id = 'C101';
SELECT * FROM members;

--Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

DELETE FROM issued_status
WHERE issued_id = 'IS121';
SELECT * FROM issued_status;

--Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E105'.

SELECT * FROM issued_status
WHERE issued_emp_id= 'E105'

--Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT 
issued_member_id,
COUNT(issued_id) as total_book_issued
FROM issued_status
GROUP BY issued_member_id
HAVING COUNT(issued_id) >1

--CTAS (Create Table As Select)
--Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

CREATE TABLE book_cnts
AS
SELECT 
b.isbn,
b.book_title,
COUNT(ist.issued_id) as no_issued
FROM books as b
JOIN
issued_status as ist
ON ist.issued_book_isbn =b.isbn
GROUP BY 1,2;

SELECT * FROM book_cnts

--Task 7. Retrieve All Books in a Specific Category:

SELECT * FROM books
WHERE category= 'History';

--Task 8: Find Total Rental Income by Category:
SELECT
b.category,
SUM(b.rental_price),
COUNT(*)
FROM books as b
JOIN
issued_status as ist
ON ist.issued_book_isbn =b.isbn
GROUP BY 1;

-- Task 9 List Members Who Registered in the Last 180 Days:
SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days' 

INSERT INTO members( member_id, member_name, member_address, reg_date)
VALUES
('C117', 'Shreeraj', '431 Oak St', '2024-06-01'),
('C120', 'Raj', '167 Oak St', '2024-05-01');

UPDATE members
SET reg_date = '2024-12-01'
WHERE member_id = 'C117'

UPDATE members
SET reg_date = '2024-11-01'
WHERE member_id = 'C120'

--Task 10.List Employees with Their Branch Manager's Name and their branch details:

SELECT 
e1.*,
b.manager_id,
e2.emp_name as manager
FROM employee as e1
JOIN
branch as b
ON e1.branch_id = b.branch_id
JOIN 
employee as e2
ON 
e2.emp_id= b.manager_id

--Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:
DROP TABLE IF EXISTS expensive_books;
CREATE TABLE price_above_six
AS
SELECT * FROM books
WHERE rental_price > 6;

SELECT * FROM price_above_six

--Task 12: Retrieve the List of Books Not Yet Returned
SELECT * FROM issued_status as ist
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;


