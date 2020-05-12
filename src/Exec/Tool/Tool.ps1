#region Copyright & License

# Copyright © 2019 - 2022 François Chabot
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#endregion

Set-StrictMode -Version Latest

# inspired by https://github.com/nightroman/Invoke-Build/blob/2ebb4c4ca5c9d15cd11e48f640763007d7a3b7f1/Invoke-Build.ps1#L272
function Add-ToolAlias {
   [CmdletBinding()]
   [OutputType([void])]
   param (
      [Parameter(Mandatory = $true)]
      [ValidateNotNullOrEmpty()]
      [string]
      $Path,

      [Parameter(Mandatory = $true)]
      [ValidateNotNullOrEmpty()]
      [string[]]
      $Tool,

      [Parameter(Mandatory = $false)]
      [ValidateSet('Global', 'Local')]
      [string]
      $Scope = 'Local',

      [Parameter(Mandatory = $false)]
      [switch]
      $Force
   )
   Resolve-ActionPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
   $expandedPath = switch -regex ($Path) {
      ^Framework { "$env:windir\Microsoft.NET\$_" }
      default { $PSCmdlet.GetUnresolvedProviderPathFromPSPath($_) }
   }
   if (-not(Test-Path -LiteralPath $expandedPath -PathType Container)) { throw "Cannot resolve '$Path'." }
   $Tool | ForEach-Object -Process {
      $toolPath = Join-Path -Path $expandedPath -ChildPath "$_.exe" -Resolve
      # add alias in parent scope only, i.e. caller's scope, https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_scopes?view=powershell-7#managing-scope
      Set-Alias -Option ReadOnly -Name $_ -Value $toolPath `
         -Scope $(if ($Scope -eq 'Local') { 1 } else { $Scope }) `
         -Force:$Force `
         -Verbose:($PSBoundParameters['Verbose'] -eq $true)
   }
}

function Invoke-Tool {
   [CmdletBinding()]
   [OutputType([void])]
   param (
      [Parameter(Mandatory = $true)]
      [ValidateNotNullOrEmpty()]
      [scriptblock]
      $Command,

      [Parameter(Mandatory = $false)]
      [ValidateNotNullOrEmpty()]
      [scriptblock]
      $ThrowUnless = $null
   )
   Resolve-ActionPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
   & $Command | Tee-Object -Variable output
   if ($LASTEXITCODE -ne 0 -and ($ThrowUnless -eq $null -or ($output | Where-Object -FilterScript $ThrowUnless | Test-None))) {
      throw "Command {$Command} failed with exit code $LASTEXITCODE."
   }
}
