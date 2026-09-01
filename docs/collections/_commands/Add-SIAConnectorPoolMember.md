---
external help file: IdentityCommand.SIA-help.xml
Module Name: IdentityCommand.SIA
online version:
schema: 2.0.0
---

# Add-SIAConnectorPoolMember

## SYNOPSIS
Assign connectors to a SIA connector pool

## SYNTAX

```
Add-SIAConnectorPoolMember [-connector_pool_id] <String> [-connectorId] <String[]>
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Assigns one or more connectors to a SIA connector pool.

## EXAMPLES

### Example 1
```powershell
Add-SIAConnectorPoolMember -connector_pool_id 1234-abcd -connectorId CMSConnector_1, CMSConnector_2
```

Assigns the two specified connectors to the connector pool.

## PARAMETERS

### -connector_pool_id
The unique identifier of the connector pool to assign connectors to.

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

### -connectorId
One or more connector identifiers to assign to the connector pool.

```yaml
Type: String[]
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

### System.String[]

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
