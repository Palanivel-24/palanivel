import unittest
import sys
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT))
from run_analysis import build_database
class DatabaseTests(unittest.TestCase):
 @classmethod
 def setUpClass(cls): cls.conn=build_database()
 @classmethod
 def tearDownClass(cls): cls.conn.close()
 def test_row_counts(self):
  for table,count in {'customers':8,'restaurants':6,'orders':30,'restaurant_tags':9}.items(): self.assertEqual(self.conn.execute(f'SELECT COUNT(*) FROM {table}').fetchone()[0],count)
 def test_fk_enabled(self): self.assertEqual(self.conn.execute('PRAGMA foreign_keys').fetchone()[0],1)
 def test_status_constraint(self): self.assertEqual(self.conn.execute("SELECT COUNT(*) FROM orders WHERE status NOT IN ('delivered','cancelled','pending')").fetchone()[0],0)
 def test_delivered_revenue_less_than_gross(self):
  delivered=self.conn.execute("SELECT SUM(amount) FROM orders WHERE status='delivered'").fetchone()[0]
  gross=self.conn.execute('SELECT SUM(amount) FROM orders').fetchone()[0]
  self.assertLess(delivered,gross)
 def test_join_cardinality(self): self.assertEqual(self.conn.execute('SELECT COUNT(*) FROM orders o JOIN customers c ON c.customer_id=o.customer_id').fetchone()[0],30)
if __name__=='__main__': unittest.main()
