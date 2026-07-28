/* ============================================================
   E-COMMERCE DEMO - FULL CRUD OPERATIONS REFERENCE
   Companion to ecommerce_demo_schema.sql.
   Every table gets its own Create / Read / Update / Delete block,
   in the same order an admin would actually touch them.
   Run ecommerce_demo_schema.sql FIRST - this script assumes the
   database, tables, and the one sample order already exist.
   ============================================================ */

USE ecommerce_demo;
GO

/* ============================================================
   1. CUSTOMERS
   ============================================================ */

-- CREATE: add a new customer
INSERT INTO customers (first_name, last_name, email, phone)
VALUES ('Tunde', 'Bakare', 'tunde.bakare@example.com', '08033334444');

-- READ: look up a customer
SELECT * FROM customers WHERE email = 'tunde.bakare@example.com';

-- UPDATE: customer changes their phone number
UPDATE customers
SET phone = '08099998888'
WHERE email = 'tunde.bakare@example.com';

-- DELETE: remove a customer
-- CAUTION: this will FAIL if the customer has any addresses, orders, or
-- reviews - those foreign keys protect you from deleting someone with history.
-- DELETE FROM customers WHERE email = 'tunde.bakare@example.com';

GO

/* ============================================================
   2. ADDRESSES
   ============================================================ */

-- CREATE: add a new address for an existing customer
-- (grab the customer_id first)
INSERT INTO addresses (customer_id, address_type, street, city, state, postal_code, country)
SELECT customer_id, 'Shipping', '45 Allen Avenue', 'Ikeja', 'Lagos', '100281', 'Nigeria'
FROM customers WHERE email = 'tunde.bakare@example.com';

-- READ: all addresses for one customer
SELECT a.*
FROM addresses a
JOIN customers c ON c.customer_id = a.customer_id
WHERE c.email = 'tunde.bakare@example.com';

-- UPDATE: correct a typo in the street name
UPDATE addresses
SET street = '45 Allen Avenue, Suite 2'
WHERE address_id = (
    SELECT TOP 1 address_id FROM addresses
    WHERE street = '45 Allen Avenue'
);

-- DELETE: remove an address
-- CAUTION: fails if an order still references this address as
-- shipping_address_id or billing_address_id.
-- DELETE FROM addresses WHERE address_id = 5;

GO

/* ============================================================
   3. CATEGORIES
   ============================================================ */

-- CREATE: add a new top-level category, and a subcategory under it
INSERT INTO categories (category_name) VALUES ('Home & Kitchen');
INSERT INTO categories (category_name, parent_category_id)
SELECT 'Cookware', category_id FROM categories WHERE category_name = 'Home & Kitchen';

-- READ: list every category with its parent (if any)
SELECT c.category_name, p.category_name AS parent_category
FROM categories c
LEFT JOIN categories p ON c.parent_category_id = p.category_id
ORDER BY p.category_name, c.category_name;

-- UPDATE: rename a category
UPDATE categories
SET category_name = 'Cookware & Bakeware'
WHERE category_name = 'Cookware';

-- DELETE: remove a category
-- CAUTION: fails if any product still references it, or if it's a parent
-- of another category.
-- DELETE FROM categories WHERE category_name = 'Cookware & Bakeware';

GO

/* ============================================================
   4. WAREHOUSES
   ============================================================ */

-- CREATE: open a new warehouse
INSERT INTO warehouses (warehouse_name, location) VALUES ('Abuja Depot', 'Abuja');

-- READ
SELECT * FROM warehouses;

-- UPDATE: warehouse relocates within the same city
UPDATE warehouses
SET location = 'Abuja - Central District'
WHERE warehouse_name = 'Abuja Depot';

-- DELETE
-- CAUTION: fails if inventory rows still reference this warehouse.
-- DELETE FROM warehouses WHERE warehouse_name = 'Abuja Depot';

GO

/* ============================================================
   5. PRODUCTS
   ============================================================ */

