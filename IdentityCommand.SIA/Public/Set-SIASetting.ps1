# .ExternalHelp IdentityCommand.SIA-help.xml
function Set-SIASetting {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'False Positive')]
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'mfaCaching'
        )]
        [switch]$mfaCaching,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'sshMfaCaching'
        )]
        [switch]$sshMfaCaching,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'rdpMfaCaching'
        )]
        [switch]$rdpMfaCaching,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'adbMfaCaching'
        )]
        [switch]$adbMfaCaching,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'k8sMfaCaching'
        )]
        [switch]$k8sMfaCaching,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'sshCommandAudit'
        )]
        [switch]$sshCommandAudit,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'standingAccess'
        )]
        [switch]$standingAccess,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'rdpFileTransfer'
        )]
        [switch]$rdpFileTransfer,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'certificateValidation'
        )]
        [switch]$certificateValidation,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'rdpKeyboardLayout'
        )]
        [switch]$rdpKeyboardLayout,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'rdpRecording'
        )]
        [switch]$rdpRecording,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'mfaCaching'
        )]
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'sshMfaCaching'
        )]
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'rdpMfaCaching'
        )]
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'adbMfaCaching'
        )]
        [bool]$isMfaCachingEnabled,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'mfaCaching'
        )]
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'sshMfaCaching'
        )]
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'rdpMfaCaching'
        )]
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'adbMfaCaching'
        )]
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'k8sMfaCaching'
        )]
        [int]$keyExpirationTimeSec,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'rdpMfaCaching'
        )]
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'adbMfaCaching'
        )]
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'k8sMfaCaching'
        )]
        [bool]$clientIpEnforced,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'rdpMfaCaching'
        )]
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'adbMfaCaching'
        )]
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'k8sMfaCaching'
        )]
        [int]$tokenUsageCount,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'sshCommandAudit'
        )]
        [bool]$isCommandParsingForAuditEnabled,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'sshCommandAudit'
        )]
        [string]$shellPromptForAudit,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'standingAccess'
        )]
        [bool]$standingAccessAvailable,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'standingAccess'
        )]
        [int]$sessionMaxDuration,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'standingAccess'
        )]
        [int]$sessionIdleTime,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'standingAccess'
        )]
        [bool]$fingerprintValidation,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'standingAccess'
        )]
        [bool]$sshStandingAccessAvailable,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'standingAccess'
        )]
        [bool]$rdpStandingAccessAvailable,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'standingAccess'
        )]
        [bool]$adbStandingAccessAvailable,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'rdpFileTransfer'
        )]
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'certificateValidation'
        )]
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'rdpRecording'
        )]
        [bool]$enabled,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'rdpKeyboardLayout'
        )]
        [string]$layout

    )

    BEGIN {
        $OrderedProperties = [ordered]@{
            'mfaCaching'            = $null
            'sshMfaCaching'         = $null
            'rdpMfaCaching'         = $null
            'adbMfaCaching'         = $null
            'k8sMfaCaching'         = $null
            'sshCommandAudit'       = $null
            'standingAccess'        = $null
            'rdpFileTransfer'       = $null
            'certificateValidation' = $null
            'rdpKeyboardLayout'     = $null
            'rdpRecording'          = $null
        }
    }#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/api/settings/"

        #Get existing policy settings
        $PolicySettings = Get-SIASetting

        #Get request parameters
        $boundParameters = $PSBoundParameters | Get-Parameter -ParametersToRemove mfaCaching, sshMfaCaching, rdpMfaCaching, adbMfaCaching,
        k8sMfaCaching, sshCommandAudit, standingAccess, rdpFileTransfer, certificateValidation, rdpKeyboardLayout, rdpRecording

        $OrderedProperties.keys | ForEach-Object {

            $Properties = [ordered]@{ }

        } {

            #ParameterSet match
            If ($PSCmdlet.ParameterSetName -eq $PSItem) {

                $ParameterSetName = $PSItem

                $Properties.Add($ParameterSetName, @{})

                #Command is Updating related Setting(s) for ParameterSetName
                $PolicySettings.$ParameterSetName.PSObject.Properties.Name | ForEach-Object {

                    #Iterate setting names, match against function parameters
                    if ($boundParameters.ContainsKey($PSItem)) {
                        #setting is being updated
                        $Properties.$ParameterSetName.Add($PSItem, $boundParameters[$PSItem])
                    } else {
                        #use existing value
                        $Properties.$ParameterSetName.Add($PSItem, $PolicySettings.$ParameterSetName.$PSItem)
                    }
                }

            } Else {
                #Send existing setting values
                $Properties.Add($PSItem, $PolicySettings.$PSItem)
            }

        } {
            #Create Request Body
            $body = $Properties | ConvertTo-Json
        }

        if ($PSCmdlet.ShouldProcess($PSCmdlet.ParameterSetName, 'Set SIA Setting')) {
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