<#
.SYNOPSIS
Run different versions of MSSQL Server without installation using containers
.PARAMETER Port
Port number for server to listen on
.PARAMETER Password
SQL server password for 'sa' user
.PARAMETER Folder
Folder for database.
.PARAMETER Task
Action to perform: 'Create' (run server in container), 'Start' (start server), 'Stop' (stop server), 'Delete' (delete server and files)
.PARAMETER SqlVersion
Sql server versions: '2017', '2019'
.Example
 1) Create and run server
    .\SqlServerContainer.ps1 -Task Create
 2) Use server via "server=.,1433;uid=sa;pwd=Test@123"
 3) Stop server
    .\SqlServerContainer.ps1 -Task Stop
 4) Start stopped server
    .\SqlServerContainer.ps1 -Task Start
 5) Delete server and files
    .\SqlServerContainer.ps1 -Task Delete
.Example
 1) Run multiple versions of MSSQL Server
 .\SqlServerContainer.ps1 -Task Create -Port 1478 -SqlVersion 2017
 .\SqlServerContainer.ps1 -Task Create -Port 1479 -SqlVersion 2019
 2) Connect via "server=.,1478;uid=sa;pwd=Test@123" and "server=.,1479;uid=sa;pwd=Test@123"
 3) Stop server
    .\SqlServerContainer.ps1 -Task Stop -SqlVersion 2017
 4) Start stopped server
    .\SqlServerContainer.ps1 -Task Start -SqlVersion 2017
 5) Delete server and files
    .\SqlServerContainer.ps1 -Task Delete -SqlVersion 2017
#>
param (
    [string]$Port       = "1433",
    [string]$Password   = "Test@123",
    [string]$Folder     = "C:/DockerShared/MsSql",
    [ValidateSet("Create","Start", "Stop", "Delete")]
    [string]$Task       = "Create",
    [ValidateSet("2017", "2019")]
    [string]$SqlVersion = "2019"
)

$versionFolder = "C:/DockerShared/MsSql/$SqlVersion"
$serverContainer = "sql-server-$SqlVersion"
$dataContainer = "mssql-$SqlVersion"

If(!(test-path $versionFolder))
{
    New-Item -ItemType Directory -Force -Path $versionFolder
}

if ($Task -ieq "create"){
    $image = "mcr.microsoft.com/mssql/server:$SqlVersion-latest"
    docker create -v $versionFolder --name $dataContainer $image /bin/true
    docker run -e 'ACCEPT_EULA=Y' -e "SA_PASSWORD=$Password" -p "$($Port):1433" --volumes-from $dataContainer -d --name $serverContainer $image
    if ($LastExitCode -eq 0) {
        Write-Host "SQL Server started. Connection string:" -f 'black' -b 'gre'
        Write-Host "Server=.,$Port;User Id=sa;Password=$Password;" -f 'black' -b 'gre'
    }
}

if ($Task -ieq "start"){
    docker start $serverContainer $dataContainer
}

if ($Task -ieq "stop"){
    docker stop $serverContainer $dataContainer
}

if ($Task -ieq "delete"){
    docker stop $serverContainer $dataContainer
    docker rm   $serverContainer $dataContainer #container removal removes data forever https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-configure-docker?view=sql-server-ver15
    Remove-Item -Recurse -Force $versionFolder
}
