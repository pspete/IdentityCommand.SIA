<#
.SYNOPSIS
Imports the IdentityCommand module the tests will run against.

.DESCRIPTION
This module borrows its HTTP/auth plumbing from the private functions of the IdentityCommand
module, which the .psm1 locates via Get-Module. Which copy of IdentityCommand is loaded therefore
decides which helpers are available, so a refactor spanning both repositories has to be testable
against a working-tree IdentityCommand rather than the published one.

Resolution order is -Path, then $env:IDENTITYCOMMAND_MODULE_PATH, then the installed module. With
neither supplied the behaviour is identical to Import-Module IdentityCommand -Force, so CI is
unaffected.

Any already loaded copy is removed first: the .psm1 resolves a single module, and leaving two
versions loaded makes which one it picks depend on load order.

.PARAMETER Path
Path to an IdentityCommand.psd1, or to the directory containing it.

.EXAMPLE
.\build\Import-IdentityCommand.ps1

Imports the installed IdentityCommand module.

.EXAMPLE
.\build\Import-IdentityCommand.ps1 -Path ..\IdentityCommand\IdentityCommand

Imports IdentityCommand from a local checkout.
#>
[CmdletBinding()]
param(

    [parameter(Mandatory = $false, Position = 0)]
    [string]$Path = $env:IDENTITYCOMMAND_MODULE_PATH

)

Get-Module -Name IdentityCommand -All | Remove-Module -Force -ErrorAction SilentlyContinue

if (-not [string]::IsNullOrWhiteSpace($Path)) {

    if (Test-Path -Path $Path -PathType Container) {
        $Path = Join-Path $Path 'IdentityCommand.psd1'
    }

    if (-not (Test-Path -Path $Path -PathType Leaf)) {
        throw "IdentityCommand manifest not found at '$Path'"
    }

    Import-Module -Name $Path -Force -ErrorAction Stop

} else {

    Import-Module -Name IdentityCommand -Force -ErrorAction Stop

}

$Loaded = @(Get-Module -Name IdentityCommand)

if ($Loaded.Count -ne 1) {
    throw "Expected a single IdentityCommand module to be loaded, found $($Loaded.Count)"
}

Write-Host "Using IdentityCommand $($Loaded[0].Version) from $($Loaded[0].ModuleBase)" -ForegroundColor Cyan
