function Get-FolderSize
{
    <#
        .SYNOPSIS
        Orders the sub-folders in a given folder by their size on the disk.
        .DESCRIPTION
        When passed a path to a folder this function recurses through each sub-folder
        totalling the size of all the files.  The results are then sorted in descending
        order and outputted to the screen.
        .PARAMETER Path
        The target folder to enumerate.
        .PARAMETER First
        If specified this restricts the output to the first number of results given
        by this parameter.
        .EXAMPLE
        Get-FolderSize C:\Source
        This will total and output the size of all the folders within the folder C:\Source.
        .EXAMPLE
        Get-FolderSize C:\Windows -First 5
        This will total and output the size of all the folders within the folder C:\Windows
        and will only show the 5 largest.
    #>
    param
    (
        [Parameter(Mandatory=$True)]
        [ValidateScript(
            {
                if(!(Test-Path -Path $_ -PathType Container))
                {
                    Throw ("Source path ($_) does not exist or is not a folder.")
 
                }else
                {
                    $True
                }
            }
        )]
        [string]$Path,
        [int]$First=0
    )
    function Get-WorkingFolderSize
    {
        param
        (
            [Parameter(Mandatory=$True)]
            [string]$Path
        )
        $FolderList=@()
        #Recurse through subfolders in the path and add the size of any child items that aren't folders.
        Write-Debug "Entering Get-FolderSize function"
        Write-Debug "Parameter : Path = $Path"
        [int64]$Size=0;
        foreach ($ChildItem in Get-ChildItem -Path $Path)
        {
            #If the child item is a folder and is NOT a symbolic link, call Get-WorkingFolderSize
            #on it.
            if (!($ChildItem.Attributes -like "*ReparsePoint*"))
            {
                if ($ChildItem.PSIsContainer)
                {
                    $SubFolders=(Get-WorkingFolderSize -Path $ChildItem.FullName)
                    $Size=$Size+($Subfolders | Measure-Object Size -Sum).Sum
                    #Build an array of all the folders we've found with their sizes.
                    $FolderList=$FolderList+$SubFolders
                }else
                {
                    $Size=$Size+$ChildItem.Length
 
                }
            }
        }
        #The result of getting the folder size should be added to a custom PSObject, which is then added
        #to the array of folders.
        $CurrentFolderObject=New-Object PSObject -Property @{Path=$Path;Size=$Size}
        $FolderList=$FolderList+$CurrentFolderObject
        Write-Debug "Leaving Get-FolderSize function"
        return $FolderList
    }
    #These actually call the worker function and format output.
    if ($First -gt 0)
    {
        Get-WorkingFolderSize -Path $Path | Sort-Object -Property Size -Descending |
             Select-Object -Property @{Name="SizeInKB";Expression={("{0:N2}" -f ($_.Size / 1KB))}},
                Path -First $First | Format-Table -Autosize -Wrap
    }else
    {
        Get-WorkingFolderSize -Path $Path | Sort-Object -Property Size -Descending |
             Select-Object -Property @{Name="SizeInKB";Expression={("{0:N2}" -f ($_.Size / 1KB))}},
                Path | Format-Table -Autosize -Wrap
    }
}