# Values the ec2 module will need

output "security_group_id" {
  description = "ID of the app security group"
  value       = aws_security_group.app.id
}

output "instance_profile_name" {
  description = "Instance profile to attach to EC2 (gives SSM access)"
  value       = aws_iam_instance_profile.ec2.name
}