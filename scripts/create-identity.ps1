# Create Resource Group
$resourceGroupName = "cloudmonitor-rg"
$location = "westeurope"
New-AzResourceGroup -Name $resourceGroupName -Location $location

# App Registration
$displayName = "cloudmonitor-deployer"
$applicationRegistration = New-AzADApplication -DisplayName $displayName

# Service Principal
New-AzADServicePrincipal -AppId $applicationRegistration.AppId

# Federated Credentials (Azure Pipelines variant)
$azureOrg = "Nenad984"
$azureProject = "CloudMonitorSuite"
$azureRepo = "CloudMonitorSuite"
$branch = "main"

$issuer = "https://pipelines.azure.com"
$audience = "api://AzureADTokenExchange"
$subject = "sc://azuredevops/$azureOrg/$azureProject/$azureRepo/ref/refs/heads/$branch"

New-AzADAppFederatedCredential `
  -Name "$displayName-pipelines-$branch" `
  -ApplicationObjectId $applicationRegistration.Id `
  -Issuer $issuer `
  -Audience $audience `
  -Subject $subject

# Role Assignment
$resourceGroup = Get-AzResourceGroup -Name $resourceGroupName
New-AzRoleAssignment `
  -ApplicationId $applicationRegistration.AppId `
  -RoleDefinitionName Contributor `
  -Scope $resourceGroup.ResourceId

# Output credentials
$azureContext = Get-AzContext
Write-Host "AZURE_CLIENT_ID: $($applicationRegistration.AppId)"
Write-Host "AZURE_TENANT_ID: $($azureContext.Tenant.Id)"
Write-Host "AZURE_SUBSCRIPTION_ID: $($azureContext.Subscription.Id)"
