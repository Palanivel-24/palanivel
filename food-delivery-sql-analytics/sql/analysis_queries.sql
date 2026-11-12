-- Food Delivery Sales & Operations Analytics
-- SQL dialect: SQLite 3.25+ (window functions are used below)

-- 1. Delivered orders
SELECT * FROM orders
WHERE status = 'delivered'
ORDER BY order_date, order_id;

-- 2. Orders by status
SELECT status, COUNT(*) AS order_count
FROM orders
GROUP BY status
ORDER BY order_count DESC;

-- 3. Delivered revenue by cuisine
SELECT r.cuisine, COUNT(*) AS delivered_orders,
       ROUND(SUM(o.amount), 2) AS delivered_revenue
FROM orders o
JOIN restaurants r ON r.restaurant_id = o.restaurant_id
WHERE o.status = 'delivered'
GROUP BY r.cuisine
HAVING COUNT(*) >= 2
ORDER BY delivered_revenue DESC;

-- 4. Average delivered order value by restaurant
SELECT r.restaurant_name, ROUND(AVG(o.amount), 2) AS avg_order_value
FROM restaurants r
JOIN orders o ON o.restaurant_id = r.restaurant_id
WHERE o.status = 'delivered'
GROUP BY r.restaurant_id, r.restaurant_name
ORDER BY avg_order_value DESC;

-- 5. Daily delivered revenue
SELECT order_date, COUNT(*) AS delivered_orders,
       ROUND(SUM(amount), 2) AS revenue
FROM orders
WHERE status = 'delivered'
GROUP BY order_date
ORDER BY order_date;

-- 6. Repeat customers
SELECT c.customer_name, COUNT(*) AS delivered_order_count
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
WHERE o.status = 'delivered'
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(*) > 1
ORDER BY delivered_order_count DESC;

-- 7. Customers without orders
SELECT c.customer_id, c.customer_name
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL;

-- 8. Restaurants without orders
SELECT r.restaurant_name
FROM restaurants r
LEFT JOIN orders o ON o.restaurant_id = r.restaurant_id
WHERE o.order_id IS NULL;

-- 9. Multi-table join
SELECT o.order_id, c.customer_name, r.restaurant_name, o.amount, o.status
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
JOIN restaurants r ON r.restaurant_id = o.restaurant_id
ORDER BY o.order_id;

-- 10. Orders above average order amount
SELECT order_id, amount
FROM orders
WHERE amount > (SELECT AVG(amount) FROM orders)
ORDER BY amount DESC;

-- 11. Revenue by cuisine using a CTE
WITH cuisine_revenue AS (
    SELECT r.cuisine, SUM(o.amount) AS revenue
    FROM orders o
    JOIN restaurants r ON r.restaurant_id = o.restaurant_id
    WHERE o.status = 'delivered'
    GROUP BY r.cuisine
)
SELECT cuisine, ROUND(revenue, 2) AS revenue
FROM cuisine_revenue
ORDER BY revenue DESC;

-- 12. Rank cuisines by delivered revenue
WITH cuisine_revenue AS (
    SELECT r.cuisine, SUM(o.amount) AS revenue
    FROM orders o
    JOIN restaurants r ON r.restaurant_id = o.restaurant_id
    WHERE o.status = 'delivered'
    GROUP BY r.cuisine
)
SELECT cuisine, ROUND(revenue, 2) AS revenue,
       DENSE_RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
FROM cuisine_revenue
ORDER BY revenue_rank, cuisine;

-- 13. Average delivery time
SELECT r.restaurant_name, ROUND(AVG(o.delivery_minutes), 1) AS avg_delivery_minutes
FROM restaurants r
JOIN orders o ON o.restaurant_id = r.restaurant_id
WHERE o.status = 'delivered' AND o.delivery_minutes IS NOT NULL
GROUP BY r.restaurant_id, r.restaurant_name
ORDER BY avg_delivery_minutes;

-- 14. Preserve all restaurants when counting delivered orders.
-- Keep the status filter in ON, not WHERE.
SELECT r.restaurant_name, COUNT(o.order_id) AS delivered_orders
FROM restaurants r
LEFT JOIN orders o
  ON o.restaurant_id = r.restaurant_id AND o.status = 'delivered'
GROUP BY r.restaurant_id, r.restaurant_name
ORDER BY delivered_orders DESC;

-- 15. Demonstrate row multiplication in a one-to-many tags join.
SELECT o.order_id, r.restaurant_name, rt.tag
FROM orders o
JOIN restaurants r ON r.restaurant_id = o.restaurant_id
JOIN restaurant_tags rt ON rt.restaurant_id = r.restaurant_id
ORDER BY o.order_id, rt.tag;

-- 16. NULL handling
SELECT order_id, status,
       COALESCE(CAST(delivery_minutes AS TEXT), 'Not delivered') AS delivery_time
FROM orders
WHERE delivery_minutes IS NULL;

-- 17. Conditional aggregation: status counts per restaurant
SELECT r.restaurant_name,
       SUM(CASE WHEN o.status = 'delivered' THEN 1 ELSE 0 END) AS delivered,
       SUM(CASE WHEN o.status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled,
       SUM(CASE WHEN o.status = 'pending' THEN 1 ELSE 0 END) AS pending
FROM restaurants r
LEFT JOIN orders o ON o.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_id, r.restaurant_name
ORDER BY r.restaurant_name;

-- 18. Customer lifetime value from delivered orders
SELECT c.customer_id, c.customer_name,
       ROUND(SUM(CASE WHEN o.status = 'delivered' THEN o.amount ELSE 0 END), 2) AS lifetime_value
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY lifetime_value DESC;
