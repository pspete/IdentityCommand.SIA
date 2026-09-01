---
external help file: IdentityCommand.SIA-help.xml
Module Name: IdentityCommand.SIA
online version:
schema: 2.0.0
---

# Get-SIASSHPublicKey

## SYNOPSIS
Return details of SSH Public keys

## SYNTAX

### AWS
```
Get-SIASSHPublicKey [-AWS] [-workspaceId] <String> [-deploymentScript] [<CommonParameters>]
```

### AZURE
```
Get-SIASSHPublicKey [-Azure] [-workspaceId] <String> [-deploymentScript] [<CommonParameters>]
```

### ON-PREMISE
```
Get-SIASSHPublicKey [-OnPrem] [-deploymentScript] [<CommonParameters>]
```

### GCP
```
Get-SIASSHPublicKey [-GCP] [-workspaceId] <String> [-deploymentScript] [<CommonParameters>]
```

## DESCRIPTION
Return SSH CA public key details

## EXAMPLES

### Example 1
```
Get-SIASSHPublicKey -AWS -workspaceId SomeID
```

Get public key details for specified AWS workspace

### Example 2
```
Get-SIASSHPublicKey -AZURE -workspaceId SomeID -deploymentScript
```

Get SSH public key details with SSH key deployment script for specified Azure workspace

## PARAMETERS

### -deploymentScript
Specify to generate an SSH CA public key plus a deployment script for the specified workspace

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -workspaceId
The workspace ID of the environment

```yaml
Type: String
Parameter Sets: AWS, AZURE, GCP
Aliases: subscription_id

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -AWS
Specify to target AWS SIA resource identified by \`workspaceId\`

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
Specify to target Azure SIA resource identified by \`workspaceId\`

```yaml
Type: SwitchParameter
Parameter Sets: AZURE
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GCP
Specify to target GCP SIA resource identified by \`workspaceId\`

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
Specify to target On-Premise SIA resource

```yaml
Type: SwitchParameter
Parameter Sets: ON-PREMISE
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
### System.Management.Automation.SwitchParameter
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
