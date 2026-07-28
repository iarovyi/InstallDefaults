<#
.SYNOPSIS
Configures npm to use Artifactory feeds with authentication.

.DESCRIPTION
Sets up npm configuration to use Artifactory as the default registry and configures
authentication tokens for multiple feeds to ensure all packages come from the company's
approved registry.

.PARAMETER Token
The authentication token for Artifactory access.

.PARAMETER Email
The email address to use for npm configuration.

.PARAMETER DefaultRegistryUrl
The primary npm registry URL (typically the group-npm feed).

.PARAMETER Feeds
Array of feed hostnames to configure with authentication tokens.

.EXAMPLE
.\setupArtifactoryNpmFeed.ps1 `
    -Token "xxxxxxxxxxxxxxx" `
    -Email "my.email@mycompany.com" `
    -DefaultRegistryUrl "https://...artifactory/api/npm/company-proxy-feed/" `
    -Feeds @(
        ".../api/npm/company-proxy-feed",
        ".../api/npm/dev-npm",
        ".../api/npm/dev-npm-ci",
        ".../api/npm/dev-npm-release"
    )
#>

param(
    [Parameter(Mandatory = $true)][string]$Token,
    [Parameter(Mandatory = $true)][string]$Email,
    [Parameter(Mandatory = $true)][string]$DefaultRegistryUrl,
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^[a-zA-Z0-9.-]+(/[a-zA-Z0-9.-]+)*$')]
    [string[]]$Feeds
)

npm config set email $Email
npm config set always-auth true
npm config set registry $DefaultRegistryUrl

foreach ($feed in $Feeds) {
    npm config set "//${feed}/:_authToken" $Token
}