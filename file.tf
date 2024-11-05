resource "random_string" "file" {
  length           = 3
  upper            = false
  lower            = false
  numeric          = true
  special          = false
}

resource "aws_s3_bucket" "app" {
  bucket = "swai-${random_string.file.result}"
  force_destroy = true
}

resource "aws_s3_object" "buildspec" {
  bucket = aws_s3_bucket.app.id
  key    = "/buildspec.yaml"
  source = "./src/buildspec.yaml"
  etag   = filemd5("./src/buildspec.yaml")
  content_type = "application/vnd.yaml"
}

resource "aws_s3_object" "swai_Dockerfile" {
  bucket = aws_s3_bucket.app.id
  key    = "/swai-app/Dockerfile"
  source = "./src/swai-app/Dockerfile"
  etag   = filemd5("./src/swai-app/Dockerfile")
}

resource "aws_s3_object" "cluster" {
  bucket        = aws_s3_bucket.app.id
  key           = "/k8s-yaml/eks/cluster.yaml"
  source        = "./src/k8s-yaml/eks/cluster.yaml"
  etag          = filemd5("./src/k8s-yaml/eks/cluster.yaml")
}

resource "aws_s3_object" "swai_app_deployment" {
  bucket        = aws_s3_bucket.app.id
  key           = "/k8s-yaml/yaml/swai-app/deployment.yaml"
  source        = "./src/k8s-yaml/yaml/swai-app/deployment.yaml"
  etag          = filemd5("./src/k8s-yaml/yaml/swai-app/deployment.yaml")
}

resource "aws_s3_object" "swai_app_service" {
  bucket        = aws_s3_bucket.app.id
  key           = "/k8s-yaml/yaml/swai-app/service.yaml"
  source        = "./src/k8s-yaml/yaml/swai-app/service.yaml"
  etag          = filemd5("./src/k8s-yaml/yaml/swai-app/service.yaml")
}

resource "aws_s3_object" "ingress" {
  bucket        = aws_s3_bucket.app.id
  key           = "/k8s-yaml/yaml/ingress.yaml"
  source        = "./src/k8s-yaml/yaml/ingress.yaml"
  etag          = filemd5("./src/k8s-yaml/yaml/ingress.yaml")
}