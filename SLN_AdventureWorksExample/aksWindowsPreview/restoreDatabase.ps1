﻿Function restoreDatabase {
Param ($db, $DbName, $Vars)	
	&"c:\Program Files\Microsoft SQL Server\150\DAC\bin\SqlPackage.exe" /Action:Publish /SourceFile:$db.dacpac $Vars /TargetDatabaseName:$DbName /TargetServerName:localhost 
        & sqlcmd -d $DbName -Q "EXEC sp_changedbowner 'sa'" 
}

gci env:

dir "C:\"

## restore adventure works from .bak file
& sqlcmd -d master -U sa -P $env:sa_password -Q "RESTORE DATABASE AdventureworksSrc FROM DISK = 'C:\ADVENTURE_WORKS.bak'"
& sqlcmd -d master -U sa -P $env:sa_password -Q "RESTORE DATABASE AdventureworksTgt FROM DISK = 'C:\ADVENTURE_WORKS.bak'"

echo "Deploying TSQLT"

DeployDacpacs TSQLT AdventureworksSrc ""
DeployDacpacs TSQLT AdventureworksTgt ""

& sqlcmd -d AdventureworksSrc -U sa -P $env:sa_password -Q "EXEC sp_changedbowner 'sa'" 
& sqlcmd -d AdventureworksTgt -U sa -P $env:sa_password -Q "EXEC sp_changedbowner 'sa'" 