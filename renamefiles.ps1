## BatchRenameFiles.ps1

## Batch renames a directory of files to the same name with number appended.
## eg
## Given a directory with files:
## filea.txt, fileb.txt, filec.txt, etc.
## Running the command BatchRenameFiles.ps1 -filepath %PATHTOFILES% -renameto Textfile
## the results would be:
## Textfile1.txt, Textfile2.txt, Textfile3.txt, etc

## Usage:
## BatchRenameFiles.ps1 -filepath %PATHTOFILES% -renameto %FILENAME% [-leadingzeros $TRUE/$FALSE]
## -filepath is the path to the files to be renamed, spaces must be quoted, trailing slash must be added
## -renameto is the new filename, spaces must be quoted
## -leadingzeros (optional) is whether or not to pad the numbers out with leading zeros.  Default is $TRUE

## eg:
## BatchRenameFiles.ps1 -filepath c:\scripts\images\ -renameto "new images"
## BatchRenameFiles.ps1 -filepath "c:\batch files\VBS\" -renameto images
## BatchRenameFiles.ps1 -filepath "c:\batch files\VBS\" -renameto images -leadingzeros $FALSE



param(
    [string]$filepath=$(throw "-filepath parameter is required"),
    [string]$renameto=$(throw "-renameto parameter is required"),
    [string]$leadingzeros=$TRUE
)

$paddinglength=0
$listoffiles=get-childitem $filepath | sort lastwritetime


## Determine if leading zeros are to be added.  If so, set the maximum amount of leading zeros to be used.
if ($leadingzeros -eq $TRUE) {
    $totalfiles=($listoffiles).count
    $paddinglength=($totalfiles.tostring()).length
}

$filenumber=1
foreach ($file in $listoffiles)
{

    ## Set the padding to nothing.  Determine the length of the current file number.  eg: file1=1, file10=2, etc
    $padding=""
    $fileupto=($filenumber.tostring()).length

    ## Add the leading zeros
        for ($i=$paddinglength;$i -gt $fileupto; $i--) {
        $padding+="0"
    }

    ## Perform the rename, using the padding
    $newname=$renameto+$padding+($filenumber).ToString()+$file.Extension
    rename-item -path $file.fullname -newname $newname
    $filenumber=$filenumber+1
}
