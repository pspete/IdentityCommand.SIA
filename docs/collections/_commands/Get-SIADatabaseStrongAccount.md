---
external help file: IdentityCommand.SIA-help.xml
Module Name: IdentityCommand.SIA
online version:
schema: 2.0.0
---


# Get-SIADatabaseStrongAccount

## SYNOPSIS
Get SIA database strong accounts

## SYNTAX

### List (Default)
```
Get-SIADatabaseStrongAccount [-limit <Int32>]
 [<CommonParameters>]
```

### ById
```
Get-SIADatabaseStrongAccount -strong_account_id <String>
 [<CommonParameters>]
```

## DESCRIPTION
Lists database strong accounts from SIA, or retrieves a single database strong account by ID. Results are automatically paginated - all matching records are returned regardless of how many pages the API splits them across.

## EXAMPLES

### Example 1
```powershell
Get-SIADatabaseStrongAccount -strong_account_id 550e8400-e29b-41d4-a716-446655440000
```

Retrieves the specified database strong account.

## PARAMETERS

### -limit
The page size to request from the API (1-1000, default 500). Does not limit the total number of items returned - all pages are fetched automatically.

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

### -strong_account_id
The unique identifier of the database strong account.

```yaml
Type: String
Parameter Sets: ById
Aliases: id

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

### System.Int32

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
