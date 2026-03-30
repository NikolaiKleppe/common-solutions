subscription_id             = "c33f9068-3058-4127-a12d-d44382efa830"
location                    = "westeurope"
resource_group_name         = "rg-common-solutions-tfstate"
storage_account_name_prefix = "tfstatecommon"
container_name              = "tfstate"

tags = {
  environment = "shared"
  managed_by  = "terraform"
  purpose     = "terraform-state"
}