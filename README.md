![Logo][Logo]

[Logo]: /docs/media/images/IdentityCommand.SIA.png

# IdentityCommand.SIA

**IdentityCommand.SIA** is a PowerShell module that provides a set of easy-to-use commands, allowing you to interact with the API for a **CyberArk Secure Infrastructure Access** from within the PowerShell environment.

| Main Branch              | Latest Build             | CodeFactor                 | Coverage                     | PowerShell Gallery        | License                      |
| ------------------------ | ------------------------ | -------------------------- | ---------------------------- | ------------------------- | ---------------------------- |
| [![appveyor][]][av-site] | [![tests][]][tests-site] | [![codefactor][]][cf-site] | [![codecov][]][codecov-link] | [![psgallery][]][ps-site] | [![license][]][license-link] |

[appveyor]: https://ci.appveyor.com/api/projects/status/q2av77njofnsul92/branch/main?svg=true
[av-site]: https://ci.appveyor.com/project/pspete/IdentityCommand-SIA/branch/main
[psgallery]: https://img.shields.io/powershellgallery/v/IdentityCommand.SIA.svg
[ps-site]: https://www.powershellgallery.com/packages/IdentityCommand.SIA
[tests]: https://img.shields.io/appveyor/tests/pspete/IdentityCommand-SIA.svg
[tests-site]: https://ci.appveyor.com/project/pspete/IdentityCommand-SIA
[downloads]: https://img.shields.io/powershellgallery/dt/IdentityCommand.SIA.svg?color=blue
[cf-site]: https://www.codefactor.io/repository/github/pspete/IdentityCommand.SIA
[codefactor]: https://www.codefactor.io/repository/github/pspete/IdentityCommand.SIA/badge
[codecov]: https://codecov.io/gh/pspete/IdentityCommand.SIA/branch/main/graph/badge.svg
[codecov-link]: https://codecov.io/gh/pspete/IdentityCommand.SIA
[license]: https://img.shields.io/github/license/pspete/IdentityCommand.SIA.svg
[license-link]: https://github.com/pspete/IdentityCommand.SIA/blob/main/LICENSE

## Using the Module

The module requires authentication to the CyberArk Identity platform using the `IdentityCommand` module.

The `IdentityCommand` module must be installed and available in order to use `IdentityCommand.SIA`.

An overview of some of the features of the module are found in the below sections.

### SIA Authentication

After authentication to an Identity tenant using the `IdentityCommand` module, the `Connect-SIATenant` command is used to initialise a bearer token to be used for module operations against the SIA service:

```powershell
# Resolve the SIA API url automatically from the shared services subdomain
Connect-SIATenant -tenant_subdomain sometenant

# Or provide the SIA tenant url directly
Connect-SIATenant -tenant_url https://sometenant.dpa.cyberark.cloud
```

### SIA Connections

The `Connect-SIATarget` command can be use to initiate SIA connections to targets.

#### SSH

SSH connections to targets using the SIA zero standing privilege method can be achieved with the following example:

```powershell
Connect-SIATarget -SSH -targetAddress someserver.somedomain.com
```

SSH connections to targets using vaulted credentials follow a similar pattern:

```powershell
Connect-SIATarget -SSH -targetAddress sometarget.somedomain.com -targetUser someuser -targetDomain somedomain
```

For SSH connections to succeed, an SSH client must be available from the terminal in which the command is being executed.

#### RDP

`Connect-SIATarget` can also request RDP files which can be used to connected through he SIA gateway, the following example facilitates a zero standing privilege RDP connection:

```powershell
Connect-SIATarget -RDP -targetAddress someserver.somedomain.com
```

Vaulted credentials can also be used for RDP connections, as shown in the below example:

```powershell
Connect-SIATarget -RDP -targetAddress sometarget.somedomain.com -targetUser someuser -targetDomain somedomain
```

### SIA Policies

SIA recurring access policies can be created after defining PowerShell objects to help create the policy configuration.

A number of helper functions are included in the module which can be used to provide the required data to the `New-SIAPolicy` command.

A complete example to create a new policy follows:

