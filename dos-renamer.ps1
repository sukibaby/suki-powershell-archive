# Use the current directory
$directoryPath = Get-Location

# Initialize a hashtable to store the DOS names
$dosNames = @{}

# Initialize an array to store the original and DOS names
$proposedChanges = @()

# Function to generate DOS compatible name
function Get-DOSName($name, $counter, $hex) {
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($name)
    $extension = [System.IO.Path]::GetExtension($name)

    if ($baseName.Length -gt 8) {
        if ($hex) {
            if ($counter -gt 255) {
                $baseName = $baseName.Substring(0, 5) + $counter.ToString("X3")
            } else {
                $baseName = $baseName.Substring(0, 6) + $counter.ToString("X2")
            }
        } else {
            $baseName = $baseName.Substring(0, 6) + "~" + $counter
        }
    }

    if ($extension.Length -gt 4) {
        $extension = $extension.Substring(0, 3)
    }

    return $baseName + $extension
}

# Check if the -h switch is given
$hex = $false
if ($args -contains "--hex") {
    $hex = $true
}

# Traverse the directory and its subdirectories
Get-ChildItem -Path $directoryPath -Recurse | ForEach-Object {
    # Get the original file name
    $originalName = $_.Name

    # Generate the DOS compatible name
    $dosName = Get-DOSName $originalName 1 $hex

    # Check for duplicates and modify the name if necessary
    $counter = 2
    while ($dosNames.ContainsKey($dosName)) {
        $dosName = Get-DOSName $originalName $counter $hex
        $counter++
    }

    # Store the DOS name in the hashtable
    $dosNames[$dosName] = $true

    # Store the original and DOS names in the array
    $proposedChanges += [PSCustomObject]@{
        'Original Name' = $originalName
        'DOS Compatible Name' = $dosName
    }
}

# Print all the proposed name changes
$proposedChanges | Format-Table -AutoSize

# Ask the user if they want to rename the files
$userInput = Read-Host -Prompt "Do you want to rename the files as proposed? (Y/N)"

# If the user types 'Y', rename the files
if ($userInput -eq 'Y') {
    foreach ($change in $proposedChanges) {
        $originalPath = Join-Path -Path $directoryPath -ChildPath $change.'Original Name'
        Rename-Item -Path $originalPath -NewName $change.'DOS Compatible Name'
    }
}
# If the user types anything other than 'Y', exit the script
else {
    Write-Output "Exiting the script as per user request."
    exit
}
