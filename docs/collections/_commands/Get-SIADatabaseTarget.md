---
external help file: IdentityCommand.SIA-help.xml
Module Name: IdentityCommand.SIA
online version:
schema: 2.0.0
---

# Get-SIADatabaseTarget

## SYNOPSIS
Get SIA database targets

## SYNTAX

```
Get-SIADatabaseTarget [[-limit] <Int32>] [[-cursor] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Lists the database targets configured in SIA.
Each target references the strong account that provisions access to it via its secretId.

## EXAMPLES

### Example 1
```
Get-SIADatabaseTarget
```

Returns all configured database targets.

## PARAMETERS

### -cursor
The pagination cursor from a previous response's nextCursor.

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

### -limit
The maximum number of database targets to return (1-1000).

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Int32
### System.String
## OUTPUTS

### System.Object
## NOTES
Requires the DpaAdmin role.

## RELATED LINKS
