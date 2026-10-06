---
title: IdentityCommand.SIA
subtitle: PowerShell for Idira Secure Infrastructure Access
hide_hero: true
---

<div class="has-text-centered mb-6">
  <img src="{{ '/SIA/media/images/IdentityCommand.SIA.png' | relative_url }}" alt="IdentityCommand.SIA" width="471">
</div>

**IdentityCommand.SIA** is a PowerShell module that provides a set of easy-to-use commands, allowing you to interact with the API for a **CyberArk Secure Infrastructure Access** from within the PowerShell environment.

It builds on [IdentityCommand]({{ '/' | relative_url }}) for authentication - see [Getting Started]({{ '/SIA/getting-started/' | relative_url }}) to install and connect, and the [command reference]({{ '/SIA/commands/' | relative_url }}) for every command.

## SIA Connections

The `Connect-SIATarget` command can be use to initiate SIA connections to targets.

### SSH

SSH connections to targets using the SIA zero standing privilege method can be achieved with the following example:

```powershell
Connect-SIATarget -SSH -targetAddress someserver.somedomain.com
```

SSH connections to targets using vaulted credentials follow a similar pattern:

```powershell
Connect-SIATarget -SSH -targetAddress sometarget.somedomain.com -targetUser someuser -targetDomain somedomain
```

For SSH connections to succeed, an SSH client must be available from the terminal in which the command is being executed.

### RDP

`Connect-SIATarget` can also request RDP files which can be used to connected through he SIA gateway, the following example facilitates a zero standing privilege RDP connection:

```powershell
Connect-SIATarget -RDP -targetAddress someserver.somedomain.com
```

Vaulted credentials can also be used for RDP connections, as shown in the below example:

```powershell
Connect-SIATarget -RDP -targetAddress sometarget.somedomain.com -targetUser someuser -targetDomain somedomain
```

## SIA Policies

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

## Module Scope Variables & Command Invocation Data

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

## Result Pagination

List commands (`Get-SIAPolicy`, `Get-SIASession`, `Get-SIAStrongAccount`, `Get-SIATargetSet`, `Get-SIAVirtualMachine`, `Get-SIADatabaseStrongAccount` and `Get-SIADatabaseTarget`) fetch every page of results automatically - there's no need to request pages individually, the complete result set is always returned.

## Tab Completion

Id and name parameters for policies, strong accounts, target sets, connectors and HTTPS relays support tab completion, sourced live from the corresponding `Get-SIA*` command, once connected with `Connect-SIATenant`.

