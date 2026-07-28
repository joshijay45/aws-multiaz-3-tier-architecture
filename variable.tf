variable "aws_region" {
  description = "Region where services will deploy"
  type = string
  default = "us-east-1"
}

variable "project_name" {
  description = "MultiAZ 3tier app"
  type = string
  default = "multiaz-3tier-app"
}

variable "enviornment" {
  description = "Deployment envirnment"
  type = string
  default = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for custom vpc"
  type =  string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidr" {
  description = "CIDR block for private subnets"
  type = list(string)
  default = [ "10.0.11.0/24", "10.0.12.0/24" ]
}

variable "database_subnet_cidr" {
  description = "CIDR block for database subnets"
  type = list(string)
  default = [ "10.0.21.0/24", "10.0.22.0/24" ]
}

variable "enable_nat_gateway" {
  description = "Toggle NAT gateway to control AWS cost"
  type = bool
  default = false
}

