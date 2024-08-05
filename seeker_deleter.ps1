# The script can't run if the user is not an administrator.
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an administrator. Please re-run the script with administrator privileges."
    exit
}

# Functions
function Get-Seconds {
    do {
        $seconds = Read-Host -Prompt 'Please enter the number of seconds to wait before checking for new drives'
        if ($seconds -match '^[-]?\d+$') {
            $seconds = [Math]::Abs([double]$seconds)
            if (2147483 -ge $seconds) { # Check if the value is within the range allowed by Start-Sleep.
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
        $sanitizedFilename = $filename -replace '[^a-zA-Z0-9._]', ''
        if ($filename -eq $sanitizedFilename) {
            return $filename
        } else {
            Write-Host "Invalid input for filename. The filename must only contain alphanumeric characters, periods, and underscores."
        }
    } while ($true)
}

# Get the info we need.
$seconds = Get-Seconds
$filename = Get-Filename

Write-Host "`nLooks good! The program will check every $seconds seconds for new drives.`n`nType CTRL-C to stop the program.`n"

# Get the initial list of drives, so fixed drives don't get scanned.
$initialDrives = Get-PSDrive -PSProvider 'FileSystem'
Write-Host "Initial list of drives was collected and are being ignored."

# This is where the drive scanning and file deletion takes place.
while ($true) {
    $currentDrives = Get-PSDrive -PSProvider 'FileSystem' # Get the current list of drives
    $newDrives = $currentDrives | Where-Object { $_.Name -notin $initialDrives.Name } # Exclude the initial drives.
    if ($newDrives) {
        Write-Host "New drives detected:"
        $newDrives | ForEach-Object { 
            Write-Host $_.Name
            $filePath = Join-Path -Path $_.Root -ChildPath $filename
            if (Test-Path -Path $filePath)
            {
                Remove-Item -Path $filePath
                Write-Host "!! Detected & removed $filename at $filePath."
            }
            else {
                Write-Host "No file with the name "$filename" found."
            }
        }
    }
    $initialDrives = $currentDrives # Update the initial list to include the new drives
    Start-Sleep -Seconds $seconds # Wait for the specified number of seconds before checking again
}
