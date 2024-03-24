module "vpc" {
  source                     = "../modules/vpc"
  name                       = var.vpc_configs.name
  region                     = var.vpc_configs.region
  vpc_cidr_block             = var.vpc_configs.vpc_cidr_block
  public_subnet_cidr_blocks  = var.vpc_configs.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.vpc_configs.private_subnet_cidr_blocks
  availability_zones         = var.vpc_configs.availability_zones
  tags                       = var.vpc_configs.tags
}

module "registry" {
  source                      = "../modules/ecr_repo"
  name                        = "web_apps_registry"
  ecr_region                  = var.vpc_configs.region
  ecr_docker_image_tag        = var.web_app_configs.ecr_docker_image_tag
  local_docker_image_with_tag = var.web_app_configs.local_docker_image_with_tag
}

module "web_app_sg" {
  source = "../modules/security_group"

  name          = "${var.web_app_configs.instance_name}-sg"
  description   = "Security Group for EC2 ${var.web_app_configs.instance_name}"
  vpc_id        = module.vpc.vpc_id
  ingress_rules = var.web_app_configs.ingress_rules
  egress_rules  = var.web_app_configs.egress_rules
  depends_on    = [module.vpc]
}

module "web_app_alb_sg" {
  source = "../modules/security_group"

  name          = "${var.web_app_configs.instance_name}-alb-sg"
  description   = "Security Group for ALB ${var.web_app_configs.instance_name}"
  vpc_id        = module.vpc.vpc_id
  ingress_rules = var.web_app_alb_configs.ingress_rules
  egress_rules  = var.web_app_alb_configs.egress_rules
  depends_on    = [module.vpc]
}

module "web_app_alb" {
  source          = "../modules/alb"
  alb_sg_id       = module.web_app_alb_sg.security_group_id
  alb_name        = "${var.web_app_configs.instance_name}-alb"
  subnets         = module.vpc.public_subnet_ids
  vpc_id          = module.vpc.vpc_id
  aws_instance_id = module.web_app_ec2.instance_id

  depends_on = [module.web_app_alb_sg]
}

module "web_app_ec2" {
  source               = "../modules/ec2_instance"
  instance_name        = var.web_app_configs.instance_name
  instance_type        = var.web_app_configs.instance_type
  subnet_id            = module.vpc.public_subnet_ids[0]
  security_group_ids   = [module.web_app_sg.security_group_id]
  ami_id               = var.web_app_configs.ami_id
  ecr_url              = module.registry.repository_url
  ecr_region           = var.vpc_configs.region
  ecr_docker_image_uri = "${module.registry.repository_url}:${var.web_app_configs.ecr_docker_image_tag}"
  tags                 = var.vpc_configs.tags

  depends_on = [
    module.vpc,
    module.web_app_sg
  ]
}