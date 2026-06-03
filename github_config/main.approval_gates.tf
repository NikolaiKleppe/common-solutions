
locals {
	apply_environment_reviewer_usernames = toset(var.apply_environment_reviewer_usernames)
	apply_environment_reviewer_team_slugs = toset(var.apply_environment_reviewer_team_slugs)
}

data "github_user" "apply_reviewers" {
	for_each = local.apply_environment_reviewer_usernames
	username = each.value
}

data "github_team" "apply_reviewers" {
	for_each = local.apply_environment_reviewer_team_slugs
	slug     = each.value
}

resource "github_repository_environment" "terraform_apply" {
	environment         = var.apply_environment_name
	repository          = var.repository_name
	prevent_self_review = false
	can_admins_bypass   = true

	dynamic "reviewers" {
		for_each = length(local.apply_environment_reviewer_usernames) + length(local.apply_environment_reviewer_team_slugs) > 0 ? [1] : []

		content {
			users = [for reviewer in data.github_user.apply_reviewers : reviewer.id]
			teams = [for team in data.github_team.apply_reviewers : team.id]
		}
	}
}

# Apparently bypassing the gate works without using this resource, just specify a non-existing name
# resource "github_repository_environment" "terraform_apply_no_gate" {
# 	environment         = "terraform-apply-no-gate"
# 	repository          = var.repository_name
# 	prevent_self_review = false
# 	can_admins_bypass   = true
# }



