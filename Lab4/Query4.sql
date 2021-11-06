-- Query 4
/* 
step 1: get table with columns Order_id and Product_id first
Order_id     Product_id
1               A
1               B
2               A
2               C
3               A
3               C

step 2: get table with columns Product_id, Bought_with, and Times_bought_together
Product_id   Bought_with      Times_bought_together 
A               B                   1
A               C                   2

-- step 1
CREATE TABLE ITEMS (
    Order_id INT,
    Product_id INT,
);

INSERT INTO ITEMS
SELECT *
FROM (
    SELECT ORDERS.Id AS Order_id, PRODUCT.Id AS Product_id
    FROM ORDERS
    JOIN ORDER_ITEM ON ORDERS.Id = ORDER_ITEM.Order_id
    JOIN PRODUCT ON PRODUCT.Id = ORDER_ITEM.Product_id
)

CREATE TABLE ITEMS_COPY LIKE ITEMS;
INSERT INTO ITEMS_COPY SELECT * FROM original_table;

-- step 2
SELECT ITEMS.Product_id AS Product_id, ITEMS_COPY.Product_id AS Bought_with, COUNT(*) AS Times_bought_together
FROM ITEMS
INNER JOIN ITEMS_COPY ON ITEMS.Order_id = ITEMS_COPY.Order_id
AND ITEMS.Product_id != ITEMS_COPY.Product_id
GROUP BY ITEMS.Product_id
*/


--- !!! new query4 !!!---

CREATE VIEW [togetherTable] AS
(SELECT O1.Product_id, O2.Product_id, COUNT(*) AS togetherTimes
FROM ORDER_ITEM O1, ORDER_ITEM O2
WHERE O1.Order_id = O2.ORDER_id 
AND   O1.Product_id <> O2.Product_id
and O1.Product_id < O2.Product_id --this line to remove mirror pairs in bottom
GROUP BY O1.Product_id, O2.Product_id)

//A B
//B A
//remove B A
SELECT O1.Product_id, O2.Product_id   -- MIGHT HAVE DUPLICATE...
FROM togetherTable
WHERE togetherTimes IN (
    SELECT MAX(togetherTimes)
    FROM togetherTable T2
)
