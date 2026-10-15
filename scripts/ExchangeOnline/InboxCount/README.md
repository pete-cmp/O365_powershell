# Exchange Online Inbox Count and Retention Folder Scripts

Reconstructed from the Inbox Count discussion. Review and test before production use.

## Prerequisites

```powershell
Install-Module ExchangeOnlineManagement -Scope CurrentUser
Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline
```

You need appropriate Exchange Online permissions for the target mailboxes.

## Scripts

- `Get-InboxCount.ps1` — report the **exact** Inbox count (excludes Inbox subfolders) and size.
- `Compare-InboxCount.ps1` — compare the exact Inbox count against a baseline. The earlier discussion used **9,393** items; supply the baseline explicitly.
- `Find-SpecialRetentionFolders.ps1` — find folders whose names/paths match retention-related terms and optionally export results. **This is a keyword search, not a validation of retention tags or policies.**

## Examples

```powershell
./Get-InboxCount.ps1 -Identity user@example.com
./Compare-InboxCount.ps1 -Identity user@example.com -BaselineCount 9393
./Find-SpecialRetentionFolders.ps1 -Identity user1@example.com,user2@example.com -CsvPath ./SpecialRetentionFolders.csv
```

`*.csv` is ignored by the repository's .gitignore to reduce the chance of committing mailbox reporting data.

Disconnect when finished:

```powershell
Disconnect-ExchangeOnline -Confirm:$false
```
