---
external help file: IdentityCommand.SIA-help.xml
Module Name: IdentityCommand.SIA
online version:
schema: 2.0.0
---

# Remove-SIAHttpsRelay

## SYNOPSIS
Delete a SIA HTTPS relay

## SYNTAX

```
Remove-SIAHttpsRelay [-https_relay_id] <String> [-force_delete] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Deletes an HTTPS relay and all associated resources from SIA.
A relay with active sessions cannot be deleted unless `-force_delete` is specified.

## EXAMPLES

### Example 1
```
Remove-SIAHttpsRelay -https_relay_id 1234-abcd
```

Deletes the specified HTTPS relay.

## PARAMETERS

### -force_delete
Force deletion even when the connector or HTTPS relay is active or has active sessions.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -https_relay_id
The unique identifier of the HTTPS relay.

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
## OUTPUTS

### System.Object
## NOTES
Requires the DpaAdmin role.

## RELATED LINKS
