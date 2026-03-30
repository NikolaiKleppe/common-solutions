#requires -Version 7.0

param(
  [Parameter(Mandatory = $true)]
  [string]$PatToken,

  [Parameter(Mandatory = $false)]
  [string]$KeyVaultName = "kv-nik-common-solutions",

  [Parameter(Mandatory = $false)]
  [string]$SecretName = "nk-azure-devops-admin-pat"
)

$subscriptionId = "c33f9068-3058-4127-a12d-d44382efa830"
az account set --subscription $subscriptionId
if ($LASTEXITCODE -ne 0) {
  Write-Error "Failed to set Azure subscription to '$subscriptionId'."
  exit 1
}

try {
  # Set the PAT token in Azure Key Vault using Azure CLI
  az keyvault secret set `
    --vault-name $KeyVaultName `
    --name $SecretName `
    --value $PatToken `
    --only-show-errors `
    --output none

  if ($LASTEXITCODE -ne 0) {
    throw "Azure CLI command failed while setting secret '$SecretName'."
  }

  Write-Output "PAT token successfully uploaded to Key Vault '$KeyVaultName' as secret '$SecretName'"
}
catch {
  Write-Error "Failed to upload PAT token: $_"
  exit 1
}