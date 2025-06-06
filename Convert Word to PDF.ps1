function Export-WordToPDF {
  param(
  [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
  [Alias("FullName")]
  $path, 
  $pdfpath = $null)

  process {
    if (!$pdfpath) {
      $pdfpath = [System.IO.Path]::ChangeExtension($path, '.pdf')
    }
    $word = New-Object -ComObject Word.Application
    $word.displayAlerts = $false
    
    $word.Visible = $true
    $doc = $word.Documents.Open($path)
    #$doc.TrackRevisions = $false
    $null = $word.ActiveDocument.ExportAsFixedFormat($pdfpath, 17, $false, 1)
    $word.ActiveDocument.Close()
    $word.Quit()
  }
}

# Use it like this:
# dir c:\folder -Filter *.doc | Export-WordToPDF