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