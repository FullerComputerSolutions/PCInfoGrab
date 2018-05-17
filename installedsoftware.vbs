'query wmi for installed software
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objTextFile = objFSO.CreateTextFile(".\software.txt", True)
strComputer = "."
Set objWMIService = GetObject("winmgmts:" _
 & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
Set colSoftware = objWMIService.ExecQuery _
 ("SELECT * FROM Win32_Product")
objTextFile.WriteLine "Caption" & vbtab & "Version" & vbtab & "Install Location" & vbtab & "Package Cache"
For Each objSoftware in colSoftware
 objTextFile.WriteLine objSoftware.Caption & vbtab & _
 objSoftware.Version & vbtab & _
 objSoftware.InstallLocation & vbtab & _
 objSoftware.Name & vbtab & _
 objSoftware.PackageCache
Next
objTextFile.Close
