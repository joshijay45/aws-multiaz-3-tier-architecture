data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64"
}

resource "aws_launch_template" "app_launch_template" {
  name_prefix   = "${var.project_name}-lt-"
  image_id = data.aws_ssm_parameter.ami.value
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  user_data = filebase64("${path.module}/scripts/userdata.sh")

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app_asg" {
  name = "${var.project_name}-app-asg"

  vpc_zone_identifier = [ aws_subnet.private_subnet1.id , aws_subnet.private_subnet2.id ]

  min_size = 2
  max_size = 4
  desired_capacity = 2

  target_group_arns = [aws_alb_target_group.app_tg.arn]

  launch_template {
    id = aws_launch_template.app_launch_template.id
    version = "$Latest"
  }

  tag {
    key = "Name"
    value = "${var.project_name}-asg-instance"
    propagate_at_launch = true
  }
}

# The scaling rule : if CPU usage hit 50% add a new one 

resource "aws_autoscaling_policy" "cpu_scaling" {
  name = "${var.project_name}-cpu-scaling-policy"
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
  policy_type = "TargetTrackingScaling"
  
  target_tracking_configuration {
        predefined_metric_specification {
        predefined_metric_type = "ASGAverageCPUUtilization"
     }
     target_value = 50.0

 }

}