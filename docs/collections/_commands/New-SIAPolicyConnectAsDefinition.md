---
external help file: IdentityCommand.SIA-help.xml
Module Name: IdentityCommand.SIA
online version:
schema: 2.0.0
---

# New-SIAPolicyConnectAsDefinition

## SYNOPSIS
Define an object to describing ConnectAs configuration for a User Access Rule of a SIA Policy.

## SYNTAX

### AWS
```
New-SIAPolicyConnectAsDefinition [-AWS] [-ssh <String>] [-assignGroups <String[]>]
 [-connectAsDefinition <PSObject>] [<CommonParameters>]
```

### Azure
```
New-SIAPolicyConnectAsDefinition [-Azure] [-ssh <String>] [-assignGroups <String[]>]
 [-connectAsDefinition <PSObject>] [<CommonParameters>]
```

### OnPrem
```
New-SIAPolicyConnectAsDefinition [-OnPrem] [-ssh <String>] [-assignGroups <String[]>]
 [-connectAsDefinition <PSObject>] [<CommonParameters>]
```

### GCP
```
New-SIAPolicyConnectAsDefinition [-GCP] [-ssh <String>] [-assignGroups <String[]>]
 [-connectAsDefinition <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
Outputs an object to be provided as input for the \`connectAs\` parameter of the \`New-SIAPolicyUserAccessRuleDefinition\` function.

The Connect As definition forms part of the User Access Rule defined on a SIA policy.

## EXAMPLES

### Example 1
```
$ConnectAs = New-SIAPolicyConnectAsDefinition -OnPrem -assignGroups Administrators
```

Defines a ConnectAs object which states users connecting via a SIA policy configured with the ConnectAs definition using RDP, will use ephemeral accounts which are added to the the Administrators group for On-Premise Windows servers.

The \`$ConnectAs\` variable in the above example is used as input for the \`connectAs\` parameter of the \`New-SIAPolicyUserAccessRuleDefinition\` function.

### Example 2
```
$ConnectAs = New-SIAPolicyConnectAsDefinition -OnPrem -assignGroups Administrators
$ConnectAs = New-SIAPolicyConnectAsDefinition -AWS -ssh "ec2-user" -assignGroups Administrators, "Remote Desktop Users" -connectAsDefinition $ConnectAs
$ConnectAs = New-SIAPolicyConnectAsDefinition -Azure -ssh "azureuser" -connectAsDefinition $ConnectAs
$ConnectAs = New-SIAPolicyConnectAsDefinition -GCP -ssh "root" -connectAsDefinition $ConnectAs
```

Defines a ConnectAs object which states users connecting via a SIA policy configured with the ConnectAs definition: - Use ephemeral accounts added to the \`Administrators\` group for on-premise windows servers

- Use ephemeral accounts added to the \`Administrators\` & \`Remote Desktop Users\`group for AWS windows servers
- Connect as the \`ec2-user\` local target user for AWS linux servers
- Connect as the \`azureuser\` local target user for Azure linux servers
- Connect as the \`root\` local target user for GCP linux servers

The \`$ConnectAs\` variable in the above example is used as input for the \`connectAs\` parameter of the \`New-SIAPolicyUserAccessRuleDefinition\` function.

## PARAMETERS

### -AWS
Specify to create a connectAs definition for AWS connections

```yaml
Type: SwitchParameter
Parameter Sets: AWS
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Azure
Specify to create a connectAs definition for Azure connections

```yaml
Type: SwitchParameter
Parameter Sets: Azure
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GCP
Specify to create a connectAs definition for GCP connections

```yaml
Type: SwitchParameter
Parameter Sets: GCP
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -OnPrem
Specify to create a connectAs definition for On-Premise connections

```yaml
Type: SwitchParameter
Parameter Sets: OnPrem
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -assignGroups
Predefined assigned groups of the local ephemeral user on Windows Servers.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -connectAsDefinition
Add additional data to previous output from \`New-SIAPolicyConnectAsDefinition\`.

Used to build a collection of connectAs definitions when multiple rules will be assigned in a policy.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ssh
For SSH connections, the local target user or a personal user template

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

### System.Management.Automation.SwitchParameter
### System.String
### System.String[]
### System.Management.Automation.PSObject
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
