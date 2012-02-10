'Basename(filename) - Return the filename portion of a full pathname
'Pathname(filename) - Return the pathname portion of a full pathname
'FileExt(filename) - Return the filename extension portion of a path/filename
'GetFileSize(filename) - Return the length of a file/folder or -1 if it does not exist
'FileExists(filename) - return 0 if a file exists else -1
'PathExists(pathname) - return 0 if a folder exists else -1
'RandomNumb(HI, LO) - returns a random number between HI and LO, inclusive
'GetDiskFree(drivename) - drivename like "c:" return number of kilobytes free for a given drive 
'GetWinDir - return Windows directory
'GetWinSys - return Windows/System directory
'GetWinTemp - return Windows/temp directory
'GetTempName - return temp filename
'GetTempFullPath - return full path and temp filename
'FileCreated(filename) - Return the date/time a file was created
'FileLastAccessed(filename) - Return the date a file was last accessed
'FileLastModified(filename) - Return the date/time a file was last modified
'FolderCreated(foldername) - Return the date/time a folder was created
'FolderLastAccessed(foldername) - Return the date a folder was last accessed
'FolderLastModified(foldername) - Return the date/time a folder was last modified
'ElementsInArray(ArrayName) - Returns the number of non-NULL elements in an array
'NonEmptyElementsInArray(ArrayName) - Returns the number of non-Empty elements in an array
'LogEvent Type , Msg - logs a message to the NT logfile (wsh.log on W9x)
'IsDST(TodayDate, arrReturn) Return 0 if date is not in DST, 1 if it is, -1 if not date. Takes a
'   1 Dimensional 2 element array for begin and end of dst dates.
'Chop(string) chops the lasts character off a string
'ChopChar(string, strchar) chops the last character off a string if it matches strchar

Option Explicit

Const ForReading = 1, ForWriting = 2, ForAppending = 8
Const TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0
Const SUCCESS = 0, ERROR = 1, WARNING = 5, INFORMATION = 4, AUDIT_SUCCESS = 8, AUDIT_FAILURE = 16


'Return the filename portion of a full pathname
function Basename(FullPath)
dim x, y
dim tmpstring

  tmpstring = FullPath
  x = Len(FullPath)
  for y = x to 1 step -1
    if mid(FullPath, y, 1) = "\" or _
      mid(FullPath, y, 1) = ":" or _
      mid(FullPath, y, 1) = "/" then
      tmpstring = mid(Fullpath, y+1)
      exit for
    end if
  next
Basename = tmpstring
end function

'Return the pathname portion of a full pathname
function Pathname(FullPath)
dim x, y
dim tmpstring

  x = Len(FullPath)
  for y = x to 1 step -1
    if mid(FullPath, y, 1) = "\" or _
      mid(FullPath, y, 1) = "/" then
      tmpstring = mid(Fullpath, 1, y-1)
      exit for
    end if
next
Pathname = tmpstring
end function

'Return the filename extension portion of a path/filename
function FileExt(FullPath)
dim x, y
dim tmpstring

  x = Len(FullPath)
  for y = x to 1 step -1
    if mid(FullPath, y, 1) = "." then
      tmpstring = mid(Fullpath, y+1)
      exit for
    end if
  next
FileExt = tmpstring
end function

'Return the length of a file or -1 if it does not exist
function GetFileSize(Fname)

  GetFileSize = -1

  Set fs = CreateObject("Scripting.FileSystemObject")

  if fs.FileExists(Fname) = True then
    set f = fs.GetFile(Fname)
    GetFileSize = f.size
  end if
  if fs.FolderExists(Fname) = True then
    set f = fs.GetFolder(Fname)
    GetFileSize = f.size
  end if

Set f = Nothing
Set fs = Nothing
end function

'Return 0 if a file exists else -1
function FileExists(Fname)
  Set fs = CreateObject("Scripting.FileSystemObject")

  if fs.FileExists(Fname) = False then
    FileExists = -1
  else
    FileExists = 0
  end if
Set fs = Nothing
end function

'Return 0 if a folder exists else -1
function PathExists(Pathname)
  Set fs = CreateObject("Scripting.FileSystemObject")

  if fs.FolderExists(Pathname) = False then
    PathExists = -1 
  else
    PathExists = 0
  end if
Set fs = Nothing
end function


'Returns a random number between HI and LO, inclusive
function RandomNumb(hi, lo)

  Randomize
  RandomNumb = Int((hi - lo + 1) * Rnd + lo)

end function

'Return number of kilobytes free for a given drive 
function GetDiskFree(drive)
dim s, d

On Error Resume Next

  s = -1
  Set fs = CreateObject("Scripting.FileSystemObject")
  Set d = fs.GetDrive(fs.GetDriveName(drive))
  if d.FreeSpace < 0 then
    s = -1
  else
    s = (d.FreeSpace / 1024)
  end if

set d = Nothing
set fs = Nothing

GetDiskFree = s
end function


'Return Windows directory
function GetWinDir
  Set fs = CreateObject("Scripting.FileSystemObject")
  GetWinDir = fs.GetSpecialFolder(WindowsFolder)
Set fs = Nothing
end function

'Return Windows/System directory
function GetWinSys
  Set fs = CreateObject("Scripting.FileSystemObject")
  GetWinSys = fs.GetSpecialFolder(1)
Set fs = Nothing
end function

'Return Windows/temp directory
function GetWinTemp
  Set fs = CreateObject("Scripting.FileSystemObject")
  GetWinTemp = fs.GetSpecialFolder(2)
Set fs = Nothing
end function

