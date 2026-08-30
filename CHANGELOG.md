# Change Log

All notable changes to this project will be documented in this file.

## [unreleased]

## 0.3.X

### Added

- `Get-SIASSHHostKeyFingerprint`, `Add-SIASSHHostKeyFingerprint`, `Set-SIASSHHostKeyFingerprint`, `Remove-SIASSHHostKeyFingerprint`
  - Manage SSH host key fingerprints for targets.
- `Invoke-SIASSHPublicKeyRotation`
  - Generate a new SSH CA public key version, or deactivate / reactivate the previous version.
- `Get-SIAMFAKey`
  - Retrieve the SIA MFA key (openssh or ppk format) used for SSH authentication.
- `Remove-SIAConnector`, `Test-SIAConnector`, `Update-SIAConnector`, `Set-SIAConnectorMaintenanceMode`, `Add-SIAConnectorPoolMember`, `Invoke-SIAConnectorCertificateRotation`
  - Delete, test reachability of, upgrade, set maintenance mode on, assign to pools, and rotate the certificate of connectors.
- `Get-SIAHttpsRelay`, `Remove-SIAHttpsRelay`, `Update-SIAHttpsRelay`, `Get-SIAHttpsRelaySetupScript`, `Invoke-SIAHttpsRelayCertificateRotation`
  - Manage SIA HTTPS relays, generate relay installation scripts, and rotate relay certificates.
- `Set-SIAStrongAccount`
  - Update an existing virtual machine strong account.
- `Get-SIADatabaseStrongAccount`, `New-SIADatabaseStrongAccount`, `Set-SIADatabaseStrongAccount`, `Remove-SIADatabaseStrongAccount`
  - Manage database strong accounts via the `/api/database-strong-accounts` API (`store_type` / `account_properties` / `password_secret_object` body), supporting PAM accounts and managed accounts for PostgreSQL, MySQL, MariaDB, MSSql, Oracle, MongoDB, DB2UnixSSH, WinDomain and AWSAccessKeys platforms.

### Changed

- Module renamed from `IdentityCommand.DPA` to `IdentityCommand.SIA`, reflecting the rebrand of CyberArk Dynamic Privileged Access to CyberArk Secure Infrastructure Access.
  - All commands renamed to use the `SIA` noun prefix in place of `DPA` (e.g. `Get-DPAPolicy` is now `Get-SIAPolicy`).
  - Repository, folder structure, and help content updated to match.
- `Get-SIAStrongAccount`, `New-SIAStrongAccount`, `Remove-SIAStrongAccount`, `Set-SIAStrongAccount` **(breaking)**
  - Now use the `/api/secrets/public/v1` endpoint (previously `/api/secrets`), matching the current SIA strong accounts API.
  - The `-database` / `-databases` switches have been removed - database strong accounts are now managed with the dedicated `*-SIADatabaseStrongAccount` commands.
  - `New-SIAStrongAccount` parameter sets renamed `StoredInDPA-VM` -> `StoredInSIA` and `VaultedInPrivilegeCloud-VM` -> `VaultedInPrivilegeCloud`.
- `Add-SIATargetSet` **(breaking)**
  - Now uses the bulk target sets endpoint and requires a `-strong_account_id` parameter to map the target set to a strong account.
  - `-secret_type` now accepts `EphemeralUser`.
  - Fixed `-provision_format` handling - the default is now applied only when the parameter is omitted (previously it overwrote a supplied value).
- `Get-SIATargetSet` **(breaking)**
  - `-strongAccountId` is now mandatory, as required by the target sets API.
- `Remove-SIATargetSet`
  - Always uses the bulk delete endpoint, including for a single target set name.
- `Get-SIAPolicy`
  - The policy list now uses `GET /api/access-policies` (no trailing slash) and accepts `-filter`, `-limit`, `-offset` and `-sort` parameters. Retrieving a single policy still uses `-policyid`.
- `New-SIAPolicy` / `Set-SIAPolicy`
  - Send `policyType: "VM"` in the request body, as required by the current access policies API.
  - `-status` now also accepts `Irrelevant`; `-description` now accepts an empty string.

### Fixed

- `Get-SIACertificate`
  - Updated to return correct property of output value.
- `Get-SIAResource`
  - Updated to return correct property of output value.

## 0.2.11 - 05-03-2024

### Added

- N/A

### Changed

- `Connect-DPATarget`
  - Updated to save RDP file and automatically invoke rdp connection via DPA
  - Updated to calculate ssh connection string and automatically invoke ssh connection

### Fixed

- N/A

## 0.1.10 - 03-03-2024

### Added

- N/A

### Changed

- Published to PowerShell Gallery

### Fixed

- N/A

## 0.1.9 - 03-03-2024

Initial release of `IdentityCommand.DPA` module

### Added

- `Add-DPATargetSet`
- `Connect-DPATenant`
- `Connect-DPATarget`
- `Get-DPACertificate`
- `Get-DPAConnector`
- `Get-DPAConnectorSetupScript`
- `Get-DPAPolicy`
- `Get-DPAModuleData`
- `Get-DPASetting`
- `Get-DPASession`
- `Get-DPASSHPublicKey`
- `Get-DPAStrongAccount`
- `Get-DPATargetSet`
- `New-DPAPolicy`
- `New-DPAPolicyConnectAsDefinition`
- `New-DPAPolicyFQDNRuleDefinition`
- `New-DPAPolicyProviderDefinition`
- `New-DPAPolicyUserAccessRuleDefinition`
- `New-DPAPolicyUserDataDefinition`
- `New-DPAStrongAccount`
- `Remove-DPAPolicy`
- `Remove-DPAStrongAccount`
- `Remove-DPATargetSet`
- `Set-DPAPolicy`
- `Set-DPASetting`
