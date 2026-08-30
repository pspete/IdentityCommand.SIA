---
external help file: IdentityCommand.SIA-help.xml
Module Name: IdentityCommand.SIA
online version:
schema: 2.0.0
---

# Test-SIAConnector

## SYNOPSIS
Test SIA connector reachability

## SYNTAX

```
Test-SIAConnector [-connector_id] <String> [[-targets] <Hashtable[]>] [[-checkBackendEndpoints] <Boolean>]
 [<CommonParameters>]
```

## DESCRIPTION
Tests reachability from a connector to the SIA backend endpoints and to one or more target hosts.

## EXAMPLES

### Example 1
```
Test-SIAConnector -connector_id 1234-abcd
```

Runs a reachability check for the specified connector.

## PARAMETERS

### -checkBackendEndpoints
Specify whether the reachability check should also test connectivity to the SIA backend endpoints.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -connector_id
The unique identifier of the SIA connector.

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

### -targets
One or more target endpoints to test connectivity to, each supplied as a hashtable - for example `@{ hostname = 'host.example.com'; port = 22 }`.
The port defaults to 22 if omitted.

```yaml
Type: Hashtable[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
### System.Collections.Hashtable[]
### System.Boolean
## OUTPUTS

### System.Object
## NOTES
Requires the DpaAdmin role.

## RELATED LINKS
