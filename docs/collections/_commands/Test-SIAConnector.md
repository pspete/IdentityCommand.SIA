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
Test-SIAConnector [-connector_id] <String> [[-targets] <String[]>] [[-checkBackendEndpoints] <Boolean>]
 [<CommonParameters>]
```

## DESCRIPTION
Runs a reachability check for a connector, optionally against specific targets and the SIA backend endpoints.

## EXAMPLES

### Example 1
```powershell
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
One or more target addresses to include in the connector reachability check.

```yaml
Type: String[]
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

### System.String[]

### System.Boolean

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
