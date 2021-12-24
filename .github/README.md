# **HOW TO BUILD AND RELEASE IMPLEMENTATIONS**

---

Two separate **Azure DevOps Pipelines** are used to build and release, respecitively modified executable `.sql` scripts. The release pipeline will automatically be trigger when the build pipeline has successfully finished executing. 

<a style="color:red">**NOTE!**</a> The release pipeline will only be trigger when then name ***build pipeline*** is named `cdb - ci` within Azure DevOps while setting up the pipelines: __[link](https://docs.microsoft.com/en-us/azure/devops/pipelines/create-first-pipeline?view=azure-devops&tabs=java%2Ctfs-2018-2%2Cbrowser)__.

## **TABLE OF CONTENTS**

---

1. __[Build Pipelines](#**build-pipelines**)__
2. __[Release Pipelines](#**release-pipelines**)__


## **BUILD PIPELINES**

---

The __[build pipeline](build-pipelines.yml)__ will convert all commited and modified `.ipynb` files into executable `.sql` files when a pull request has been approved (one the `main/` branch). 

```yml
- task: PowerShell@2
  displayName: "Task 1: Build MSSQL Artifacts"
  inputs:
    filePath: "$(Build.SourcesDirectory)/deploy/scripts/build-script.ps1"
    arguments: |
      -RootPath "$(Build.SourcesDirectory)"
    failOnStderr: true
    pwsh: true
```

Sequentually, the `.sql`, including the __[release script](scripts/release-script.ps1)__ artifacts, will be archived for future releases.

```yml
- task: CopyFiles@2
  inputs:
    SourceFolder: "$(Build.SourcesDirectory)/"
    Contents: "*.sql"
    TargetFolder: "$(Build.ArtifactStagingDirectory)/src"
    OverWrite: true
  displayName: "Task 2: Copy Files: MSSQL"

- task: CopyFiles@2
  inputs:
    SourceFolder: "$(Build.SourcesDirectory)/deploy/scripts"
    Contents: "*.ps1"
    TargetFolder: "$(Build.ArtifactStagingDirectory)/scripts"
    OverWrite: true
  displayName: "Task 3: Copy Files: Scripts"
```

## **RELEASE PIPELINES**

---

On the other hand, the __[release pipeline](release-pipeline.yml)__ will retreive the archived artifacts and only executes the `.sql` files using `Invoke-Sqlcmd` which is part of the `SqlServer` Powershell module. 

```yml
- task: PowerShell@2
  displayName: "Task 3: Migrate MSSQL Artifacts"
  inputs:
    filePath: "$(Pipeline.Workspace)/build/drop/scripts/release-script.ps1"
    arguments: '-Server "$(MssqlServer)" -Database "$(MssqlDatabase)" -RootPath "$(Pipeline.Workspace)/build/drop/src" -Password $(LoginPassword) -Username $(LoginUsername)'
    pwsh: true
```