resource "aws_ecr_repository" "main" {
  name                 = var.name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}
# Authenticate Docker with Amazon ECR
resource "null_resource" "docker_auth" {
  provisioner "local-exec" {
    command = "aws ecr get-login-password --region ${var.ecr_region} | docker login --username AWS --password-stdin ${aws_ecr_repository.main.repository_url}"
  }
}

# Tag the local Docker image with the ECR repository URI
resource "null_resource" "docker_tag" {
  depends_on = [null_resource.docker_auth]

  provisioner "local-exec" {
    command = "docker tag ${var.local_docker_image_with_tag} ${aws_ecr_repository.main.repository_url}:${var.ecr_docker_image_tag}"
  }
}

# Push the local Docker image to Amazon ECR
resource "null_resource" "docker_push" {
  depends_on = [null_resource.docker_tag]

  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.main.repository_url}:${var.ecr_docker_image_tag}"
  }
}