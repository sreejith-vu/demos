resource "aws_instance" "ec2" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  associate_public_ip_address = true
  key_name                    = aws_key_pair.web_app.key_name

  user_data = base64encode(templatefile("${path.module}/user_data.sh.tftpl", { "region" = var.ecr_region, "ecr_url" = var.ecr_url, "ecr_docker_image_uri" = var.ecr_docker_image_uri }))
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy_attachment" "ecr_pull_policy" {
  name       = "ecr-pull-policy"
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_key_pair" "web_app" {
  key_name   = "web_app"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDUWNOeX/yYBKoDS5INW+k8u/F6orcaTMi/suxBORb8MLlRcDrSLLYK7Zphp9AwI5Ldr84Z36Iw+oGxMOXrx+Zx3XQalnbX2Y805VEygKm1QAd6LciPm5usKCJeGHtfbyqsM38BOoxfPOng/5ikIjW7lKL3bWdV66RoGT5HZZ6TwO5MZMzYvhcG9zxe4DwwpWNcs6ZwreB0BbGtQZGIWnPJaHmLMGHN6qhw3R9HEpujZvskm4mJv7u4Xk8ohnaPxqaC6+pPQ6SNdOXoG17mN5rtP9j68gzbhqzWeLSg699BjpXZL65yQPSJFesUbjDfBLBN1XFYupHbejsOm6pmXoW4QD/jrx8c9H7V/6aUX4RPAQO4YE3aq08aDfU/26UTJFTzsi8MFWQpqkTct/QnWUqsjw9ySiJDM7TrsIbl6Nm7W+mdTY0YAx+BEGyYcSIkyvW6ANOni8U8njIGqtk0wwatzhfD7jj7IlCoS0UydDMMoFUyWcf41kMZGkFxYhgtym8= svu@Sreelakshmi"
}