# Author: Shree Niraula
# Script Creation Date: 2024-12-06
# Purpose: Delete files and empty folders created before 2024-08-15 in the specified directory.

# Define the target directory
$directory = "E:\FARRMS_Application\TRMTracker\FARRMS\trm\adiha.php.scripts\dev\shared_docs\temp_Note"

# Define the cutoff date (August 15, 2024)
$cutoffDate = Get-Date "2024-08-15"

# Get all files and folders in the directory and subdirectories
Get-ChildItem -Path $directory -Recurse | ForEach-Object {
    
    # Print the file/folder path and creation date for debugging
    Write-Host "Processing: $($_.FullName) - Created on: $($_.CreationTime)"

    # If it's a directory (folder)
    if ($_.PSIsContainer) {
        # Check if the folder creation date is before the cutoff date
        $folderCreationTime = $_.CreationTime
        if ($folderCreationTime -lt $cutoffDate) {
            # Display the folder being deleted
            Write-Host "Deleting folder: $($_.FullName)"
            Remove-Item $_.FullName -Force -Recurse
        }
    }
    # If it's a file
    else {
        # Check the file's creation date
        $fileCreationTime = $_.CreationTime
        if ($fileCreationTime -lt $cutoffDate) {
            # Display the file being deleted
            Write-Host "Deleting file: $($_.FullName)"
            Remove-Item $_.FullName -Force
        }
    }
}
