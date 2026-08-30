# .ExternalHelp IdentityCommand.SIA-help.xml
function Add-SIAConnectorPoolMember {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$connector_pool_id,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String[]]$connectorId
    )

    BEGIN { }#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/api/connectors/connector-pools/$connector_pool_id"

        #Create Request Body
        $requestBody = @{
            'connectors' = @($connectorId | ForEach-Object { @{'connectorId' = $PSItem } })
        }

        $body = $requestBody | ConvertTo-Json -Depth 4

        if ($PSCmdlet.ShouldProcess($connector_pool_id, 'Assign connectors to SIA Connector Pool')) {

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body $body

            if ($null -ne $result) {

                $result

            }

        }

    }#process

    END { }#end

}
