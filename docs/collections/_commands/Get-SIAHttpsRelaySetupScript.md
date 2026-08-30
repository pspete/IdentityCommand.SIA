---
external help file: IdentityCommand.SIA-help.xml
Module Name: IdentityCommand.SIA
online version:
schema: 2.0.0
---

# Get-SIAHttpsRelaySetupScript

## SYNOPSIS
Get a SIA HTTPS relay setup script

## SYNTAX

```
Get-SIAHttpsRelaySetupScript [-https_relay_os] <String> [[-expiration_minutes] <Int32>]
 [[-protocol_port_map] <Hashtable>] [[-proxy_host] <String>] [[-proxy_port] <Int32>]
 [[-windows_installation_path] <String>] [<CommonParameters>]
```

## DESCRIPTION
Generates an installation script used to deploy a SIA HTTPS relay on the specified operating system.

## EXAMPLES

### Example 1
```powershell
Get-SIAHttpsRelaySetupScript -https_relay_os linux
```

Generates an HTTPS relay installation script for Linux.

## PARAMETERS

### -expiration_minutes
The number of minutes the generated installation script remains valid for.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -https_relay_os
The operating system of the host the HTTPS relay will be installed on.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: windows, darwin, linux

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -protocol_port_map
A hashtable mapping supported protocols (SSH, POSTGRES, MYSQL) to the local ports the HTTPS relay should listen on.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -proxy_host
The hostname of an outbound proxy the HTTPS relay should connect through.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -proxy_port
The port of an outbound proxy the HTTPS relay should connect through.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -windows_installation_path
The installation path to use when the HTTPS relay is installed on Windows.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

### System.Int32

### System.Collections.Hashtable

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
