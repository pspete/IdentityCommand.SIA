---
external help file: IdentityCommand.SIA-help.xml
Module Name: IdentityCommand.SIA
online version:
schema: 2.0.0
---

# Remove-SIAVirtualMachine

## SYNOPSIS
Deletes a VM infrastructure target from SIA

## SYNTAX

```
Remove-SIAVirtualMachine [-machine_id] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Deletes a virtual machine infrastructure target from SIA, by machine ID.

Deletion is permanent and irreversible.

## EXAMPLES

### Example 1
```
Remove-SIAVirtualMachine -machine_id i-02bcf1723f4509c12
```

Deletes the VM infrastructure target with the specified machine ID

### Example 2
```
Get-SIAVirtualMachine -filter "(locationType eq 'FQDN_IP')" | Remove-SIAVirtualMachine
```

Deletes every VM infrastructure target which is not hosted in a cloud provider

## PARAMETERS

### -machine_id
The unique machine ID of the VM infrastructure target to delete.

```yaml
Type: String
Parameter Sets: (All)
Aliases: machineId

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

## OUTPUTS

## NOTES

## RELATED LINKS
