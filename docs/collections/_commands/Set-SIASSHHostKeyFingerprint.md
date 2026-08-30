---
external help file: IdentityCommand.SIA-help.xml
Module Name: IdentityCommand.SIA
online version:
schema: 2.0.0
---

# Set-SIASSHHostKeyFingerprint

## SYNOPSIS
Update an SSH host key fingerprint in SIA

## SYNTAX

```
Set-SIASSHHostKeyFingerprint [-target_id] <String> [-fingerprint] <String>
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates the stored SSH host key fingerprint for an existing target.

## EXAMPLES

### Example 1
```powershell
Set-SIASSHHostKeyFingerprint -target_id i-0abc123 -fingerprint SHA256:efgh...
```

Updates the SSH host key fingerprint stored for the specified target.

## PARAMETERS

### -fingerprint
The SSH host key fingerprint value to store for the target.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -target_id
The unique identifier of the target - an AWS instance ID, Azure VM ID, GCP instance ID, FQDN, or IP_LogicalNetworkName.

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

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
