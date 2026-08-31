# .ExternalHelp IdentityCommand.SIA-help.xml
function Set-SIASetting {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Parameters are consumed via $PSBoundParameters / ParameterSetName')]
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true, ParameterSetName = 'mfaCaching')]
        [switch]$mfaCaching,

        [parameter(Mandatory = $true, ParameterSetName = 'sshMfaCaching')]
        [switch]$sshMfaCaching,

        [parameter(Mandatory = $true, ParameterSetName = 'rdpMfaCaching')]
        [switch]$rdpMfaCaching,

        [parameter(Mandatory = $true, ParameterSetName = 'rdpTokenMfaCaching')]
        [switch]$rdpTokenMfaCaching,

        [parameter(Mandatory = $true, ParameterSetName = 'adbMfaCaching')]
        [switch]$adbMfaCaching,

        [parameter(Mandatory = $true, ParameterSetName = 'k8sMfaCaching')]
        [switch]$k8sMfaCaching,

        [parameter(Mandatory = $true, ParameterSetName = 'sshCommandAudit')]
        [switch]$sshCommandAudit,

        [parameter(Mandatory = $true, ParameterSetName = 'standingAccess')]
        [switch]$standingAccess,

        [parameter(Mandatory = $true, ParameterSetName = 'rdpFileTransfer')]
        [switch]$rdpFileTransfer,

        [parameter(Mandatory = $true, ParameterSetName = 'certificateValidation')]
        [switch]$certificateValidation,

        [parameter(Mandatory = $true, ParameterSetName = 'rdpKeyboardLayout')]
        [switch]$rdpKeyboardLayout,

        [parameter(Mandatory = $true, ParameterSetName = 'rdpRecording')]
        [switch]$rdpRecording,

        [parameter(Mandatory = $true, ParameterSetName = 'rdpTranscription')]
        [switch]$rdpTranscription,

        [parameter(Mandatory = $true, ParameterSetName = 'sshRecording')]
        [switch]$sshRecording,

        [parameter(Mandatory = $true, ParameterSetName = 'logonSequence')]
        [switch]$logonSequence,

        [parameter(Mandatory = $true, ParameterSetName = 'selfHostedPam')]
        [switch]$selfHostedPam,

        [parameter(Mandatory = $true, ParameterSetName = 'connectViaBrowser')]
        [switch]$connectViaBrowser,

        [parameter(Mandatory = $true, ParameterSetName = 'rdpFileSigning')]
        [switch]$rdpFileSigning,

        [parameter(Mandatory = $true, ParameterSetName = 'rdpKerberosAuthMode')]
        [switch]$rdpKerberosAuthMode,

        [parameter(Mandatory = $true, ParameterSetName = 'rdpChannels')]
        [switch]$rdpChannels,

        [parameter(Mandatory = $true, ParameterSetName = 'validateFingerprintForSshZeroStanding')]
        [switch]$validateFingerprintForSshZeroStanding,

        [parameter(Mandatory = $true, ParameterSetName = 'httpsRelay')]
        [switch]$httpsRelay,

        [parameter(Mandatory = $true, ParameterSetName = 'rdpFileParameters')]
        [switch]$rdpFileParameters,

        [parameter(Mandatory = $true, ParameterSetName = 'granularEnabled')]
        [switch]$granularEnabled,

        [parameter(Mandatory = $true, ParameterSetName = 'oracleOud')]
        [switch]$oracleOud,

        [parameter(Mandatory = $true, ParameterSetName = 'oracleConnectionProtocol')]
        [switch]$oracleConnectionProtocol,

        # --- MFA caching sub-settings ---
        [parameter(Mandatory = $false, ParameterSetName = 'mfaCaching')]
        [parameter(Mandatory = $false, ParameterSetName = 'sshMfaCaching')]
        [parameter(Mandatory = $false, ParameterSetName = 'rdpMfaCaching')]
        [parameter(Mandatory = $false, ParameterSetName = 'rdpTokenMfaCaching')]
        [parameter(Mandatory = $false, ParameterSetName = 'adbMfaCaching')]
        [bool]$isMfaCachingEnabled,

        [parameter(Mandatory = $false, ParameterSetName = 'mfaCaching')]
        [parameter(Mandatory = $false, ParameterSetName = 'sshMfaCaching')]
        [parameter(Mandatory = $false, ParameterSetName = 'rdpMfaCaching')]
        [parameter(Mandatory = $false, ParameterSetName = 'rdpTokenMfaCaching')]
        [parameter(Mandatory = $false, ParameterSetName = 'adbMfaCaching')]
        [parameter(Mandatory = $false, ParameterSetName = 'k8sMfaCaching')]
        [ValidateRange(300, 43200)]
        [int]$keyExpirationTimeSec,

        [parameter(Mandatory = $false, ParameterSetName = 'mfaCaching')]
        [parameter(Mandatory = $false, ParameterSetName = 'sshMfaCaching')]
        [parameter(Mandatory = $false, ParameterSetName = 'rdpMfaCaching')]
        [parameter(Mandatory = $false, ParameterSetName = 'rdpTokenMfaCaching')]
        [parameter(Mandatory = $false, ParameterSetName = 'adbMfaCaching')]
        [parameter(Mandatory = $false, ParameterSetName = 'k8sMfaCaching')]
        [bool]$clientIpEnforced,

        [parameter(Mandatory = $false, ParameterSetName = 'rdpMfaCaching')]
        [parameter(Mandatory = $false, ParameterSetName = 'rdpTokenMfaCaching')]
        [parameter(Mandatory = $false, ParameterSetName = 'adbMfaCaching')]
        [parameter(Mandatory = $false, ParameterSetName = 'k8sMfaCaching')]
        [int]$tokenUsageCount,

        # --- sshCommandAudit ---
        [parameter(Mandatory = $false, ParameterSetName = 'sshCommandAudit')]
        [bool]$isCommandParsingForAuditEnabled,

        [parameter(Mandatory = $false, ParameterSetName = 'sshCommandAudit')]
        [string]$shellPromptForAudit,

        # --- standingAccess ---
        [parameter(Mandatory = $false, ParameterSetName = 'standingAccess')]
        [bool]$standingAccessAvailable,

        [parameter(Mandatory = $false, ParameterSetName = 'standingAccess')]
        [ValidateRange(60, 1440)]
        [int]$sessionMaxDuration,

        [parameter(Mandatory = $false, ParameterSetName = 'standingAccess')]
        [ValidateRange(1, 120)]
        [int]$sessionIdleTime,

        [parameter(Mandatory = $false, ParameterSetName = 'standingAccess')]
        [bool]$fingerprintValidation,

        [parameter(Mandatory = $false, ParameterSetName = 'standingAccess')]
        [bool]$sshStandingAccessAvailable,

        [parameter(Mandatory = $false, ParameterSetName = 'standingAccess')]
        [bool]$rdpStandingAccessAvailable,

        [parameter(Mandatory = $false, ParameterSetName = 'standingAccess')]
        [bool]$adbStandingAccessAvailable,

        # --- shared "enabled" toggle ---
        [parameter(Mandatory = $false, ParameterSetName = 'rdpFileTransfer')]
        [parameter(Mandatory = $false, ParameterSetName = 'certificateValidation')]
        [parameter(Mandatory = $false, ParameterSetName = 'rdpRecording')]
        [parameter(Mandatory = $false, ParameterSetName = 'rdpTranscription')]
        [parameter(Mandatory = $false, ParameterSetName = 'sshRecording')]
        [parameter(Mandatory = $false, ParameterSetName = 'connectViaBrowser')]
        [parameter(Mandatory = $false, ParameterSetName = 'rdpFileSigning')]
        [parameter(Mandatory = $false, ParameterSetName = 'validateFingerprintForSshZeroStanding')]
        [parameter(Mandatory = $false, ParameterSetName = 'oracleOud')]
        [bool]$enabled,

        # --- rdpKeyboardLayout ---
        [parameter(Mandatory = $false, ParameterSetName = 'rdpKeyboardLayout')]
        [string]$layout,

        # --- logonSequence ---
        [parameter(Mandatory = $false, ParameterSetName = 'logonSequence')]
        [string]$logonSequenceValue,

        [parameter(Mandatory = $false, ParameterSetName = 'logonSequence')]
        [bool]$alwaysUseSia,

        # --- selfHostedPam ---
        [parameter(Mandatory = $false, ParameterSetName = 'selfHostedPam')]
        [string]$tenantType,

        [parameter(Mandatory = $false, ParameterSetName = 'selfHostedPam')]
        [string]$connectorPoolId,

        [parameter(Mandatory = $false, ParameterSetName = 'selfHostedPam')]
        [string]$pvwaBaseUrl,

        [parameter(Mandatory = $false, ParameterSetName = 'selfHostedPam')]
        [string]$serviceUserSecretId,

        [parameter(Mandatory = $false, ParameterSetName = 'selfHostedPam')]
        [bool]$isIpBasedLbEnabled,

        # --- rdpFileSigning ---
        [parameter(Mandatory = $false, ParameterSetName = 'rdpFileSigning')]
        [string]$pfxSecretId,

        # --- rdpKerberosAuthMode ---
        [parameter(Mandatory = $false, ParameterSetName = 'rdpKerberosAuthMode')]
        [string]$authMode,

        # --- rdpChannels ---
        [parameter(Mandatory = $false, ParameterSetName = 'rdpChannels')]
        [bool]$gfxChannelEnabled,

        # --- httpsRelay ---
        [parameter(Mandatory = $false, ParameterSetName = 'httpsRelay')]
        [bool]$isHttpsRelayEnabled,

        [parameter(Mandatory = $false, ParameterSetName = 'httpsRelay')]
        [string]$relayHost,

        [parameter(Mandatory = $false, ParameterSetName = 'httpsRelay')]
        [int]$sshRelayPort,

        # --- rdpFileParameters ---
        [parameter(Mandatory = $false, ParameterSetName = 'rdpFileParameters')]
        [bool]$disableCredentialsDelegation,

        # --- granularEnabled ---
        [parameter(Mandatory = $false, ParameterSetName = 'granularEnabled')]
        [bool]$isGranularEnabled,

        # --- oracleOud ---
        [parameter(Mandatory = $false, ParameterSetName = 'oracleOud')]
        [int]$oudPort,

        # --- oracleConnectionProtocol ---
        [parameter(Mandatory = $false, ParameterSetName = 'oracleConnectionProtocol')]
        [string]$targetProtocolType
    )

    BEGIN {
        #All feature switch names - removed from the projected body, the active one becomes the feature key
        $FeatureNames = @(
            'mfaCaching', 'sshMfaCaching', 'rdpMfaCaching', 'rdpTokenMfaCaching', 'adbMfaCaching', 'k8sMfaCaching',
            'sshCommandAudit', 'standingAccess', 'rdpFileTransfer', 'certificateValidation', 'rdpKeyboardLayout',
            'rdpRecording', 'rdpTranscription', 'sshRecording', 'logonSequence', 'selfHostedPam', 'connectViaBrowser',
            'rdpFileSigning', 'rdpKerberosAuthMode', 'rdpChannels', 'validateFingerprintForSshZeroStanding', 'httpsRelay',
            'rdpFileParameters', 'granularEnabled', 'oracleOud', 'oracleConnectionProtocol'
        )
    }#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/api/settings/"

        $FeatureName = $PSCmdlet.ParameterSetName

        #Project the bound sub-settings, dropping the feature switches
        $Settings = $PSBoundParameters | Get-Parameter -ParametersToRemove $FeatureNames

        #The API field is "logonSequence" but the parameter is renamed to avoid clashing with the switch
        if ($Settings.ContainsKey('logonSequenceValue')) {
            $Settings['logonSequence'] = $Settings['logonSequenceValue']
            $Settings.Remove('logonSequenceValue')
        }

        #Partial update - send only the target feature with only the supplied sub-settings
        $body = [ordered]@{ $FeatureName = $Settings } | ConvertTo-Json -Depth 4

        if ($PSCmdlet.ShouldProcess($FeatureName, 'Set SIA Setting')) {

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method PATCH -Body $body

            if ($null -ne $result) {

                $result

            }

        }

    }#process

    END {

    }#end

}
