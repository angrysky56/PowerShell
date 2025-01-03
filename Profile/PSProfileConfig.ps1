

function prompt {
    # Assign Windows Title Text
    $host.ui.RawUI.WindowTitle = "Current Folder: $pwd"

    # Configure current user and date outputs
    $CmdPromptUser = [Security.Principal.WindowsIdentity]::GetCurrent().Name
    $Date = Get-Date -Format 'dddd hh:mm:ss tt'

    # Test for Admin / Elevated
    $IsAdmin = (New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

    # Calculate execution time of last command
    $LastCommand = Get-History -Count 1
    if ($LastCommand) { 
        $RunTime = ($LastCommand.EndExecutionTime - $LastCommand.StartExecutionTime).TotalSeconds 
    }

    if ($RunTime -ge 60) {
        $ElapsedTime = [timespan]::fromseconds($RunTime).ToString("mm\:ss") + " min"
    } else {
        $ElapsedTime = "{0:N2} sec" -f $RunTime
    }

    # Detect active Conda environment
    $CondaEnv = $env:CONDA_DEFAULT_ENV
    if (-not $CondaEnv) { $CondaEnv = "None" }  # Default if no Conda environment is active

    # Decorate the CMD Prompt
    Write-Host ""
    Write-host ($(if ($IsAdmin) { 'Elevated ' } else { '' })) -BackgroundColor DarkRed -ForegroundColor White -NoNewline
    Write-Host " USER: $CmdPromptUser " -BackgroundColor DarkBlue -ForegroundColor White -NoNewline
    Write-Host " ENV: $CondaEnv " -BackgroundColor DarkGreen -ForegroundColor White -NoNewline
    Write-Host " $pwd " -ForegroundColor White -BackgroundColor DarkGray -NoNewline
    Write-Host " $Date " -ForegroundColor White
    Write-Host "[$ElapsedTime] " -NoNewline -ForegroundColor Green

    return "> "

 # end prompt function



    #Decorate the CMD Prompt
    Write-Host ""
    Write-host ($(if ($IsAdmin) { 'Elevated ' } else { '' })) -BackgroundColor DarkRed -ForegroundColor White -NoNewline
    Write-Host " USER:$($CmdPromptUser.Name.split("\")[1]) " -BackgroundColor DarkBlue -ForegroundColor White -NoNewline
    If ($CmdPromptCurrentFolder -like "*:*")
        {Write-Host " $CmdPromptCurrentFolder "  -ForegroundColor White -BackgroundColor DarkGray -NoNewline}
        else {Write-Host ".\$CmdPromptCurrentFolder\ "  -ForegroundColor White -BackgroundColor DarkGray -NoNewline}

    Write-Host " $date " -ForegroundColor White
    Write-Host "[$elapsedTime] " -NoNewline -ForegroundColor Green
    return "> "
} #end prompt function


function Invoke-5Admin {
    [CmdletBinding()]
    param ()

    begin {

    }

    process {
        Start-Process powershell.exe -Credential TY\Administrators -ArgumentList "Start-Process powershell.exe -Verb runAs"
    }

    end {

    }
}

function Invoke-7Admin {
    [CmdletBinding()]
    param ()

    begin {

    }

    process {
        Start-Process powershell.exe -Credential TY\Administrators -ArgumentList "Start-Process pwsh.exe -Verb runAs"
    }

    end {

    }
}


#PSReadline settings
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -Colors @{emphasis = '#ff0000'; inlinePrediction = 'Yellow'}
Set-PSReadLineOption -HistoryNoDuplicates
Set-PSReadLineKeyHandler -Key Tab -Function Complete

#Fav Variables & Shortcuts

$exclude = "runspaceid", "pscomputername"

$InputDir = "C:\Scripts\Input"
$OutputDir = "C:\Scripts\Output"

$GitIAMDir = "F:\GithubRepos\"
$OneDriveDir = "C:\Users\angry\OneDrive"
$DownloadsDir = "C:\Users\angry\Downloads"
$DesktopDir = "C:\Users\angry\Desktop"
$ReportsDir = "C:\Users\angry\OneDrive\Reports"


# Conda initialization
# !! Contents within this block are managed by 'conda init' !!
If (Test-Path "F:\miniforge3\Scripts\conda.exe") {
    (& "F:\miniforge3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | ?{$_} | Invoke-Expression
}

# Optionally activate the base environment by default
conda activate base
