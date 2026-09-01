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

### Subdomain (Default)
```
Connect-SIATenant [-tenant_subdomain] <String> [<CommonParameters>]
```

### URL
```
Connect-SIATenant [-tenant_url] <String> [<CommonParameters>]
```

## DESCRIPTION
Connects to a SIA tenant to be able to run IdentityCommand.SIA module commands against it.

Provide either the ISPSS shared services subdomain (the SIA API url is resolved automatically via platform discovery) or the SIA tenant url directly.

Requires prior authentication to the related ISPSS Identity Shared Services tenant using the \`IdentityCommand\` module.

## EXAMPLES

### Example 1
```
Connect-SIATenant -tenant_subdomain sometenant
```

Resolves the SIA API url for the \`sometenant\` shared services subdomain and connects to it for subsequent module operations

### Example 2
```
Connect-SIATenant -tenant_url https://sometenant.dpa.cyberark.cloud
```

Connects to the https://sometenant.dpa.cyberark.cloud SIA tenant for subsequent module operations

## PARAMETERS

### -tenant_subdomain
The ISPSS shared services subdomain of the SIA tenant.
The SIA API url is resolved from platform discovery and used for subsequent operations.

```yaml
Type: String
Parameter Sets: Subdomain
Aliases: subdomain

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -tenant_url
The url of the SIA tenant

```yaml
Type: String
Parameter Sets: URL
Aliases: sia_url

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
