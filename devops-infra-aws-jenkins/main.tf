resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}
resource "aws_default_subnet" "default_az" {
  availability_zone = "us-east-1a"

  tags = {
    Name = "Default subnet for us-west-2a"
  }
}

module "jenkins_ec2" {
  source = "../devops-mod-aws-ec2"

  aws_autoscaling_group_health_check_type   = "ELB"
  aws_autoscaling_group_max_size            = "1"
  aws_autoscaling_group_min_size            = "1"
  aws_autoscaling_group_name                = "${local.stack_id}-jenkins-master"
  aws_autoscaling_group_vpc_zone_identifier = [aws_default_subnet.default_az.id]
  aws_launch_template_ec2_image_id          = "ami-0fff1b9a61dec8a5f"
  aws_launch_template_ec2_key_name          = "${local.stack_id}-jenkins-master-test"
  aws_launch_template_ec2_name              = "${local.stack_id}-jenkins-master"
  aws_launch_template_ec2_name_prefix       = ""
  aws_launch_template_ec2_user_data         = ""
  aws_tags = local.common_tags
}

resource "aws_key_pair" "jenkins" {
  public_key = file("${path.module}/keys/common-jenkins.pub")
  key_name   = "${local.stack_id}-jenkins-master-test"
  tags       = local.common_tags
}