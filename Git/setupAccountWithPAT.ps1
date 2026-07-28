param(
    [Parameter(Mandatory = $true)][string]$Token,
    [Parameter(Mandatory = $true)][string]$Username
)
git credential-manager github login --username $Username --pat $Token