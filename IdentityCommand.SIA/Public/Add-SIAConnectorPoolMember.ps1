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

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/connectors/connector-pools/$connector_pool_id"

        #Create Request Body (ConvertTo-SIAJsonBody keeps a single connector id a one-element JSON array)
        $body = ConvertTo-SIAJsonBody -Body @{
            connectors = @($connectorId | ForEach-Object { @{ connectorId = $PSItem } })
        }

        if ($PSCmdlet.ShouldProcess($connector_pool_id, 'Assign connectors to SIA Connector Pool')) {

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body $body

            if ($null -ne $result) {

                $result

            }

        }

    }#process

    end { }#end

}
