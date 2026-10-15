#Requires -Version 5.1
<#
.SYNOPSIS
    Reports the exact Inbox item count and folder size for an Exchange Online mailbox.
.EXAMPLE
    ./Get-InboxCount.ps1 -Identity user@example.com
.NOTES
    Requires ExchangeOnlineManagement and an existing Connect-ExchangeOnline session.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Identity
)
$ErrorActionPreference = 'Stop'
if (-not (Get-Command Get-EXOMailboxFolderStatistics -ErrorAction SilentlyContinue)) {
    throw 'Get-EXOMailboxFolderStatistics is unavailable. Install/import ExchangeOnlineManagement and run Connect-ExchangeOnline.'
}
$inbox = Get-EXOMailboxFolderStatistics -Identity $Identity -FolderScope Inbox |
    Where-Object { $_.FolderPath -eq '/Inbox' } |
    Select-Object -First 1
if (-not $inbox) { throw "Could not find the Inbox folder for $Identity." }
[pscustomobject]@{
    Mailbox       = $Identity
    Name          = $inbox.Name
    FolderPath    = $inbox.FolderPath
    ItemsInFolder = $inbox.ItemsInFolder
    FolderSize    = $inbox.FolderSize
}
