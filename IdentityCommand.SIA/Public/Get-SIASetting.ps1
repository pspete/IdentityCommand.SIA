# .ExternalHelp IdentityCommand.SIA-help.xml
function Get-SIASetting {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('mfaCaching', 'sshMfaCaching', 'rdpMfaCaching', 'rdpTokenMfaCaching', 'adbMfaCaching', 'k8sMfaCaching',
            'sshCommandAudit', 'standingAccess', 'rdpFileTransfer', 'certificateValidation', 'rdpKeyboardLayout', 'rdpRecording',
            'rdpTranscription', 'sshRecording', 'logonSequence', 'selfHostedPam', 'connectViaBrowser', 'rdpFileSigning',
            'rdpKerberosAuthMode', 'rdpChannels', 'validateFingerprintForSshZeroStanding', 'httpsRelay', 'rdpFileParameters',
            'granularEnabled', 'oracleOud', 'oracleConnectionProtocol')]
        [String]$FeatureName
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/settings/$FeatureName"

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method GET

        if ($null -ne $result) {

            switch ($PSBoundParameters.Keys) {

                'FeatureName' { $result = $result | Select-Object -ExpandProperty $FeatureName }

            }

            $result

        }

    }#process

    end {

    }#end

}