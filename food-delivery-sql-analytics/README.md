# Food Delivery Sales & Operations Analytics

A portfolio SQL project that models a small food-delivery platform and answers operational questions with relational queries.

> **Data notice:** All records are fictional and generated for learning. This project does not use real customer or company data.

## Tech stack
- SQL (SQLite)
- Python (sqlite3, pandas)
- CSV
- Google Colab / Jupyter Notebook

## Data model
Four related tables:
- customers: one row per customer
- restaurants: one row per restaurant
- orders: one row per order; references a customer and restaurant
- restaurant_tags: one or more tags per restaurant

Relationships:
- customers 1-to-many orders
- restaurants 1-to-many orders
- restaurants 1-to-many restaurant_tags

## SQL concepts
SELECT, INSERT, UPDATE, DELETE, INNER JOIN, LEFT JOIN, multi-table joins, GROUP BY, HAVING, aggregate functions, subqueries, CTEs, window functions, CASE WHEN, NULL handling, constraints, foreign keys, indexes, and join-cardinality pitfalls.

## Run locally
```bash
python -m venv .venv
# Windows: .venv\Scripts\activate
# macOS/Linux: source .venv/bin/activate
pip install -r requirements.txt
python run_analysis.py
python -m unittest discover -s tests -v
```

## Business questions
- How many orders are delivered, cancelled and pending?
- Which cuisines generate the most delivered revenue?
- What is the average delivered order value per restaurant?
- What is daily delivered revenue?
- Which customers place repeat delivered orders?
- Which customers/restaurants have no related orders?
- How do delivery times compare by restaurant?
- How can cuisines be ranked by delivered revenue?

## Important analytical decisions
- Revenue is calculated only from delivered orders.
- Restaurant tags form a one-to-many relationship. Joining orders to tags can repeat an order and inflate revenue unless aggregation happens at the correct grain.
- To preserve unmatched rows in a LEFT JOIN, right-side filters may belong in ON rather than WHERE.
- Dates use ISO YYYY-MM-DD text.

## Limitations
- Synthetic, small dataset; not suitable for production conclusions.
- SQLite is used for portability. Syntax may differ across MySQL, PostgreSQL and SQL Server.
- No production API or live food-delivery integration is included.

See [INTERVIEW_GUIDE.md](INTERVIEW_GUIDE.md) for the project walkthrough and SQL interview notes.
