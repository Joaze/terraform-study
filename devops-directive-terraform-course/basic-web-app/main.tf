terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.6.2"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  profile = "user235"
}

resource "aws_security_group" "instances" {
  name        = "instance-security-group"
  description = "Instance security group"
  #vpc_id      = aws_vpc.main.id

  tags = {
    Name = "instance_sg"
  }
}

resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.instances.id
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}


resource "aws_instance" "web-01" {
  ami             = "ami-011899242bb902164" # Ubuntu 20.04 LTS // us-east-1
  instance_type   = "t2.micro"
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
  ami             = "ami-011899242bb902164" # Ubuntu 20.04 LTS // us-east-1
  instance_type   = "t2.micro"
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

resource "aws_s3_bucket" "web-app" {
#  bucket = "web-app"
  bucket_prefix = "web-app-data-terraform"
  force_destroy = true

  tags = {
    Name        = "web-app"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_versioning" "versioning_web-app" {
  bucket = aws_s3_bucket.web-app.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "crypto-conf-web-app" {
  bucket = aws_s3_bucket.web-app.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_security_group" "alb" {
  name        = "alb-security-group"
  description = "Alb security group"
  #vpc_id      = aws_vpc.main.id

  tags = {
    Name = "alb_sg"
  }
}

resource "aws_security_group_rule" "allow_alb_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.alb.id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_alb_http_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.alb.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_lb" "web-app-alb" {
  name               = "web-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = ["subnet-05e5bb4703dce42b9", "subnet-0c3896a507226f22a", "subnet-0f01e84f31d95c836", "subnet-0c8ac7414c118f675", "subnet-07025e363545181b6", "subnet-0122ffb17b60fb4ec"]
  enable_deletion_protection = false

#   access_logs {
#     bucket  = aws_s3_bucket.web-app.id
#     prefix  = "web-app-data-terraform"
#     enabled = true
#   }

  tags = {
    Environment = "production"
  }
}
#############

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web-app-alb.arn

  port = 80

  protocol = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

data "aws_vpc" "default_vpc" {
  default = true
}

resource "aws_lb_target_group" "instances" {
  name     = "instance-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "tg-instance-1" {
  target_group_arn = aws_lb_target_group.instances.arn
  target_id        = aws_instance.web-01.id
  port             = 8080
}

resource "aws_lb_target_group_attachment" "tg-instance-2" {
  target_group_arn = aws_lb_target_group.instances.arn
  target_id        = aws_instance.web-02.id
  port             = 8080
}

resource "aws_lb_listener_rule" "instances" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.instances.arn
  }
}

