[System.Diagnostics.CodeAnalysis.SuppressMessage('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
[CmdletBinding()]
param
(
    [Parameter()]
    [System.String]
    $ModuleRootPath = (Get-Location)
)

$moduleManifestName = 'azure.datafactory.tools.psd1'
$moduleManifestPath = Join-Path -Path $ModuleRootPath -ChildPath $moduleManifestName

Import-Module -Name $moduleManifestPath -Force -Verbose:$false

InModuleScope azure.datafactory.tools {
    $script:SrcFolder = $env:ADF_ExampleCode
    $script:ConfigFolder = Join-Path -Path $script:SrcFolder -ChildPath "deployment"

    Describe 'Read-CsvConfigFile' -Tag 'Unit','private' {
        It 'Should exist' {
            { Get-Command -Name Read-CsvConfigFile -ErrorAction Stop } | Should -Not -Throw
        }

        Context 'When called without parameters' {
            It 'Should throw an error' {
                { Read-CsvConfigFile -Force } | Should -Throw 
            }
        }

        Context 'When called' {
            It 'Should return Array object' {
                $result = Read-CsvConfigFile -Path ( Join-Path -Path $script:ConfigFolder -ChildPath "config-c001.csv" )
                $result | Should -Not -Be $null
                $result.GetType() | Should -Be 'System.Object[]'
            }
            It 'Validation should fail if the file has wrong format' {
                {
                    Read-CsvConfigFile -Path ( Join-Path -Path $script:ConfigFolder -ChildPath "config-badformat.csv" )
                } | Should -Throw -ExceptionType ([System.Data.DataException])
            }
            It 'Validation should fail if the file contains incorrect type of object' {
                {
                    Read-CsvConfigFile -Path ( Join-Path -Path $script:ConfigFolder -ChildPath "config-badtype.csv" )
                } | Should -Throw -ExceptionType ([System.Data.DataException])
            }
            It 'Validation should complete even if the file contains commented and empty lines' {
                {
                    Read-CsvConfigFile -Path ( Join-Path -Path $script:ConfigFolder -ChildPath "config-commented.csv" )
                } | Should -Not -Throw 
            }

        }


    } 
}