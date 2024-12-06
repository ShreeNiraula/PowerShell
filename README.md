# File and Folder Cleaner Script

## Author: Shree Niraula

**Date:** 2024-12-06  
**Purpose:** This script moves files and folders older than 3 months (based on either creation or last modified date) from a specified directory to the Recycle Bin silently, without any user prompts.

## Overview

This PowerShell script performs the following actions:

- It targets a specific directory (`$directory`), including all subdirectories.
- It checks the creation and last modified date of each file and folder.
- If a file or folder is older than 3 months, it is moved to the Recycle Bin.
- The process is silent, meaning no prompts or confirmations are shown during the operation.
- After execution, the script outputs the total number of files and folders that were moved to the Recycle Bin.

## Requirements

- PowerShell (version 5 or higher recommended)
- The script uses `shell32.dll` for moving items to the Recycle Bin. Ensure that this system library is available on your system (standard on most Windows OS).

## Parameters

- `$directory`: The directory where the script will scan for old files and folders. This is hardcoded in the script and should be updated based on the folder you want to target.

## How It Works

1. **Target Directory Setup:**  
   The script starts by defining the directory (`$directory`) to scan. You can modify this path to suit your needs.

2. **Date Calculation:**  
   The script calculates the cutoff date for files and folders older than 3 months using the current date.

3. **Scanning Files and Folders:**  
   It uses `Get-ChildItem` to recursively gather all files and folders in the target directory.

4. **Date Comparison:**  
   For each item (file or folder), it compares the `CreationTime` and `LastWriteTime` to the cutoff date. If the item is older than 3 months, it is moved to the Recycle Bin.

5. **Silent Operation:**  
   The function `Send-ToRecycleBin` uses `shell32.dll` to move files/folders to the Recycle Bin silently (no confirmation dialog or UI prompt).

6. **Counts:**  
   The script maintains a count of how many files and folders are deleted (moved to the Recycle Bin).

7. **Output:**  
   After execution, the script prints the total count of deleted files and folders.

## Example Output

```plaintext
Sending file to Recycle Bin: x:\temp_Note\old_file.txt
Sending folder to Recycle Bin: x:\temp_Note\old_folder

Total files deleted: 5
Total folders deleted: 2
```
