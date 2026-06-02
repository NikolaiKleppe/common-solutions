
resource "github_repository_environment" "terraform_apply" {
	environment         = var.apply_environment_name
	repository          = var.repository_name
	can_admins_bypass   = false
}

