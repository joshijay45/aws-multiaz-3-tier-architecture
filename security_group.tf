resource "aws_security_group" "alb_sg" {
  name = "${var.project_name}-alb-sg"
  vpc_id = aws_vpc.app_vpc.id
  description = "Allow HTTPinbounf traffic from the internet"


    ingress {
        description = "HTTP from anywhere"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
}

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# EC2 security group allowing traffic only from ALB

resource "aws_security_group" "ec2_sg" {
  description = "Allow HTTP from ALB only"
  name = "${var.project_name}-ec2-sg"
  vpc_id = aws_vpc.app_vpc.id

    ingress {
        description = "HTTP from ALB"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [aws_security_group.alb_sg.id]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# Database security groups 

resource "aws_security_group" "db_sg" {
  description = "Allow DB traffic from EC2 only"
  name = "${var.project_name}-db-sg"
  vpc_id = aws_vpc.app_vpc.id

  ingress {
    description = "MYSQL from EC2"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


