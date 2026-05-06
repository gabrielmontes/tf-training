terraform {
  required_version = "1.15.1"

  cloud {
    organization = "gmontes-training"

    workspaces {
      name =  "gmontes-ws"
    }
  }


  required_providers {
    tfe = {
      source = "hashicorp/tfe"
      version = "~> 0.42.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}


provider "github" {
  token = var.github_token
}

provider "tfe"{
  hostname = "app.terraform.io"
}

resource "tfe_oauth_client" "github_client" {
  name             = var.github_repository_name
  organization     = var.org_name
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  service_provider = "github"
  oauth_token      = var.github_token
}

resource "tfe_workspace" "parent" {
  name                 = var.workspace_name
  organization         = var.org_name
  queue_all_runs       = false

  vcs_repo {
    branch             = "main"
    identifier         = github_repository.github_repo.full_name
    oauth_token_id     = tfe_oauth_client.github_client.oauth_token_id
  }
  depends_on = [ tfe_oauth_client.github_client ]
}

resource "tfe_variable" "tfe_gh_token" {
  description = "gh provider token"
  key = "TF_VAR_github_token"
  value = var.github_token
  sensitive = true 
  category = "env"
  workspace_id = tfe_workspace.parent.id
}

resource "github_repository" "github_repo" {
  name        = var.github_repository_name
  description = "Terraform training"
  visibility  = "public"

  has_issues    = true
  has_projects  = false
  has_wiki      = false

  allow_merge_commit = true
  allow_squash_merge = true
  allow_rebase_merge = true

  delete_branch_on_merge = true

  auto_init = false

  topics = ["training", "terraform"]
}