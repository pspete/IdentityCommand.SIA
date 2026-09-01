---
external help file: IdentityCommand.SIA-help.xml
Module Name: IdentityCommand.SIA
online version:
schema: 2.0.0
---

# Set-SIAConnectorMaintenanceMode

## SYNOPSIS
Set the maintenance mode of a SIA connector

## SYNTAX

```
Set-SIAConnectorMaintenanceMode [-connector_id] <String> [-maintenance] <Boolean>
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Places a SIA connector into, or removes it from, maintenance mode.

## EXAMPLES

### Example 1
```powershell
Set-SIAConnectorMaintenanceMode -connector_id 1234-abcd -maintenance $true
```

Places the specified connector into maintenance mode.

## PARAMETERS

### -connector_id
The unique identifier of the SIA connector.

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

### -maintenance
Specify $true to place the connector into maintenance mode, or $false to remove it from maintenance mode.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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
Default value: None
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
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

### System.Boolean

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
