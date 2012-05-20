# http://stackoverflow.com/questions/1475950/tail-f-in-python-with-no-time-sleep
import time

def follow(thefile, sleep_secs=0.2):
    # Go to the end of the file
    thefile.seek(0, 2)
    while True:
         line = thefile.readline()
         if not line:
             time.sleep(sleep_secs)
             continue
         yield line