```powershell
#Create ConnectAs definitions for the policy userAccessRules
$ConnectAs1 = New-SIAPolicyConnectAsDefinition -OnPrem -assignGroups Administrators
$ConnectAs1 = New-SIAPolicyConnectAsDefinition -AWS -ssh "ec2-user" -assignGroups Administrators, "Remote Desktop Users" -connectAsDefinition $ConnectAs1
$ConnectAs2 = New-SIAPolicyConnectAsDefinition -Azure -ssh "azureuser" -connectAsDefinition $ConnectAs1
$ConnectAs2 = New-SIAPolicyConnectAsDefinition -GCP -ssh "root" -connectAsDefinition $ConnectAs2

#Create User Data definitions for the policy user AccessRules
$UserData1 = New-SIAPolicyUserDataDefinition -Role -name "DEV_TEAM_ROLE"
$UserData1 = New-SIAPolicyUserDataDefinition -Role -name "SOME_TEAM_ROLE" -UserDataDefinition $UserData1
$UserData1 = New-SIAPolicyUserDataDefinition -Group -name "DEV_TEAM_GROUP" -UserDataDefinition $UserData1
$UserData2 = New-SIAPolicyUserDataDefinition -Group -name "SOME_TEAM_GROUP" -UserDataDefinition $UserData1
$UserData2 = New-SIAPolicyUserDataDefinition -User -name SomeUser -UserDataDefinition $UserData2
$UserData2 = New-SIAPolicyUserDataDefinition -User -name SomeOtherUser -UserDataDefinition $UserData2

#Create AccessRules definitions for the policy using the ConnectAs & User Data definitions
$AccessRules = @()
$AccessRules += New-SIAPolicyUserAccessRuleDefinition -ruleName SomeAccessRule -userData $UserData1 -connectAs $ConnectAs1 -timeZone Europe/London
$AccessRules += New-SIAPolicyUserAccessRuleDefinition -ruleName AnotherAccessRule -userData $UserData2 -connectAs $ConnectAs2 -timeZone America/Costa_Rica

#Define FQDN Rules for connections to On-Prem resources
$FQDNrules = @()
$FQDNrules += New-SIAPolicyFQDNRuleDefinition -operator EXACTLY -computernamePattern SomeHost -domain SomeDomain.com
$FQDNrules += New-SIAPolicyFQDNRuleDefinition -operator WILDCARD -computernamePattern *-DEV-* -domain SomeDomain.com
$FQDNrules += New-SIAPolicyFQDNRuleDefinition -operator SUFFIX -computernamePattern '-Prod' -domain SomeDomain.com
$FQDNrules += New-SIAPolicyFQDNRuleDefinition -operator CONTAINS -computernamePattern SQL -domain SomeDomain.com
$FQDNrules += New-SIAPolicyFQDNRuleDefinition -operator PREFIX -computernamePattern DC1 -domain SomeDomain.com

#Create Provider definitions for connections to on-prem and cloud resources
$Providers = New-SIAPolicyProviderDefinition -OnPrem -fqdnRulesConjunction OR -fqdnRules $FQDNrules
$Providers = New-SIAPolicyProviderDefinition -AWS -regions "us-east-1","us-east-2" -tags @{"Key"="env";"Value"=@("prod")} -ProviderDefinition $Providers
$Providers = New-SIAPolicyProviderDefinition -Azure -regions "eastus2","eastus" -tags @{"Key"="env";"Value"=@("prod")} -ProviderDefinition $Providers
$Providers = New-SIAPolicyProviderDefinition -GCP -regions "asia-east1","us-east1" -labels @{"Key"="env";"Value"=@("prod")} -ProviderDefinition $Providers

#Create the new SIA Policy using the Provider and Access Rule definitions previously created
New-SIAPolicy -policyName SomePolicy -status Enabled -description "Some Description" -providersData $Providers -userAccessRules $AccessRules
```

Running the code above creates a complete policy with settings according to the parameter values.

### Module Scope Variables & Command Invocation Data

The `Get-SIAModuleData` command can be used to return data from the module scope:

```powershell
PS C:\> Get-SIAModuleData

Name                           Value
----                           -----
tenant_url                     https://abc1234.dpa.cyberark.cloud
User                           some.user@somedomain.com
TenantId
SessionId
WebSession                     Microsoft.PowerShell.Commands.WebRequestSession
StartTime                      12/02/2024 22:58:13
ElapsedTime                    00:25:30
LastCommand                    System.Management.Automation.InvocationInfo
LastCommandTime                12/02/2024 23:23:07
LastCommandResults             {"success":true,"Result":{"SomeResult"}}
```

