Function New-File{
    Param(
        $FileName
    )
    try{
        New-Item -Name $filename -ItemType file -ErrorAction stop | out-null
    }
    catch{
        $_
    }
}

New-Alias -Name "touch" -Value "new-file"