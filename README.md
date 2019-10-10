# InstallDefaults

Don't waster your time for installing all applications manually once you got new pc. Just use simple to use script that will do everything for you. Script install all base applications neede for .NET developer:
- chrome
- visual studio code
- visual studio 2019
- resharper and dotpeek
- git and source tree
- docker
- sql server express
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

or install including paied software that requires providing license afterwards:
```
Set-ExecutionPolicy Bypass -Scope Process -Force;
& $([scriptblock]::Create((New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/iarovyi/InstallDefaults/master/InstallDefaults.ps1'))) -IncludePaid
```