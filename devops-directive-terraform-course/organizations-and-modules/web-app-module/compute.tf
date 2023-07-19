resource "aws_instance" "web-01" {
  ami             = var.ami
  instance_type   = var.instance_type
  security_groups = [aws_security_group.instances.name]
  user_data       = <<-EOF
              #!/bin/bash
              echo "Hello, World web-01" > index.html
              python3 -m http.server 8080 &
              EOF
  tags = {
    Name = "instance_web-01"
  }
}

resource "aws_instance" "web-02" {
  ami             = var.ami
  instance_type   = var.instance_type
  security_groups = [aws_security_group.instances.name]
  user_data       = <<-EOF
              #!/bin/bash
              echo "Hello, World web-02" > index.html
              python3 -m http.server 8080 &
              EOF
  tags = {
    Name = "instance_web-02"
  }
}
