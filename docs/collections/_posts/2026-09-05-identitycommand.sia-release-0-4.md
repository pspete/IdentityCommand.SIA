---
title: "IdentityCommand.SIA Release 0.4"
date: 2026-09-05 00:00:00
version: 0.4.50
tags:
  - Release Notes
  - Get-SIAPolicy
  - Get-SIASession
  - Get-SIAStrongAccount
  - Get-SIATargetSet
  - Get-SIADatabaseStrongAccount
  - Get-SIADatabaseTarget
  - Add-SIATargetSet
  - Connect-SIATenant
  - Set-SIAPolicy
  - Remove-SIAPolicy
---

## [0.4.50]

### Added

- Automatic result pagination for `Get-SIAPolicy`, `Get-SIASession`, `Get-SIAStrongAccount`, `Get-SIATargetSet`, `Get-SIADatabaseStrongAccount` and `Get-SIADatabaseTarget` - these now transparently fetch every page instead of only the first.
- Tab-completion for id/name parameters across connector, policy, strong-account, target-set and HTTPS-relay commands.
- `Get-SIAPolicy` gained `-limit` and `-sort` list parameters.
- `Add-SIATargetSet` now supports `-WhatIf` / `-Confirm`.
- `Connect-SIATenant`: when no `IdentityCommand` session exists, authenticates to CyberArk Identity itself via new `-Credential` (interactive `New-IDSession`), `-Credential -PlatformToken` (service user `New-IDPlatformToken`) or `-SAMLResponse` parameters. The Identity url is discovered from the given subdomain / SIA url. Existing-session behaviour is unchanged. Also gained `-WhatIf` / `-Confirm`.

### Changed

- `Get-SIAStrongAccount` **(breaking)**: `-offset` removed - the command now pages results internally.
- `Get-SIATargetSet` **(breaking)**: `-b64StartKey` removed - the command now pages results internally.
- `Get-SIADatabaseStrongAccount`, `Get-SIADatabaseTarget` **(breaking)**: `-cursor` removed - the commands now page results internally.
- `Set-SIAPolicy`: `-policyId` parameter renamed `-policyid` for consistency with `Get-SIAPolicy` / `Remove-SIAPolicy`.
