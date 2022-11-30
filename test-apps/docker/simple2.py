import os
import time
import datetime
import random
import psycopg2

print(os.environ)
while True:
    print(f'now: {datetime.datetime.now()}')
    print(f'random: {random.random()}')
    
    conn = psycopg2.connect(database = os.environ.get('DATABASE_NAME'), user = os.environ.get('DATABASE_USER'), password = os.environ.get('DATABASE_PASSWORD'), host = os.environ.get('DATABASE_HOSTNAME'), port = os.environ.get('DATABASE_PORT'))
    cur = conn.cursor()
    cur.execute('SELECT CURRENT_TIME;')
    db_time = cur.fetchall()[0][0]
    print(f'DB Time: {db_time}')

    time.sleep(10)
