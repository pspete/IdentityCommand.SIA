---
title: "IdentityCommand.SIA Release 0.5"
date: 2026-09-07 00:00:00
version: 0.5.60
tags:
  - Release Notes
  - Connect-SIATenant
---

## [0.5.60]

### Changed

- The module's private helpers are now the shared implementations provided by `IdentityCommand`, rather than SIA-specific copies. `ConvertTo-SIAJsonBody`, `ConvertTo-SIASecretBody`, `Get-SIAPagedResult`, `Merge-SIAParameter`, `Resolve-SIAServiceUrl`, `Get-SIACompletionResult` and `Get-SIAArgumentCompleter` have been removed in favour of `ConvertTo-JsonBody`, `ConvertTo-SecretBody`, `Get-PagedResult`, `Merge-Parameter`, `Resolve-ServiceUrl`, `Get-CompletionResult` and `Get-ArgumentCompleter`. Query strings are now built with the shared `Add-QueryString` in place of hand-assembled `ConvertTo-QueryString` output. No change to command behaviour or output.
  - `RequiredModules` raised accordingly: `IdentityCommand` `0.6.158` or later is now required.
- `Connect-SIATenant` **(breaking)**: supplying `-Credential` (with or without `-PlatformToken`) or `-SAMLResponse` now always authenticates to CyberArk Identity and replaces any existing `IdentityCommand` session. Previously an active session took precedence and the supplied authentication parameters were ignored. Calls that supply no authentication parameters are unchanged - an existing session is still used as-is, and its absence is still an error.

### Fixed

- `IdentityCommand`'s private helpers are now loaded before this module's own files, so the argument completer registrations that run at import time can call them. Previously they were loaded afterwards.
- The module loader resolves a single `IdentityCommand` module - the highest version - when more than one version is loaded. Previously every loaded version's `Private` folder was dot-sourced, last one winning.
- Importing `IdentityCommand.SIA` without `IdentityCommand` loaded now throws a clear error instead of failing obscurely.
