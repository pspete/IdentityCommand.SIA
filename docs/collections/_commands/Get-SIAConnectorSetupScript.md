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
Get-SIAConnectorSetupScript [-connector_os] <String> [[-connector_pool_id] <String>]
 [-expiration_minutes <Int32>] [-proxy_host <String>] [-proxy_port <Int32>]
 [-windows_installation_path <String>] [<CommonParameters>]
```

## DESCRIPTION
Generates and returns a setup script used to install a SIA connector on a target server.

## EXAMPLES

### Example 1
```
Get-SIAConnectorSetupScript -connector_os windows -connector_pool_id 86fde987-c84f-4e85-8110-90b6df3f7c4c
```

Generates a setup script for a Windows SIA connector joining the specified connector pool

### Example 2
```
Get-SIAConnectorSetupScript -connector_os linux -connector_pool_id 86fde987-c84f-4e85-8110-90b6df3f7c4c -expiration_minutes 60
```

Generates a setup script for a Linux SIA connector, valid for 60 minutes

## PARAMETERS

### -connector_os
The operating system of the server the connector will be installed on

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
The identifier of the connector pool the connector should join

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

### -expiration_minutes
The number of minutes the generated setup script remains valid for. Accepts 15 - 240.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -proxy_host
The proxy host the connector should use for outbound connectivity

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -proxy_port
The proxy port the connector should use for outbound connectivity

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -windows_installation_path
The installation path to use when installing the connector on Windows

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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
