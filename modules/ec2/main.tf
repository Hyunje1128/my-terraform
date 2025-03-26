// modules/ec2/main.tf

resource "aws_launch_template" "main" {
  name_prefix   = var.name
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [var.security_group_id]

  // ec2 iam 역할
  iam_instance_profile {
    name = var.aws_iam_instance_profile_name
  }

  user_data = base64encode(var.user_data)

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"
    tags          = var.tags
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

  dynamic "tag" {
  for_each = var.tags
  content {
    key                 = tag.key
    value               = tag.value
    propagate_at_launch = true
  }
  }

}
