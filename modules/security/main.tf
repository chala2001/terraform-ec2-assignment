# ---------- Firewall ----------

# Security group: the firewall around the EC2 instance
resource "aws_security_group" "app" {
  name        = "${var.name_prefix}-app-sg"
  description = "Allow API traffic in, all traffic out"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name_prefix}-app-sg"
  }
}

# Inbound rule SG: allow ONLY the API port (no SSH port 22)
resource "aws_vpc_security_group_ingress_rule" "app_port" {
  security_group_id = aws_security_group.app.id
  description       = "API access"
  cidr_ipv4         = var.allowed_cidr
  ip_protocol       = "tcp"
  from_port         = var.app_port
  to_port           = var.app_port
}

# Outbound rule SG: allow all (needed to install packages and talk to SSM)
resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.app.id
  description       = "All outbound traffic"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # -1 means all protocols and ports
}

# ---------- IAM: permission for SSM Session Manager ----------

# IAM role that the EC2 service is allowed to "assume" (use)
resource "aws_iam_role" "ec2" {
  name = "${var.name_prefix}-ec2-role"

  # Trust policy: WHO can use this role → only the EC2 service
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

# Attach AWS's managed policy that gives ONLY what SSM needs (least privilege)
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance profile: the "container" that lets an EC2 instance carry the role
resource "aws_iam_instance_profile" "ec2" {
  name = "${var.name_prefix}-ec2-profile"
  role = aws_iam_role.ec2.name
}


# what I learn :: Role vs instance profile: EC2 can’t attach a role directly. It needs an instance profile that wraps the role.
# what I learm :: Why separate rule resources instead of ingress { } blocks inside the security group? The current AWS provider docs recommend aws_vpc_security_group_ingress_rule and egress_rule. Each rule is its own resource, can have its own tags, and is easier to manage.