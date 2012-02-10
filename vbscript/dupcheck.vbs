Const ForAppending = 8
dim fso, lockfilepath, lockfile

set fso = CreateObject("Scripting.FileSystemObject")
lockfilepath = "C:\TEMP\" & WScript.ScriptName & ".lck"

on error resume next
set lockfile = fso.OpenTextFile(LockFilePath, ForAppending, True)
if Err.Number <> 0 then
  Wscript.Echo "program already running"
  Wscript.Exit 1
else
  lockfile.WriteLine Now() & vbTab & "program started"
  Wscript.Sleep 2000
end if
on error goto 0

