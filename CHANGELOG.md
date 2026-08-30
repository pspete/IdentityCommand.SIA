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
  - Update an existing strong account for virtual machines or databases.

### Changed

- Module renamed from `IdentityCommand.DPA` to `IdentityCommand.SIA`, reflecting the rebrand of CyberArk Dynamic Privileged Access to CyberArk Secure Infrastructure Access.
  - All commands renamed to use the `SIA` noun prefix in place of `DPA` (e.g. `Get-DPAPolicy` is now `Get-SIAPolicy`).
  - Repository, folder structure, and help content updated to match.

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
