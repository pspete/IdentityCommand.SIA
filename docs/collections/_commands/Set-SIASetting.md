---
external help file: IdentityCommand.SIA-help.xml
Module Name: IdentityCommand.SIA
online version:
schema: 2.0.0
---

# Set-SIASetting

## SYNOPSIS
Updates SIA settings

## SYNTAX

### mfaCaching
```
Set-SIASetting [-mfaCaching] [-isMfaCachingEnabled <Boolean>] [-keyExpirationTimeSec <Int32>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### sshMfaCaching
```
Set-SIASetting [-sshMfaCaching] [-isMfaCachingEnabled <Boolean>] [-keyExpirationTimeSec <Int32>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### rdpMfaCaching
```
Set-SIASetting [-rdpMfaCaching] [-isMfaCachingEnabled <Boolean>] [-keyExpirationTimeSec <Int32>]
 [-clientIpEnforced <Boolean>] [-tokenUsageCount <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### adbMfaCaching
```
Set-SIASetting [-adbMfaCaching] [-isMfaCachingEnabled <Boolean>] [-keyExpirationTimeSec <Int32>]
 [-clientIpEnforced <Boolean>] [-tokenUsageCount <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### k8sMfaCaching
```
Set-SIASetting [-k8sMfaCaching] [-keyExpirationTimeSec <Int32>] [-clientIpEnforced <Boolean>]
 [-tokenUsageCount <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### sshCommandAudit
```
Set-SIASetting [-sshCommandAudit] [-isCommandParsingForAuditEnabled <Boolean>] [-shellPromptForAudit <String>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### standingAccess
```
Set-SIASetting [-standingAccess] [-standingAccessAvailable <Boolean>] [-sessionMaxDuration <Int32>]
 [-sessionIdleTime <Int32>] [-fingerprintValidation <Boolean>] [-sshStandingAccessAvailable <Boolean>]
 [-rdpStandingAccessAvailable <Boolean>] [-adbStandingAccessAvailable <Boolean>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### rdpFileTransfer
```
Set-SIASetting [-rdpFileTransfer] [-enabled <Boolean>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### certificateValidation
```
Set-SIASetting [-certificateValidation] [-enabled <Boolean>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### rdpKeyboardLayout
```
Set-SIASetting [-rdpKeyboardLayout] [-layout <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### rdpRecording
```
Set-SIASetting [-rdpRecording] [-enabled <Boolean>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Enable, disable, or set values for SIA settings.

## EXAMPLES

### Example 1
```
Set-SIASetting -sshMfaCaching -isMfaCachingEnabled $true -keyExpirationTimeSec 7200
```

Enables SSH MFA Caching and sets timeout for 7200 seconds

### Example 2
```
Set-SIASetting -rdpRecording -enabled $false
```

Disables RDP recording

### Example 3
```
Set-SIASetting -rdpFileTransfer -enabled $true
```

Enables RDP file transfer

## PARAMETERS

### -adbMfaCaching
Switch parameter to interface with settings related to databases

```yaml
Type: SwitchParameter
Parameter Sets: adbMfaCaching
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -adbStandingAccessAvailable
Switch parameter to interface with settings related to standing access for databases

```yaml
Type: Boolean
Parameter Sets: standingAccess
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -certificateValidation
Switch parameter to interface with settings related to certificate validation

```yaml
Type: SwitchParameter
Parameter Sets: certificateValidation
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -clientIpEnforced
Specify if client IP is enforced

```yaml
Type: Boolean
Parameter Sets: rdpMfaCaching, adbMfaCaching, k8sMfaCaching
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -enabled
Specify if setting is enabled or disabled

```yaml
Type: Boolean
Parameter Sets: rdpFileTransfer, certificateValidation, rdpRecording
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -fingerprintValidation
Specify if fingerprint validation is enabled

```yaml
Type: Boolean
Parameter Sets: standingAccess
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -isCommandParsingForAuditEnabled
Specify if command parsing is enabled

```yaml
Type: Boolean
Parameter Sets: sshCommandAudit
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -isMfaCachingEnabled
Specify if MFA caching is enabled

```yaml
Type: Boolean
Parameter Sets: mfaCaching, sshMfaCaching, rdpMfaCaching, adbMfaCaching
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -k8sMfaCaching
Switch parameter to interface with settings related to kubernetes MFA caching

```yaml
Type: SwitchParameter
Parameter Sets: k8sMfaCaching
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -keyExpirationTimeSec
Specify MFA caching key expiration

```yaml
Type: Int32
Parameter Sets: mfaCaching, sshMfaCaching, rdpMfaCaching, adbMfaCaching, k8sMfaCaching
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -layout
Specify keyboard layout for RDP connections

```yaml
Type: String
Parameter Sets: rdpKeyboardLayout
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -mfaCaching
Switch parameter to interface with settings related to MFA caching

```yaml
Type: SwitchParameter
Parameter Sets: mfaCaching
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -rdpFileTransfer
Specify if file transfer over rdp is enabled or not

```yaml
Type: SwitchParameter
Parameter Sets: rdpFileTransfer
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -rdpKeyboardLayout
Switch parameter to interface with settings related to RDP keyboard layout

```yaml
Type: SwitchParameter
Parameter Sets: rdpKeyboardLayout
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -rdpMfaCaching
Switch parameter to interface with settings related to RDP MFA caching

```yaml
Type: SwitchParameter
Parameter Sets: rdpMfaCaching
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -rdpRecording
Switch parameter to interface with settings related to RDP recording

```yaml
Type: SwitchParameter
Parameter Sets: rdpRecording
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -rdpStandingAccessAvailable
Specify if RDP standing access is enabled and available

```yaml
Type: Boolean
Parameter Sets: standingAccess
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -sessionIdleTime
Specify session idle time

```yaml
Type: Int32
Parameter Sets: standingAccess
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -sessionMaxDuration
Specify maximum session duration

```yaml
Type: Int32
Parameter Sets: standingAccess
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -shellPromptForAudit
Specify SSH prompt for audit capability

```yaml
Type: String
Parameter Sets: sshCommandAudit
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -sshCommandAudit
Switch parameter to interface with settings related to SSH command audit

```yaml
Type: SwitchParameter
Parameter Sets: sshCommandAudit
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -sshMfaCaching
Switch parameter to interface with settings related to SSH MFA caching

```yaml
Type: SwitchParameter
Parameter Sets: sshMfaCaching
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -sshStandingAccessAvailable
Specify if SSH standing access if available

```yaml
Type: Boolean
Parameter Sets: standingAccess
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -standingAccess
Switch parameter to interface with settings related to standing access

```yaml
Type: SwitchParameter
Parameter Sets: standingAccess
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -standingAccessAvailable
Specify if standing access is enabled and available

```yaml
Type: Boolean
Parameter Sets: standingAccess
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -tokenUsageCount
Specify the number of times an MFA caching token can be used

```yaml
Type: Int32
Parameter Sets: rdpMfaCaching, adbMfaCaching, k8sMfaCaching
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
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
Default value: False
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
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Management.Automation.SwitchParameter
### System.Boolean
### System.Int32
### System.String
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
