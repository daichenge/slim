variable "access_key" { 
  description = "AWS access key"
  default     = "AKIAJJ43PJBS4YNWQZQQ" 
}

variable "secret_key" { 
  description = "AWS secret access key"
  default     = "KIwmXwVSy8hBA5H7BdtYCJq7TsRGVhdy5/uK8h6+"
}

variable "region"     { 
  description = "AWS region to host your network"
  default     = "eu-west-1" 
}

variable "vpc_cidr" {
  description = "CIDR for VPC"
  default     = "10.128.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for public subnet"
  default     = "10.128.0.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for private subnet"
  default     = "10.128.1.0/24"
}

/* Ubuntu 14.04 amis by region */
variable "amis" {
  description = "Base AMI to launch the instances with"
  default = {
    eu-west-1 = "ami-47a23a30" 
  }
}
