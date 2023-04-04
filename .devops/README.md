# **BUILD AND RELEASE IMPLEMENTATIONS**

---

Two separate **Azure DevOps Pipelines** are used to build and release, respecitively executable `.sql` scripts. The release pipeline will automatically be trigger when the build pipeline has successfully finished. 

<a style="color:red">**NOTE!**</a> The release pipeline will only be trigger when then the **build pipeline** is called `nl-cdb-be-business-logic - CI` within *Azure DevOps* while setting up the pipelines. **[Learn more](https://docs.microsoft.com/en-us/azure/devops/pipelines/create-first-pipeline?view=azure-devops&tabs=java%2Ctfs-2018-2%2Cbrowser)**

## **TABLE OF CONTENTS**

---

1. **[Build Pipelines](#build-pipelines)**
2. **[Release Pipelines](#release-pipelines)**


## **BUILD PIPELINES**

---

The **[Build Pipeline](build-pipelines.yml)** will convert all commited and modified `.ipynb` files into executable `.sql` files when a code is pushed into a branch.

```yml
- task: PowerShell@2
  displayName: "Task 2: Build Artifacts"
  inputs:
    filePath: "$(WORKING_DIRECTORY)/.devops/scripts/build-script.ps1"
    arguments: > 
      -SourceDirectory "./src" 
      -ModifiedFiles $(git diff-tree --no-commit-id --name-only -r $(Build.SourceVersion))
      -DatatinoDevOpsGitRefUrl "../nl-cdb-be-apis"
    failOnStderr: true
    pwsh: true
    workingDirectory: $(WORKING_DIRECTORY)
```

Sequentually, the `.sql`, including the **[Release Script](scripts/release-script.ps1)** artifacts, will be archived for future releases.

```yml
- task: CopyFiles@2
  displayName: "Task 3: Copy MSSQL Database Update Scripts"
  inputs:
    SourceFolder: '$(WORKING_DIRECTORY)'
    Contents: '**/*.sql'
    TargetFolder: '$(Build.ArtifactStagingDirectory)/src'
    OverWrite: true

- task: CopyFiles@2
  displayName: "Task 4: Copy Powershell Release Scripts"
  inputs:
    SourceFolder: "$(WORKING_DIRECTORY)/.devops/scripts"
    Contents: "**/*.ps1"
    TargetFolder: "$(Build.ArtifactStagingDirectory)/.devops/scripts"
    OverWrite: true
```

## **RELEASE PIPELINES**

---

On the other hand, the **[Release Pipeline](release-pipeline.yml)** will retreive the archived artifacts and only executes the `.sql` files using `Invoke-Sqlcmd` which is part of the `SqlServer` Powershell module. 

```yml
- task: AzurePowerShell@5
  displayName: 'Task 2: Deploy MSSQL Update Scripts'
  inputs:
    azureSubscription: '${{ parameters.AZURE_RM_SERVICE_PRINCIPAL_NAME }}'
    ScriptType: 'InlineScript'
    Inline: |
      & "./.devops/scripts/release-script.ps1" `
          -Server "$(AZURE_SQL_SERVER_NAME)" `
          -Database "$(AZURE_SQL_SERVER_NAME)" `
          -SourceDirectory "./src" `
          -Password "$(AZURE_SQL_DATABASE_LOGIN_PASSWORD)" `
          -Username "$(AZURE_SQL_DATABASE_LOGIN_USERNAME)"
    FailOnStandardError: true
    azurePowerShellVersion: 'LatestVersion'
    pwsh: true
    workingDirectory: ${{ parameters.WORKING_DIRECTORY }}
```