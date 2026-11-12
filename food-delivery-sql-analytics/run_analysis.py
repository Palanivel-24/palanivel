from pathlib import Path
import sqlite3
import pandas as pd
ROOT=Path(__file__).resolve().parent
DB_PATH=ROOT/'food_delivery.db'
def build_database():
    if DB_PATH.exists(): DB_PATH.unlink()
    conn=sqlite3.connect(DB_PATH)
    conn.execute('PRAGMA foreign_keys = ON')
    conn.executescript((ROOT/'sql'/'schema.sql').read_text())
    for table in ('customers','restaurants','orders','restaurant_tags'):
        pd.read_csv(ROOT/'data'/f'{table}.csv').to_sql(table,conn,if_exists='append',index=False)
    conn.commit()
    return conn
def main():
    conn=build_database()
    for table in ('customers','restaurants','orders','restaurant_tags'):
        print(f'{table}:',conn.execute(f'SELECT COUNT(*) FROM {table}').fetchone()[0])
    print(pd.read_sql_query("SELECT r.cuisine, COUNT(*) AS delivered_orders, ROUND(SUM(o.amount),2) AS revenue FROM orders o JOIN restaurants r ON r.restaurant_id=o.restaurant_id WHERE o.status='delivered' GROUP BY r.cuisine ORDER BY revenue DESC",conn).to_string(index=False))
    conn.close()
if __name__=='__main__': main()
