<#
.SYNOPSIS
Configures NuGet to use Artifactory feed with authentication.

.DESCRIPTION
Sets up NuGet configuration to use Artifactory as a package source with authentication.
Removes any existing Artifactory source and reconfigures it to ensure consistent setup.

.PARAMETER SourceUrl
The NuGet package source URL (Artifactory feed index.json endpoint).

.PARAMETER Username
The username for Artifactory authentication.

.PARAMETER ApiToken
The API token or password for Artifactory authentication.

.EXAMPLE
.\setupArtifactoryNugetFeed.ps1 `
    -SourceUrl "..../artifactory/api/nuget/v3/dev-nuget/index.json" `
    -Username "my.username" `
    -ApiToken "xxxxx"
#>

param(
    [Parameter(Mandatory = $true)][string]$SourceUrl,
    [Parameter(Mandatory = $true)][string]$Username,
    [Parameter(Mandatory = $true)][string]$ApiToken
)

nuget sources Remove -Name Artifactory 2>$null | Out-Null
nuget sources Add -Name Artifactory -Source $SourceUrl -username $Username -password $ApiToken
nuget setapikey "${Username}:${ApiToken}" -Source Artifactory