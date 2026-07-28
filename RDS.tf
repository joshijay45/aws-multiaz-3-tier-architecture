resource "aws_db_subnet_group" "db_subnet_group" {
  name = "${var.project_name}-db-subnet-group"

  subnet_ids = [ aws_subnet.private_subnet3.id , aws_subnet.private_subnet4.id ]

}

# RDS MYSQL database instance

resource "aws_db_instance" "app_db" {
  engine = "mysql"
  instance_class = "db.t3.micro"
  engine_version = "8.0"
  identifier = "${var.project_name}-database"
  allocated_storage = 20

  username = "admin"
  password = "admin_1845"

  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [ aws_security_group.db_sg.id ]

  multi_az = false
  skip_final_snapshot = true
}
