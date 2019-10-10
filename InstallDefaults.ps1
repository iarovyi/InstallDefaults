<#
.SYNOPSIS
Installs basic software for .NET developer
.PARAMETER IncludePaid
Install paied software that requires specifying license afterwards
.Example
 .\InstallDefaults.ps1 -IncludePaid
#>
[CmdletBinding()]
param (
    [switch]$IncludePaid
)

function Install-Chocolatey
{
	Set-ExecutionPolicy Bypass -Scope Process -Force;
	iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

function Disable-Service
{
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$Name
	)

	Get-Service -Name $Name | ?{ $_.Status -eq "Running" } | % { $_.Stop(); }
	Get-Service -Name $Name | ?{ $_.StartType -eq "Automatic" } |
	% { Set-Service -Name $_.Name -StartupType "Manual"; }
}

Write-Output "Installing $(If ($IncludePaid.IsPresent) {"with"} Else {"without"}) paied software"
$stopwatch =  [system.diagnostics.stopwatch]::StartNew()
Install-Chocolatey
choco install -y googlechrome
choco install -y vscode
choco install -y notepadplusplus
choco install -y sourcetree
choco install -y git.install
choco install -y conemu
choco install -y 7zip
choco install -y docker-desktop
choco install -y visualstudio2019community
choco install -y dotpeek
choco install -y sql-server-express #"Server=.\SQLEXPRESS;Trusted_Connection=True;
choco install -y sql-server-management-studio
Disable-Service "*SQL*"
choco install -y thunderbird

if ($IncludePaid.IsPresent){
	choco install -y resharper
	choco install -y webstorm
}

Write-Output "Installion completed in $([math]::Round($stopwatch.Elapsed.TotalMinutes,0)) minutes"