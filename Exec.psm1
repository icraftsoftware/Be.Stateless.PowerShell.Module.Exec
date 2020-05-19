#region Copyright & License

# Copyright © 2019 - 2020 François Chabot
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
        [string]
        $Path,

        [Parameter(Mandatory = $true)]
        [string[]]
        $Tool
    )
    $expandedPath = switch -regex ($Path) {
        ^Framework { "$env:windir\Microsoft.NET\$_" }
        default { $PSCmdlet.GetUnresolvedProviderPathFromPSPath($_) }
    }
    if (-not(Test-Path -LiteralPath $expandedPath -PathType Container)) { throw "Cannot resolve '$Path'." }
    $Tool | ForEach-Object -Process {
        $toolPath = Join-Path -Path $expandedPath -ChildPath "$_.exe" -Resolve
        # add alias in parent scope only, i.e. caller's scope, see https://mohitgoyal.co/2016/12/26/understand-scopes-in-powershell-part-1/
        # You can refer to scopes by name or by a number that describes the relative position of one scope to another. Scope 0 represents the
        # current, or local, scope. Scope 1 indicates the immediate parent scope. Scope 2 indicates the parent of the parent scope, and so on.
        Set-Alias -Name $_ -Value $toolPath -Scope 1 -Verbose:($PSBoundParameters.ContainsKey('Verbose'))
    }
}

function Invoke-Tool {
    [CmdletBinding()]
    [OutputType([void])]
    param (
        [Parameter(Mandatory = $true)]
        [scriptblock]
        $Command
    )
    & $Command
    if ($LASTEXITCODE -ne 0) { throw "Command {$Command} failed with code $LASTEXITCODE." }
}
