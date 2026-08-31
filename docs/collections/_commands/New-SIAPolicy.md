---
external help file: IdentityCommand.SIA-help.xml
Module Name: IdentityCommand.SIA
online version:
schema: 2.0.0
---

# New-SIAPolicy

## SYNOPSIS
Create a new SIA policy

## SYNTAX

```
New-SIAPolicy [-policyName] <String> [[-status] <String>] [[-description] <String>]
 [[-providersData] <PSObject>] [[-startDate] <DateTime>] [[-endDate] <DateTime>]
 [[-userAccessRules] <PSObject[]>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Creates new SIA policy using the details specified for any parameters

## EXAMPLES

### Example 1
```
New-SIAPolicy -policyName Some-Policy-Name
```

Creates a draft policy with no settings

### Example 2
```
New-SIAPolicy -policyName Some-Policy-Name -status Enabled -description "Policy Description" `
-providersData $providersData -startDate (Get-Date) -endDate (Get-Date).AddDays(7) `
-userAccessRules $userAccessRules
```

Creates an enabled policy, valid for 7 days with settings according to the parameter values.

\`$providersData\` object is created using the \`New-SIAPolicyProviderDefinition\` command

\`$userAccessRules\` object is created using the \`New-SIAPolicyUserAccessRuleDefinition\` command

### Example 3
```
New-SIAPolicy -policyName Some-Policy-Name -status Enabled -description "Policy Description" `
-providersData $providersData  -userAccessRules $userAccessRules
```

Creates an enabled policy with settings according to the parameter values.

\`$providersData\` object is created using the \`New-SIAPolicyProviderDefinition\` command

\`$userAccessRules\` object is created using the \`New-SIAPolicyUserAccessRuleDefinition\` command

### Example 4
```
New-SIAPolicy -policyName Some-Policy-Name -status Draft -providersData $providersData
```

Creates a draft policy with settings according to the parameter values.

\`$providersData\` object is created using the \`New-SIAPolicyProviderDefinition\` command

### Example 5
```
New-SIAPolicy -policyName Some-Policy-Name -status Draft -userAccessRules $userAccessRules
```

Creates a draft policy with settings according to the parameter values.

\`$userAccessRules\` object is created using the \`New-SIAPolicyUserAccessRuleDefinition\` command

### Example 6
```
$ConnectAs = New-SIAPolicyConnectAsDefinition -OnPrem -assignGroups Administrators
$ConnectAs = New-SIAPolicyConnectAsDefinition -AWS -ssh "ec2-user" -assignGroups Administrators, "Remote Desktop Users" -connectAsDefinition $ConnectAs
$ConnectAs = New-SIAPolicyConnectAsDefinition -Azure -ssh "azureuser" -connectAsDefinition $ConnectAs
$ConnectAs = New-SIAPolicyConnectAsDefinition -GCP -ssh "root" -connectAsDefinition $ConnectAs

$UserData = New-SIAPolicyUserDataDefinition -Role -name "DEV_TEAM_ROLE"
$UserData = New-SIAPolicyUserDataDefinition -Role -name "SOME_TEAM_ROLE" -UserDataDefinition $UserData
$UserData = New-SIAPolicyUserDataDefinition -Group -name "DEV_TEAM_GROUP" -UserDataDefinition $UserData
$UserData = New-SIAPolicyUserDataDefinition -Group -name "SOME_TEAM_GROUP" -UserDataDefinition $UserData
$UserData = New-SIAPolicyUserDataDefinition -User -name SomeUser -UserDataDefinition $UserData
$UserData = New-SIAPolicyUserDataDefinition -User -name SomeOtherUser -UserDataDefinition $UserData

$AccessRules = @()
$AccessRules += New-SIAPolicyUserAccessRuleDefinition -ruleName SomeAccessRule -userData $UserData1 -connectAs $ConnectAs1 -timeZone Europe/London
$AccessRules += New-SIAPolicyUserAccessRuleDefinition -ruleName AnotherAccessRule -userData $UserData2 -connectAs $ConnectAs2 -timeZone America/Costa_Rica

$FQDNrules = @()
$FQDNrules += New-SIAPolicyFQDNRuleDefinition -operator EXACTLY -computernamePattern SomeHost -domain SomeDomain.com
$FQDNrules += New-SIAPolicyFQDNRuleDefinition -operator WILDCARD -computernamePattern *-DEV-* -domain SomeDomain.com
$FQDNrules += New-SIAPolicyFQDNRuleDefinition -operator SUFFIX -computernamePattern '-Prod' -domain SomeDomain.com
$FQDNrules += New-SIAPolicyFQDNRuleDefinition -operator CONTAINS -computernamePattern SQL -domain SomeDomain.com
$FQDNrules += New-SIAPolicyFQDNRuleDefinition -operator PREFIX -computernamePattern DC1 -domain SomeDomain.com

$Providers = New-SIAPolicyProviderDefinition -OnPrem -fqdnRulesConjunction OR -fqdnRules $FQDNrules
$Providers = New-SIAPolicyProviderDefinition -AWS -regions "us-east-1","us-east-2" -tags @{"Key"="env";"Value"=@("prod")} -ProviderDefinition $Providers
$Providers = New-SIAPolicyProviderDefinition -Azure -regions "eastus2","eastus" -tags @{"Key"="env";"Value"=@("prod")} -ProviderDefinition $Providers
$Providers = New-SIAPolicyProviderDefinition -GCP -regions "asia-east1","us-east1" -labels @{"Key"="env";"Value"=@("prod")} -ProviderDefinition $Providers

New-SIAPolicy -policyName SomePolicy -status Enabled -description "Some Description" -providersData $Providers -userAccessRules $AccessRules
```

Creates a complete policy with settings according to the parameter values.

## PARAMETERS

### -description
A description for the policy

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -endDate
The end date for the policy

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -policyName
A name for the policy

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -providersData
Accepts object output from New-SIAPolicyProviderDefinition.

Describes the configuration relating to the providers for the policy

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -startDate
The date the policy is valid from

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -status
The status of the policy

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Enabled, Disabled, Draft, Expired

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -userAccessRules
Accepts object output from New-SIAPolicyUserAccessRuleDefinition.

Describes the user access rules configured on the policy

```yaml
Type: PSObject[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
### System.Management.Automation.PSObject
### System.DateTime
### System.Management.Automation.PSObject[]
## OUTPUTS

### System.Object
## NOTES
Requires the DpaAdmin role.

## RELATED LINKS