Executing this command exports variables like the URL, Username & WebSession object for the authenticated session from IdentityCommand.SIA into your local scope, either for use in other requests outside of the module scope, or for informational purposes.

Return data also includes details such as session start time, elapsed time, last command time, as well as data for the last invoked command and the results of the previous command.

## List Of Commands

The examples provided above are not exhaustive, further commands enabling configuration and administration of the SIA platform are available in the module.

The full list of commands currently available in the _`IdentityCommand.SIA`_ module are detailed here:

| Function                                  | Description                                                                    |
| ----------------------------------------- | ------------------------------------------------------------------------------ |
| `Connect-SIATenant`                       | Obtains a Bearer token from an authenticated `IdentityCommand` session for SIA |
| `Connect-SIATarget`                       | Connect via RDP or SSH to SIA targets                                          |
| `Add-SIATargetSet`                        | Adds a SIA Target Set                                                          |
| `Get-SIACertificate`                      | Get details of SIA certificates                                                |
| `Get-SIAConnector`                        | Get details of SIA connectors                                                  |
| `Get-SIAConnectorSetupScript`             | Gets setup scripts for SIA connectors                                          |
| `Get-SIAPolicy`                           | Gets configured SIA policies                                                   |
| `Get-SIAModuleData`                       | Outputs data relating to the `IdentityCommand.SIA` module session              |
| `Get-SIASetting`                          | Get SIA settings                                                               |
| `Get-SIASession`                          | Get SIA session diagnostic event data                                          |
| `Get-SIASSHPublicKey`                     | Get SIA SSH Public Keys                                                        |
| `Get-SIAStrongAccount`                    | Get virtual machine strong accounts                                            |
| `Get-SIATargetSet`                        | Get details of configured target sets                                          |
| `Get-SIAResource`                         | Get details of configured resources                                            |
| `New-SIAPolicy`                           | Configures a new SIA recurring access policy                                   |
| `New-SIAPolicyConnectAsDefinition`        | Defines ConnectAs profile for SIA policy                                       |
| `New-SIAPolicyFQDNRuleDefinition`         | Defines FQDN Rules for SIA Policy                                              |
| `New-SIAPolicyProviderDefinition`         | Defines Providers for SIA Policy                                               |
| `New-SIAPolicyUserAccessRuleDefinition`   | Defines user access rules for SIA Policy                                       |
| `New-SIAPolicyUserDataDefinition`         | Defines user data for SIA Policy                                               |
| `New-SIAStrongAccount`                    | Creates a virtual machine strong account in SIA                                |
| `Remove-SIAPolicy`                        | Deletes a SIA policy                                                           |
| `Remove-SIAStrongAccount`                 | Deletes a virtual machine strong account in SIA                                |
| `Remove-SIATargetSet`                     | Deletes a SIA target set                                                       |
| `Set-SIAPolicy`                           | Updates a SIA policy                                                           |
| `Set-SIASetting`                          | Update SIA settings                                                            |
| `Set-SIAStrongAccount`                    | Updates a virtual machine strong account in SIA                                |
| `Get-SIADatabaseStrongAccount`            | Get SIA database strong accounts                                               |
| `New-SIADatabaseStrongAccount`            | Creates a SIA database strong account                                          |
| `Set-SIADatabaseStrongAccount`            | Updates a SIA database strong account                                          |
| `Remove-SIADatabaseStrongAccount`         | Deletes a SIA database strong account                                          |
| `Get-SIADatabaseTarget`                   | Get SIA database targets                                                       |
| `Get-SIASSHHostKeyFingerprint`            | Get a stored SSH host key fingerprint                                          |
| `Add-SIASSHHostKeyFingerprint`            | Add an SSH host key fingerprint                                                |
| `Set-SIASSHHostKeyFingerprint`            | Update an SSH host key fingerprint                                             |
| `Remove-SIASSHHostKeyFingerprint`         | Delete an SSH host key fingerprint                                             |
| `Invoke-SIASSHPublicKeyRotation`          | Rotate, deactivate or reactivate the SSH CA public key                         |
| `Get-SIAMFAKey`                           | Get the SIA MFA key for SSH authentication                                     |
| `Remove-SIAConnector`                     | Deletes a SIA connector                                                        |
| `Test-SIAConnector`                       | Test SIA connector reachability                                                |
| `Update-SIAConnector`                     | Upgrade a SIA connector                                                        |
| `Set-SIAConnectorMaintenanceMode`         | Set the maintenance mode of a SIA connector                                    |
| `Add-SIAConnectorPoolMember`              | Assign connectors to a SIA connector pool                                      |
| `Invoke-SIAConnectorCertificateRotation`  | Rotate a SIA connector certificate                                             |
| `Get-SIAHttpsRelay`                       | Get SIA HTTPS relays                                                           |
| `Remove-SIAHttpsRelay`                    | Deletes a SIA HTTPS relay                                                      |
| `Update-SIAHttpsRelay`                    | Upgrade a SIA HTTPS relay                                                      |
| `Get-SIAHttpsRelaySetupScript`            | Get a SIA HTTPS relay setup script                                             |
| `Invoke-SIAHttpsRelayCertificateRotation` | Rotate a SIA HTTPS relay certificate                                           |

