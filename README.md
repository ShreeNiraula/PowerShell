# File Management Script

## Author: Shree Niraula

**Date:** 2024-12-06  
**Purpose:** This collection of PowerShell scripts is designed to manage old files and folders in a specified directory. It provides two options:

1. Moving old files and folders to the Recycle Bin.
2. Archiving old files and folders by moving them to another location.

---

### Overview

There are two PowerShell scripts included:

1. **Delete_old_files.ps1:** This script moves files and folders that are older than 3 months to the Recycle Bin.
2. **Move_to_archive.ps1:** This script moves files and folders older than 3 months to a specified archive location instead of the Recycle Bin.

Both scripts operate silently, meaning no user prompts or confirmations will appear during their execution.

---

### Requirements

- PowerShell (version 5 or higher recommended).
- The `Delete_old_files.ps1` script uses `shell32.dll` to move items to the Recycle Bin. This system library is available by default on most Windows operating systems.
- The `Move_to_archive.ps1` script requires you to specify a valid archive destination where the old files and folders will be moved.

---

### Parameters

#### For `Delete_old_files.ps1`:

- **$directory**: The target directory to scan for old files and folders. This path is defined within the script and should be modified to suit your needs.

#### For `Move_to_archive.ps1`:

- **$directory**: The target directory to scan for old files and folders (similar to `Delete_old_files.ps1`).
- **$archiveDirectory**: The destination directory where old files and folders will be moved. You must define this path before running the script.

---

### How It Works

#### **Delete_old_files.ps1**:

1. **Target Directory Setup:**  
   The script begins by defining the directory (`$directory`) to scan. You can modify this to the folder you want to manage.
2. **Date Calculation:**  
   The script calculates the cutoff date by subtracting 3 months from the current date.

3. **Scanning Files and Folders:**  
   It uses `Get-ChildItem` to recursively list all files and folders within the target directory.

4. **Date Comparison:**  
   For each item (file or folder), the script compares its `CreationTime` and `LastWriteTime` to the cutoff date. If it is older than 3 months, the file or folder is moved to the Recycle Bin.

5. **Silent Operation:**  
   The `Send-ToRecycleBin` function uses `shell32.dll` to move the items to the Recycle Bin without displaying any prompts or confirmation dialogs.

6. **Counts:**  
   The script keeps track of how many files and folders are moved to the Recycle Bin.

7. **Output:**  
   Once the script finishes, it prints the total count of files and folders that were moved to the Recycle Bin.

#### **Move_to_archive.ps1**:

1. **Target Directory Setup:**  
   Like the first script, this one defines a directory (`$directory`) to scan for files and folders older than 3 months.

2. **Date Calculation:**  
   The cutoff date is also calculated as 3 months prior to the current date.

3. **Scanning Files and Folders:**  
   `Get-ChildItem` is used to list all files and folders in the target directory.

4. **Date Comparison:**  
   Each file or folder is checked against the cutoff date. If older than 3 months, the item is moved to the archive location defined by `$archiveDirectory`.

5. **Silent Operation:**  
   Files and folders are moved silently without any prompts.

6. **Counts:**  
   The script keeps track of the number of files and folders that were moved to the archive.

7. **Output:**  
   After execution, the script will print the total count of files and folders moved to the archive.

---

### Example Output

For **Delete_old_files.ps1**:

```plaintext
Sending file to Recycle Bin: x:\temp_Note\old_file.txt
Sending folder to Recycle Bin: x:\temp_Note\old_folder

Total files deleted: 5
Total folders deleted: 2
```
