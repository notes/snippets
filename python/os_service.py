import os
import sys
import time
import signal

# open, read, close file
print "----file io----"
f = open("a.py")
data = f.read(32)
print "[%s]" % data
for line in f:
    sys.stdout.write(line)
f.close()

# directory listing
print "----directory listing----"
dirs = os.listdir(".")
print dirs

# stat file
print "----stat file----"
st = os.stat("a.py")
print """\
size={0.st_size:d}, mode={0.st_mode:06o}, inode={0.st_ino:d},
uid={0.st_uid:d}, gid={0.st_gid:d}, mtime={0.st_mtime:.6f}
""".format(st)

# install signal handler and send signal
print "----signal handling----"
def sig_handler(s, frames):
    print "Signal %d received" % s
signal.signal(signal.SIGUSR1, sig_handler)
os.kill(os.getpid(), signal.SIGUSR1)

# sleep forever
time.sleep(-1)
