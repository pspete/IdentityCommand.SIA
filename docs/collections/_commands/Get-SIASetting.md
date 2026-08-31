---
external help file: IdentityCommand.SIA-help.xml
Module Name: IdentityCommand.SIA
online version:
schema: 2.0.0
---

# Get-SIASetting

## SYNOPSIS
Get SIA settings

## SYNTAX

```
Get-SIASetting [[-FeatureName] <String>] [<CommonParameters>]
```

## DESCRIPTION
Return details of SIA setting values

## EXAMPLES

### Example 1
```
Get-SIASetting
```

Return all SIA settings

### Example 2
```
Get-SIASetting -FeatureName rdpKeyboardLayout
```

Return setting values relating to RDP keyboard layout

## PARAMETERS

### -FeatureName
The name of the SIA feature to return setting values for

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: mfaCaching, sshMfaCaching, rdpMfaCaching, rdpTokenMfaCaching, adbMfaCaching, k8sMfaCaching, sshCommandAudit, standingAccess, rdpFileTransfer, certificateValidation, rdpKeyboardLayout, rdpRecording, rdpTranscription, sshRecording, logonSequence, selfHostedPam, connectViaBrowser, rdpFileSigning, rdpKerberosAuthMode, rdpChannels, validateFingerprintForSshZeroStanding, httpsRelay, rdpFileParameters, granularEnabled, oracleOud, oracleConnectionProtocol

Required: False
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
