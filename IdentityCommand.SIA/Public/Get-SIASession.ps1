# .ExternalHelp IdentityCommand.SIA-help.xml
function Get-SIASession {
    [CmdletBinding(DefaultParameterSetName = 'List')]
    param(
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'List'
        )]
        [datetime]$minStartedTime,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'List'
        )]
        [datetime]$maxStartedTime,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'ById'
        )]
        [String]$session_id
    )

    begin { }#begin

    process {

        $URI = "$(Resolve-RequestUrl)/api/monitoring/sessions"

        if ($PSCmdlet.ParameterSetName -eq 'ById') {

            $result = Invoke-IDRestMethod -Uri "$URI/$session_id" -Method GET

            #Parse JSON details, show key/status/label by default
            $DisplaySet = [System.Management.Automation.PSPropertySet]::new('DefaultDisplayPropertySet', [string[]]@('key', 'status', 'label'))
            $StandardMembers = [System.Management.Automation.PSMemberInfo[]]@($DisplaySet)

            foreach ($step in $result.extra_info) {

                if ($step.details -match '^\s*[\[{]') {
                    try {
                        $step.details = $step.details | ConvertFrom-Json -ErrorAction Stop
                    } catch {
                        Write-Verbose "$($step.key) details left as text: $($_.Exception.Message)"
                    }
                }

                $step | Add-Member -MemberType MemberSet -Name PSStandardMembers -Value $StandardMembers -Force

            }

            return $result

        }

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

        $URI = Add-QueryString -URI $URI -Parameter $boundparameters

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method GET

        if ($null -ne $result) {

            #TODO offset query parameter name assumed to match the other list endpoints -
            #not yet confirmed against a tenant with more than one page of sessions.
            Get-PagedResult -InitialResult $result -URI $URI -Style Offset -ResultProperty 'items'

        }

    }#process

    end {

    }#end

}