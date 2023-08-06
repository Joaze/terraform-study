output "public_ip" {
  description = "the ec2 instance public ip"
  value = aws_instance.app_server.public_ip
}

output "public_dns" {
  description = "the ec2 instance public dns"
  value = aws_instance.app_server.public_dns
}

