resource_group_name = "rg-common-solutions-az-kv"
location            = "westeurope"
key_vault_name      = "kv-nik-common-solutions"

sku_name                   = "standard"
soft_delete_retention_days = 90

tags = {
	environment = "shared"
	workload    = "common-solutions"
	managed_by  = "terraform"
}
