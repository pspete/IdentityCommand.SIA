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
Connect-SIATenant [-tenant_subdomain] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### SubdomainCredential
```
Connect-SIATenant [-tenant_subdomain] <String> -Credential <PSCredential> [-PlatformToken] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### SubdomainSAML
```
Connect-SIATenant [-tenant_subdomain] <String> -SAMLResponse <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### URL
```
Connect-SIATenant [-tenant_url] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### URLCredential
```
Connect-SIATenant [-tenant_url] <String> -Credential <PSCredential> [-PlatformToken] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### URLSAML
```
Connect-SIATenant [-tenant_url] <String> -SAMLResponse <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Connects to a SIA tenant to be able to run IdentityCommand.SIA module commands against it.

Provide either the ISPSS shared services subdomain (the SIA API url is resolved automatically via platform discovery) or the SIA tenant url directly.

If an active `IdentityCommand` session is already present (established with `New-IDSession` or `New-IDPlatformToken`), it is used as-is.

If no active session is found, supply `-Credential` (or `-SAMLResponse`) and `Connect-SIATenant` will authenticate to CyberArk Identity first: the Identity tenant url is discovered from the same subdomain / url via platform discovery, then `New-IDSession` (interactive user, including any MFA challenges) or - with `-PlatformToken` - `New-IDPlatformToken` (OAuth `client_credentials`, for a service user) is invoked.

## EXAMPLES

### Example 1
```
Connect-SIATenant -tenant_subdomain sometenant
```

Resolves the SIA API url for the `sometenant` shared services subdomain and connects to it, using the active `IdentityCommand` session, for subsequent module operations

### Example 2
```
Connect-SIATenant -tenant_url https://sometenant.dpa.cyberark.cloud
```

Connects to the https://sometenant.dpa.cyberark.cloud SIA tenant, using the active `IdentityCommand` session, for subsequent module operations

### Example 3
```
Connect-SIATenant -tenant_subdomain sometenant -Credential $Credential
```

When no active `IdentityCommand` session is present, discovers the CyberArk Identity url for the `sometenant` subdomain, authenticates the user in `$Credential` (completing any MFA challenges), resolves the SIA API url and connects to it

### Example 4
```
Connect-SIATenant -tenant_subdomain sometenant -Credential $ServiceUserCredential -PlatformToken
```

When no active `IdentityCommand` session is present, authenticates non-interactively as a service user via an OAuth platform token, then connects to the `sometenant` SIA tenant

## PARAMETERS

### -tenant_subdomain
The ISPSS shared services subdomain of the SIA tenant.
The SIA API url is resolved from platform discovery and used for subsequent operations.

```yaml
Type: String
Parameter Sets: Subdomain, SubdomainCredential, SubdomainSAML
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
Parameter Sets: URL, URLCredential, URLSAML
Aliases: sia_url

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Credential
Credential used to authenticate to CyberArk Identity when no active `IdentityCommand` session is found.
A user credential is used with `New-IDSession`; a service user credential is used with `New-IDPlatformToken` when `-PlatformToken` is also specified.

```yaml
Type: PSCredential
Parameter Sets: SubdomainCredential, URLCredential
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PlatformToken
Authenticate as a service user via `New-IDPlatformToken` (OAuth `client_credentials`) rather than the interactive `New-IDSession`.

```yaml
Type: SwitchParameter
Parameter Sets: SubdomainCredential, URLCredential
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SAMLResponse
SAML assertion used to authenticate to CyberArk Identity, via `New-IDSession`, when no active `IdentityCommand` session is found.

```yaml
Type: String
Parameter Sets: SubdomainSAML, URLSAML
Aliases:

Required: True
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
