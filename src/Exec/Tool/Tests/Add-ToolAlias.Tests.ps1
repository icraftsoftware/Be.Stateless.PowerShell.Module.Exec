#region Copyright & License

# Copyright © 2012 - 2020 François Chabot
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

Import-Module -Name $PSScriptRoot\..\..\Exec -Force

Describe 'Add-ToolAlias' {
    InModuleScope Exec {
        It 'Resolves tool path.' {
            Add-ToolAlias -Path 'Framework\v4.0.30319' -Tool InstallUtil
            Get-Alias -Name InstallUtil | Select-Object -ExpandProperty Definition | Should -Be 'C:\Windows\Microsoft.NET\Framework\v4.0.30319\InstallUtil.exe'
        }
        It 'Creates alias in current scope.' {
            Add-ToolAlias -Path 'Framework\v4.0.30319' -Tool InstallUtil
            Get-Alias -Name InstallUtil -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
            Get-Command -Name InstallUtil -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
        }
        It 'Creates alias in no other scope.' {
            Get-Alias -Name InstallUtil -ErrorAction SilentlyContinue | Should -BeNullOrEmpty
            Get-Command -Name InstallUtil -ErrorAction SilentlyContinue | Should -BeNullOrEmpty
        }
    }
}
