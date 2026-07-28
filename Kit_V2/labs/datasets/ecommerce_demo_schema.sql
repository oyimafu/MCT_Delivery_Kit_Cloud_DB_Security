/* ============================================================
   E-COMMERCE DEMO DATABASE
   Purpose: teaching schema showing PK/FK relationships across
   a realistic app - customers, catalog, orders, payments, logistics.
   Tested logic in SQLite sandbox before writing this SQL Server version.
   ============================================================ */

-- ============================================================
-- STEP 1: Create the database
-- ============================================================
CREATE DATABASE ecommerce_demo;
GO
USE ecommerce_demo;
GO

-- ============================================================
-- STEP 2: Create tables, in dependency order
-- (parent tables first, so foreign keys always have something to point to)
-- ============================================================

-- CUSTOMERS: root entity, no dependencies
CREATE TABLE customers (
    customer_id   INT IDENTITY(1,1) PRIMARY KEY,
    first_name    NVARCHAR(50)  NOT NULL,
    last_name     NVARCHAR(50)  NOT NULL,
    email         NVARCHAR(100) NOT NULL UNIQUE,
    phone         NVARCHAR(20),
    created_at    DATETIME DEFAULT GETDATE()
);
GO

-- ADDRESSES: one customer can have many addresses (one-to-many)
CREATE TABLE addresses (
    address_id    INT IDENTITY(1,1) PRIMARY KEY,
    customer_id   INT NOT NULL,
    address_type  NVARCHAR(20) NOT NULL,   -- 'Shipping' or 'Billing'
    street        NVARCHAR(150) NOT NULL,
    city          NVARCHAR(50) NOT NULL,
    state         NVARCHAR(50),
    postal_code   NVARCHAR(20),
    country       NVARCHAR(50) NOT NULL,
    CONSTRAINT FK_addresses_customers
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
GO

-- CATEGORIES: self-referencing FK, so a category can have a parent category
-- (e.g. "Phones" belongs under "Electronics")
CREATE TABLE categories (
    category_id         INT IDENTITY(1,1) PRIMARY KEY,
    category_name       NVARCHAR(100) NOT NULL UNIQUE,
    parent_category_id  INT NULL,
    CONSTRAINT FK_categories_parent
        FOREIGN KEY (parent_category_id) REFERENCES categories(category_id)
);
GO

-- WAREHOUSES: physical stock locations (for logistics)
CREATE TABLE warehouses (
    warehouse_id    INT IDENTITY(1,1) PRIMARY KEY,
    warehouse_name  NVARCHAR(100) NOT NULL,
    location        NVARCHAR(150) NOT NULL
);
GO

-- PRODUCTS: the catalog
CREATE TABLE products (
    product_id      INT IDENTITY(1,1) PRIMARY KEY,
    product_name    NVARCHAR(150) NOT NULL,
    category_id     INT NOT NULL,
    sku             NVARCHAR(50) NOT NULL UNIQUE,
    unit_price      DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
    CONSTRAINT FK_products_categories
        FOREIGN KEY (category_id) REFERENCES categories(category_id)
);
GO

-- INVENTORY: how much stock of each product sits in each warehouse
-- (many-to-many resolved with its own quantity column)
CREATE TABLE inventory (
    inventory_id      INT IDENTITY(1,1) PRIMARY KEY,
    product_id        INT NOT NULL,
    warehouse_id      INT NOT NULL,
    quantity_on_hand  INT NOT NULL DEFAULT 0 CHECK (quantity_on_hand >= 0),
    CONSTRAINT FK_inventory_products
        FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT FK_inventory_warehouses
        FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id)
);
GO

-- ORDERS: one customer places many orders (one-to-many)
-- pulls in TWO foreign keys to the SAME table (addresses) - a good talking point
CREATE TABLE orders (
    order_id             INT IDENTITY(1,1) PRIMARY KEY,
    customer_id          INT NOT NULL,
    shipping_address_id  INT NOT NULL,
    billing_address_id   INT NOT NULL,
    order_date           DATETIME DEFAULT GETDATE(),
    order_status         NVARCHAR(30) NOT NULL DEFAULT 'Pending',
    CONSTRAINT FK_orders_customers
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT FK_orders_shipping_address
        FOREIGN KEY (shipping_address_id) REFERENCES addresses(address_id),
    CONSTRAINT FK_orders_billing_address
        FOREIGN KEY (billing_address_id) REFERENCES addresses(address_id)
);
GO

-- ORDER_ITEMS: the many-to-many bridge between orders and products
-- (one order can have many products, one product can appear on many orders)
CREATE TABLE order_items (
    order_item_id  INT IDENTITY(1,1) PRIMARY KEY,
    order_id       INT NOT NULL,
    product_id     INT NOT NULL,
    quantity       INT NOT NULL CHECK (quantity > 0),
    unit_price     DECIMAL(10,2) NOT NULL,  -- price at time of sale, not looked up later
    CONSTRAINT FK_orderitems_orders
        FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT FK_orderitems_products
        FOREIGN KEY (product_id) REFERENCES products(product_id)
);
GO

