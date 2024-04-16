return "This is a demo script file."

<#
    My contact information
    https://jdhitsolutions.github.io
#>

<#
Terminology
cmdlet: a powershell command
function: a powershell command defined in a script
script: a file containing powershell commands
module: a collection of cmdlets, functions, and other resources
toolmaking: the process of creating cmdlets, functions, and modules
#>

<#
Toolmaking decisions and planning
- what is the purpose of the tool?
- Who will use the tools?
- What is their expectation?
- Plan for the unexpected.
    - You don't know how or where parameter values will come from.
    - You can't predict every use case
- Plan for the pipeline
#>

#region start with a command

Get-WinEvent -LogName System -MaxEvents 20 -ComputerName $env:COMPUTERNAME

#endregion

#region scripts
#basic script
psedit .\basicscript.ps1

.\basicscript.ps1 -LogName application

#parameterized script
psedit .\paramscript.ps1

.\paramscript.ps1 -LogName System -Count 25 -path c:\temp | invoke-item

#endregion

#region functions
psedit .\basic-function.ps1
#load the function
. .\basic-function.ps1
help Get-CriticalEventLogEntry
Get-CriticalEventLogEntry -LogName application -Count 5

psedit .\Get-CriticalEventLogEntry.ps1

#load the function
. .\Get-CriticalEventLogEntry.ps
help gcel
"dom1","srv1","srv2" | gcel -LogName system -Count 10 -verbose -ov l | Out-GridView

psedit .\Get-LastBoot.ps1
. .\Get-LastBoot.ps1
$r = "srv1","srv2","dom2" | Get-LastBoot -verbose
$r
#endregion

#region modules
# module terms and basics
$env:PSModulePath -split ';'

# New-Item -name PSTools -Path . -ItemType Directory
cd .\PSTools

#create my module structure
'en-US', 'docs', 'functions', 'tests', 'formats', 'types' |
Where {-Not (Test-Path $_ )} | ForEach-Object {
    New-Item -Name $_  -path . -ItemType Directory
}

# copy ..\Get-CriticalEventLogEntry.ps1 -Destination .\functions\
# copy ..\Get-LastBoot.ps1 -Destination .\functions\

#create the module file
New-Item -Name PSTools.psm1 -ItemType File
psedit .\PSTools.psm1

#create the manifest
help New-ModuleManifest
#parameter hashtable to splat to New-ModuleManifest
$paramHash = @{
    Path              = '.\PSTools.psd1'
    Author            = 'Jeff Hicks'
    Description       = 'TCSMUG PowerShell Tools'
    RootModule        = 'PSTools.psm1'
    FunctionsToExport = 'Get-LastBoot', 'Get-PSTools', 'Get-CriticalEventLogEntry'
}

New-ModuleManifest @paramHash
psedit .\PSTools.psd1

#test the module
Import-Module .\PSTools.psd1 -force
Get-PSTools
Get-LastBoot

help Get-LastBoot

#create help docs
# Install-Module Platyps
Get-Command -module Platyps
New-MarkdownHelp -Module PSTools -OutputFolder .\docs
#update existing help
Update-MarkdownHelp -Path .\docs\Get-LastBoot.md

#create formatting file
# Install-Module PSScriptTools

$r = Get-LastBoot
$r | New-PSFormatXML -path .\formats\PSLastBootInfo.format.ps1xml -GroupBy Computername -Properties LastBoot,Uptime

#Create an additional List view
$r | New-PSFormatXML -Properties OS,Uptime -ViewName OS -FormatType List -GroupBy Computername -append -Path .\formats\PSLastBootInfo.format.ps1xml

#I have tweaked this file
psedit .\formats\PSLastBootInfo.format.ps1xml

#create external help
New-ExternalHelp -Path .\docs -OutputPath .\en-US -force
Import-Module .\PSTools.psd1 -force
help Get-LastBoot -Full

<#
other files:
    changelog
        Import-Module ChangelogManagement
        New-ChangeLog -path .\PSTools\CHANGELOG.md
        Use Add-ChangeLogData to add entries and
        Update-ChangeLog to set a new release
    license file
    Create README.md
#>
#endregion