-- CREATE: add a new product to the catalog
INSERT INTO products (product_name, category_id, sku, unit_price)
SELECT 'Non-stick Frying Pan', category_id, 'SKU-002', 12500.00
FROM categories WHERE category_name = 'Cookware & Bakeware';

-- READ: products with their category name
SELECT p.product_name, c.category_name, p.unit_price
FROM products p
JOIN categories c ON c.category_id = p.category_id
ORDER BY p.product_name;

-- UPDATE: price change
UPDATE products
SET unit_price = 11500.00
WHERE sku = 'SKU-002';

-- DELETE: discontinue a product
-- CAUTION: fails if the product appears in order_items, inventory,
-- or reviews. In practice, prefer marking it discontinued over deleting -
-- see the "soft delete" note at the bottom of this file.
-- DELETE FROM products WHERE sku = 'SKU-002';

GO

/* ============================================================
   6. INVENTORY
   ============================================================ */

-- CREATE: stock the new product into a warehouse
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand)
SELECT p.product_id, w.warehouse_id, 75
FROM products p, warehouses w
WHERE p.sku = 'SKU-002' AND w.warehouse_name = 'Lagos Main Warehouse';

-- READ: current stock by product and warehouse
SELECT p.product_name, w.warehouse_name, i.quantity_on_hand
FROM inventory i
JOIN products p ON p.product_id = i.product_id
JOIN warehouses w ON w.warehouse_id = i.warehouse_id
ORDER BY p.product_name;

-- UPDATE: stock arrives - increase quantity (never overwrite with a
-- guessed number, always add/subtract the change)
UPDATE inventory
SET quantity_on_hand = quantity_on_hand + 20
WHERE product_id = (SELECT product_id FROM products WHERE sku = 'SKU-002')
  AND warehouse_id = (SELECT warehouse_id FROM warehouses WHERE warehouse_name = 'Lagos Main Warehouse');

-- UPDATE: an order ships - decrease quantity
UPDATE inventory
SET quantity_on_hand = quantity_on_hand - 2
WHERE product_id = (SELECT product_id FROM products WHERE sku = 'SKU-002')
  AND warehouse_id = (SELECT warehouse_id FROM warehouses WHERE warehouse_name = 'Lagos Main Warehouse');

-- DELETE: remove an inventory record (e.g. product pulled from a warehouse entirely)
DELETE FROM inventory
WHERE product_id = (SELECT product_id FROM products WHERE sku = 'SKU-002')
  AND warehouse_id = (SELECT warehouse_id FROM warehouses WHERE warehouse_name = 'Lagos Main Warehouse');

GO

/* ============================================================
   7. ORDERS
   ============================================================ */

-- CREATE: place a new order for an existing customer
INSERT INTO orders (customer_id, shipping_address_id, billing_address_id, order_status)
SELECT c.customer_id, a.address_id, a.address_id, 'Pending'
FROM customers c
JOIN addresses a ON a.customer_id = c.customer_id AND a.address_type = 'Shipping'
WHERE c.email = 'tunde.bakare@example.com';

-- READ: a customer's order history, most recent first
SELECT o.order_id, o.order_date, o.order_status
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
WHERE c.email = 'tunde.bakare@example.com'
ORDER BY o.order_date DESC;

-- UPDATE: move an order through its lifecycle
UPDATE orders
SET order_status = 'Processing'
WHERE order_id = (
    SELECT TOP 1 o.order_id FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    WHERE c.email = 'tunde.bakare@example.com'
    ORDER BY o.order_date DESC
);

-- DELETE: cancel/remove an order
-- CAUTION: fails if order_items, payments, or shipments still reference it.
-- Delete or reassign those child rows first, or prefer order_status = 'Cancelled'
-- over a hard delete - see the note at the bottom of this file.
-- DELETE FROM orders WHERE order_id = 2;

GO

