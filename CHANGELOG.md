# Change Log

All notable changes to this project will be documented in this file.

## [unreleased]

### Security

- Secret-bearing request bodies (`New-SIAStrongAccount`, `Set-SIAStrongAccount`, `New-SIADatabaseStrongAccount`, `Set-SIADatabaseStrongAccount`) are now sent to `Invoke-IDRestMethod` as UTF8 bytes instead of a JSON string, so the plaintext password / secret cannot be captured by Windows PowerShell ParameterBinding / Module Logging. Mirrors [pspete/psPAS#602](https://github.com/pspete/psPAS/issues/602) / [pspete/psPAS#627](https://github.com/pspete/psPAS/pull/627). A static regression guard test was added to `IdentityCommand.SIA.Tests.ps1`.

## 0.3.X

### Added

- `Get-SIASSHHostKeyFingerprint`, `Add-SIASSHHostKeyFingerprint`, `Set-SIASSHHostKeyFingerprint`, `Remove-SIASSHHostKeyFingerprint`
  - Manage SSH host key fingerprints for targets.
- `Invoke-SIASSHPublicKeyRotation`
  - Generate a new SSH CA public key version, or deactivate / reactivate the previous version.
- `Get-SIAMFAKey`
  - Retrieve the SIA MFA key (openssh or ppk format) used for SSH authentication, returned as text.
- `Remove-SIAConnector`, `Test-SIAConnector`, `Update-SIAConnector`, `Set-SIAConnectorMaintenanceMode`, `Add-SIAConnectorPoolMember`, `Invoke-SIAConnectorCertificateRotation`
  - Delete, test reachability of, upgrade, set maintenance mode on, assign to pools, and rotate the certificate of connectors.
- `Get-SIAHttpsRelay`, `Remove-SIAHttpsRelay`, `Update-SIAHttpsRelay`, `Get-SIAHttpsRelaySetupScript`, `Invoke-SIAHttpsRelayCertificateRotation`
  - Manage SIA HTTPS relays, generate relay installation scripts, and rotate relay certificates.
- `Set-SIAStrongAccount`
  - Update an existing virtual machine strong account.
- `Get-SIADatabaseStrongAccount`, `New-SIADatabaseStrongAccount`, `Set-SIADatabaseStrongAccount`, `Remove-SIADatabaseStrongAccount`
  - Manage database strong accounts via the `/api/database-strong-accounts` API (`store_type` / `account_properties` / `password_secret_object` body), supporting PAM accounts and managed accounts for PostgreSQL, MySQL, MariaDB, MSSql, Oracle, MongoDB, DB2UnixSSH, WinDomain and AWSAccessKeys platforms.
- `Get-SIADatabaseTarget`
  - Lists the database targets configured in SIA (`GET /api/database-targets`).

### Changed

- Module renamed from `IdentityCommand.DPA` to `IdentityCommand.SIA`, reflecting the rebrand of CyberArk Dynamic Privileged Access to CyberArk Secure Infrastructure Access.
  - All commands renamed to use the `SIA` noun prefix in place of `DPA` (e.g. `Get-DPAPolicy` is now `Get-SIAPolicy`).
  - Repository, folder structure, and help content updated to match.
- `Get-SIAStrongAccount`, `New-SIAStrongAccount`, `Remove-SIAStrongAccount` **(breaking)**
  - The `-database` / `-databases` switches have been removed - database strong accounts are now managed with the dedicated `*-SIADatabaseStrongAccount` commands. These commands now only manage virtual machine strong accounts (`/api/secrets`).
  - `New-SIAStrongAccount` parameter sets renamed `StoredInDPA-VM` -> `StoredInSIA` and `VaultedInPrivilegeCloud-VM` -> `VaultedInPrivilegeCloud`.
  - `New-SIAStrongAccount` / `Set-SIAStrongAccount` gained optional `-enable_bulk_elevation` and `-ephemeral_domain_user_data` parameters.
  - `Get-SIAStrongAccount` gained `-count` and `-offset` list parameters.
- `Add-SIATargetSet` / `Get-SIATargetSet` / `Remove-SIATargetSet`
  - Target set endpoints moved from `/api/discovery/targetsets` to `/api/targetsets`.
- `Get-SIAConnectorSetupScript` **(breaking)**
  - Removed the `-connector_type` parameter - it is not part of the `POST /api/connectors/setup-script` request body.
  - Added optional `-expiration_minutes` (15 - 240), `-proxy_host`, `-proxy_port` and `-windows_installation_path` parameters.
- `Get-SIASetting` / `Set-SIASetting`
  - `-FeatureName` (Get) and the feature switches (Set) now cover all settings features exposed by SIA, including `rdpTokenMfaCaching`, `rdpTranscription`, `sshRecording`, `logonSequence`, `selfHostedPam`, `connectViaBrowser`, `rdpFileSigning`, `rdpKerberosAuthMode`, `rdpChannels`, `validateFingerprintForSshZeroStanding`, `httpsRelay`, `rdpFileParameters`, `granularEnabled`, `oracleOud` and `oracleConnectionProtocol`.
  - `Set-SIASetting` now performs a true partial update - only the supplied sub-settings are sent (`PATCH /api/settings/`), instead of reading and re-sending the full configuration.
  - `Set-SIASetting` validates `-keyExpirationTimeSec` (300 - 43200 seconds), `-sessionMaxDuration` (60 - 1440 minutes), `-sessionIdleTime` (1 - 120 minutes), `-logonSequenceValue` (up to 30000 characters) and `-shellPromptForAudit` (up to 1024 characters).

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
