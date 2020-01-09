# Run Multiple Versions of SQL Server in container without installation

It is much easier and fater to run sql server without installing SQL server itself.
Run as administrator in powershell script for running database.

1. Start sql Server:
```
$Port = "1433"
$Task = "Create"

Set-ExecutionPolicy Bypass -Scope Process -Force;
& $([scriptblock]::Create((New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/iarovyi/InstallDefaults/master/SqlServer/SqlServerContainer.ps1'))) -Task $Task -Port "1433" -Password "Test@123" -SqlVersion 2019
```

2. Stop sql Server without loosing data:
```
$Port = "1433"
$Task = "Stop"

Set-ExecutionPolicy Bypass -Scope Process -Force;
& $([scriptblock]::Create((New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/iarovyi/InstallDefaults/master/SqlServer/SqlServerContainer.ps1'))) -Task $Task -Port "1433" -Password "Test@123" -SqlVersion 2019
```

3. Resume sql Server:
```
$Port = "1433"
$Task = "Start"

Set-ExecutionPolicy Bypass -Scope Process -Force;
& $([scriptblock]::Create((New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/iarovyi/InstallDefaults/master/SqlServer/SqlServerContainer.ps1'))) -Task $Task -Port "1433" -Password "Test@123" -SqlVersion 2019
```

4. Delete sql Server and data:
```
$Port = "1433"
$Task = "Delete"

Set-ExecutionPolicy Bypass -Scope Process -Force;
& $([scriptblock]::Create((New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/iarovyi/InstallDefaults/master/SqlServer/SqlServerContainer.ps1'))) -Task $Task -Port "1433" -Password "Test@123" -SqlVersion 2019
```