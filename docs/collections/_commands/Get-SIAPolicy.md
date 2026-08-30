---
external help file: IdentityCommand.SIA-help.xml
Module Name: IdentityCommand.SIA
online version:
schema: 2.0.0
---


# Get-SIAPolicy

## SYNOPSIS
Get details of policies from SIA

## SYNTAX

### List (Default)
```
Get-SIAPolicy [-filter <String>] [-limit <Int32>] [-offset <Int32>] [-sort <String>]
 [<CommonParameters>]
```

### ById
```
Get-SIAPolicy [-policyid] <String> [<CommonParameters>]
```

## DESCRIPTION
Returns details of all policies or a specific policy from SIA

## EXAMPLES

### Example 1
```
Get-SIAPolicy
```

Get details of all policies from SIA

### Example 1
```
Get-SIAPolicy -policyid 1234-abcd
```

Get details of specific policy from SIA

## PARAMETERS

### -filter
An OData-style filter expression, fully parenthesised - for example ((status ne 'Disabled')). Supports policyName, description, startDate, endDate, status, updatedBy, updatedOn, createdBy, createdOn, platforms, fqdns and ips.

```yaml
Type: String
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -limit
The maximum number of policies to return (1-1000, default 100).

```yaml
Type: Int32
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -offset
The starting point of the retrieved policies (default 0).

```yaml
Type: Int32
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -policyid
The ID of a policy to get details of

```yaml
Type: String
Parameter Sets: ById
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -sort
The sort order, e.g. 'updatedOn DESC'.

```yaml
Type: String
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
## OUTPUTS

### System.Object
## NOTES
Requires the DpaAdmin role.

## RELATED LINKS
