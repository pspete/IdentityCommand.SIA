# .ExternalHelp IdentityCommand.SIA-help.xml
function Get-SIASession {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [datetime]$minStartedTime,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [datetime]$maxStartedTime
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/monitoring/sessions"

        $boundparameters = $PSBoundParameters | Get-Parameter

        #If no arguments initialise boundparameters
        if ($null -eq $boundparameters) {
            $boundparameters = @{ }
        }

        #Max Time UTC
        If ($PSBoundParameters.ContainsKey('maxStartedTime')) {
            $MaxDate = (Get-Date $maxStartedTime).ToUniversalTime()
        } Else {
            #MaxTime is now
            $MaxDate = (Get-Date).ToUniversalTime()
        }
        #Min Time UTC
        If ($PSBoundParameters.ContainsKey('minStartedTime')) {
            $MinDate = (Get-Date $minStartedTime).ToUniversalTime()
        } Else {
            #Min Time is MaxTime - 24 hours
            $MinDate = (Get-Date $MaxDate).AddDays(-1).ToUniversalTime()
        }

        #Format maxStartedTime & minStartedTime
        $boundParameters['maxStartedTime'] = (Get-Date $MaxDate -UFormat '+%Y-%m-%dT%H:%M:%S.000Z').ToString()
        $boundParameters['minStartedTime'] = (Get-Date $MinDate -UFormat '+%Y-%m-%dT%H:%M:%S.000Z').ToString()

        $QueryString = $($boundparameters | ConvertTo-QueryString)

        $URI = "$URI`?$QueryString"

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method GET

        if ($null -ne $result) {

            #TODO offset query parameter name assumed to match the other list endpoints -
            #not yet confirmed against a tenant with more than one page of sessions.
            Get-SIAPagedResult -InitialResult $result -URI $URI -Style Offset -ResultProperty 'items'

        }

    }#process

    end {

    }#end

}