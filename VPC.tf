resource "aws_vpc" "app_vpc" {
    cidr_block = var.vpc_cidr
   
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
      Name = "${var.project_name}-vpc"
    }
}

data "aws_availability_zones" "available_az" {
  state = "available"
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.app_vpc.id
  tags = {
    Name = "${var.project_name}-igw"
  }
}
resource "aws_subnet" "public_subnet1" {
    vpc_id = aws_vpc.app_vpc.id
    cidr_block = var.public_subnet_cidr[0]
    availability_zone = data.aws_availability_zones.available_az.names[0]
    map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet2" {
    vpc_id = aws_vpc.app_vpc.id
    cidr_block = var.public_subnet_cidr[1]
    availability_zone =  data.aws_availability_zones.available_az.names[1] 
    map_public_ip_on_launch = true
}



resource "aws_subnet" "private_subnet1" {
  vpc_id = aws_vpc.app_vpc.id
  cidr_block = var.private_subnet_cidr[0]
  availability_zone =  data.aws_availability_zones.available_az.names[0]

  tags = {
    name = "Private subnet for EC2 instance1"
  }
}

resource "aws_subnet" "private_subnet2" {
    vpc_id = aws_vpc.app_vpc.id
    cidr_block = var.private_subnet_cidr[1]
    availability_zone =  data.aws_availability_zones.available_az.names[1]

    tags = {
      name = "Private subnet for EC2 instance2"
    }
}

resource "aws_subnet" "private_subnet3" {
    vpc_id = aws_vpc.app_vpc.id
    cidr_block = var.database_subnet_cidr[0]
    availability_zone =  data.aws_availability_zones.available_az.names[0]

    tags = {
      name = "private subnet for database1"
    }
  
}

resource "aws_subnet" "private_subnet4" {
  vpc_id = aws_vpc.app_vpc.id
  cidr_block = var.database_subnet_cidr[1]
  availability_zone =  data.aws_availability_zones.available_az.names[1]

  tags = {
    name = "Private subnet for database2"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.app_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
}

resource "aws_route_table_association" "pub_sub1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "pub_sub2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public.id
}