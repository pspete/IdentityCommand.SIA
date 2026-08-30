---
external help file: IdentityCommand.SIA-help.xml
Module Name: IdentityCommand.SIA
online version:
schema: 2.0.0
---

# Connect-SIATarget

## SYNOPSIS
Initiates connection to RDP or SSH targets via SIA

## SYNTAX

### Vaulted-RDP
```
Connect-SIATarget [-RDP] -targetAddress <String> -targetUser <String> [-targetDomain <String>]
 [-logicalName <String>] [-elevatedPrivileges <Boolean>] [<CommonParameters>]
```

### DPA-RDP
```
Connect-SIATarget [-RDP] -targetAddress <String> [-targetDomain <String>] [<CommonParameters>]
```

### Vaulted-SSH
```
Connect-SIATarget [-SSH] -targetAddress <String> -targetUser <String> [-targetDomain <String>]
 [-logicalName <String>] [<CommonParameters>]
```

### DPA-SSH
```
Connect-SIATarget [-SSH] -targetAddress <String> [<CommonParameters>]
```

## DESCRIPTION
Automatically invokes RDP or SSH connections to targets via the SIA service, using either vaulted credentials or zero standing privilege connections.

A users will be prompted for authentication by the SIA service and must satisfy any configured MFA conditions in order for connection to the target to be completed.

For SSH connections, an SSH client must be available from the terminal in which the command is being executed.

The SSH connection string being executed will be output in the debug stream of the module.

RDP files are saved to, and invoked from, the local temp directory.

## EXAMPLES

### Example 1
```
Connect-SIATarget -RDP -targetAddress someserver.somedomain.com
```

Connects to RDP session for zero standing privilege connection to target

### Example 2
```
Connect-SIATarget -RDP -targetAddress sometarget.somedomain.com -targetUser someuser -targetDomain somedomain
```

Connects to RDP session for vaulted credential access to target

### Example 3
```
Connect-SIATarget -RDP -targetAddress someserver.somedomain.com -targetDomain somedomain
```

Connects to RDP session for zero standing privilege connection to cloud instance target

### Example 4
```
Connect-SIATarget -SSH -targetAddress someserver.somedomain.com
```

Initiates SSH session for zero standing privilege connection to target

### Example 5
```
Connect-SIATarget -SSH -targetAddress sometarget.somedomain.com -targetUser someuser -targetDomain somedomain
```

Connects to SSH session for vaulted credential access to target

## PARAMETERS

### -targetAddress
The address of the target

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -targetUser
The vaulted credential to use

```yaml
Type: String
Parameter Sets: Vaulted-RDP, Vaulted-SSH
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -targetDomain
The domain of the user

```yaml
Type: String
Parameter Sets: Vaulted-RDP, DPA-RDP, Vaulted-SSH
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -logicalName
The logical network name

```yaml
Type: String
Parameter Sets: Vaulted-RDP, Vaulted-SSH
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -elevatedPrivileges
Just-in-time elevation with a vaulted credential

```yaml
Type: Boolean
Parameter Sets: Vaulted-RDP
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -RDP
Specify to invoke RDP connection to target

```yaml
Type: SwitchParameter
Parameter Sets: Vaulted-RDP, DPA-RDP
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SSH
Specify to invoke SSH connection to target

```yaml
Type: SwitchParameter
Parameter Sets: Vaulted-SSH, DPA-SSH
Aliases:

Required: True
Position: Named
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
