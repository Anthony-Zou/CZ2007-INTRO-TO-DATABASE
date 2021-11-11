CREATE TABLE [CUSTOMER] (  
  [Id] INT NOT NULL 
  [Phone_num] VARCHAR(8) NOT NULL, 
  [Username] VARCHAR(30) UNIQUE NOT NULL, 
  [Email] VARCHAR(50) UNIQUE NOT NULL, 
  [Password] VARCHAR(50) NOT NULL,
  [Full_name] VARCHAR(30) NOT NULL, 
  [Address] VARCHAR(50) NOT NULL,
  PRIMARY KEY ([Id]), 
); 
 
CREATE TABLE [CREDIT_CARD] ( 
  [Card_num] VARCHAR(16) NOT NULL, 
  [Customer_id] INT NOT NULL,                               
  [Bank] VARCHAR(20) NOT NULL, 
  [Date_valid_to] DATE NOT NULL, 
  [Date_valid_from] DATE NOT NULL, 
  PRIMARY KEY ([Card_num]),  
  FOREIGN KEY (Customer_id) REFERENCES CUSTOMER(Id) 
  ON DELETE SET NULL
  ON UPDATE CASCADE
); 
 
CREATE TABLE [SHOP] ( 
  [Id] INT NOT NULL, 
  [Name] VARCHAR(50) NOT NULL,
  PRIMARY KEY ([Id]),  
); 
 
 
CREATE TABLE [PRODUCT_TYPE] ( 
  [Id] INT NOT NULL, 
  [Parent_id] INT , 
  [Description] VARCHAR(300) NOT NULL, 
  PRIMARY KEY ([Id]), 
  FOREIGN KEY (Parent_id) REFERENCES PRODUCT_TYPE(Id)
  ON DELETE SET NULL
  ON UPDATE CASCADE 
); 
 
CREATE TABLE [RESTRICTED_TO] ( 
  [Shop_id] INT NOT NULL, 
  [Product_type_id] INT NOT NULL, 
  PRIMARY KEY ([Shop_id], [Product_type_id]), 
  FOREIGN KEY (Shop_id) REFERENCES SHOP(Id) 
  ON DELETE CASCADE
  ON UPDATE CASCADE, 
  FOREIGN KEY (Product_type_id) REFERENCES PRODUCT_TYPE(Id) 
  ON DELETE CASCADE 
  ON UPDATE CASCADE
); 
 
 
CREATE TABLE [PRODUCT] ( 
  [Id] INT NOT NULL, 
  [Shop_id] INT NOT NULL, 
  [Product_type_id] INT NOT NULL,  
  [Name] VARCHAR(50) NOT NULL, 
  [Colour] VARCHAR(10) NOT NULL, 
  [Size] VARCHAR(5) NOT NULL, 
  [Price] FLOAT(7)NOT NULL CHECK(Price > 0), 
  [Description] VARCHAR(300) NOT NULL, 
  PRIMARY KEY ([Id]), 
  FOREIGN KEY (Shop_id) REFERENCES SHOP(Id) 
  ON DELETE NO ACTION       -- A product must have a shop_id, we set NO ACTION to prevent from deleting shop_id this action
  ON UPDATE CASCADE, 
  FOREIGN KEY (Product_type_id) REFERENCES PRODUCT_TYPE(Id) 
  ON DELETE NO ACTION       -- A product must have a Product_type_id, we set NO ACTION to prevent from deleting Product_type_id this action  
  ON UPDATE CASCADE
); 
 
CREATE TABLE [PHOTO] ( 
  [Seq] INT NOT NULL, 
  [Product_id] INT NOT NULL, 
  [Url] VARCHAR(50) NOT NULL, 
  PRIMARY KEY ([Seq], [Product_id]), 
  FOREIGN KEY (Product_id) REFERENCES PRODUCT(Id) 
  ON DELETE CASCADE 
  ON UPDATE CASCADE
); 
 
CREATE TABLE [SHIPMENT] ( 
  [Id] INT NOT NULL, 
  [Date] DATE NOT NULL, 
  PRIMARY KEY ([Id]), 
  [Tracking_num] VARCHAR(30) UNIQUE,
); 
 
CREATE TABLE [ORDERS] ( 
  [Id] INT NOT NULL, 
  [Customer_id] INT NOT NULL, 
  [Date] DATE NOT NULL, 
  [Status] VARCHAR(10) DEFAULT 'processing',
  PRIMARY KEY ([Id]),   
  FOREIGN KEY (Customer_id) REFERENCES CUSTOMER(Id) 
  ON DELETE NO ACTION  --  Prevent from deleting customer_id this action to trace the order record
  ON UPDATE CASCADE 
); 
 
CREATE TABLE [INVOICE] ( 
  [Number] VARCHAR(10) NOT NULL, 
  [Order_id] INT NOT NULL, 
  [Date] DATE NOT NULL,  
  [Status] VARCHAR(10) DEFAULT 'issued',
  PRIMARY KEY ([Number]), 
  FOREIGN KEY (Order_id) REFERENCES ORDERS(Id) 
  ON DELETE NO ACTION 
  ON UPDATE CASCADE
); 
 
CREATE TABLE [PAYMENT] ( 
  [Id] INT, 
  [Invoice_number] VARCHAR(10) NOT NULL, 
  [Credit_card_num] VARCHAR(16) NOT NULL, 
  [Amount] FLOAT(10) NOT NULL CHECK(Amount > 0), 
  PRIMARY KEY ([Id]), 
  FOREIGN KEY (Invoice_number) REFERENCES INVOICE(Number)          -- prevent from changes to trace the record
  ON DELETE NO ACTION
  ON UPDATE NO ACTION, 
  FOREIGN KEY (Credit_card_num) REFERENCES CREDIT_CARD(Card_num)   -- prevent from changes to trace the record
  ON DELETE NO ACTION 
  ON UPDATE NO ACTION 
); 
 
CREATE TABLE [ORDER_ITEM] ( 
  [Sequence_num] INT, 
  [Order_id] INT, 
  [Product_id] INT NOT NULL, 
  [Shipment_id] INT ,
  [Quantity] INT NOT NULL CHECK(Quantity>0), 
  [Status] VARCHAR(10) DEFAULT 'processing', 
  [Product_unit_price] FLOAT(7) not null CHECK(Product_unit_price>0), 
  PRIMARY KEY ([Sequence_num], [Order_id]), 

  FOREIGN KEY (Order_id) REFERENCES ORDERS(Id) 
  ON DELETE NO ACTION   
  ON UPDATE CASCADE, 
  FOREIGN KEY (Product_id) REFERENCES PRODUCT(Id) 
  ON DELETE NO ACTION  
  ON UPDATE CASCADE, 
  FOREIGN KEY (Shipment_id) REFERENCES SHIPMENT(Id)  
  ON DELETE NO ACTION 
  ON UPDATE CASCADE 
);


-- Most of time, we set ON DELETE NO ACTION to prevent from losing the record
