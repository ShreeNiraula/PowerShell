# Author: Shree Niraula
# Script Creation Date: 2024-12-06
# Purpose: Move files and folders older than 3 months (based on creation or modified date) to the Recycle Bin silently.

# Define the target directory
$directory = "E:\FARRMS_Application\TRMTracker\FARRMS\trm\adiha.php.scripts\dev\shared_docs\temp_Note"

# Get the current date and calculate the cutoff date (3 months ago)
$cutoffDate = (Get-Date).AddMonths(-3)

# Function to send files/folders to the Recycle Bin without confirmation
function Send-ToRecycleBin {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;

    public class RecycleBin {
        [DllImport("shell32.dll", CharSet = CharSet.Auto)]
        public static extern int SHFileOperation(ref SHFILEOPSTRUCT FileOp);

        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Auto)]
        public struct SHFILEOPSTRUCT {
            public IntPtr hwnd;
            public uint wFunc;
            public string pFrom;
            public string pTo;
            public ushort fFlags;
            public bool fAnyOperationsAborted;
            public IntPtr hNameMappings;
            public string lpszProgressTitle;
        }

        public const uint FO_DELETE = 0x0003;
        public const ushort FOF_ALLOWUNDO = 0x0040;    // Allow undo (move to Recycle Bin)
        public const ushort FOF_SILENT = 0x0004;        // Do not show any UI prompts
        public const ushort FOF_NO_CONFIRMATION = 0x0010; // No confirmation dialog

        public static void DeleteFile(string filePath) {
            SHFILEOPSTRUCT fileOp = new SHFILEOPSTRUCT();
            fileOp.wFunc = FO_DELETE;
            fileOp.pFrom = filePath + '\0' + '\0';  // null-terminated string
            fileOp.fFlags = FOF_ALLOWUNDO | FOF_SILENT | FOF_NO_CONFIRMATION;
            SHFileOperation(ref fileOp);
        }
    }
"@

    [RecycleBin]::DeleteFile($Path)
}

# Get all files and folders in the directory and subdirectories
Get-ChildItem -Path $directory -Recurse | ForEach-Object {
    # Check the file/folder creation and last modified dates
    $isOld = ($_.CreationTime -lt $cutoffDate) -or ($_.LastWriteTime -lt $cutoffDate)

    # If it's a directory (folder)
    if ($_.PSIsContainer) {
        # If the folder is older based on either creation or last modified date
        if ($isOld) {
            # Send folder to Recycle Bin
            Write-Host "Sending folder to Recycle Bin: $($_.FullName)"
            Send-ToRecycleBin -Path $_.FullName
        }
    }
    # If it's a file
    else {
        # If the file is older based on either creation or last modified date
        if ($isOld) {
            # Send file to Recycle Bin
            Write-Host "Sending file to Recycle Bin: $($_.FullName)"
            Send-ToRecycleBin -Path $_.FullName
        }
    }
}
