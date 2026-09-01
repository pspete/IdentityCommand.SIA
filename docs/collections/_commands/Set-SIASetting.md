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
Set-SIASetting [-mfaCaching] [-isMfaCachingEnabled <Boolean>] [-keyExpirationTimeSec <Int32>]
 [-clientIpEnforced <Boolean>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### sshMfaCaching
```
Set-SIASetting [-sshMfaCaching] [-isMfaCachingEnabled <Boolean>] [-keyExpirationTimeSec <Int32>]
 [-clientIpEnforced <Boolean>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### rdpMfaCaching
```
Set-SIASetting [-rdpMfaCaching] [-isMfaCachingEnabled <Boolean>] [-keyExpirationTimeSec <Int32>]
 [-clientIpEnforced <Boolean>] [-tokenUsageCount <Int32>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### rdpTokenMfaCaching
```
Set-SIASetting [-rdpTokenMfaCaching] [-isMfaCachingEnabled <Boolean>] [-keyExpirationTimeSec <Int32>]
 [-clientIpEnforced <Boolean>] [-tokenUsageCount <Int32>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### adbMfaCaching
```
Set-SIASetting [-adbMfaCaching] [-isMfaCachingEnabled <Boolean>] [-keyExpirationTimeSec <Int32>]
 [-clientIpEnforced <Boolean>] [-tokenUsageCount <Int32>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
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
 [-rdpStandingAccessAvailable <Boolean>] [-adbStandingAccessAvailable <Boolean>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### rdpFileTransfer
```
Set-SIASetting [-rdpFileTransfer] [-enabled <Boolean>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### certificateValidation
```
Set-SIASetting [-certificateValidation] [-enabled <Boolean>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### rdpKeyboardLayout
```
Set-SIASetting [-rdpKeyboardLayout] [-layout <String>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### rdpRecording
```
Set-SIASetting [-rdpRecording] [-enabled <Boolean>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### rdpTranscription
```
Set-SIASetting [-rdpTranscription] [-enabled <Boolean>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### sshRecording
```
Set-SIASetting [-sshRecording] [-enabled <Boolean>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### logonSequence
```
Set-SIASetting [-logonSequence] [-logonSequenceValue <String>] [-alwaysUseSia <Boolean>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### selfHostedPam
```
Set-SIASetting [-selfHostedPam] [-tenantType <String>] [-connectorPoolId <String>] [-pvwaBaseUrl <String>]
 [-serviceUserSecretId <String>] [-isIpBasedLbEnabled <Boolean>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### connectViaBrowser
```
Set-SIASetting [-connectViaBrowser] [-enabled <Boolean>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### rdpFileSigning
```
Set-SIASetting [-rdpFileSigning] [-enabled <Boolean>] [-pfxSecretId <String>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### rdpKerberosAuthMode
```
Set-SIASetting [-rdpKerberosAuthMode] [-authMode <String>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### rdpChannels
```
Set-SIASetting [-rdpChannels] [-gfxChannelEnabled <Boolean>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### validateFingerprintForSshZeroStanding
```
Set-SIASetting [-validateFingerprintForSshZeroStanding] [-enabled <Boolean>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### httpsRelay
```
Set-SIASetting [-httpsRelay] [-isHttpsRelayEnabled <Boolean>] [-relayHost <String>] [-sshRelayPort <Int32>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### rdpFileParameters
```
Set-SIASetting [-rdpFileParameters] [-disableCredentialsDelegation <Boolean>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### granularEnabled
```
Set-SIASetting [-granularEnabled] [-isGranularEnabled <Boolean>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### oracleOud
```
Set-SIASetting [-oracleOud] [-enabled <Boolean>] [-oudPort <Int32>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### oracleConnectionProtocol
```
Set-SIASetting [-oracleConnectionProtocol] [-targetProtocolType <String>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Enable, disable, or set values for SIA settings.

Each invocation targets a single settings feature (selected by the switch parameter) and performs a partial update - only the sub-settings you supply are sent to the API (`PATCH /api/settings/`); any sub-settings you omit are left unchanged.

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

### Example 4
```
Set-SIASetting -validateFingerprintForSshZeroStanding -enabled $true
```

Enables SSH host key fingerprint validation for zero standing access

### Example 5
```
Set-SIASetting -standingAccess -sessionIdleTime 20
```

Sets the standing access session idle time to 20 minutes, leaving all other standing access sub-settings unchanged

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
Accept pipeline input: False
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
Accept pipeline input: False
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
Accept pipeline input: False
Accept wildcard characters: False
```

### -clientIpEnforced
Specify if client IP is enforced

```yaml
Type: Boolean
Parameter Sets: mfaCaching, sshMfaCaching, rdpMfaCaching, rdpTokenMfaCaching, adbMfaCaching, k8sMfaCaching
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -enabled
Specify if setting is enabled or disabled

```yaml
Type: Boolean
Parameter Sets: rdpFileTransfer, certificateValidation, rdpRecording, rdpTranscription, sshRecording, connectViaBrowser, rdpFileSigning, validateFingerprintForSshZeroStanding, oracleOud
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
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
Accept pipeline input: False
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
Accept pipeline input: False
Accept wildcard characters: False
```

### -isMfaCachingEnabled
Specify if MFA caching is enabled

```yaml
Type: Boolean
Parameter Sets: mfaCaching, sshMfaCaching, rdpMfaCaching, rdpTokenMfaCaching, adbMfaCaching
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
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
Accept pipeline input: False
Accept wildcard characters: False
```

### -keyExpirationTimeSec
Specify the MFA caching key expiration, in seconds.
Accepts 300 - 43200 (the UI equivalent is 5 - 720 minutes).

```yaml
Type: Int32
Parameter Sets: mfaCaching, sshMfaCaching, rdpMfaCaching, rdpTokenMfaCaching, adbMfaCaching, k8sMfaCaching
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
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
Accept pipeline input: False
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
Accept pipeline input: False
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
Accept pipeline input: False
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
Accept pipeline input: False
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
Accept pipeline input: False
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
Accept pipeline input: False
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
Accept pipeline input: False
Accept wildcard characters: False
```

### -sessionIdleTime
Specify the idle session timeout, in minutes.
Accepts 1 - 120.

```yaml
Type: Int32
Parameter Sets: standingAccess
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -sessionMaxDuration
Specify the maximum session duration, in minutes.
Accepts 60 - 1440 (the UI equivalent is 1 - 24 hours). Only relevant for vaulted credentials access.

```yaml
Type: Int32
Parameter Sets: standingAccess
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -shellPromptForAudit
Specify the shell prompt pattern used for SSH command audit parsing. Accepts up to 1024 characters.

```yaml
Type: String
Parameter Sets: sshCommandAudit
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
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
Accept pipeline input: False
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
Accept pipeline input: False
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
Accept pipeline input: False
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
Accept pipeline input: False
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
Accept pipeline input: False
Accept wildcard characters: False
```

### -tokenUsageCount
Specify the number of times an MFA caching token can be used

```yaml
Type: Int32
Parameter Sets: rdpMfaCaching, rdpTokenMfaCaching, adbMfaCaching, k8sMfaCaching
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
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

### -alwaysUseSia
Specify if SIA is always used when applying the logon sequence

```yaml
Type: Boolean
Parameter Sets: logonSequence
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -authMode
Specify the RDP Kerberos authentication mode

```yaml
Type: String
Parameter Sets: rdpKerberosAuthMode
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -connectorPoolId
Specify the connector pool id used for self-hosted PAM

```yaml
Type: String
Parameter Sets: selfHostedPam
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -connectViaBrowser
Switch parameter to interface with settings related to connecting via browser

```yaml
Type: SwitchParameter
Parameter Sets: connectViaBrowser
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -disableCredentialsDelegation
Specify if credentials delegation is disabled in the generated RDP file

```yaml
Type: Boolean
Parameter Sets: rdpFileParameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -gfxChannelEnabled
Specify if the RDP graphics channel is enabled

```yaml
Type: Boolean
Parameter Sets: rdpChannels
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -granularEnabled
Switch parameter to interface with settings related to granular access

```yaml
Type: SwitchParameter
Parameter Sets: granularEnabled
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -httpsRelay
Switch parameter to interface with settings related to the HTTPS relay

```yaml
Type: SwitchParameter
Parameter Sets: httpsRelay
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -isGranularEnabled
Specify if granular access is enabled

```yaml
Type: Boolean
Parameter Sets: granularEnabled
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -isHttpsRelayEnabled
Specify if the HTTPS relay is enabled

```yaml
Type: Boolean
Parameter Sets: httpsRelay
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -isIpBasedLbEnabled
Specify if IP based load balancing is enabled for self-hosted PAM

```yaml
Type: Boolean
Parameter Sets: selfHostedPam
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -logonSequence
Switch parameter to interface with settings related to the logon sequence

```yaml
Type: SwitchParameter
Parameter Sets: logonSequence
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -logonSequenceValue
Specify the logon sequence string (sent to the API as the logonSequence value). Accepts up to 30000 characters; pass an empty string to clear it.

```yaml
Type: String
Parameter Sets: logonSequence
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -oracleConnectionProtocol
Switch parameter to interface with settings related to the Oracle connection protocol

```yaml
Type: SwitchParameter
Parameter Sets: oracleConnectionProtocol
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -oracleOud
Switch parameter to interface with settings related to Oracle Unified Directory (OUD)

```yaml
Type: SwitchParameter
Parameter Sets: oracleOud
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -oudPort
Specify the Oracle Unified Directory port

```yaml
Type: Int32
Parameter Sets: oracleOud
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -pfxSecretId
Specify the secret id of the PFX certificate used to sign generated RDP files

```yaml
Type: String
Parameter Sets: rdpFileSigning
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -pvwaBaseUrl
Specify the PVWA base URL used for self-hosted PAM

```yaml
Type: String
Parameter Sets: selfHostedPam
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -rdpChannels
Switch parameter to interface with settings related to RDP channels

```yaml
Type: SwitchParameter
Parameter Sets: rdpChannels
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -rdpFileParameters
Switch parameter to interface with settings related to generated RDP file parameters

```yaml
Type: SwitchParameter
Parameter Sets: rdpFileParameters
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -rdpFileSigning
Switch parameter to interface with settings related to RDP file signing

```yaml
Type: SwitchParameter
Parameter Sets: rdpFileSigning
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -rdpKerberosAuthMode
Switch parameter to interface with settings related to the RDP Kerberos authentication mode

```yaml
Type: SwitchParameter
Parameter Sets: rdpKerberosAuthMode
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -rdpTokenMfaCaching
Switch parameter to interface with settings related to RDP token MFA caching

```yaml
Type: SwitchParameter
Parameter Sets: rdpTokenMfaCaching
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -rdpTranscription
Switch parameter to interface with settings related to RDP session transcription

```yaml
Type: SwitchParameter
Parameter Sets: rdpTranscription
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -relayHost
Specify the HTTPS relay host

```yaml
Type: String
Parameter Sets: httpsRelay
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -selfHostedPam
Switch parameter to interface with settings related to self-hosted PAM

```yaml
Type: SwitchParameter
Parameter Sets: selfHostedPam
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -serviceUserSecretId
Specify the service user secret id used for self-hosted PAM

```yaml
Type: String
Parameter Sets: selfHostedPam
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -sshRecording
Switch parameter to interface with settings related to SSH session recording

```yaml
Type: SwitchParameter
Parameter Sets: sshRecording
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -sshRelayPort
Specify the SSH relay port

```yaml
Type: Int32
Parameter Sets: httpsRelay
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -targetProtocolType
Specify the Oracle target connection protocol type

```yaml
Type: String
Parameter Sets: oracleConnectionProtocol
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -tenantType
Specify the tenant type used for self-hosted PAM

```yaml
Type: String
Parameter Sets: selfHostedPam
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -validateFingerprintForSshZeroStanding
Switch parameter to interface with settings related to SSH host key fingerprint validation for zero standing access

```yaml
Type: SwitchParameter
Parameter Sets: validateFingerprintForSshZeroStanding
Aliases:

Required: True
Position: Named
Default value: None
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
