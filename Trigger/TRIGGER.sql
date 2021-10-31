CREATE TRIGGER invoiceStatusTGR  -- ADD A Order_price on ORDER table?
AFTER INSERT ON PAYMENT
REFERECING NEW ROW AS N
FOR EACH ROW
WHEN (INVOICE.Id = N.Invoice_number 
     AND INVOICE.Order_id = ORDERS.id
     AND ORDERS.Id = (  
        SELECT SUM(Amount)
        FROM PAYMENT
        WHERE Invoice_number = N.Invoice_number))
BEGIN
    UPDATE INVOICE
    SET Status = "paid"
    WHERE INVOICE.Id = N.Invoice_number
END;



-- constraints 2

CREATE TRIGGER orderItemStatusTGR
AFTER INSERT ON SHIPMENT --这里没用 order_item 的 update 是因为
REFERENCING NEW ROW AS N
FOR EACH ROW
-- no need condition right?
BEGIN
    UPDATE ORDER_ITEM
    SET Status = "shipped"
    WHERE ORDER_ITEM.Shipment_id = N.Id
END;

-- constraint 3

CREATE TRIGGER orderStatusTGR
AFTER UPDATE OF [Status] ON ORDER_ITEM
REFERENCING NEW ROW AS N
FOR EACH ROW
WHEN(
    NOT EXISTS(
        SELECT sequence_num
        FROM ORDER_ITEM
        WHERE ORDER_ITEM.Order_id = N.Order_id
        AND [Status] = "processing"
    )
) 
BEGIN
    UPDATE ORDERS
    SET [Status] = "completed"
    WHERE ORDERS.Id = N.Order_id
END;


-- constraint 4

CREATE TRIGGER limitePaymentTrg
BEFORE INSERT ON PAYMENT
REFERENCING NEW ROW AS N
FOR EACH ROW
DECALRE Order_price FLOAT(10)
DECALRE sum FLOAT(10)
WHEN( (SELECT COUNT(*) FROM PAYMENT WHERE PAYMENT.Invoice_number = N.Invoice_number) = 2)  -- this is the 3d payment
BEGIN
     SELECT SUM(Amount) INTO sum
     FROM PAYMENT
     WHERE PAYMENT.Invoice_number = N.Invoice_number;
     
     SELECT SUM(OI.Product_unit_price * OI.Quantity) INTO Order_price
     FROM ORDER_ITEM OI, INVOICE I
     WHERE I.Number = N.Invoice_number AND I.Order_id = OI.Order_Id;
     
     IF((sum + N.Amount) < Order_price)
     THEN raise_exception('the third payment must fully pay')
END;   
     
     
-- constraint 5

CREATE TRIGGER canclePrecentTGR
BEFORE UPDATE OF [Status] ON ORDERS
REFERENCING NEW ROW AS N
FOR EACH ROW
WHEN(
    EXISTS(
        SELECT P.Id
        FROM ORDERS O, INVOICE I, PAYMENT P
        WHERE N.Id = I.Order_id AND I.Id = P.Invoice_number
    )
)
BEGIN
    IF(N.Status = "cancelled")
    THEN raise_exception('order can not be cancelled')
END;
