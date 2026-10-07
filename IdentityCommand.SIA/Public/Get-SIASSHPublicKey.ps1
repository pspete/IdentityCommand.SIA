# .ExternalHelp IdentityCommand.SIA-help.xml
function Get-SIASSHPublicKey {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'AWS'
        )]
        [switch]$AWS,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'AZURE'
        )]
        [switch]$Azure,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'ON-PREMISE'
        )]
        [switch]$OnPrem,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'GCP'
        )]
        [switch]$GCP,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'AWS'
        )]
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'AZURE'
        )]
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'GCP'
        )]
        [Alias('subscription_id')]
        [String]$workspaceId,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [switch]$deploymentScript
    )

    begin { }#begin

    process {

        #TODO the published SIA SSH public keys API spec documents no parameters on GET /public-keys,
        #and only scriptType (BASH|KORN_SHELL) on GET /public-keys/scripts - suggesting the service
        #moved from a key per workspace to a single tenant wide CA key. This command still requires a
        #workspace type switch and workspaceId, and sends both as query parameters. Confirm against a
        #tenant whether they are still accepted: aligning to the spec drops mandatory parameters and
        #is a breaking change, so it is not being done on the strength of the spec alone.
        $URI = "$($ISPSSSession.tenant_url)/api/public-keys"

        $boundparameters = $PSBoundParameters | Get-Parameter -ParametersToRemove deploymentScript, AWS, AZURE, GCP, OnPrem

        if ($null -eq $boundparameters) {
            $boundparameters = @{ }
        }

        $boundparameters.Add('workspaceType', $PSCmdlet.ParameterSetName)

        If ($deploymentScript.IsPresent) {
            $URI = "$URI/scripts"
        }

        $URI = Add-QueryString -URI $URI -Parameter $boundparameters

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method GET

        if ($null -ne $result) {

            If ($deploymentScript.IsPresent) {
                $result = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($result.base64_cmd))
            }

            $result

        }

    }#process

    end {

    }#end

}