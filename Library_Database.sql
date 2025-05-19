CREATE TABLE Books (
	book_id INT PRIMARY KEY,
	title VARCHAR(255) NOT NULL,
	author VARCHAR(255) NOT NULL,
	genre VARCHAR(100),
	published_year INT,
	copies_available BOOLEAN DEFAULT TRUE
);

CREATE TABLE Members (
	member_id INT NOT NULL PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
	email VARCHAR(255),
	phone_number VARCHAR(15),
	join_date DATE DEFAULT (CURRENT_DATE)
);

CREATE TABLE Librarians (
	librarian_id INT NOT NULL PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
	email VARCHAR(255) NOT NULL,
	phone_number VARCHAR(15),
	join_date DATE DEFAULT (CURRENT_DATE)
);

CREATE TABLE Checkouts (
    checkout_id INT PRIMARY KEY,
    member_id INT NOT NULL,
    book_id INT NOT NULL,
    checkout_date DATE NOT NULL,
    return_date DATE,
    FOREIGN KEY (member_ID) REFERENCES members(member_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);




-- Triggers for books checked out or returned

CREATE FUNCTION reduce_available_copies_func() RETURNS TRIGGER AS $$
BEGIN
    UPDATE books
    SET copies_available = copies_available - 1
    WHERE book_id = NEW.book_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER reduce_available_copies
AFTER INSERT ON checkouts
FOR EACH ROW
EXECUTE FUNCTION reduce_available_copies_func();


CREATE FUNCTION restore_available_copies_func() RETURNS TRIGGER AS $$
BEGIN
    -- Ensure this only runs when the return_date changes from NULL to a real date
    IF OLD.return_date IS NULL AND NEW.return_date IS NOT NULL THEN
        UPDATE books
        SET copies_available = copies_available + 1
        WHERE book_id = NEW.book_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER restore_available_copies
AFTER UPDATE ON checkouts
FOR EACH ROW
EXECUTE FUNCTION restore_available_copies_func();

-- Inserting values into tables

SELECT * FROM books;

INSERT INTO books (book_id, title, author, genre, published_year, copies_available)
VALUES
	(1, 'The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction', 1925, 5),
	(2, 'Frankenstein', 'Mary Shelley', 'Horror', 1818, 7),
	(3, 'To Kill a Mockingbird', 'Harper Lee', 'Southern Gothic', 1960, 3);

SELECT * FROM librarians;

INSERT INTO librarians
VALUES
	(1, 'Luc Atchley', 'lucatchley@email.com', '823-4427', '2022-09-05');

SELECT * FROM members;

INSERT INTO members (member_id, name, email, phone_number, join_date)
VALUES
	(1, 'Zac Case', 'zaccase@email.com', '555-1234', '2023-05-01' ),
	(2, 'Tyler Bosellowitz', 'tylerbos@email.com','783-2984', '2024-07-11'),
	(3, 'Jacob Thomas', 'jacobtom@email.com', '723-4823', '2024-09-15'),
	(4, 'Kyle Turner', 'kyleturner@email.com', '912-4372', '2024-11-05'),
	(5, 'Dylan Goulah', 'dylangoul@email.com', '359-1209', '2025-01-12'),
	(6, 'Ethan Banks', 'ethanbanks@email.com', '420-8735', '2025-05-22');

SELECT * FROM checkouts;

INSERT INTO checkouts (checkout_id, member_id, book_id, checkout_date, return_date)
VALUES
	(1, 2, 2, '2025-05-07', NULL);

--First trigger caused 'copies_available' for Frankenstein to decrease by 1 after inserting these values.

--Check if second trigger causes the 'copies_available' to increase after updating the return_date to something other than 'NULL'

UPDATE checkouts
SET return_date = CURRENT_DATE
WHERE book_id = 2 AND return_date IS NULL;

-- Second trigger activated and added the book back into 'copies_available
