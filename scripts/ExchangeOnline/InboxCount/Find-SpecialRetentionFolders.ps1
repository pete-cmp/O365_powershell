#Requires -Version 5.1
<#
.SYNOPSIS
    Searches Exchange Online mailbox folders for retention-related keywords.
.DESCRIPTION
    Reports matching folder names and paths. This does not determine actual retention
    policy assignments or tags; inspect policy properties separately.
.EXAMPLE
    ./Find-SpecialRetentionFolders.ps1 -Identity user1@example.com,user2@example.com -CsvPath ./SpecialRetentionFolders.csv
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string[]]$Identity,
    [string]$CsvPath,
    [string[]]$Keywords = @(
        'Finance', 'Personnel', 'Audits', 'OSHA', 'Incident Reports',
        'Key Long Term Historic Ref', 'HIPAA', 'Billing', 'QA'
    )
)
$ErrorActionPreference = 'Stop'
if (-not (Get-Command Get-EXOMailboxFolderStatistics -ErrorAction SilentlyContinue)) {
    throw 'Connect to Exchange Online first using Connect-ExchangeOnline.'
}
$matches = @(
    foreach ($mailbox in $Identity) {
        $folders = Get-EXOMailboxFolderStatistics -Identity $mailbox
        foreach ($folder in $folders) {
            $matched = @($Keywords | Where-Object {
                $folder.Name.IndexOf($_, [System.StringComparison]::OrdinalIgnoreCase) -ge 0 -or
                $folder.FolderPath.IndexOf($_, [System.StringComparison]::OrdinalIgnoreCase) -ge 0
            })
            if ($matched.Count -gt 0) {
                [pscustomobject]@{
                    Mailbox       = $mailbox
                    FolderName    = $folder.Name
                    FolderPath    = $folder.FolderPath
                    ItemsInFolder = $folder.ItemsInFolder
                    MatchedTerms  = ($matched -join '; ')
                }
            }
        }
    }
)
if ($CsvPath) {
    $matches | Export-Csv -Path $CsvPath -NoTypeInformation -Encoding UTF8
}
$matches
