# .ExternalHelp IdentityCommand.SIA-help.xml
function Invoke-SIASSHPublicKeyRotation {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'False Positive')]
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'generate-new')]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'generate-new'
        )]
        [switch]$GenerateNew,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'deactivate-previous'
        )]
        [switch]$DeactivatePrevious,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'reactivate-previous'
        )]
        [switch]$ReactivatePrevious
    )

    begin { }#begin

    process {

        #Parameterset name is the url path to send the request to.
        $URI = "$($ISPSSSession.tenant_url)/api/public-keys/rotation/$($PSCmdlet.ParameterSetName)"

        if ($PSCmdlet.ShouldProcess('SSH CA Public Key', "Invoke Rotation Operation '$($PSCmdlet.ParameterSetName)'")) {

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method POST

            if ($null -ne $result) {

                $result

            }

        }

    }#process

    end { }#end

}
