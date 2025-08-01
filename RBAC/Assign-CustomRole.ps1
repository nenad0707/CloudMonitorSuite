param(
    [Parameter(Mandatory = $true)]
    [string]$ServicePrincipalName,

    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory = $true)]
    [string]$RoleDefinitionPath
)

# 1. Check Azure connection
if (-not (Get-AzContext)) {
    Write-Error "⛔ Not connected to Azure. Please run 'Connect-AzAccount'."
    return
}

# 2. Function: Get Service Principal object
function Get-ServicePrincipal {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name
    )
    try {
        $sp = Get-AzADServicePrincipal -DisplayName $Name
        if ($sp) {
            return $sp
        } else {
            Write-Error "⛔ Service Principal '$Name' not found."
            return $null
        }
    }
    catch {
        Write-Error "⛔ Error getting Service Principal: $_"
        return $null
    }
}

# 3. Function: Create custom role if it doesn't exist
function Test-CustomRoleExists {
    param(
        [Parameter(Mandatory = $true)]
        [string]$DefinitionPath
    )
    try {
        $existing = Get-AzRoleDefinition -Name "CloudMonitorLimitedRole" -ErrorAction SilentlyContinue
        if (-not $existing) {
            New-AzRoleDefinition -InputFile $DefinitionPath
            Write-Host "✅ Custom role created successfully."
        } else {
            Write-Host "ℹ️ Role already exists. Skipping creation."
        }
    }
    catch {
        Write-Error "⛔ Error creating role: $_"
    }
}

# 4. Function: Assign role to Service Principal
function Set-CustomRole {
    param(
        [Parameter(Mandatory = $true)]
        [object]$ServicePrincipal,

        [Parameter(Mandatory = $true)]
        [string]$ResourceGroup
    )
    try {
        $scope = (Get-AzResourceGroup -Name $ResourceGroup).ResourceId

        # Check existing role assignments
        $existingContributor = Get-AzRoleAssignment -ObjectId $ServicePrincipal.Id -Scope $scope | 
            Where-Object { $_.RoleDefinitionName -eq "Contributor" }
        
        $existingCustomRole = Get-AzRoleAssignment -ObjectId $ServicePrincipal.Id -Scope $scope | 
            Where-Object { $_.RoleDefinitionName -eq "CloudMonitorLimitedRole" }

        # Remove Contributor role if exists
        if ($existingContributor) {
            Remove-AzRoleAssignment -ObjectId $ServicePrincipal.Id `
                                  -RoleDefinitionName "Contributor" `
                                  -Scope $scope
            Write-Host "🧹 Removed existing Contributor role."
            Start-Sleep -Seconds 30  # Wait for role removal to propagate
        }

        # Assign custom role only if it doesn't exist
        if (-not $existingCustomRole) {
            New-AzRoleAssignment `
                -ObjectId $ServicePrincipal.Id `
                -RoleDefinitionName "CloudMonitorLimitedRole" `
                -Scope $scope

            Write-Host "✅ Role assigned to SP: $($ServicePrincipal.DisplayName)"
        } else {
            Write-Host "ℹ️ Custom role already assigned to SP: $($ServicePrincipal.DisplayName)"
        }
    }
    catch {
        Write-Error "⛔ Error in role assignment: $_"
    }
}

# 5. Main flow
Test-CustomRoleExists -DefinitionPath $RoleDefinitionPath

$sp = Get-ServicePrincipal -Name $ServicePrincipalName

if ($sp) {
    Set-CustomRole -ServicePrincipal $sp -ResourceGroup $ResourceGroupName
}
