output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

#Public IP for SSH connection
output "ec2_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.k3s_server.public_ip
}

output "ssh_connection_command" {
  description = "Command to connect to the EC2 instance via SSH"
  value       = "ssh -i ~/.ssh/devops-pet-project ubuntu@${aws_instance.k3s_server.public_ip}"
}