'Return temp filename
function GetTempName
  Set fs = CreateObject("Scripting.FileSystemObject")
  GetTempName = fs.GetTempName
Set fs = Nothing
end function

'Return full path and temp filename
function GetTempFullPath
  GetTempFullPath = GetWinTemp & "\" & GetTempName
  Set fs = Nothing
end function

'Return the date/time a file was created
function FileCreated(Fname)

  FileCreated = ""

  Set fs = CreateObject("Scripting.FileSystemObject")

  if fs.FileExists(Fname) = True then
    Set f = fs.GetFile(Fname)
    FileCreated = f.DateCreated
  end if
Set f = Nothing
Set fs = Nothing
end function

'Return the date a file was last accessed
function FileLastAccessed(Fname)

  FileLastAccessed = ""

  Set fs = CreateObject("Scripting.FileSystemObject")

  if fs.FileExists(Fname) = True then
    Set f = fs.GetFile(Fname)
    FileLastAccessed = f.DateLastAccessed
  end if
Set f = Nothing
Set fs = Nothing
end function

'Return the date/time a file was last modified
function FileLastModified(Fname)

  FileLastModified = ""

  Set fs = CreateObject("Scripting.FileSystemObject")

  if fs.FileExists(Fname) = True then
    Set f = fs.GetFile(Fname)
    FileLastModified = f.DateLastModified
  end if
Set f = Nothing
Set fs = Nothing
end function

'Return the date/time a folder was created
function FolderCreated(Fname)

  FolderCreated = ""

  Set fs = CreateObject("Scripting.FileSystemObject")

  if fs.FolderExists(Fname) = True then
    Set f = fs.GetFolder(Fname)
    FolderCreated = f.DateCreated
  end if
Set f = Nothing
Set fs = Nothing
end function

'Return the date a folder was last accessed
function FolderLastAccessed(Fname)

  FolderLastAccessed = ""

  Set fs = CreateObject("Scripting.FileSystemObject")

  if fs.FolderExists(Fname) = True then
    Set f = fs.GetFolder(Fname)
    FolderLastAccessed = f.DateLastAccessed
  end if
Set f = Nothing
Set fs = Nothing
end function

'Return the date/time a folder was last modified
function FolderLastModified(Fname)

  FolderLastModified = ""

  Set fs = CreateObject("Scripting.FileSystemObject")

  if fs.FolderExists(Fname) = True then
    Set f = fs.GetFolder(Fname)
    FolderLastModified = f.DateLastModified
  end if
Set f = Nothing
Set fs = Nothing
end function
 

'Logs a message to the NT logfile (wsh.log on W9x)
 sub LogEvent(msgType, Msg)
   Set WshShell = WScript.CreateObject("WScript.Shell")
   WshShell.LogEvent msgType, Msg
   Set WshShell = Nothing
 end sub
 
 'Returns the number of elements in an array
 function ElementsInArray(ArrayName)
 dim Fields
   Fields = 0
   if IsEmpty(ArrayName) <> True then
     Fields = UBound(ArrayName) - LBound(ArrayName) + 1
   end if
 ElementsInArray = Fields
 end function
 
 'Returns the number of non-Empty elements in an array
 function NonEmptyElementsInArray(ArrayName)
 dim Fields, tmp
   Fields = 0
   if IsEmpty(ArrayName) <> True then
     For Each tmp in ArrayName
       if tmp <> "" then
         Fields = Fields + 1
       end if
     next
   end if
 NonEmptyElementsInArray = Fields
 end function
 
' Is any date in DST and dates DST begins and ends
Function IsDST(TodayDate, arrReturn)
' Is any date in DST and dates DST begins and ends
' Args = Date, 1 dimensional 2 element array
' Returns -1 on error (bad date)
' 0 if NOT DST
' 1 If in DST
' arrRetunr(0) = First day of DST
' arrReturn(1) = Last day of DST
' Paul R. Sadowski <aa089#bfn.org>
Dim StartDate, EndDate, StartDOW, EndDOW, TargetDOW
Dim BeginDST, EndDST
  if IsDate(TodayDate) <> True then
    arrReturn(0) = -1
    arrReturn(1) = -1
    IsDST = -1
    Exit Function
  end if
  StartDate = CDate("4/1/" & Cstr(Year(TodayDate)))
  EndDate = CDate("11/1/" & Cstr(Year(TodayDate)))
  StartDOW = Weekday(StartDate)
  if StartDOW <> 1 then
    TargetDOW = 8 - StartDOW 
  end if
  BeginDST = DateAdd("d", TargetDOW, StartDate)
  EndDOW = Weekday(EndDate)
  if EndDOW <> 1 then
    TargetDOW = 1 - EndDOW
  end if
  EndDST = DateAdd("d", TargetDOW, EndDate)
  if DateDiff("d", BeginDST, TodayDate) >= 0 then
    if DateDiff("d", EndDST, TodayDate) < 0 then
      arrReturn(0) = BeginDST
      arrReturn(1) = EndDST
      IsDST = 1
      Exit Function
    end if
  end if
  arrReturn(0) = BeginDST
  arrReturn(1) = EndDST
 IsDST = 0
End Function

'Chops the last character off a string
Function Chop(strString)
Dim x
  x = Len(strString)
  Chop = mid(strString, 1, x -1)
End Function

'Chops the last character off a string if it matches strchar
Function ChopChar(strString, strChar)
Dim x
  x = Len(strString)
  if mid(strString, x) = strChar then
    ChopChar = mid(strString, 1, x -1)
  else
    ChopChar = strString
end if
End Function

