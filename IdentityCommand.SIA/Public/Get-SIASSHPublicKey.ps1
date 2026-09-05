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

        $URI = "$($ISPSSSession.tenant_url)/api/public-keys"

        $boundparameters = $PSBoundParameters | Get-Parameter -ParametersToRemove deploymentScript, AWS, AZURE, GCP, OnPrem

        if ($null -eq $boundparameters) {
            $boundparameters = @{ }
        }

        $boundparameters.Add('workspaceType', $PSCmdlet.ParameterSetName)

        $QueryString = $($boundparameters | ConvertTo-QueryString)

        If ($deploymentScript.IsPresent) {
            $URI = "$URI/scripts"
        }

        $URI = "$URI`?$QueryString"

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