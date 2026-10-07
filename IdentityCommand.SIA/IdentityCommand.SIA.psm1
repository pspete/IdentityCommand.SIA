<#
.SYNOPSIS

.DESCRIPTION

.EXAMPLE

.INPUTS

.OUTPUTS
#>
[CmdletBinding()]
param(

    [bool]$DotSourceModule = $false

)

#Copy IdentityCommand's private helpers into this module first: this module's own files call them,
#and the argument completer registrations do so at import time.
#Each copy is created from the function definition, so it runs in this module's scope and uses this
#module's $ISPSSSession, whether IdentityCommand loaded from source or from its combined psm1.
#Resolve a single IdentityCommand module: with more than one version loaded, Get-Module returns
#an array.
$Module = Get-Module -Name IdentityCommand | Sort-Object Version -Descending | Select-Object -First 1

if ($null -eq $Module) {
    throw 'The IdentityCommand module is not loaded. Import IdentityCommand and try again.'
}

& $Module { Get-ChildItem -Path Function: } |

    Where-Object { $_.ModuleName -eq $Module.Name -and -not $Module.ExportedFunctions.ContainsKey($_.Name) } |

    ForEach-Object {

        . ([scriptblock]::Create("function $($_.Name) {$($_.Definition)}"))

    }

#Get function files
Get-ChildItem $PSScriptRoot\ -Recurse -Include '*.ps1' -Exclude '*.ps1xml' |

    ForEach-Object {

        if ($DotSourceModule) {
            . $_.FullName
        } else {
            $ExecutionContext.InvokeCommand.InvokeScript(
                $false,
                (
                    [scriptblock]::Create(
                        [io.file]::ReadAllText(
                            $_.FullName,
                            [Text.Encoding]::UTF8
                        )
                    )
                ),
                $null,
                $null
            )

        }

    }

# Script scope session object for session data
$ISPSSSession = [ordered]@{
    tenant_url         = $null
    User               = $null
    TenantId           = $null
    SessionId          = $null
    WebSession         = $null
    StartTime          = $null
    ElapsedTime        = $null
    LastCommand        = $null
    LastCommandTime    = $null
    LastCommandResults = $null
    LastError          = $null
    LastErrorTime      = $null
} | Add-CustomType -Type IdCmd.Session

New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force