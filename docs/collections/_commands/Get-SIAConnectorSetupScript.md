---
external help file: IdentityCommand.SIA-help.xml
Module Name: IdentityCommand.SIA
online version:
schema: 2.0.0
---

# Get-SIAConnectorSetupScript

## SYNOPSIS
Gets SIA connector setup script

## SYNTAX

```
Get-SIAConnectorSetupScript [-connector_type] <String> [-connector_os] <String> [[-connector_pool_id] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Generates and retuns setup scripts for SIA connectors based on the provided parameters

## EXAMPLES

### Example 1
```
Get-SIAConnectorSetupScript -connector_type windows -connector_os ON-PREMISE
```

Generates a setup script for an on-premise windows SIA connector server

### Example 2
```
Get-SIAConnectorSetupScript -connector_type linux -connector_os AZURE
```

Generates a setup script for an Azure linux SIA connector server

## PARAMETERS

### -connector_os
{{ Fill connector_os Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: windows, darwin, linux

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -connector_pool_id
{{ Fill connector_pool_id Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -connector_type
{{ Fill connector_type Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: AWS, AZURE, ON-PREMISE, GCP

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
