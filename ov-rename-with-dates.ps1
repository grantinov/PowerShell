# Objective : Automate the renaming of pictures and videos into a common chronoloical format so they can be sorted properly
# Author    : Grant Stokley
# Date      : 22-July-2024

Clear-Host
# Define the folder path
$folderPath = "/Volumes/T7/2024-0811-Wildcat/"
$Now = Get-Date -Format "yyyy-MM-dd-HHmm"
$LogFile = $folderPath+"/FileRenameLog"+$($Now)+".txt"
$space = ""
$StartTime = ""
$StopTime = ""
$newFileName = ""
$newFilePath = ""

# Get all files in the folder
$files = Get-ChildItem -Path $folderPath -File

# Loop through each file and rename it using the last write time timestamp
foreach ($file in $files) {
    # ONLY RENAME MEDIA FILES
    if ($file.Extension -eq ".mp4" -Or $file.Extension -eq ".jpg" -Or $file.Extension -eq ".mov" -Or $file.Extension -eq ".png") {
        
        # Build the new filename
        $StartTime = $file.CreationTime.ToString("yyyy-MM-dd_HHmm")
        $StopTime = $file.LastWriteTime.ToString("HHmm")
        $Size = [math]::Round($file.Length / 1KB)
        $timestamp = $StartTime+"-"+$StopTime+"_"+$Size
        $newFileName = "$timestamp$($file.Extension)"
        $newFilePath = Join-Path -Path $folderPath -ChildPath $newFileName

        # Feedback
        Write-Host "[+] Old filename:" $file
        $logOld = "[+] Old filename:"+$file
        Add-Content -Path $LogFile -Value $logOld

        Write-Host "[+] New filename:" $newFilePath
        $logNew = "[+] New filename:"+$newFilePath
        Add-Content -Path $LogFile -Value $logNew
        
        # EXECUTE: Rename the file
        Rename-Item -Path $file.FullName -NewName $newFilePath
    } else {
        Add-Content -Path $logFile -Value $space
        Write-Host "[-] Not renaming:" $file ", with ext: " $file.Extension
        $logError = "[-] Not renaming:"+$file+", with ext: "+$file.Extension
        Add-Content -Path $LogFile -Value $logError
        Add-Content -Path $logFile -Value $space
    }
    Write-Host ""
    Add-Content -Path $logFile -Value $space
}

Write-Host "Complete"
