/* ============================================================
   COCA-COLA BOTTLING CO. - RELATIONAL DATABASE EXAMPLE
   Recreates the classic Customer / Order / Order Line / Distributor /
   Product teaching example, with sample data matching the printed
   sales order for Order #34562 (Dave's Sub Shop, Vanilla Coke).
   ============================================================ */

CREATE DATABASE CocaColaBottling;
GO
USE CocaColaBottling;
GO

/* ============================================================
   STEP 1: Create tables, parents before children
   ============================================================ */

-- CUSTOMER: who places orders
CREATE TABLE Customer (
    CustomerID    INT PRIMARY KEY,
    CustomerName  NVARCHAR(100) NOT NULL,
    ContactName   NVARCHAR(100),
    Phone         NVARCHAR(20)
);
GO

-- DISTRIBUTOR: who fulfills/ships orders
CREATE TABLE Distributor (
    DistributorID    NVARCHAR(10) PRIMARY KEY,
    DistributorName  NVARCHAR(100) NOT NULL
);
GO

-- PRODUCT: the catalog of items that can be ordered
CREATE TABLE Product (
    ProductID           NVARCHAR(10) PRIMARY KEY,
    ProductDescription  NVARCHAR(100) NOT NULL,
    Price                DECIMAL(10,2) NOT NULL CHECK (Price >= 0)
);
GO

-- [Orders]: one order header per purchase. "Order" is a reserved SQL
-- keyword, so the table is named [Orders] with brackets to be safe.
CREATE TABLE [Orders] (
    OrderID         INT PRIMARY KEY,
    OrderDate       DATE NOT NULL,
    CustomerID      INT NOT NULL,
    DistributorID   NVARCHAR(10) NOT NULL,
    DistributorFee  DECIMAL(10,2) NOT NULL,
    OrderTotal      DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_Orders_Customer
        FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    CONSTRAINT FK_Orders_Distributor
        FOREIGN KEY (DistributorID) REFERENCES Distributor(DistributorID)
);
GO

-- OrderLine: the individual products within one order (bridge table -
-- this is what turns "one order, many products" into clean rows)
CREATE TABLE OrderLine (
    OrderID    INT NOT NULL,
    LineItem   INT NOT NULL,
    ProductID  NVARCHAR(10) NOT NULL,
    Quantity   INT NOT NULL CHECK (Quantity > 0),
    CONSTRAINT PK_OrderLine PRIMARY KEY (OrderID, LineItem),
    CONSTRAINT FK_OrderLine_Orders
        FOREIGN KEY (OrderID) REFERENCES [Orders](OrderID),
    CONSTRAINT FK_OrderLine_Product
        FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);
GO

/* ============================================================
   STEP 2: Populate with sample data
   (Order 34562 / Vanilla Coke matches the printed sales order exactly:
   100 x $0.55 = $55.00, + $12.95 distributor fee = $67.95 total)
   ============================================================ */

INSERT INTO Customer (CustomerID, CustomerName, ContactName, Phone) VALUES
(23,  N'Dave''s Sub Shop', N'David Logan',      N'(555)010-4545'),
(42,  N'Pizza Palace',     N'Debbie Fernandez', N'(555)049-5432'),
(765, N'T''s Fun Zone',    N'Tom Reppoci',      N'(555)095-9605');

INSERT INTO Distributor (DistributorID, DistributorName) VALUES
(N'DEN0001', N'Hawkeye Shipping'),
(N'CH0001',  N'ABC Trucking'),
(N'NY9001',  N'Van Distributors');

INSERT INTO Product (ProductID, ProductDescription, Price) VALUES
(N'12345AA', N'Coca-Cola',    0.55),
(N'12345BB', N'Diet Coke',    0.55),
(N'12345CC', N'Sprite',       0.55),
(N'12345DD', N'Diet Sprite',  0.55),
(N'12345EE', N'Vanilla Coke', 0.55);

INSERT INTO [Orders] (OrderID, OrderDate, CustomerID, DistributorID, DistributorFee, OrderTotal) VALUES
(34561, '2008-05-04', 23,  N'DEN0001', 22.00, 145.75),
(34562, '2008-08-06', 23,  N'DEN0001', 12.95, 67.95),
(34563, '2008-06-05', 765, N'NY9001',  29.50, 249.50);

INSERT INTO OrderLine (OrderID, LineItem, ProductID, Quantity) VALUES
(34561, 1, N'12345AA', 75),
(34561, 2, N'12345BB', 50),
(34562, 1, N'12345EE', 100),   -- the printed sales order example
(34563, 1, N'12345CC', 120),
(34563, 2, N'12345DD', 90);
GO

/* ============================================================
   STEP 3: Commands that show the relationships
   ============================================================ */

-- 3a. List every foreign key in the database, and which table/column
--     it points to - this is SQL Server's own record of the relationships
--     you just built with CONSTRAINT ... FOREIGN KEY above.
SELECT
    fk.name                                   AS ForeignKeyName,
    OBJECT_NAME(fk.parent_object_id)          AS ChildTable,
    COL_NAME(fkc.parent_object_id, fkc.parent_column_id)      AS ChildColumn,
    OBJECT_NAME(fk.referenced_object_id)      AS ParentTable,
    COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id) AS ParentColumn
FROM sys.foreign_keys fk
JOIN sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
ORDER BY ChildTable;

-- 3b. Prove the relationships work: rebuild the exact printed sales
--     order for Order #34562 by joining all 5 tables together.
SELECT
    o.OrderID,
    o.OrderDate,
    c.CustomerName,
    p.ProductDescription,
    ol.Quantity,
    p.Price,
    (ol.Quantity * p.Price)   AS LineAmount,
    o.DistributorFee,
    o.OrderTotal,
    d.DistributorName
FROM [Orders] o
JOIN Customer c     ON c.CustomerID    = o.CustomerID
JOIN Distributor d  ON d.DistributorID = o.DistributorID
JOIN OrderLine ol   ON ol.OrderID      = o.OrderID
JOIN Product p      ON p.ProductID     = ol.ProductID
WHERE o.OrderID = 34562;

-- 3c. Try to break a relationship on purpose - this INSERT should FAIL,
--     proving the foreign key is actively enforcing the link, not just
--     documenting it.
-- INSERT INTO [Orders] (OrderID, OrderDate, CustomerID, DistributorID, DistributorFee, OrderTotal)
-- VALUES (34999, '2008-01-01', 9999, N'DEN0001', 5.00, 20.00);  -- CustomerID 9999 doesn't exist
