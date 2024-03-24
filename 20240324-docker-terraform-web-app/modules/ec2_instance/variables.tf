variable "instance_name" {
  description = "Name for the EC2 instance"
}

variable "instance_type" {
  description = "Type of the EC2 instance"
}

variable "subnet_id" {
  description = "Subnet ID where the EC2 instance will be launched"
}

variable "security_group_ids" {
  description = "List of security group IDs for the EC2 instance"
  type        = list(string)
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
}

variable "tags" {
  description = "Tags to apply to AWS resources"
  type        = map(string)
}

variable "ecr_docker_image_uri" {

}
variable "ecr_url" {

}
variable "ecr_region" {

}