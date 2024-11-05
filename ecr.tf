resource "aws_ecr_repository" "swai" {
  name = "swai-ecr"

    tags = {
        Name = "swai-ecr"
    } 
}

resource "aws_ecr_lifecycle_policy" "swai_policy" {
  repository = aws_ecr_repository.swai.name

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "delete docker image on ecr",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 4
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}