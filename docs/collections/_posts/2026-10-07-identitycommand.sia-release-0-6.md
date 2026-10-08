---
title: "IdentityCommand.SIA Release 0.6"
date: 2026-10-07 00:00:00
version: 0.6.67
tags:
  - Release Notes
  - Get-SIAVirtualMachine
  - Remove-SIAVirtualMachine
---

## [0.6.67]

### Added

- `Get-SIAVirtualMachine`: get details of VM infrastructure targets, with `-filter`, `-source`,
  `-sort` and `-search`. Results are paginated automatically.
- `Remove-SIAVirtualMachine`: delete a VM infrastructure target by machine ID.

### Changed

- The module loader copies `IdentityCommand`'s private helper functions from the loaded module's session state instead of dot-sourcing its `Private` folder, so it works with both the current `IdentityCommand` layout and the combined single-file layout of future releases. Each copied helper runs in this module's scope and uses its session.
