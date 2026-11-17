# Inputs for the security module

variable "name_prefix" {
  type        = string
  description = "Prefix for resource names"
}

variable "vpc_id" {
  type        = string
  description = "VPC where the security group is created (from the network module)"
}

variable "app_port" {
  type        = number
  description = "Port to open for the API"
}

variable "allowed_cidr" {
  type        = string
  description = "CIDR allowed to reach the API"
}