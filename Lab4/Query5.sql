-- Get 3 random customers and return their email addresses.

SELECT TOP 3 Email
FROM CUSTOMER
ORDER BY NEWID()