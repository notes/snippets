#!Python27
# coding: utf-8

import sys
import cgi
import subprocess

def do_system(args, stdin=None, shell=True):
  p = subprocess.Popen(args, stdin=subprocess.PIPE, stdout=subprocess.PIPE,
    stderr=subprocess.PIPE, shell=shell)
  stdout, stderr = p.communicate(stdin)
  return p.returncode, stdout, stderr

form = cgi.FieldStorage()
command = '"C:\\Program Files\\Java\\jre7\\bin\\java.exe" -jar plantuml.jar -charset utf-8 -pipe'
status, stdout, stderr = do_system(command, form["text"].value)
if status != 0:
  print "Content-Type: text/plain; charset=CP932"
  print ""
  print stderr
else:
  print "Content-Type: text/plain"
  print ""
  print stdout.encode("base64")
