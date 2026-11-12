from pathlib import Path
import sqlite3
import pandas as pd

ROOT = Path(__file__).resolve().parent
DB_PATH = ROOT / "food_delivery.db"


def build_database():
    """Create the SQLite database and load all synthetic CSV tables."""
    if DB_PATH.exists():
        DB_PATH.unlink()

    conn = sqlite3.connect(DB_PATH)
    conn.execute("PRAGMA foreign_keys = ON")
    try:
        conn.executescript((ROOT / "sql" / "schema.sql").read_text(encoding="utf-8"))
        for table in ("customers", "restaurants", "orders", "restaurant_tags"):
            frame = pd.read_csv(ROOT / "data" / f"{table}.csv")
            frame.to_sql(table, conn, if_exists="append", index=False)
        conn.commit()
    except Exception:
        conn.close()
        raise
    return conn


def main():
    conn = build_database()
    try:
        print("Database created:", DB_PATH)
        for table in ("customers", "restaurants", "orders", "restaurant_tags"):
            count = conn.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0]
            print(f"{table}: {count} rows")

        result = pd.read_sql_query(
            """
            SELECT r.cuisine,
                   COUNT(*) AS delivered_orders,
                   ROUND(SUM(o.amount), 2) AS delivered_revenue
            FROM orders o
            JOIN restaurants r ON r.restaurant_id = o.restaurant_id
            WHERE o.status = 'delivered'
            GROUP BY r.cuisine
            ORDER BY delivered_revenue DESC
            """,
            conn,
        )
        print("\nDelivered revenue by cuisine:")
        print(result.to_string(index=False))
    finally:
        conn.close()


if __name__ == "__main__":
    main()
