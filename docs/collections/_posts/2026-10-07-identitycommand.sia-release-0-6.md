---
title: "IdentityCommand.SIA Release 0.6"
date: 2026-10-08 00:00:00
version: 0.6.68
tags:
  - Release Notes
  - Get-SIAVirtualMachine
  - Remove-SIAVirtualMachine
  - New-SIAPolicyProviderDefinition
---

## [0.6.68]

### Changed

- Moved to the pspete.Build GitHub Actions pipeline; AppVeyor is retired.
- Requires IdentityCommand 0.7.159 or later.
- Argument completer registrations run from the module psm1, after IdentityCommand's helpers are copied in.

### Fixed

- `New-SIAPolicyProviderDefinition` help: `-vnetIds` now has a description, and `-vpcIds` describes AWS/GCP VPC IDs instead of Azure VNet IDs.

## [0.6.67]

### Added

- `Get-SIAVirtualMachine`: get details of VM infrastructure targets, with `-filter`, `-source`,
  `-sort` and `-search`. Results are paginated automatically.
- `Remove-SIAVirtualMachine`: delete a VM infrastructure target by machine ID.

### Changed

- The module loader copies `IdentityCommand`'s private helper functions from the loaded module's session state instead of dot-sourcing its `Private` folder, so it works with both the current `IdentityCommand` layout and the combined single-file layout of future releases. Each copied helper runs in this module's scope and uses its session.
