---
external help file: IdentityCommand.SIA-help.xml
Module Name: IdentityCommand.SIA
online version:
schema: 2.0.0
---

# Get-SIATargetSet

## SYNOPSIS
Get details of target sets from SIA

## SYNTAX

```
Get-SIATargetSet [[-name] <String>] [[-strongAccountId] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Get details of all target sets, target sets associated with a specific strong account, or a specific target set. Results are automatically paginated - all matching records are returned regardless of how many pages the API splits them across.

## EXAMPLES

### Example 1
```
Get-SIATargetSet
```

Get all target sets from SIA

### Example 2
```
Get-SIATargetSet -name somename
```

Get a specific target set from SIA

### Example 1
```
Get-SIATargetSet -strongAccountId 1234-abcd
```

Get all target sets for a specific strong account from SIA

## PARAMETERS

### -name
The name of a target set to get details of

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -strongAccountId
The ID of a string account to return target details for

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
