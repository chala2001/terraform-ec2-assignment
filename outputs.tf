output "instance_id" {
  description = "EC2 instance ID (use it to connect with SSM)"
  value       = module.ec2.instance_id
}

output "api_url" {
  description = "URL to test the API"
  value       = "http://${module.ec2.public_ip}:${var.app_port}"
}