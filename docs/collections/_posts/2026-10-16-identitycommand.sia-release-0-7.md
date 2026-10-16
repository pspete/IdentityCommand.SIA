---
title: "IdentityCommand.SIA Release 0.7"
date: 2026-10-16 00:00:00
version: 0.7.0
tags:
  - Release Notes
---

## [0.7.0]

### Added

- Commands find the Secure Infrastructure Access service url from the `IdentityCommand` session on first use, so no connection step is needed after `New-IDSession` or `New-IDPlatformToken`. Commands follow a later `New-IDSession` or `New-IDPlatformToken`, and fail after `Close-IDSession` until you authenticate again.

### Changed

- Requires `IdentityCommand` 1.0.1.
- A request refused with 401 because the session token has expired reports `Session expired at <time>:
  authenticate again with New-IDSession or New-IDPlatformToken`. Previously, it reported `Unauthorized. Unauthorized.`.
- CI caches the PowerShell modules it installs, so dependency installs skip the PowerShell Gallery on a cache hit.

### Removed

- `Connect-SIATenant`. Authenticate with `New-IDSession` or `New-IDPlatformToken` from `IdentityCommand` instead.
