import os
import time
import datetime
import random

print(os.environ)
while True:
    print(f'now: {datetime.datetime.now()}')
    print(f'random: {random.random()}')
    time.sleep(10)
