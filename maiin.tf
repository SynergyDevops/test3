terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "4.3.0"
    }
  }
}
provider "github" {
  token        = "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"
  organization = "SynergyDevops"
  #version = "~> 4.0"
}

locals {
  repos = yamldecode(file("repositories.yml"))["repositories"]["name"]
  }
  resource "github_branch_protection_v3" "main_protection" {
  branch = "main"
  for_each = toset(flatten(local.repos))
  repository = each.value
  enforce_admins = true
  require_signed_commits = true #Commits pushed to matching branches must have verified signatures.
  
  required_status_checks {
    strict   = true
    contexts = ["Terraform"]
  }
  required_pull_request_reviews {
    dismiss_stale_reviews  = true
    required_approving_review_count = 2
    require_code_owner_reviews = true
  }
}
output "repositories"{
  value = "${local.repos}"
}
