variable "region" {
  description = "AWS region"
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
}

variable "public_subnet_cidr_blocks" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidr_blocks" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to AWS resources"
  type        = map(string)
}

variable "availability_zones" {
  description = "AZ's for subnets"
  type        = list(string)
}

variable "nat_gateway_zone" {
  description = "Index value of Zone"
  default     = 0
}

variable "name" {

}