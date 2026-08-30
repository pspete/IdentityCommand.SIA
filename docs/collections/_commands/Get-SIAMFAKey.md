---
external help file: IdentityCommand.SIA-help.xml
Module Name: IdentityCommand.SIA
online version:
schema: 2.0.0
---


# Get-SIAMFAKey

## SYNOPSIS
Get the SIA MFA key

## SYNTAX

```
Get-SIAMFAKey [[-format] <String>] [<CommonParameters>]
```

## DESCRIPTION
Returns the SIA MFA key used for SSH authentication, in openssh (default) or ppk format.

## EXAMPLES

### Example 1
```powershell
Get-SIAMFAKey -format ppk
```

Returns the SIA MFA key in PuTTY (ppk) format.

## PARAMETERS

### -format
The key format to return - openssh (default) or ppk.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: openssh, ppk

Required: False
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
Requires the JitUser role.

## RELATED LINKS
