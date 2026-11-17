# Local values: names built once and reused everywhere
locals {
  name_prefix = "${var.project_name}-${var.environment}" # e.g. ec2-api-assignment-dev
}

# Network module: creates the VPC, subnet, internet gateway and routing
module "network" {
  source = "./modules/network" # Path to the module folder

  name_prefix        = local.name_prefix
  vpc_cidr           = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
  availability_zone  = "${var.aws_region}a" # ap-south-1a
}




# Security module: firewall + IAM role for SSM
module "security" {
  source = "./modules/security"

  name_prefix  = local.name_prefix
  vpc_id       = module.network.vpc_id # O/P from the network module → input here
  app_port     = var.app_port
  allowed_cidr = var.allowed_cidr
}

# what i Learn New : The line module.network.vpc_id is where modules connect: one module’s output becomes another module’s input. 
# Terraform also understands from it that the network must be created first.




# EC2 module: the instance running the Python API
module "ec2" {
  source = "./modules/ec2"

  name_prefix           = local.name_prefix
  instance_type         = var.instance_type
  subnet_id             = module.network.public_subnet_id
  security_group_id     = module.security.security_group_id
  instance_profile_name = module.security.instance_profile_name
  app_port              = var.app_port
  app_code              = file("${path.root}/app/app.py") # Read the Python file as text
}