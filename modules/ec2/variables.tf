# Inputs for the ec2 module

variable "name_prefix" {
  type        = string
  description = "Prefix for resource names"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance size"
}

variable "subnet_id" {
  type        = string
  description = "Subnet to launch the instance in (from the network module)"
}

variable "security_group_id" {
  type        = string
  description = "Security group for the instance (from the security module)"
}

variable "instance_profile_name" {
  type        = string
  description = "IAM instance profile for SSM access (from the security module)"
}

variable "app_port" {
  type        = number
  description = "Port the API listens on"
}

variable "app_code" {
  type        = string
  description = "Contents of the Python app file"
}