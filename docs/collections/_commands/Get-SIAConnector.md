---
external help file: IdentityCommand.SIA-help.xml
Module Name: IdentityCommand.SIA
online version:
schema: 2.0.0
---

# Get-SIAConnector

## SYNOPSIS
Get SIA connector details

## SYNTAX

```
Get-SIAConnector [[-connector_id] <String>] [<CommonParameters>]
```

## DESCRIPTION
Returns details of all SIA connectors, or a specific SIA connector which providing a connector ID.

## EXAMPLES

### Example 1
```
Get-SIAConnector
```

Get details of all configured SIA connectors

### Example 1
```
Get-SIAConnector -connector_id SomeConnectorID
```

Get details of the SIA connector with the ID SomeConnectorID

## PARAMETERS

### -connector_id
The ID of a connector to query

```yaml
Type: String
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

## OUTPUTS

## NOTES

## RELATED LINKS
