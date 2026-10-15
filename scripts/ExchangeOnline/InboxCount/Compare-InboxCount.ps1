#Requires -Version 5.1
<#
.SYNOPSIS
    Compares the current exact Inbox item count with a known baseline.
.EXAMPLE
    ./Compare-InboxCount.ps1 -Identity user@example.com -BaselineCount 9393
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Identity,
    [Parameter(Mandatory)]
    [ValidateRange(0, 2147483647)]
    [int]$BaselineCount
)
$ErrorActionPreference = 'Stop'
if (-not (Get-Command Get-EXOMailboxFolderStatistics -ErrorAction SilentlyContinue)) {
    throw 'Connect to Exchange Online first using Connect-ExchangeOnline.'
}
$inbox = Get-EXOMailboxFolderStatistics -Identity $Identity -FolderScope Inbox |
    Where-Object { $_.FolderPath -eq '/Inbox' } |
    Select-Object -First 1
if (-not $inbox) { throw "Could not find the Inbox folder for $Identity." }
$current = [int]$inbox.ItemsInFolder
[pscustomobject]@{
    Mailbox       = $Identity
    BaselineCount = $BaselineCount
    CurrentCount  = $current
    Difference    = $current - $BaselineCount
    CheckedAt     = Get-Date
}
