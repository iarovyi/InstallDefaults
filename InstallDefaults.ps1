[CmdletBinding()]
param(
	[ValidateSet('Community', 'Professional', 'Enterprise')]
	[string]$VisualStudioEdition = 'Professional',
	[string]$Packages = ''
)

$ErrorActionPreference = 'Stop'

$defaultPackageIds = @(
	'Microsoft.VisualStudioCode',
	'Notion.Notion',
	'Google.Chrome',
	'Git.Git',
	'Atlassian.Sourcetree',
	"Microsoft.VisualStudio.$VisualStudioEdition",
	'Microsoft.NuGet',
	'7zip.7zip',
	'GitHub.Copilot',
	'Google.GoogleDrive',
	'OpenJS.NodeJS.LTS',
	'Python.Python.3.14',
	'Microsoft.PowerToys',
	'Microsoft.WSL',
	'Docker.DockerDesktop',
	'Docker.sbx'
)

$packageOverrides = @{
	'Microsoft.VisualStudioCode' = '/VERYSILENT /MERGETASKS=addcontextmenufiles,addcontextmenufolders,addtopath'
}

$packageIds = if ([string]::IsNullOrWhiteSpace($Packages)) {
	$defaultPackageIds
}
else {
	$Packages -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ } | Select-Object -Unique
}

function Invoke-Winget([string[]]$WingetArgs) {
	if ($VerbosePreference -eq 'Continue') {
		& winget @WingetArgs 2>&1 | Out-Host
	}
	else {
		& winget @WingetArgs *> $null
	}
	return $LASTEXITCODE
}

function Test-WingetInstalled([string]$Id) {
	$code = Invoke-Winget -WingetArgs @('list', '--id', $Id, '-e', '--accept-source-agreements')
	return $code -eq 0
}

function Install-App([string]$Id, [string]$Override) {
	$timer = [System.Diagnostics.Stopwatch]::StartNew()
	$installed = Test-WingetInstalled $Id
	$needsInstall = -not $installed

	if (-not $needsInstall) {
		$timer.Stop()
		return [pscustomobject]@{ Id = $Id; Status = 'Success'; Details = 'AlreadyInstalled'; Seconds = 0 }
	}

	$args = @('install', '--id', $Id, '-e', '--source', 'winget', '--silent', '--disable-interactivity', '--accept-package-agreements', '--accept-source-agreements')
	if ($Override) { $args += @('--override', $Override) }
	[void](Invoke-Winget -WingetArgs $args)

	$ok = Test-WingetInstalled $Id

	$timer.Stop()
	[pscustomobject]@{
		Id      = $Id
		Status  = if ($ok) { 'Success' } else { 'Failed' }
		Details = if ($ok) { 'Installed' } else { 'NotInstalledAfterAttempt' }
		Seconds = [math]::Round($timer.Elapsed.TotalSeconds, 1)
	}
}

$all = [System.Diagnostics.Stopwatch]::StartNew()
$results = foreach ($id in $packageIds) { Install-App $id $packageOverrides[$id] }
$all.Stop()

"`nInstallation summary (winget):"
$results | Sort-Object Id | Format-Table Id, Status, Details, Seconds -AutoSize
"Total time: $([math]::Round($all.Elapsed.TotalMinutes, 1)) min"