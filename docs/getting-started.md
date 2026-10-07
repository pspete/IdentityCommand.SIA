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


The `Connect-SIATenant` command initialises the bearer token used for module operations against the SIA service.

If an Identity session already exists (established with the `IdentityCommand` module's `New-IDSession` or `New-IDPlatformToken`), it is used as-is:

```powershell
# Resolve the SIA API url automatically from the shared services subdomain
Connect-SIATenant -tenant_subdomain sometenant

# Or provide the SIA tenant url directly
Connect-SIATenant -tenant_url https://sometenant.dpa.cyberark.cloud
```

Otherwise, provide a credential and `Connect-SIATenant` authenticates to CyberArk Identity for you - the Identity tenant url is discovered from the same subdomain / url:

```powershell
# Interactive user authentication (any MFA challenges are handled by IdentityCommand)
Connect-SIATenant -tenant_subdomain sometenant -Credential $Credential

# Non-interactive service user authentication via an OAuth platform token
Connect-SIATenant -tenant_subdomain sometenant -Credential $ServiceUserCredential -PlatformToken
```

