#requires -version 5.1

#Moving from a command-line expression to a flexible and
#reusable script

#get errors and warnings from the system log by default
Param(
    [string]$Computername = $env:COMPUTERNAME,
    [string]$LogName = 'System',
    [int]$MaxEvents = 20
)

$params = @{
    FilterHashtable = @{LogName = $LogName; Level = 2, 3 }
    MaxEvents       = $MaxEvents
    ComputerName    = $Computername
}

Get-WinEvent @params