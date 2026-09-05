# .ExternalHelp IdentityCommand.SIA-help.xml
function Update-SIAConnector {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [Alias('id')]
        [String]$connector_id
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/connectors/$connector_id/upgrade"

        #The API requires an (empty) JSON body
        $body = '{}'

        if ($PSCmdlet.ShouldProcess($connector_id, 'Upgrade SIA Connector')) {

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body $body

            if ($null -ne $result) {

                $result

            }

        }

    }#process

    end { }#end

}