/* ============================================================
   8. ORDER_ITEMS
   ============================================================ */

-- CREATE: add a product line to an order
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
SELECT o.order_id, p.product_id, 1, p.unit_price
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id AND c.email = 'tunde.bakare@example.com'
CROSS JOIN products p
WHERE p.sku = 'SKU-001' AND o.order_status = 'Processing';

-- READ: every line item on an order, with product names
SELECT p.product_name, oi.quantity, oi.unit_price, (oi.quantity * oi.unit_price) AS line_total
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
WHERE oi.order_id = (
    SELECT TOP 1 o.order_id FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    WHERE c.email = 'tunde.bakare@example.com'
    ORDER BY o.order_date DESC
);

-- UPDATE: customer changes the quantity before the order ships
UPDATE order_items
SET quantity = 2
WHERE order_item_id = (SELECT MAX(order_item_id) FROM order_items);

-- DELETE: remove a line item (customer removed a product from their cart/order)
DELETE FROM order_items
WHERE order_item_id = (SELECT MAX(order_item_id) FROM order_items);

GO

/* ============================================================
   9. PAYMENTS
   ============================================================ */

-- CREATE: record a payment against an order
INSERT INTO payments (order_id, payment_method, amount, payment_status)
SELECT o.order_id, 'Bank Transfer', 15990.00, 'Pending'
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
WHERE c.email = 'tunde.bakare@example.com' AND o.order_status = 'Processing';

-- READ: payment status for an order
SELECT o.order_id, o.order_status, pay.payment_method, pay.payment_status, pay.amount
FROM orders o
JOIN payments pay ON pay.order_id = o.order_id
JOIN customers c ON c.customer_id = o.customer_id
WHERE c.email = 'tunde.bakare@example.com';

-- UPDATE: payment clears
UPDATE payments
SET payment_status = 'Paid'
WHERE order_id = (
    SELECT TOP 1 o.order_id FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    WHERE c.email = 'tunde.bakare@example.com'
    ORDER BY o.order_date DESC
);

-- DELETE: remove a payment record
-- CAUTION: in a real regulated system, never hard-delete a payment record -
-- reverse it with a refund row instead. Shown here only for completeness.
-- DELETE FROM payments WHERE payment_id = 3;

GO

/* ============================================================
   10. CARRIERS
   ============================================================ */

-- CREATE: add a new shipping partner
INSERT INTO carriers (carrier_name) VALUES ('GIG Logistics');

-- READ
SELECT * FROM carriers;

-- UPDATE: correct a carrier name
UPDATE carriers SET carrier_name = 'GIG Logistics Ltd' WHERE carrier_name = 'GIG Logistics';

-- DELETE
-- CAUTION: fails if any shipment still references this carrier.
-- DELETE FROM carriers WHERE carrier_name = 'GIG Logistics Ltd';

GO

/* ============================================================
   11. SHIPMENTS
   ============================================================ */

-- CREATE: dispatch an order
INSERT INTO shipments (order_id, carrier_id, tracking_number, shipment_status)
SELECT o.order_id, car.carrier_id, 'TRK-' + CAST(o.order_id AS NVARCHAR(10)), 'Processing'
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
CROSS JOIN carriers car
WHERE c.email = 'tunde.bakare@example.com' AND car.carrier_name = 'GIG Logistics Ltd'
  AND o.order_status = 'Processing';

-- READ: shipment status with carrier name
SELECT o.order_id, car.carrier_name, s.tracking_number, s.shipment_status
FROM shipments s
JOIN orders o ON o.order_id = s.order_id
JOIN carriers car ON car.carrier_id = s.carrier_id
JOIN customers c ON c.customer_id = o.customer_id
WHERE c.email = 'tunde.bakare@example.com';

-- UPDATE: mark as shipped, then delivered (two separate real-world events)
UPDATE shipments
SET shipment_status = 'Shipped', shipped_date = GETDATE()
WHERE tracking_number LIKE 'TRK-%'
  AND order_id = (SELECT TOP 1 order_id FROM orders WHERE order_status = 'Processing' ORDER BY order_id DESC);

