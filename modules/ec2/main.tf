# Look up the latest Amazon Linux 2023 AMI ID from AWS's public SSM parameter
# Why: no hard-coded AMI ID, which differs per region and goes out of date
data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# The EC2 instance that runs the API
resource "aws_instance" "app" {
  ami                    = data.aws_ssm_parameter.al2023.value
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile   = var.instance_profile_name # Gives SSM access (no SSH keys)

  # Build the startup script from the template, filling in the app code and port
  user_data = templatefile("${path.module}/user_data.sh.tftpl", {
    app_code = var.app_code
    app_port = var.app_port
  })
  user_data_replace_on_change = true # If the app code changes, replace the instance

  # Security best practice: require IMDSv2 (token-based metadata, blocks SSRF attacks)
  metadata_options {
    http_tokens = "required"
  }

  # Root disk: encrypted, gp3 (cheaper and faster than gp2)
  root_block_device {
    volume_type = "gp3"
    encrypted   = true

    tags = {
      Name = "${var.name_prefix}-root-volume"
    }
  }

  tags = {
    Name = "${var.name_prefix}-ec2"
  }
}