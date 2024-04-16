#requires -version 5.1
#requires -RunAsAdministrator

#Functions do ONE thing and write ONE type of object to the pipeline

#this demo function lacks error handling
Function Get-CriticalEventLogEntry {
    [CmdletBinding()]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = 'Specify a Windows event log name like System.'
        )]
        [ValidateNotNullOrEmpty()]
        [string]$LogName,

        [Parameter(HelpMessage = 'Enter the name of the computer to query')]
        [ValidateNotNullOrEmpty()]
        [alias("System","CN")]
        [string]$Computername = $env:COMPUTERNAME,
        [int]$Count = 20
    )

    Get-WinEvent -FilterHashtable @{LogName = $LogName; Level = 2,3 } -MaxEvents $Count -ComputerName $Computername

} #close Get-CriticalEventLogEntry