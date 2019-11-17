# InstallDefaults

Don't waste your time for installing all applications manually once you got new pc. Just use simple to use script that will do everything for you. Script install all base applications neede for .NET developer:
- chrome
- visual studio code
- visual studio 2019
- dotpeek
- git and source tree
- docker
- sql server express (windows service suspended)
- webstorm
- thunderbird email client
- conemu
- 7zip
- notepad++

Install by simple executing script in powershell:
```
Set-ExecutionPolicy Bypass -Scope Process -Force;
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/iarovyi/InstallDefaults/master/InstallDefaults.ps1'))
```

or install custom list of packages and suspend certain windows services:
```
$packages = "googlechrome,vscode,notepadplusplus,sourcetree,git.install,conemu,7zip,docker-desktop,visualstudio2019community,dotpeek,sql-server-express,sql-server-management-studio,thunderbird";
$suspendServices = "*SQL*"
Set-ExecutionPolicy Bypass -Scope Process -Force;
& $([scriptblock]::Create((New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/iarovyi/InstallDefaults/master/InstallDefaults.ps1'))) -Packages $packages -SuspendServices $suspendServices
```

All packages can be updated at once after a while:
```
choco upgrade all
```