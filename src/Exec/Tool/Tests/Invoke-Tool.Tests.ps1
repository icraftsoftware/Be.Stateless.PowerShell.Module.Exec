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

Describe 'Invoke-Tool' {
    InModuleScope Exec {
        It 'Does not throw when exit code indicates success.' {
            { Invoke-Tool -Command { cmd /c 'exit 0' } } | Should -Not -Throw
        }
        It 'Throws when exit code indicates failure.' {
            { Invoke-Tool -Command { cmd /c 'exit 5' } } | Should -Throw -ExpectedMessage "Command { cmd /c 'exit 5' } failed with exit code 5."
        }
        It 'Does not throw when exit code indicates failure but output is expected.' {
            { Invoke-Tool -Command { cmd /c '@echo Expected failure. && exit 7' } -ThrowUnless { $_ -match '^Expected failure\.' } } | Should -Not -Throw
        }
        It 'Throws when exit code indicates failure and output is not expected.' {
            { Invoke-Tool -Command { cmd /c '@echo Unexpected failure. && exit 7' } -ThrowUnless { $_ -match '^Expected failure\.' } } | Should -Throw -ExpectedMessage "Command { cmd /c '@echo Unexpected failure. && exit 7' } failed with exit code 7."
        }
    }
}
