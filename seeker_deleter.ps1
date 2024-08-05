<#
.SYNOPSIS
    Seeker Deleter Script

.DESCRIPTION
    This PowerShell script continuously monitors for new drives being connected to the system. 
    When a new drive is detected, it checks for the presence of a specified file on the new drive.
    If the file is found, it deletes the file and logs the action.

.PARAMETERS
    None

.NOTES
    - The script must be run with administrator privileges.
    - The user is prompted to enter the number of seconds to wait between checks for new drives.
    - The user is also prompted to enter the filename to look for on the new drives.
    - The script ignores fixed drives that are present when the script starts.

.EXAMPLE
    To run the script, open PowerShell with administrator privileges and execute the script:
    .\seeker_deleter.ps1

    Follow the prompts to enter the number of seconds to wait between checks and the filename to look for.

#>

if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an administrator. Please re-run the script with administrator privileges."
    exit
}

function Get-Seconds {
    do {
        $seconds = Read-Host -Prompt 'Please enter the number of seconds to wait before checking for new drives'
        if ($seconds -match '^[-]?\d+$') {
            $seconds = [Math]::Abs([double]$seconds)
            if (2147483 -ge $seconds) {
                return [int]$seconds
            } else {
                Write-Host "The number you entered is too large. Please enter a smaller number."
            }
        } else {
            Write-Host "Invalid input for seconds. The value must be a whole number."
        }
    } while ($true)
}
function Get-Filename {
    do {
        $filename = Read-Host -Prompt 'Please enter the filename to look for'
        $sanitized_filename = $filename -replace '[^a-zA-Z0-9._]', ''
        if ($filename -eq $sanitized_filename) {
            return $filename
        } else {
            Write-Host "Invalid input for filename. The filename must only contain alphanumeric characters, periods, and underscores."
        }
    } while ($true)
}

$seconds = Get-Seconds
$filename = Get-Filename

Write-Host "`nLooks good! The program will check every $seconds seconds for new drives.`n`nType CTRL-C to stop the program.`n"

$initial_drives = Get-PSDrive -PSProvider 'FileSystem'
Write-Host "Initial list of drives was collected and are being ignored."

while ($true) {
    $current_drives = Get-PSDrive -PSProvider 'FileSystem'
    $new_drives = $current_drives | Where-Object { $_.Name -notin $initial_drives.Name }
    if ($new_drives) {
        Write-Host "New drives detected:"
        $new_drives | ForEach-Object { 
            Write-Host $_.Name
            $file_path = Join-Path -Path $_.Root -ChildPath $filename
            if (Test-Path -Path $file_path)
            {
                Remove-Item -Path $file_path
                Write-Host "!! Detected & removed $filename at $file_path."
            }
            else {
                Write-Host "No file with the name "$filename" found."
            }
        }
    }
    $initial_drives = $current_drives
    Start-Sleep -Seconds $seconds
}
