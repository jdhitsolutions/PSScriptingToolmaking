Function Get-LastBoot {
    [cmdletbinding()]
    Param(
        [Parameter(
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('CN')]
        [string[]]$Computername = $env:computername
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running in PS $($PSVersionTable.PSVersion)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Using PS Host $($Host.Name)"
        #define hashtable of parameters to splat to Get-CimInstance
        $paramHash = @{
            class        = 'Win32_OperatingSystem'
            ComputerName = $Null
            ErrorAction  = 'Stop'
            Property     = 'LastBootUpTime', 'CSName', 'Caption'
        }
    } #begin

    Process {
        <#
        This is a scripting ForEach loop which is
        different from the ForEach-Object cmdlet.
        #>
        Foreach ($computer in $Computername) {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Processing $($Computer.ToUpper())"
            $paramHash.computername = $computer
            #this is an example of error handling in PowerShell
            try {
                $data = Get-CimInstance @paramHash
                [PSCustomObject]@{
                    PSTypeName      = 'PSLastBootInfo'
                    Computername    = $data.CSName
                    LastBoot        = $data.LastBootUpTime
                    OperatingSystem = $data.Caption
                }
            }
            catch {
                Write-Warning "There was an error: $($error[0].Exception.message)"
            }
        } #foreach computer
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end
} #end function

#extend the type

Update-TypeData -TypeName PSLastBootInfo -MemberType ScriptProperty -MemberName Uptime -Value {
    New-TimeSpan -Start $this.LastBoot -End (Get-Date)
} -Force

Update-TypeData -TypeName PSLastBootInfo -MemberType AliasProperty -MemberName OS -Value OperatingSystem -Force