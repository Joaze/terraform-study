variable "ami_id" {
  description = "ami ec2 instance default"
  type        = string
  default     = "ami-0f34c5ae932e6f0e4"
}

variable "instance_name" {
  description = "instance name"
  type = string
  default = "exampleappserverinstance"
  
}
