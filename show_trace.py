import CUBRIDdb
import json

conn = CUBRIDdb.connect('CUBRID:localhost:33000:testdb:::', 'dba', '')
cur = conn.cursor()

cur.execute("set trace on output json;")

cur.execute("select count(*) from t_oos_ovf")

rows = cur.fetchall()
for row in rows:
    print (row)
    assert row[0] == 300000

cur.execute("show trace")
rows = cur.fetchall()
data = json.loads(rows[0][0])

print(json.dumps(data, indent=2))


