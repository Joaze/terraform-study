output "web-01" {
  value = aws_instance.web-01.public_ip
}

output "web-02" {
  value = aws_instance.web-02.public_ip
  
}
