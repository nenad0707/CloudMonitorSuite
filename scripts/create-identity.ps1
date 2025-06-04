param(
    [Parameter(Mandatory=$true)][string]$resourceGroup,
    [Parameter(Mandatory=$true)][string]$location,
    [Parameter(Mandatory=$true)][string]$displayName,
    [Parameter(Mandatory=$true)][string]$azureOrg,
    [Parameter(Mandatory=$true)][string]$azureProject,
    [Parameter(Mandatory=$true)][string]$azureRepo,
    [string]$branch = "refs/heads/main"
)

# Login
if (-not (Get-AzContext)) {
    Connect-AzAccount | Out-Null
}

# Context info
$subscriptionId = (Get-AzContext).Subscription.Id
$tenantId = (Get-AzContext).Tenant.Id

# Resource Group (create if not exists)
$rg = Get-AzResourceGroup -Name $resourceGroup -ErrorAction SilentlyContinue
if (-not $rg) {
    Write-Host "Creating resource group: $resourceGroup in $location"
    New-AzResourceGroup -Name $resourceGroup -Location $location
} else {
    Write-Host "Resource group already exists: $resourceGroup"
}

# App Registration
$app = Get-AzADApplication -DisplayName $displayName -ErrorAction SilentlyContinue
if (-not $app) {
    $app = New-AzADApplication -DisplayName $displayName
}

# Service Principal
$sp = Get-AzADServicePrincipal -ApplicationId $app.ApplicationId -ErrorAction SilentlyContinue
if (-not $sp) {
    $sp = New-AzADServicePrincipal -ApplicationId $app.ApplicationId
}

# Role assignment
$roleAssignment = Get-AzRoleAssignment -ObjectId $sp.Id -RoleDefinitionName "Contributor" -ResourceGroupName $resourceGroup -ErrorAction SilentlyContinue
if (-not $roleAssignment) {
    New-AzRoleAssignment -ObjectId $sp.Id -RoleDefinitionName "Contributor" -ResourceGroupName $resourceGroup
}

# Federated Credential (only pipelines)
$federatedCredentials = Get-AzADAppFederatedCredential -ApplicationObjectId $app.Id -ErrorAction SilentlyContinue

$issuer = "https://pipelines.azure.com"
$audience = "api://AzureADTokenExchange"
$subject = "sc://azuredevops/$azureOrg/$azureProject/$azureRepo/ref/$branch"
$credName = "$displayName-pipelines-main"

if (-not ($federatedCredentials | Where-Object { $_.Subject -eq $subject })) {
    New-AzADAppFederatedCredential `
      -Name $credName `
      -ApplicationObjectId $app.Id `
      -Issuer $issuer `
      -Audience $audience `
      -Subject $subject
}

# Output for Azure Pipelines Service Connection
Write-Host "`n--- Use these values in Azure DevOps ---"
Write-Host ("AZURE_CLIENT_ID:       {0}" -f $app.AppId)
Write-Host ("AZURE_TENANT_ID:       {0}" -f $tenantId)
Write-Host ("AZURE_SUBSCRIPTION_ID: {0}" -f $subscriptionId)
