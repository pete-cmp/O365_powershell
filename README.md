# Microsoft 365 PowerShell Administration

A starter collection of PowerShell scripts for Microsoft 365 administration using the Microsoft Graph PowerShell SDK.

## Requirements

- PowerShell 7.2 or later recommended
- Microsoft Graph PowerShell SDK
- An account authorized to perform the requested Microsoft Graph operations

## Getting started

1. Install the SDK in your PowerShell session:

   ```powershell
   Install-Module Microsoft.Graph -Scope CurrentUser
   ```

2. Run the connection script:

   ```powershell
   ./scripts/Connect-M365Graph.ps1
   ```

3. Sign in interactively when prompted. The example requests `User.Read` only. Other scripts may require additional delegated permissions and admin consent.

4. Disconnect when finished:

   ```powershell
   Disconnect-MgGraph
   ```

## Structure

- `scripts/Connect-M365Graph.ps1`: Interactive Microsoft Graph connection and basic context display.
- `docs/`: Notes and future administration examples.

## Security

Never commit passwords, access tokens, certificates, private keys, tenant secrets, or exported user data. Review scopes before granting consent. Use least-privilege permissions and test changes in a non-production tenant first.

## Disclaimer

These are educational administration examples. Review scripts and permissions before running them in a production environment.
