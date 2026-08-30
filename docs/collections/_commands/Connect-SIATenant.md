---
external help file: IdentityCommand.SIA-help.xml
Module Name: IdentityCommand.SIA
online version:
schema: 2.0.0
---

# Connect-SIATenant

## SYNOPSIS
Connects to a SIA tenant

## SYNTAX

```
Connect-SIATenant [-tenant_url] <String> [<CommonParameters>]
```

## DESCRIPTION
Connects to a SIA tenant to be able to run IdentityCommand.SIA module commands against it.

Requires prior authentication to the related ISPSS Identity Shared Services tenant using the \`IdentityCommand\` module.

## EXAMPLES

### Example 1
```
Connect-SIATenant -tenant_url https://sometenant.dpa.cyberark.cloud
```

Connects to the https://sometenant.dpa.cyberark.cloud SIA tenant for subsequent module operations

## PARAMETERS

### -tenant_url
The url of the SIA tenant

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
