resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    name = "${var.project_name}-nat-eip"
  }
}

# NAT gateway in public subnet1 (CREATED ONLY IF NAT GATEWAY IS ENABLED TRUE)

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public_subnet1.id
  depends_on = [ aws_internet_gateway.IGW ]

  tags = {
    Name = "${var.project_name}-nat-gw"
  }
}

# Private route table 

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.app_vpc.id
  tags = {
    name = "${var.project_name}-pvt-rt"
  }
}
# Outbound internet traffic from private subnet to NAT gateway

resource "aws_route" "private_nat_route" {
  route_table_id = aws_route_table.private_route.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}

# Assoisiate private route to private subnets

resource "aws_route_table_association" "pvt_rt_assosiation1" {
  subnet_id = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private_route.id
}

resource "aws_route_table_association" "pvt_rt_assosiation2" {
  subnet_id = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private_route.id
}

# Database route table completely isolated from IGW and NAT gateway

resource "aws_route_table" "db_route" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    name = "${var.project_name}-db-route"
  }
}

resource "aws_route_table_association" "private_db1" {
  subnet_id = aws_subnet.private_subnet3.id
  route_table_id = aws_route_table.db_route.id
}

resource "aws_route_table_association" "private_db2" {
  subnet_id = aws_subnet.private_subnet4.id
  route_table_id = aws_route_table.db_route.id
}