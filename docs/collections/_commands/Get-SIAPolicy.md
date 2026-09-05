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
Get-SIAPolicy [-limit <Int32>] [-sort <String>] [<CommonParameters>]
```

### ById
```
Get-SIAPolicy [-policyid <String>] [<CommonParameters>]
```

## DESCRIPTION
Returns details of all policies or a specific policy from SIA. Results are automatically paginated - all matching records are returned regardless of how many pages the API splits them across.

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

### -policyid
The ID of a policy to get details of

```yaml
Type: String
Parameter Sets: ById
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -limit
The page size to request from the API. Does not limit the total number of items returned - all pages are fetched automatically.

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

### -sort
The field and direction to sort results by, eg "updatedOn desc".

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
