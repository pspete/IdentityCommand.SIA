---
external help file: IdentityCommand.SIA-help.xml
Module Name: IdentityCommand.SIA
online version:
schema: 2.0.0
---


# Remove-SIAStrongAccount

## SYNOPSIS
Delete a string account from SIA

## SYNTAX

```
Remove-SIAStrongAccount -secret_id <String> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Deletes a configured strong account for either virtual machines or databases

## EXAMPLES

### Example 1
```
Remove-SIAStrongAccount -secret_id 1234-abcd
```

Deletes specified strong account configured for virtual machine

### Example 1
```
Remove-SIAStrongAccount -secret_id 1234-abcd -database
```

Deletes specified strong account configured for database

## PARAMETERS

### -secret_id
The ID of the strong account

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
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
### System.Management.Automation.SwitchParameter
## OUTPUTS

### System.Object
## NOTES
Requires the DpaAdmin role.

## RELATED LINKS
