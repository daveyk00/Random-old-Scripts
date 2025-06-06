$findme="string to search for"

Select-String *.txt -pattern $findme | %{$_.line} | set-content output.txt
