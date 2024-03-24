output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "instance_id" {
  value = module.web_app_ec2.instance_id
}

output "instance_public_ip" {
  value = module.web_app_ec2.instance_public_ip
}

output "security_group_id" {
  value = module.web_app_sg.security_group_id
}

output "ecr_url" {
  value = module.registry.repository_url
}

output "web_app_alb_dns_name" {
  value = module.web_app_alb.alb_dns_name
}