

variable "alb_name" {
  description = "Name for the Application Load Balancer"
}

variable "internal" {
  description = "Whether the load balancer is internal or external"
  default     = false
}

variable "subnets" {
  description = "List of subnet IDs for the load balancer"
  type        = list(string)
}


variable "vpc_id" {
  description = "VPC ID"
}

variable "alb_sg_id" {

}

variable "aws_instance_id" {

}