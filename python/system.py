import sys
import subprocess

def do_system(args, stdin=None, shell=True):
  p = subprocess.Popen(args, stdin=subprocess.PIPE, stdout=subprocess.PIPE,
    stderr=subprocess.PIPE, shell=shell)
  stdout, stderr = p.communicate(stdin)
  return p.returncode, stdout, stderr
    
if __name__ == "__main__":
  if len(sys.argv) == 2:
    status, stdout, stderr = do_system(sys.argv[1])
  else:
    status, stdout, stderr = do_system(sys.argv[1:], shell=False)

  if status == 0:
    print "Success"
  elif status > 0:
    print "Failure (exit with %d)" % status
  elif status < 0:
    # You can't get a coredump status
    print "Failure (killed by signal %d)" % -status

  if stdout:
    print "\n[STDOUT]\n" + stdout
  if stderr:
    print "\n[STDERR]\n" + stderr

