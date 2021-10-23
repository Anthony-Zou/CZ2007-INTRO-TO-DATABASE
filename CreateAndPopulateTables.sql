CREATE TABLE [CUSTOMER] (  
  [Id] INT, 
  [Phone_num] VARCHAR(8), 
  [Username] VARCHAR(30), 
  [Email] VARCHAR(50), 
  [Password] VARCHAR(50),
  [Full_name] VARCHAR(30), 
  [Address] VARCHAR(50),
  PRIMARY KEY ([Id]), 
); 
 
CREATE TABLE [CREDIT_CARD] ( 
  [Card_num] VARCHAR(16), 
  [Customer_id] INT, 
  [Bank] VARCHAR(20), 
  [Date_valid_to] DATE, 
  [Date_valid_from] DATE, 
  PRIMARY KEY ([Card_num]), 
  FOREIGN KEY (Customer_id) REFERENCES CUSTOMER(Id) 
  ON DELETE CASCADE 
  ON UPDATE CASCADE 
); 
 
CREATE TABLE [SHOP] ( 
  [Id] INT, 
  [Name] VARCHAR(50), 
  PRIMARY KEY ([Id]) 
); 
 
 
CREATE TABLE [PRODUCT_TYPE] ( 
  [Id] INT, 
  [Parent_id] INT, 
  [Description] VARCHAR(300), 
  PRIMARY KEY ([Id]), 
  FOREIGN KEY (Parent_id) REFERENCES PRODUCT_TYPE(Id) 
); 
 
CREATE TABLE [RESTRICTED_TO] ( 
  [Shop_id] INT, 
  [Product_type_id] INT, 
  PRIMARY KEY ([Shop_id], [Product_type_id]), 
  FOREIGN KEY (Shop_id) REFERENCES SHOP(Id) 
  ON DELETE CASCADE 
  ON UPDATE CASCADE, 
  FOREIGN KEY (Product_type_id) REFERENCES PRODUCT_TYPE(Id) 
  ON DELETE CASCADE 
  ON UPDATE CASCADE 
); 
 
 
CREATE TABLE [PRODUCT] ( 
  [Id] INT, 
  [Shop_id] INT, 
  [Product_type_id] INT, 
  [Name] VARCHAR(50), 
  [Colour] VARCHAR(10), 
  [Size] VARCHAR(5), 
  [Price] FLOAT(7), 
  [Description] VARCHAR(300), 
  PRIMARY KEY ([Id]), 
  FOREIGN KEY (Shop_id) REFERENCES SHOP(Id) 
  ON DELETE CASCADE 
  ON UPDATE CASCADE, 
  FOREIGN KEY (Product_type_id) REFERENCES PRODUCT_TYPE(Id) 
  ON DELETE NO ACTION 
  ON UPDATE CASCADE 
); 
 
CREATE TABLE [PHOTO] ( 
  [Seq] INT, 
  [Product_id] INT, 
  [Url] VARCHAR(50), 
  PRIMARY KEY ([Seq], [Product_id]), 
  FOREIGN KEY (Product_id) REFERENCES PRODUCT(Id) 
  ON DELETE CASCADE 
  ON UPDATE CASCADE 
); 
 
CREATE TABLE [SHIPMENT] ( 
  [Id] INT, 
  [Date] DATE, 
  [Tracking_num] VARCHAR(30), 
  PRIMARY KEY ([Id]) 
); 
 
CREATE TABLE [ORDERS] ( 
  [Id] INT, 
  [Customer_id] INT, 
  [Date] DATE, 
  [Status] VARCHAR(10), 
  PRIMARY KEY ([Id]), 
  FOREIGN KEY (Customer_id) REFERENCES CUSTOMER(Id) 
  ON DELETE NO ACTION 
  ON UPDATE CASCADE 
); 
 
CREATE TABLE [INVOICE] ( 
  [Number] VARCHAR(10), 
  [Order_id] INT, 
  [Date] DATE, 
  [Status] VARCHAR(10), 
  PRIMARY KEY ([Number]), 
  FOREIGN KEY (Order_id) REFERENCES ORDERS(Id) 
  ON DELETE CASCADE 
  ON UPDATE CASCADE 
); 
 
CREATE TABLE [PAYMENT] ( 
  [Id] INT, 
  [Invoice_number] VARCHAR(10), 
  [Credit_card_num] VARCHAR(16), 
  [Amount] FLOAT(10), 
  PRIMARY KEY ([Id]), 
  FOREIGN KEY (Invoice_number) REFERENCES INVOICE(Number) 
  ON DELETE CASCADE 
  ON UPDATE CASCADE, 
  FOREIGN KEY (Credit_card_num) REFERENCES CREDIT_CARD(Card_num) 
  ON DELETE NO ACTION 
  ON UPDATE NO ACTION 
); 
 
CREATE TABLE [ORDER_ITEM] ( 
  [Sequence_num] INT, 
  [Order_id] INT, 
  [Product_id] INT, 
  [Shipment_id] INT, 
  [Quantity] INT, 
  [Status] VARCHAR(10), 
  [Product_unit_price] FLOAT(7), 
  PRIMARY KEY ([Sequence_num], [Order_id]), 
  FOREIGN KEY (Order_id) REFERENCES ORDERS(Id) 
  ON DELETE CASCADE 
  ON UPDATE CASCADE, 
  FOREIGN KEY (Product_id) REFERENCES PRODUCT(Id) 
  ON DELETE NO ACTION 
  ON UPDATE NO ACTION, 
  FOREIGN KEY (Shipment_id) REFERENCES SHIPMENT(Id)  
  ON DELETE NO ACTION 
  ON UPDATE NO ACTION 
);
