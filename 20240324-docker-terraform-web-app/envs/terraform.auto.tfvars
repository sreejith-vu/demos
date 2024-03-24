vpc_configs = {
  name                       = "web-app"
  region                     = "ap-south-1"
  vpc_cidr_block             = "10.50.0.0/16"
  availability_zones         = ["ap-south-1a", "ap-south-1b"]
  public_subnet_cidr_blocks  = ["10.50.0.0/24", "10.50.1.0/24"]
  private_subnet_cidr_blocks = ["10.50.10.0/24", "10.50.11.0/24"]
  tags = {
    Enviroment = "POC"
  }
}

web_app_configs = {
  instance_name               = "web-app-1"
  instance_type               = "t2.medium"
  ami_id                      = "ami-05295b6e6c790593e" #AMLN2
  local_docker_image_with_tag = "my-nginx-image:latest"
  ecr_docker_image_tag        = "NEW"
  ssh_public_key              = "<replace with you ssh public key>"

  ingress_rules = [
    {
      description      = "Allow SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      security_groups  = []

    },
    {
      description      = "Allow HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["10.50.0.0/16"]
      ipv6_cidr_blocks = []
      security_groups  = []
    }
  ]

  egress_rules = [
    {
      description      = "Allow all traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      security_groups  = []
    }
  ]
}

web_app_alb_configs = {
  ingress_rules = [
    {
      description      = "Allow HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      security_groups  = []
    }
  ]

  egress_rules = [
    {
      description      = "Allow all traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      security_groups  = []
    }
  ]
}
