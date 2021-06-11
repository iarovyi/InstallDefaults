<#
.SYNOPSIS
Installs basic software for .NET developer
.PARAMETER Packages
Comma separated list of chocolatey packages to install. If no value will install default set of applications
.PARAMETER SuspendServices
Comma separated list of windows services to disable on start. Wildcard are supported
.Example
 .\InstallDefaults.ps1 -Packages "googlechrome,vscode" -SuspendServices "*SQL*"
#>
[CmdletBinding()]
param (
	[string]$SuspendServices = "*SQL*",
	[string]$Packages = @("googlechrome",
						"vscode",
						"notepadplusplus",
						"sourcetree",
						"git.install",
						"conemu",
						"7zip",
						"docker-desktop",
						"visualstudio2019community",
						"dotpeek",
						"sql-server-express",
						"sql-server-management-studio",
						"thunderbird",
						"greenshot") -join ","
)

function Install-Chocolatey
{
	Set-ExecutionPolicy Bypass -Scope Process -Force;
	iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

function Suspend-Service
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

$stopwatch =  [system.diagnostics.stopwatch]::StartNew()
Install-Chocolatey

$Packages -split "," | % { choco install -y $_ }
if ($SuspendServices) {
	$SuspendServices -split "," | % { Suspend-Service $_ }
}


Write-Output "Installion completed in $([math]::Round($stopwatch.Elapsed.TotalMinutes,0)) minutes"