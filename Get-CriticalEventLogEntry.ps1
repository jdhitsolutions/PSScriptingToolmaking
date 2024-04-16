#requires -version 5.1

#an advanced function that accepts pipeline input
Function Get-CriticalEventLogEntry {
    [CmdletBinding()]
    [alias('gcel')]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = 'Specify a Windows event log name like System.'
        )]
        [ValidateNotNullOrEmpty()]
        [string]$LogName,

        [Parameter(ValueFromPipeline,HelpMessage = 'Enter the name of the computer to query')]
        [ValidateNotNullOrEmpty()]
        [string]$Computername = $env:COMPUTERNAME,

        [Parameter(HelpMessage = 'Enter the number of events to retrieve between 1 and 1000')]
        [ValidateRange(1, 1000)]
        [int]$Count = 25
    )

    Begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
    }
    Process {
        Write-Verbose "Getting $LogName entries from $Computername"
        Get-WinEvent -FilterHashtable @{LogName = $LogName; Level = 2, 3 } -MaxEvents $Count -ComputerName $Computername |
        Select-Object -Property @{Name = 'Computername'; Expression = { $_.MachineName } },
        TimeCreated, ID, ProviderName, Message, LevelDisplayName,
        @{Name = 'LogName'; Expression = { $_.ContainerLog } }
    }
    End {
        Write-Verbose "Ending $($MyInvocation.MyCommand)"
    }
} #close Get-CriticalEventLogEntry