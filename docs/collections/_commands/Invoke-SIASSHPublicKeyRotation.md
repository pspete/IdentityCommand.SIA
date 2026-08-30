---
external help file: IdentityCommand.SIA-help.xml
Module Name: IdentityCommand.SIA
online version:
schema: 2.0.0
---

# Invoke-SIASSHPublicKeyRotation

## SYNOPSIS
Invoke a SIA SSH CA public key rotation operation

## SYNTAX

### generate-new (Default)
```
Invoke-SIASSHPublicKeyRotation [-GenerateNew] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### deactivate-previous
```
Invoke-SIASSHPublicKeyRotation [-DeactivatePrevious] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### reactivate-previous
```
Invoke-SIASSHPublicKeyRotation [-ReactivatePrevious] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Performs an SSH CA public key rotation operation - generating a new key version, deactivating the previous key version, or reactivating the previous key version.

## EXAMPLES

### Example 1
```powershell
Invoke-SIASSHPublicKeyRotation -GenerateNew
```

Generates a new SSH CA public key version and begins key rotation.

## PARAMETERS

### -DeactivatePrevious
Deactivate the previous SSH CA key version once key rotation is complete.

```yaml
Type: SwitchParameter
Parameter Sets: deactivate-previous
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenerateNew
Generate a new SSH CA key version and begin key rotation.

```yaml
Type: SwitchParameter
Parameter Sets: generate-new
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ReactivatePrevious
Reactivate the previous SSH CA key version to roll back an in-progress rotation.

```yaml
Type: SwitchParameter
Parameter Sets: reactivate-previous
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

### System.Management.Automation.SwitchParameter

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
