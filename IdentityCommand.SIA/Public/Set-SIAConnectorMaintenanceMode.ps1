# .ExternalHelp IdentityCommand.SIA-help.xml
function Set-SIAConnectorMaintenanceMode {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [Alias('id')]
        [String]$connector_id,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [bool]$maintenance
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/connectors/$connector_id/maintenance"

        #Create Request Body
        $body = @{'maintenance' = $maintenance } | ConvertTo-Json

        if ($PSCmdlet.ShouldProcess($connector_id, "Set SIA Connector Maintenance Mode to '$maintenance'")) {

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method PUT -Body $body

            if ($null -ne $result) {

                $result

            }

        }

    }#process

    end { }#end

}
