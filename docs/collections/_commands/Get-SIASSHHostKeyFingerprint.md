---
external help file: IdentityCommand.SIA-help.xml
Module Name: IdentityCommand.SIA
online version:
schema: 2.0.0
---

# Get-SIASSHHostKeyFingerprint

## SYNOPSIS
Get an SSH host key fingerprint from SIA

## SYNTAX

```
Get-SIASSHHostKeyFingerprint [-target_id] <String> [<CommonParameters>]
```

## DESCRIPTION
Returns the stored SSH host key fingerprint for a specific target.

## EXAMPLES

### Example 1
```powershell
Get-SIASSHHostKeyFingerprint -target_id i-0abc123
```

Returns the SSH host key fingerprint stored for the specified target.

## PARAMETERS

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
