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

@{
    RootModule            = 'Exec.psm1'
    ModuleVersion         = '1.0.0.0'
    GUID                  = '83f4143a-79ee-49ee-a510-7770a0fc1644'
    Author                = 'François Chabot'
    CompanyName           = 'be.stateless'
    Copyright             = '(c) 2019 - 2021 be.stateless. All rights reserved.'
    Description           = 'Commands to work with external executables.'
    ProcessorArchitecture = 'None'
    PowerShellVersion     = '5.0'
    NestedModules         = @()
    RequiredModules       = @(
        @{ ModuleName = 'Psx'; ModuleVersion = '1.0.21342.42869'; GUID = '217de01f-f2e1-460a-99a4-b8895d0dd071' }
    )

    AliasesToExport       = @()
    CmdletsToExport       = @()
    FunctionsToExport     = @('Add-ToolAlias', 'Invoke-Tool')
    VariablesToExport     = @()
    PrivateData           = @{
        PSData = @{
            Tags                       = @('be.stateless.be', 'icraftsoftware', 'Exe', 'Exec', 'Executables', 'PowerShell', 'Tools')
            LicenseUri                 = 'https://github.com/icraftsoftware/Be.Stateless.PowerShell.Module.Exec/blob/master/LICENSE'
            ProjectUri                 = 'https://github.com/icraftsoftware/Be.Stateless.PowerShell.Module.Exec'
            ExternalModuleDependencies = @('Psx')
        }
    }
}