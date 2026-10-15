#Requires -Version 5.1
<#
.SYNOPSIS
    Connects interactively to Microsoft Graph with a minimal delegated scope.
.DESCRIPTION
    Checks that Microsoft.Graph.Authentication is available, prompts for sign-in,
    and displays the current Microsoft Graph context.
.EXAMPLE
    ./Connect-M365Graph.ps1
#>
[CmdletBinding()]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string[]]$Scopes = @('User.Read')
)

$ErrorActionPreference = 'Stop'

if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Authentication)) {
    throw 'Microsoft.Graph.Authentication is not installed. Run: Install-Module Microsoft.Graph -Scope CurrentUser'
}

Import-Module Microsoft.Graph.Authentication
Connect-MgGraph -Scopes $Scopes -NoWelcome

$context = Get-MgContext
if (-not $context) {
    throw 'Microsoft Graph connection could not be verified.'
}

[pscustomobject]@{
    Account  = $context.Account
    TenantId = $context.TenantId
    Scopes   = ($context.Scopes -join ', ')
} | Format-List
