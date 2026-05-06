output "repository_url" {
  value       = github_repository.github_repo.html_url
  description = "The web URL of the GitHub repository"
}