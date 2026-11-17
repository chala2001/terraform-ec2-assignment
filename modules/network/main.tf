#VPC creation
resource "aws_vpc" "this" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true #instances resolve the dns 
    enable_dns_hostnames = true #gives instaces dns names


    tags ={
        Name = "${var.name_prefix}-vpc"
    }
}


#Internet Gateway creation
resource "aws_internet_gateway" "this" {
    vpc_id = aws_vpc.this.id

    tags = {
        Name = "${var.name_prefix}-igw"
    }
}



# Public subnet creation
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true # Instances get a public IP, so users can reach the API

  tags = {
    Name = "${var.name_prefix}-public-subnet"
  }
}


# Route table: rules for where network traffic goes
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  # Send all internet traffic (0.0.0.0/0) through the Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.name_prefix}-public-rt"
  }
}


# Connect the route table to the subnet (this is what makes the subnet "public")

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}


# What I learn New: this resource does not support tags in AWS



