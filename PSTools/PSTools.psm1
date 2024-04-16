#dot source the module functions
Get-ChildItem -Path $PSScriptRoot\functions\*.ps1 |
ForEach-Object {
    . $_.FullName
}

#add any other module related code here

Function Get-PSTools {
    [cmdletbinding()]
    Param()
    Get-Command -Module PSTools | ForEach-Object {
        [PSCustomObject]@{
            PSTypeName = 'PSToolsCommand'
            Name       = $_.Name
            Alias      = (Get-Alias -Definition $_.Name -ErrorAction SilentlyContinue).Name
            Type       = $_.CommandType
            Version    = $_.Version
        }
    } | Sort-Object -Property Name
}

<#
I created a formatting file for last boot info using New-PSFormatXML from
the PSScriptTools module

$a = Get-LastBoot
$a | New-PSFormatXML -path .\formats\PSLastBootInfo.format.ps1xml -FormatType Table -Properties LastBoot,Uptime -GroupBy Computername

#>