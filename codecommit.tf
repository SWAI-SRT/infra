resource "aws_codecommit_repository" "commit" {
    repository_name = "swai-commit"
    default_branch = "swai"
    
    lifecycle {
        ignore_changes = [default_branch]
    }
    
    tags = {
      Name = "swai-commit"
    } 
}