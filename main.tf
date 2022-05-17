terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "4.3.0"
    }
  }
}
provider "github" {
  organization = "SynergyDevops"
  #version = "~> 4.0"
}
for i in $(seq 1 100); do cat <<EOF >> main.tf
  resource "github_repository" "repo${i}" {
    name      = "repo${i}"
    auto_init = true
  }
  resource "github_branch_protection" "repo${i}" {
    repository_id = github_repository.repo${i}.node_id
    pattern       = github_repository.repo${i}.default_branch
    required_status_checks {
      strict = true
      contexts = [
        "Terraform",
        "docs",
      ]
    }
    required_pull_request_reviews {
      dismiss_stale_reviews      = true
      require_code_owner_reviews = true
    }
  }
EOF
done
