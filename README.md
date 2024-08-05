a collection of small powershell scripts i've made which don't warrant their own repository :godmode:

DOS Filename Renamer Script
- This PowerShell script renames files in a specified directory to be compatible with the DOS 8.3 filename convention.
- It traverses the directory recursively and generates DOS-compatible names for each file.
- The script supports an optional `--hex` argument to use hexadecimal numbering for filenames that exceed the 8-character limit.

Restore Right Click
- Restores the old right click menu in Windows 11

Measure QPC
- Measure how long it takes QueryPerformanceCounter to execute on Windows

File Seeker & Deleter
- This PowerShell script continuously monitors for new drives being connected to the system.
- When a new drive is detected, it checks for the presence of a specified file on the new drive.
- If the file is found, it deletes the file and logs the action.
