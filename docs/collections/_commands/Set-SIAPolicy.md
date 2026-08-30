---
external help file: IdentityCommand.SIA-help.xml
Module Name: IdentityCommand.SIA
online version:
schema: 2.0.0
---


# Set-SIAPolicy

## SYNOPSIS
Update SIA access policy

## SYNTAX

```
Set-SIAPolicy [-policyId] <String> [[-policyName] <String>] [[-status] <String>] [[-description] <String>]
 [[-providersData] <PSObject>] [[-startDate] <DateTime>] [[-endDate] <DateTime>]
 [[-userAccessRules] <PSObject[]>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Updates configuration of a recurring access policy configured in SIA.

## EXAMPLES

### Example 1
```
Set-SIAPolicy -policyId 1234-abcd -status Enabled
```

Set SIA Policy with ID 1234-abcd to "Enabled"

### Example 2
```
Set-SIAPolicy -policyId 1234-abcd -startDate (Get-Date) -endDate (Get-Date).AddDays(7)
```

Set SIA Policy with ID 1234-abcd to be valid for the next 7 days

### Example 3
```
Set-SIAPolicy -policyId 1234-abcd -providersData $ProviderData
```

Update SIA Policy with ID 1234-abcd with provider configuration held in the $ProviderData object.
ProviderData object is created with the New-SIAPolicyProviderDefinition function.

### Example 4
```
Set-SIAPolicy -policyId 1234-abcd -userAccessRules $AccessRules
```

Update SIA Policy with ID 1234-abcd with access rule configuration held in the $AccessRules object.
ProviderData object is created with the New-SIAPolicyUserAccessRuleDefinition function.

## PARAMETERS

### -description
The description text of the access policy

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -endDate
The end date of the access policy

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -policyId
The ID of the access policy

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

### -policyName
The name of the access policy

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -providersData
Accepts object output from New-SIAPolicyProviderDefinition.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -startDate
The start date of the access policy

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

### -status
The status of the access policy

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Enabled, Disabled, Draft, Expired

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -userAccessRules
Accepts object output from New-SIAPolicyUserAccessRuleDefinition.

```yaml
Type: PSObject[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
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
