Function Get-GitStatus{
[cmdletBinding()]
Param(
    $ProjectPath = (Get-location)
)
    if(".git" -in (Get-ChildItem -Path $projectPath -force).name){
        $info = ""
        Invoke-Expression "git remote update" | out-null
        $gitupdate = Invoke-Expression "git status -uno"
        $project = Split-Path $ProjectPath -Leaf
        $branch = (($gitupdate | Select-Object -first 1) -replace "On branch","").trim()
        $info = $gitupdate | Select-Object -Index 1
        switch -wildcard ($info){
            "*up to date*" {$status = "Up-To-Date";$commits = "";break}
            "*behind*" {$status = "Behind";$commits = ($info -replace "\D","").trim();break}
            "*ahead*" {$status = "Ahead";$commits = ($info -replace "\D","").trim();break}
        }
        if($gitupdate -like "*changes not staged for commit*"){
            $changeinfo = "Changes not staged for commit"
        }
        if($gitupdate -like "*changes to be committed*"){
            $changeinfo = "Changes to be committed"
        }
        [pscustomobject]@{
            Project = $project
            Branch = $branch
            Status = $status
            Commits = $commits
            Info = $changeinfo
        }
    }
    else{
        $folders = get-childitem -Path $Project
        foreach($folder in $folders){
            $info = ""
            set-location $folder.fullname
            Invoke-Expression "git remote update" | out-null
            $gitupdate = Invoke-Expression "git status -uno"
            $project = $folder.name
            $branch = (($gitupdate | Select-Object -first 1) -replace "On branch","").trim()
            $info = $gitupdate | Select-Object -Index 1
            switch -wildcard ($info){
                "*up to date*" {$status = "Up-To-Date";$commits = "";break}
                "*behind*" {$status = "Behind";$commits = ($info -replace "\D","").trim();break}
                "*ahead*" {$status = "Ahead";$commits = ($info -replace "\D","").trim();break}
            }
            if($gitupdate -like "*changes not staged for commit*"){
                $changeinfo = "Changes not staged for commit"
            }
            if($gitupdate -like "*changes to be committed*"){
                $changeinfo = "Changes to be committed"
            }
            [pscustomobject]@{
                Project = $project
                Branch = $branch
                Status = $status
                Commits = $commits
                Info = $changeinfo
            }
        }
    }
}