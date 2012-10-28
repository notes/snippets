Option Explicit

On Error Resume Next

ExcelMacroExample

Sub ExcelMacroExample() 
  Dim xlApp 
  Dim xlBook 

  Set xlApp = CreateObject("Excel.Application") 
  Set xlBook = xlApp.Workbooks.Open("MacroFilename.xls", 0, True) 

  xlApp.DisplayAlerts = False
  xlApp.Run "MacroName"
  xlApp.SaveAs "ResultFilename.xls"

  xlBook.Close
  xlApp.Quit 
End Sub 