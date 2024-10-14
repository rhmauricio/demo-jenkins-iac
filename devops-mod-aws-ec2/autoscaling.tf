resource "aws_autoscaling_group" "jenkins_autoscaling_group" {

  name                      = var.aws_autoscaling_group_name
  health_check_type         = var.aws_autoscaling_group_health_check_type
  health_check_grace_period = var.aws_autoscaling_group_health_check_grace_period
  default_cooldown          = var.aws_autoscaling_group_default_cooldown
  max_size                  = var.aws_autoscaling_group_max_size
  min_size                  = var.aws_autoscaling_group_min_size
  vpc_zone_identifier       = var.aws_autoscaling_group_vpc_zone_identifier
  target_group_arns         = var.aws_autoscaling_group_target_group_arns
  launch_template {
    id      = aws_launch_template.aws_module_ec2.id
    version = var.aws_autoscaling_group_launch_template_version
  }
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity]
  }
  depends_on = [aws_launch_template.aws_module_ec2]

}
