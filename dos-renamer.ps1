<#
.SYNOPSIS
    DOS Filename Renamer Script

.DESCRIPTION
    This PowerShell script renames files in a specified directory to be compatible with the DOS 8.3 filename convention.
    It traverses the directory recursively and generates DOS-compatible names for each file.
    The script supports an optional `--hex` argument to use hexadecimal numbering for filenames that exceed the 8-character limit.

.PARAMETERS
    --hex
        Optional. If provided, the script will use hexadecimal numbering for filenames that exceed the 8-character limit.

.NOTES
    - The script must be run with appropriate permissions to rename files in the specified directory.
    - The user is prompted to confirm the proposed changes before the renaming operation is performed.
    - The script ignores directories and only processes files.

.EXAMPLE
    To run the script and rename files in the current directory:
    .\dos-renamer.ps1

    To run the script with hexadecimal numbering for long filenames:
    .\dos-renamer.ps1 --hex

    Follow the prompts to confirm the proposed changes.

#>

$directory_path = Get-Location

$dos_names = @{}

$proposed_changes = @()

function Get-DOSName($name, $counter, $hex) {
    $base_name = [System.IO.Path]::GetFileNameWithoutExtension($name)
    $extension = [System.IO.Path]::GetExtension($name)

    if ($base_name.Length -gt 8) {
        if ($hex) {
            if ($counter -gt 255) {
                $base_name = $base_name.Substring(0, 5) + $counter.ToString("X3")
            } else {
                $base_name = $base_name.Substring(0, 6) + $counter.ToString("X2")
            }
        } else {
            $base_name = $base_name.Substring(0, 6) + "~" + $counter
        }
    }

    if ($extension.Length -gt 4) {
        $extension = $extension.Substring(0, 3)
    }

    return $base_name + $extension
}

$hex = $false
if ($args -contains "--hex") {
    $hex = $true
}

Get-ChildItem -Path $directory_path -Recurse | ForEach-Object {
    $original_name = $_.Name

    $dos_name = Get-DOSName $original_name 1 $hex

    $counter = 2
    while ($dos_names.ContainsKey($dos_name)) {
        $dos_name = Get-DOSName $original_name $counter $hex
        $counter++
    }

    $dos_names[$dos_name] = $true

    $proposed_changes += [PSCustomObject]@{
        'Original Name' = $original_name
        'DOS Compatible Name' = $dos_name
    }
}

$proposed_changes | Format-Table -AutoSize

$user_input = Read-Host -Prompt "Do you want to rename the files as proposed? (Y/N)"

if ($user_input -eq 'Y') {
    foreach ($change in $proposed_changes) {
        $original_path = Join-Path -Path $directory_path -ChildPath $change.'Original Name'
        Rename-Item -Path $original_path -NewName $change.'DOS Compatible Name'
    }
}
else {
    Write-Output "Exiting the script as per user request."
    exit
}
