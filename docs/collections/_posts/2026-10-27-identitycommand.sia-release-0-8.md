---
title: "IdentityCommand.SIA Release 0.8"
date: 2026-10-27 00:00:00
version: 0.8.0
tags:
  - Release Notes
---

## [0.8.0]

### Added

- `Get-SIASession -session_id` gets a single session by id. Its `extra_info` steps list as a `key`, `status`, `label` table, and step details holding JSON are returned as objects.
