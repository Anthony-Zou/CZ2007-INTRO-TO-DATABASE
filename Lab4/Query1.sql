--highlight as -- !! new !! is the updated one


-- Given a customer by an email address, returns the product ids that have been ordered and paid by this customer but not yet shipped. 


/*
SELECT PRODUCT.Id AS Product_id
FROM CUSTOMER
JOIN ORDERS ON CUSTOMER.Id = ORDERS.Customer_id
JOIN ORDER_ITEM ON ORDERS.Id = ORDER_ITEM.Order_id
JOIN PRODUCT ON ORDER_ITEM.Product_id = PRODUCT.Id
WHERE CUSTOMER.Email = "abc@gmail.com"
AND ORDER_ITEM.Status = "processing"
*/

--- !!! new query 1 !!! ---
---(no need PRODUCT table since ORDER_ITEM can reference product id
---              need INVOICE table to get the status as paid)

SELECT DISTINCT Product_id
FROM CUSTOMER
JOIN ORDERS ON CUSTOMER.Id = ORDERS.Customer_id
JOIN ORDER_ITEM ON ORDERS.Id = ORDER_ITEM.Order_id
JOIN INVOICE ON INCOICE.Order_id = ORDERS.id
WHERE CUSTOMER.Email = "abc@gmail.com"
AND ORDER_ITEM.Status = "processing"
AND INVOICE.status ="paid";