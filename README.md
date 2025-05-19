# Library_SQL_Databse

Database Summary:

This project focuses on creating a simple and user friendly database for a library. This project was done using SQL. I created this database by creating tables for books, librarians, members, and checkouts. I added functionality by creating triggers that automatically updates the copies available for each book based on changes in the return_date column.

Books table after adding a row in checkouts:
![Screenshot 2025-05-19 151421](https://github.com/user-attachments/assets/c0577e82-d750-4e26-ae2d-c9ce54e055fe)

Update code when book is returned:
UPDATE checkouts
SET return_date = CURRENT_DATE
WHERE book_id = 2 AND return_date IS NULL;

Books table after the code above is implemented:
![Screenshot 2025-05-19 153134](https://github.com/user-attachments/assets/9f04b2c0-dd5a-4591-9bb2-ead41e64e69b)

This project is meant to showcase my abilities in SQL. If you would like to see all of the code, open the file called "Library_Database.sql".
