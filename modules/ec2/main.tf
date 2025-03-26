// modules/ec2/main.tf

// ec2 iam role 생성
resource "aws_iam_instance_profile" "codedeploy_profile" {
  name = "${var.name}-instance-profile"
  role = var.iam_role_name
}

resource "aws_launch_template" "main" {
  name_prefix   = var.name
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [var.security_group_id]

  // iam instance profile 연결
  iam_instance_profile {
    name = aws_iam_instance_profile.codedeploy_profile.name
  }

  user_data = base64encode(var.user_data)

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.name
    }
  }

    tags = var.tags
}

resource "aws_autoscaling_group" "main" {
  name                      = var.name
  desired_capacity          = var.desired_capacity
  max_size                  = var.max_size
  min_size                  = var.min_size
  vpc_zone_identifier       = var.subnet_ids
  health_check_type         = "EC2"
  health_check_grace_period = 300
  target_group_arns         = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = var.name
    propagate_at_launch = true
  }
}
