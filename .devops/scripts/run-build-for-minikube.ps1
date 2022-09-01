﻿
$tempDirectory = "C:\Projects\CoronaDashboards\Temp\Downloads\"
$backendDirectory = "C:\Projects\CoronaDashboards\DATALAB\Business_Logic\nl-cdb-be-business-logic"
$datatinoDirectory = "C:\Projects\CoronaDashboards\DATALAB\BE-APIs\nl-cdb-be-apis\src"

$dockerServerName = "local-mssql"

cd $backendDirectory

Write-Host "Fetching docker environment variables from minikube..."  -ForegroundColor Yellow

& minikube -p minikube docker-env --shell powershell | Invoke-Expression

$sqlHost = ([System.Uri]$Env:DOCKER_HOST).Host

Write-Host "Docker SQL host ip address: [$sqlHost]`n" -ForegroundColor Green
Write-Host "Starting build script...`n"  -ForegroundColor Yellow

.\.devops\scripts\build-script.ps1 -Hostname $sqlHost

######################################################################

Write-Host "Finished build script. Determining SA password and SQL port number..."  -ForegroundColor Yellow

$sqlPassword = $(docker exec $dockerServerName /bin/bash -c 'echo $MSSQL_SA_PASSWORD')
$portNr = $(docker port $dockerServerName).Split(':')[-1]

$datatinoLocalEnv = "$env:USERPROFILE\Datatino"

######################################################################

Write-Host "Updating connection string in local .env file: [$datatinoLocalEnv\.env]..."  -ForegroundColor Yellow
$envSettings = Get-Content $datatinoLocalEnv\.env -Encoding UTF8 | ConvertFrom-Json

$localSettings = $envSettings | ? {
    $_.Level -eq 0
} 

$database =  $localSettings.availableDatabases | ? { $_.databaseSecretName -eq "DatatinoDatabase" }

$database.databaseConnectionString = "Data Source=$sqlHost,$portNr;user id=SA;password=$sqlPassword;Initial Catalog=dashboard-db;MultipleActiveResultSets=True"

$storageConnectionString = ($localSettings.availableStorages | ? { $_.storageSecretName -eq "DatatinoStorage" }).storageConnectionString

ConvertTo-JSon @($envSettings) -Depth 100 | Out-File $datatinoLocalEnv\.env -fORCE

Write-Host "Done saving file."  -ForegroundColor Green

######################################################################

Write-Host "Fetching .env file from azure blob storage..."  -ForegroundColor Yellow

$storageContext = New-AzureStorageContext -connectionstring $storageConnectionString

Get-AzureStorageBlobContent -Container "datatino" -Blob ".env" -Destination $tempDirectory -context $storageContext -Force

Write-Host "`nUpdating connection string in temp file..." -ForegroundColor yellow 

$envSettingsStorage = Get-Content $tempDirectory\.env -Encoding UTF8 | ConvertFrom-Json

$localSettingsStorage = $envSettingsStorage | ? {
    $_.Level -eq 0
} 

$databaseStorage =  $localSettingsStorage.availableDatabases | ? { $_.databaseSecretName -eq "DatatinoDatabase" }

$databaseStorage.databaseConnectionString = "Data Source=$sqlHost,$portNr;user id=SA;password=$sqlPassword;Initial Catalog=dashboard-db;MultipleActiveResultSets=True"
$localSettingsStorage.databaseConnectionString = "Data Source=$sqlHost,$portNr;user id=SA;password=$sqlPassword;Initial Catalog=dashboard-db;MultipleActiveResultSets=True"


ConvertTo-JSon @($envSettingsStorage) -Depth 100 | Out-File $tempDirectory\.env -Force

Write-Host "Uploading temp file to blob...`n" -ForegroundColor Yellow

Set-AzureStorageBlobContent -Container "datatino" -Blob ".env" -File "$tempDirectory\.env" -context $storageContext -Force

Write-Host "`nDone uploading.`n" -ForegroundColor Green

######################################################################

Write-Host "Updating EF core config in the Datatino.Model project: [$datatinoDirectory\Datatino.Model\.database]..." -ForegroundColor Yellow

$datatinoSettings = Get-Content $datatinoDirectory\Datatino.Model\.database -Encoding UTF8 | ConvertFrom-Json

$datatinoSettings.DatabaseConnectionString = "Data Source=$sqlHost,$portNr;user id=SA;password=$sqlPassword;Initial Catalog=dashboard-db;MultipleActiveResultSets=True"

ConvertTo-JSon $datatinoSettings -Depth 100 | Out-File $datatinoDirectory\Datatino.Model\.database -Force

Write-Host "`nAll done." -ForegroundColor Green