## Installation

### Prerequisites

- Requires Powershell Core (recommended), or Windows PowerShell (version 5.1)
- A CyberArk Identity tenant with the Secure Infrastructure Access service enabled
- An Account to Access CyberArk Identity

### Install Options

Users can install IdentityCommand.SIA from GitHub or the PowerShell Gallery.

Choose any of the following ways to download the module and install it:

#### Option 1: Install from PowerShell Gallery

This is the easiest and most popular way to install the module:

1. Open a PowerShell prompt

2. Run the following command:

```powershell
Install-Module -Name IdentityCommand.SIA -Scope CurrentUser
```

#### Option 2: Manual Install

The module files can be manually copied to one of your PowerShell module directories.

Use the following command to get the paths to your local PowerShell module folders:

```powershell

$env:PSModulePath.split(';')

```

The module files must be placed in one of the listed directories, in a folder called `IdentityCommand.SIA`.

More: [about_PSModulePath](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_psmodulepath)

The module files are available to download using a variety of methods:

##### PowerShell Gallery

- Download from the module from the [PowerShell Gallery](https://www.powershellgallery.com/packages/IdentityCommand.SIA/):
  - Run the PowerShell command `Save-Module -Name IdentityCommand.SIA -Path C:\temp`
  - Copy the `C:\temp\IdentityCommand.SIA` folder to your "Powershell Modules" directory of choice.

##### IdentityCommand.SIA Release

- [Download the latest GitHub release](https://github.com/pspete/IdentityCommand.SIA/releases/latest)
  - Unblock & Extract the archive
  - Rename the extracted `IdentityCommand.SIA-v#.#.#` folder to `IdentityCommand.SIA`
  - Copy the `IdentityCommand.SIA` folder to your "Powershell Modules" directory of choice.

##### IdentityCommand.SIA Branch

- [Download the `main` branch](https://github.com/pspete/IdentityCommand.SIA/archive/refs/heads/main.zip)
  - Unblock & Extract the archive
  - Copy the `IdentityCommand.SIA` (`\<Archive Root>\IdentityCommand.SIA-master\IdentityCommand.SIA`) folder to your "Powershell Modules" directory of choice.

#### Verification

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

Get-Help New-IDSession -Full

```

## Sponsorship

Please support continued development; consider sponsoring <a href="https://github.com/sponsors/pspete"> @pspete on GitHub Sponsors</a>

## Changelog

All notable changes to this project will be documented in the [Changelog](CHANGELOG.md)

## Author

- **Pete Maan** - [pspete](https://github.com/pspete)

## License

This project is [licensed under the MIT License](LICENSE.md).

## Contributing

Any and all contributions to this project are appreciated.

See the [CONTRIBUTING.md](CONTRIBUTING.md) for a few more details.

## Support

_IdentityCommand.SIA_ is neither developed nor supported by CyberArk; any official support channels offered by the vendor are not appropriate for seeking help with the _IdentityCommand.SIA_ module.

Help and support should be sought by [opening an issue][new-issue].

[new-issue]: https://github.com/pspete/IdentityCommand.SIA/issues/new

Priority support could be considered for <a href="https://github.com/sponsors/pspete">sponsors of @pspete</a>, <a href="mailto:pspete@pspete.dev">contact us</a> to discuss options.

![Logo][Logo]
