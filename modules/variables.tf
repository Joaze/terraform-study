variable "name" {
  description = "name of vpc"
  type        = string
  default     = "main_vpc"
}

variable "cidr" {
  description = "cidr of vpc"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "list of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1c"]
}

variable "private_subnets" {
  description = "list of private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets" {
  description = "list of public subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}
