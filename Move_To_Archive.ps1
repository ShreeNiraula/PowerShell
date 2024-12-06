# Author: Shree Niraula
# Purpose: Move files and folders older than 3 months (based on creation or modified date) to a specified folder

# Define the target directory and the target folder where old files will be moved
$directory = "x:\temp_Note"                # Source directory to check for old files and folders
$targetFolder = "y:\three_month_older"     # Target folder where old files and folders will be moved

# Get the current date and calculate the cutoff date (3 months ago)
$cutoffDate = (Get-Date).AddMonths(-3)

# Initialize counters for moved files and folders
$movedFilesCount = 0
$movedFoldersCount = 0

# Ensure the target folder exists
if (-not (Test-Path $targetFolder)) {
    New-Item -Path $targetFolder -ItemType Directory
}

# Function to move files/folders to the specified target folder
function Move-ToTargetFolder {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    try {
        # Get the item name (file or folder) and create the destination path
        $itemName = [System.IO.Path]::GetFileName($Path)
        $destination = Join-Path -Path $targetFolder -ChildPath $itemName
        
        # Move the item to the target folder
        Move-Item -Path $Path -Destination $destination -Force
        Write-Host "Moved item: $Path to $destination"
        
        # Increment counters
        if (Test-Path -Path $destination) {
            if (Test-Path -Path $destination -PathType Container) {
                $movedFoldersCount++
            } else {
                $movedFilesCount++
            }
        }
    } catch {
        Write-Warning "Failed to move item: $Path"
    }
}

# Get all files and folders in the directory and subdirectories
Get-ChildItem -Path $directory -Recurse | ForEach-Object {
    # Check if the file/folder is older than 3 months based on creation or last modified date
    $isOld = ($_.CreationTime -lt $cutoffDate) -or ($_.LastWriteTime -lt $cutoffDate)

    # If it's a directory (folder)
    if ($_.PSIsContainer) {
        if ($isOld) {
            # Move folder to target folder
            Write-Host "Moving folder: $($_.FullName)"
            Move-ToTargetFolder -Path $_.FullName
            # Increment the moved folder count
            $movedFoldersCount++
        }
    }
    # If it's a file
    else {
        if ($isOld) {
            # Move file to target folder
            Write-Host "Moving file: $($_.FullName)"
            Move-ToTargetFolder -Path $_.FullName
            # Increment the moved file count
            $movedFilesCount++
        }
    }
}

# Output the number of moved files and folders
Write-Host "`nTotal files moved: $movedFilesCount"
Write-Host "Total folders moved: $movedFoldersCount"
