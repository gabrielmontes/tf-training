variable "org_name"{
  type = string
  description = "Terraform cloud organization name"
  default = "gmontes-training"
}

variable "workspace_name"{
  type = string
  description = "Terraform workspace name"
  default = "gmontes-ws"
}

variable "github_token" {
  description = "GitHub Personal Access Token"
  type        = string
  sensitive   = true
}

variable "github_repository_name"{
  type = string
  description = "github repository name"
  default = "tf-training"
}