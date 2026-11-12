# Flex SQL Developer — Project & Interview Guide

## Project explanation
"I built a small relational database for a fictional food-delivery platform using SQLite. It has customers, restaurants, orders and restaurant_tags tables. I used primary keys, foreign keys, NOT NULL and CHECK constraints, and indexes. I loaded synthetic CSV data using Python and pandas, then wrote reports using joins, GROUP BY, HAVING, subqueries, CTEs and DENSE_RANK. Reports cover delivered revenue by cuisine, daily revenue, repeat customers and delivery performance. I also tested row counts and foreign-key enforcement."

All records are synthetic, not real company data.

## Schema and relationships
- customers(customer_id PK, customer_name, city, signup_date)
- restaurants(restaurant_id PK, restaurant_name, cuisine, city)
- orders(order_id PK, customer_id FK, restaurant_id FK, order_date, amount, status, delivery_minutes)
- restaurant_tags(tag_id PK, restaurant_id FK, tag)

A customer can place many orders. A restaurant can receive many orders and have many tags. Each order refers to one customer and one restaurant.

## Logical SQL processing order
FROM/JOIN -> WHERE -> GROUP BY -> HAVING -> SELECT -> DISTINCT -> ORDER BY -> LIMIT.
This is the logical processing order, not necessarily the physical execution plan.

## Must-know interview answers
- SQL: Structured Query Language used to define, query and manipulate relational data.
- Primary key vs foreign key: a primary key uniquely identifies a row; a foreign key references a key in another table.
- WHERE vs HAVING: WHERE filters rows before grouping; HAVING filters groups after GROUP BY.
- INNER vs LEFT JOIN: INNER returns matches only; LEFT preserves all left rows and returns NULL for unmatched right-side columns.
- DELETE vs TRUNCATE vs DROP: DELETE removes selected rows and supports WHERE; TRUNCATE removes all rows in engines that support it (SQLite has no TRUNCATE); DROP removes the table definition and data.
- UNION vs UNION ALL: UNION removes duplicate result rows; UNION ALL retains duplicates.
- COUNT(*) vs COUNT(column): COUNT(*) counts rows; COUNT(column) ignores NULL values.
- Index: can speed up lookups and joins, but uses storage and adds write overhead.
- Currency precision: SQLite REAL is floating-point. For production financial data, store integer paise or use an exact-decimal data type in a suitable database.
- Normalization: structures tables to reduce duplication and update anomalies.
- Subquery: query nested inside another query.
- CTE: named temporary result set defined with WITH for one statement.
- Window function: calculates across related rows without collapsing them into one row per group.
- NULL: missing/unknown/not-applicable marker; use IS NULL, not = NULL.
- Join duplication: one row may match multiple rows on the other side. Aggregate at the correct grain before additional one-to-many joins.
- COALESCE: returns the first non-NULL argument.
- Referential integrity: keeps foreign-key references consistent with valid parent rows.

## Practical SQL exercises
1. Show all delivered orders.
2. Count orders by status.
3. Calculate delivered revenue by cuisine.
4. Find average delivered order value per restaurant.
5. Calculate daily delivered revenue.
6. Find repeat customers.
7. Find customers with no orders.
8. Find restaurants with no orders.
9. Find orders above average amount.
10. Rank cuisines by delivered revenue.
11. Find duplicate names.
12. Find the second-highest distinct order amount.
13. Preserve restaurants with zero delivered orders.
14. Count statuses using CASE WHEN.
15. Explain why joining orders to restaurant_tags can inflate revenue.
16. Explain why floating-point REAL is not ideal for production money calculations.

## Query patterns
Second-highest distinct amount:
    SELECT MAX(amount) FROM orders
    WHERE amount < (SELECT MAX(amount) FROM orders);

Find duplicates:
    SELECT customer_name, COUNT(*) FROM customers
    GROUP BY customer_name HAVING COUNT(*) > 1;

Customers without orders:
    SELECT c.customer_id, c.customer_name
    FROM customers c LEFT JOIN orders o ON o.customer_id=c.customer_id
    WHERE o.order_id IS NULL;

To preserve restaurants when counting delivered orders, put the delivered status filter in the LEFT JOIN ON clause, then GROUP BY restaurant.

## Debugging scenarios
- Duplicate revenue: check join cardinality, one-to-many relationships, source duplicates and aggregation grain.
- LEFT JOIN excludes rows: a WHERE filter on the right table may remove NULL-extended rows; move it into ON when unmatched left rows must remain.
- Revenue is wrong: check status filters, duplicate orders, NULL amounts, join keys and aggregation grain.
- Query fails: check names, aliases, quotes, commas, grouping columns, types and SQL dialect.

## HR answers
Why SQL Developer? My CSE background and project work gave me a foundation in relational data and SQL. I enjoy breaking business questions into joins, filters and aggregations and want to deepen my database experience.

Why hire a fresher? I have practised writing and explaining SQL queries against a relational schema. I understand joins, aggregation, subqueries and data integrity. I validate results and am willing to learn team procedures.

Rotational shifts: answer truthfully. Do not promise to work overnight if transport or personal constraints make it impractical.

Salary: ask for fixed/variable split, deductions, shift allowance and monthly take-home before confirming.

## Questions to ask
- Which engine is used: SQL Server, Oracle, MySQL or PostgreSQL?
- Is the work query development, production support, reporting or database operations?
- Is training provided?
- How often do shifts rotate?
- Is company transport available for 11 PM–7 AM?
- What are fixed pay, variable pay, PF/ESI and monthly take-home?

## Revision plan
90 min CRUD and filters; 90 min joins; 60 min grouping; 60 min subqueries/CTEs/windows; 45 min database fundamentals; 60 min practice queries; 30 min explain the project aloud.

## Honesty checklist
- Say SQLite; do not claim Oracle/MySQL/SQL Server experience unless you have it.
- Say synthetic sample data.
- Do not claim production deployment or company use.
- Be ready to run the repository and explain each query.
