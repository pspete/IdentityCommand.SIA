---
title: Getting Started
subtitle: Install IdentityCommand.SIA and connect to Secure Infrastructure Access
---

## Prerequisites

- Requires Powershell Core (recommended), or Windows PowerShell (version 5.1)
- A CyberArk Identity tenant with the Secure Infrastructure Access service enabled
- An Account to Access CyberArk Identity

## Install Options

Users can install IdentityCommand.SIA from GitHub or the PowerShell Gallery.

Choose any of the following ways to download the module and install it:

### Option 1: Install from PowerShell Gallery

This is the easiest and most popular way to install the module:

1. Open a PowerShell prompt

2. Run the following command:

```powershell
Install-Module -Name IdentityCommand.SIA -Scope CurrentUser
```

### Option 2: Manual Install

The module files can be manually copied to one of your PowerShell module directories.

Use the following command to get the paths to your local PowerShell module folders:

```powershell

$env:PSModulePath.split(';')

```

The module files must be placed in one of the listed directories, in a folder called `IdentityCommand.SIA`.

More: [about_PSModulePath](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_psmodulepath)

The module files are available to download using a variety of methods:

#### PowerShell Gallery

- Download from the module from the [PowerShell Gallery](https://www.powershellgallery.com/packages/IdentityCommand.SIA/):
  - Run the PowerShell command `Save-Module -Name IdentityCommand.SIA -Path C:\temp`
  - Copy the `C:\temp\IdentityCommand.SIA` folder to your "Powershell Modules" directory of choice.

#### IdentityCommand.SIA Release

- [Download the latest GitHub release](https://github.com/pspete/IdentityCommand.SIA/releases/latest)
  - Unblock & Extract the archive
  - Rename the extracted `IdentityCommand.SIA-v#.#.#` folder to `IdentityCommand.SIA`
  - Copy the `IdentityCommand.SIA` folder to your "Powershell Modules" directory of choice.

#### IdentityCommand.SIA Branch

- [Download the `main` branch](https://github.com/pspete/IdentityCommand.SIA/archive/refs/heads/main.zip)
  - Unblock & Extract the archive
  - Copy the `IdentityCommand.SIA` (`\<Archive Root>\IdentityCommand.SIA-master\IdentityCommand.SIA`) folder to your "Powershell Modules" directory of choice.

### Verification

Validate Install:

```powershell

Get-Module -ListAvailable IdentityCommand.SIA

```

Import the module:

```powershell

Import-Module IdentityCommand.SIA

```

List Module Commands:

```powershell

Get-Command -Module IdentityCommand.SIA

```

Get detailed information on specific commands:

```powershell

Get-Help Get-SIAPolicy -Full

```

## Authentication

The module requires authentication to the CyberArk Identity platform using the `IdentityCommand` module.

The `IdentityCommand` module must be installed and available in order to use `IdentityCommand.SIA`.

An overview of some of the features of the module are found in the below sections.


Authenticate with the `IdentityCommand` module, using `New-IDSession` (interactive user, including any MFA challenges) or `New-IDPlatformToken` (non-interactive service user). Commands find the SIA service url from the Identity session on first use - no separate connection step is needed:

```powershell
# Interactive user authentication
New-IDSession -tenant_url https://abc1234.id.cyberark.cloud -Credential $Credential

# Or non-interactive service user authentication via an OAuth platform token
New-IDPlatformToken -tenant_url https://abc1234.id.cyberark.cloud -Credential $ServiceUserCredential

Get-SIAConnector
```

Commands follow the current Identity session: a later `New-IDSession` or `New-IDPlatformToken` is used by the next command, and after `Close-IDSession` commands fail until you authenticate again.