-- PAYMENTS: one-to-one with orders (each order gets exactly one payment record here)
CREATE TABLE payments (
    payment_id      INT IDENTITY(1,1) PRIMARY KEY,
    order_id        INT NOT NULL UNIQUE,
    payment_method  NVARCHAR(30) NOT NULL,
    amount          DECIMAL(10,2) NOT NULL,
    payment_status  NVARCHAR(30) NOT NULL DEFAULT 'Pending',
    payment_date    DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_payments_orders
        FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
GO

-- CARRIERS: shipping companies (DHL, FedEx, local dispatch, etc.)
CREATE TABLE carriers (
    carrier_id    INT IDENTITY(1,1) PRIMARY KEY,
    carrier_name  NVARCHAR(100) NOT NULL UNIQUE
);
GO

-- SHIPMENTS: the logistics table - tracks how an order physically moves
CREATE TABLE shipments (
    shipment_id      INT IDENTITY(1,1) PRIMARY KEY,
    order_id         INT NOT NULL UNIQUE,
    carrier_id       INT NOT NULL,
    tracking_number  NVARCHAR(50),
    shipped_date     DATETIME NULL,
    delivered_date   DATETIME NULL,
    shipment_status  NVARCHAR(30) NOT NULL DEFAULT 'Processing',
    CONSTRAINT FK_shipments_orders
        FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT FK_shipments_carriers
        FOREIGN KEY (carrier_id) REFERENCES carriers(carrier_id)
);
GO

-- REVIEWS: customer feedback on products
CREATE TABLE reviews (
    review_id     INT IDENTITY(1,1) PRIMARY KEY,
    product_id    INT NOT NULL,
    customer_id   INT NOT NULL,
    rating        INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment       NVARCHAR(500),
    review_date   DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_reviews_products
        FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT FK_reviews_customers
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
GO

/* ============================================================
   STEP 3: Populate with sample data
   Order matters here too - parents before children, same rule as before.
   ============================================================ */

INSERT INTO customers (first_name, last_name, email, phone)
VALUES ('Amaka', 'Obi', 'amaka@example.com', '08011112222');

INSERT INTO addresses (customer_id, address_type, street, city, state, postal_code, country)
VALUES (1, 'Shipping', '12 Marina Road', 'Lagos', 'Lagos', '100001', 'Nigeria');

INSERT INTO addresses (customer_id, address_type, street, city, state, postal_code, country)
VALUES (1, 'Billing', '12 Marina Road', 'Lagos', 'Lagos', '100001', 'Nigeria');

INSERT INTO categories (category_name) VALUES ('Electronics');
INSERT INTO categories (category_name, parent_category_id) VALUES ('Phones', 1);

INSERT INTO warehouses (warehouse_name, location) VALUES ('Lagos Main Warehouse', 'Lagos');

INSERT INTO products (product_name, category_id, sku, unit_price)
VALUES ('Smartphone X', 2, 'SKU-001', 250000.00);

INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand)
VALUES (1, 1, 40);

INSERT INTO orders (customer_id, shipping_address_id, billing_address_id, order_status)
VALUES (1, 1, 2, 'Processing');

INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES (1, 1, 2, 250000.00);

INSERT INTO payments (order_id, payment_method, amount, payment_status)
VALUES (1, 'Card', 500000.00, 'Paid');

INSERT INTO carriers (carrier_name) VALUES ('DHL');

INSERT INTO shipments (order_id, carrier_id, tracking_number, shipment_status)
VALUES (1, 1, 'TRK123456', 'Shipped');

INSERT INTO reviews (product_id, customer_id, rating, comment)
VALUES (1, 1, 5, 'Great phone, fast delivery');

/* ============================================================
   STEP 4: Verify - check each table individually
   ============================================================ */
SELECT * FROM customers;
SELECT * FROM addresses;
SELECT * FROM categories;
SELECT * FROM warehouses;
SELECT * FROM products;
SELECT * FROM inventory;
SELECT * FROM orders;
SELECT * FROM order_items;
SELECT * FROM payments;
SELECT * FROM carriers;
SELECT * FROM shipments;
SELECT * FROM reviews;

/* ============================================================
   STEP 5: The payoff query - the full order picture
   Joins across 7 tables using every PK/FK relationship in the schema.
   This is the query to demo in class: it proves WHY the tables
   were split apart in the first place.
   ============================================================ */
SELECT
    c.first_name + ' ' + c.last_name  AS customer_name,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    o.order_status,
    pay.payment_status,
    car.carrier_name,
    s.tracking_number,
    s.shipment_status
FROM orders o
JOIN customers c    ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p     ON p.product_id = oi.product_id
JOIN payments pay   ON pay.order_id = o.order_id
JOIN shipments s    ON s.order_id = o.order_id
JOIN carriers car   ON car.carrier_id = s.carrier_id
WHERE o.order_id = 1;

/* ============================================================
   STEP 6: "Break it" demos - show the class the FK actually enforces rules
   ============================================================ */

-- This should FAIL: product_id 999 doesn't exist
-- INSERT INTO order_items (order_id, product_id, quantity, unit_price)
-- VALUES (1, 999, 1, 100.00);

-- This should also FAIL: can't delete a product that's referenced in order_items
-- DELETE FROM products WHERE product_id = 1;

-- Uncomment either block above, one at a time, to demo the constraint live.