UPDATE shipments
SET shipment_status = 'Delivered', delivered_date = GETDATE()
WHERE tracking_number LIKE 'TRK-%'
  AND order_id = (SELECT TOP 1 order_id FROM orders WHERE order_status = 'Processing' ORDER BY order_id DESC);

-- DELETE: remove a shipment record
-- DELETE FROM shipments WHERE shipment_id = 2;

GO

/* ============================================================
   12. REVIEWS
   ============================================================ */

-- CREATE: customer leaves a review after delivery
INSERT INTO reviews (product_id, customer_id, rating, comment)
SELECT p.product_id, c.customer_id, 4, 'Good quality, delivery took a bit longer than expected.'
FROM products p, customers c
WHERE p.sku = 'SKU-001' AND c.email = 'tunde.bakare@example.com';

-- READ: all reviews for a product, newest first
SELECT c.first_name, r.rating, r.comment, r.review_date
FROM reviews r
JOIN customers c ON c.customer_id = r.customer_id
JOIN products p ON p.product_id = r.product_id
WHERE p.sku = 'SKU-001'
ORDER BY r.review_date DESC;

-- UPDATE: customer edits their review
UPDATE reviews
SET rating = 5, comment = 'Updated: delivery was actually fine, product is great.'
WHERE review_id = (SELECT MAX(review_id) FROM reviews);

-- DELETE: remove a review (e.g. flagged as spam by moderation)
DELETE FROM reviews
WHERE review_id = (SELECT MAX(review_id) FROM reviews);

GO

/* ============================================================
   BONUS: THE RIGHT ORDER TO DELETE A WHOLE ORDER
   Deleting a customer's order touches 4 tables. FK constraints force
   you to delete child rows before parent rows - this is the exact
   order that will actually succeed.
   ============================================================ */

DECLARE @order_to_remove INT = (
    SELECT TOP 1 o.order_id FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    WHERE c.email = 'tunde.bakare@example.com'
    ORDER BY o.order_date DESC
);

DELETE FROM shipments   WHERE order_id = @order_to_remove;
DELETE FROM payments    WHERE order_id = @order_to_remove;
DELETE FROM order_items WHERE order_id = @order_to_remove;
DELETE FROM orders      WHERE order_id = @order_to_remove;

GO

/* ============================================================
   BONUS: ADMIN OPERATIONS BEYOND BASIC CRUD
   ============================================================ */

-- Add a new column to an existing table (schema change, not a data change)
ALTER TABLE products ADD is_discontinued BIT NOT NULL DEFAULT 0;

-- "Soft delete" pattern - preferred over hard DELETE for products/orders in
-- most real systems, because it preserves history for reporting and audits
UPDATE products SET is_discontinued = 1 WHERE sku = 'SKU-002';
-- Everyday queries then filter it out instead of the row being gone forever:
SELECT * FROM products WHERE is_discontinued = 0;

-- Wrap multiple changes in a transaction - either all succeed or none do
BEGIN TRANSACTION;

    UPDATE inventory SET quantity_on_hand = quantity_on_hand - 1
    WHERE product_id = (SELECT product_id FROM products WHERE sku = 'SKU-001');

    UPDATE orders SET order_status = 'Shipped'
    WHERE order_id = (SELECT TOP 1 order_id FROM orders ORDER BY order_id DESC);

    -- If both updates look right, make them permanent:
    COMMIT TRANSACTION;
    -- If something looked wrong instead, this would undo both:
    -- ROLLBACK TRANSACTION;

GO

-- Empty a table completely but keep its structure (fast, but no WHERE clause
-- is possible - it removes every row). Never run this on a live table by accident.
-- TRUNCATE TABLE reviews;

-- Permanently remove a table and all its data
-- DROP TABLE reviews;
