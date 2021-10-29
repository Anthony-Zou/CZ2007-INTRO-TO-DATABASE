-- Find the 3 bestselling product type ids in terms of product quantity sold. The products of concerned must be ordered and paid. Whether they have been shipped is irrelevant.
-- have to join ORDER_ITEM, PRODUCT and PRODUCT_TYPE


/*
SELECT TOP 3 *
FROM (
    SELECT Product_type_id, Sales
    FROM (
    SELECT PRODUCT.Id AS Product_id, PRODUCT_TYPE.Id AS Product_type_id, SUM(ORDER_ITEM.Quantity) AS Sales,
    FROM ORDER_ITEM
    INNER JOIN PRODUCT ON ORDER_ITEM.Product_id = PRODUCT.Id
    INNER JOIN PRODUCT_TYPE ON PRODUCT.Product_type_id = PRODUCT_TYPE.Id
    GROUP BY Product_type_id
    )
    ORDER BY Sales DESC;
)
*/

---!!! new query 2 !!! ---

SELECT TOP 3 * --4. select top 3
FROM(
    SELECT *   --3. order it 
    FROM
        (SELECT Product_type_id, SUM(Quantity) AS Sales  -- 2.join PRODUCT and ORDER_ITEM, group by product_type_id and sum the quantity as sales
        FROM ORDER_ITEM OI, PRODUCT P
        WHERE OI.Product_id = P.id
        AND OI.Order_id IN (         --1. find the paid order
            SELECT O.id
            FROM ORDER O, INVOICE I
            WHERE I.status = 'paid'
            AND I.Order_id = O.id      
        )
        GROUP BY Product_type_id
    ORDER BY Sales DESC
);

-- suggested changes for new query 2
/*
SELECT TOP 3 * --4. select top 3
FROM(
    SELECT *   --3. order it 
    FROM
        (SELECT Product_type_id, SUM(Quantity) AS Sales  -- 2.join PRODUCT and ORDER_ITEM, group by product_type_id and sum the quantity as sales
        FROM ORDER_ITEM OI
        JOIN PRODUCT P ON OI.Product_id = P.id
        AND OI.Order_id IN (         --1. find the paid order
            SELECT O.id
            FROM ORDER O
            JOIN INVOICE I ON I.Order_id = O.id
            WHERE I.status = "paid"
        )
        GROUP BY Product_type_id
    ORDER BY Sales DESC
);
*/
