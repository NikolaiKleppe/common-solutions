


$FileName       = "nk-admin-app.2026-03-30.private-key.pem"
$PemFilePath    = "C:\Users\nikol\Desktop\$FileName"
$secretName     = "nk-github-admin-app-private-key"
$vaultName      = "kv-nik-common-solutions"
$subscriptionId = "c33f9068-3058-4127-a12d-d44382efa830"

az login

az account set --subscription $subscriptionId

az keyvault secret set --vault-name $vaultName --name $secretName --file $PemFilePath
