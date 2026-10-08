#Requires -Modules Pester
<#
.SYNOPSIS
    Tests IdentityCommand.SIA-specific conventions across the module.
.EXAMPLE
    Invoke-Pester
.NOTES
    The generic module tests come from pspete.Build (build/tests/Module.Tests.ps1).
    The built module is a single psm1 with no Public folder, so Secure Value Handling finds no scripts to check against it.
#>

Describe 'Module' -Tag 'Consistency' {

	$ModuleName = 'IdentityCommand.SIA'

	$ModulePath = Join-Path (Split-Path (Split-Path -Parent $PSCommandPath) -Parent) $ModuleName

	$Scripts = Get-ChildItem $ModulePath -Include *.ps1 -Recurse

	if ( -not (Get-Module -Name $ModuleName -All)) {

		Import-Module -Name (Join-Path $ModulePath "$ModuleName.psd1") -ArgumentList $true -Force -ErrorAction Stop

	}

	Context 'Secure Value Handling' -Tag 'SecureValueHandling' {

		#Any function that decodes a SecureString (or otherwise obtains a plaintext secret) and sends a
		#JSON request body via Invoke-IDRestMethod must convert that body to UTF8 bytes (not a String)
		#before the call, so Windows PowerShell ParameterBinding/Module Logging cannot capture the
		#plaintext value. See https://github.com/pspete/psPAS/issues/602

		$SecretFieldNames = 'password', 'secret_access_key', 'secret_data', 'BindPassword', 'clientSecret'
		$SecretFieldPattern = "(?i)'($($SecretFieldNames -join '|'))'"
		$SecretDecodePattern = 'ConvertTo-InsecureString'

		Foreach ($Script in $Scripts) {

			$Content = Get-Content -Path $Script.FullName -Raw

			$HandlesSecret = ($Content -match $SecretFieldPattern) -or ($Content -match $SecretDecodePattern)
			$BuildsJsonBody = ($Content -match 'ConvertTo-Json') -or ($Content -match 'ConvertTo-SecretBody')
			$SendsRequest = $Content -match 'Invoke-IDRestMethod'

			if ($HandlesSecret -and $BuildsJsonBody -and $SendsRequest) {

				It "$($Script.Name) converts its request body to UTF8 bytes before calling Invoke-IDRestMethod" -Tag "$($Script.BaseName)" -TestCases @{
					'Content' = $Content
				} {
					param($Content)

					$Content | Should -Match '(\[System\.Text\.Encoding\]::UTF8\.GetBytes\(|ConvertTo-SecretBody)'

				}

			}

		}

	}

	Context 'Shared Helpers' {

		#These are IdentityCommand's private helpers, which the psm1 copies into this module's scope.
		#Asserting they resolve turns "the wrong IdentityCommand is loaded" into one
		#clear failure rather than a cascade of unrelated ones.
		It 'resolves <_> from the loaded IdentityCommand module' -ForEach @(
			'Add-QueryString'
			'ConvertTo-DateString'
			'ConvertTo-JsonBody'
			'ConvertTo-SecretBody'
			'Get-ArgumentCompleter'
			'Get-CompletionResult'
			'Get-PagedResult'
			'Merge-Parameter'
			'Resolve-ServiceUrl'
			'Select-RequestProperty'
		) {

			InModuleScope 'IdentityCommand.SIA' -Parameters @{ Name = $_ } {
				param($Name)
				Get-Command -Name $Name -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
			}

		}

	}

}