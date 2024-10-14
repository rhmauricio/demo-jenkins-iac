
resource "aws_launch_template" "aws_module_ec2" {
  instance_type        = var.aws_launch_template_instance_type
  name                 = var.aws_launch_template_ec2_name
  image_id             = var.aws_launch_template_ec2_image_id
  //name_prefix          = var.aws_launch_template_ec2_name_prefix
  key_name             = var.aws_launch_template_ec2_key_name
  #TODO: SE DEBERIA CREAR EN ESTE MISMO MODULO
  //security_group_names = var.aws_launch_template_ec2_map_security_group_names
  network_interfaces {
    associate_public_ip_address = var.aws_launch_template_ec2_network_interface_public_ip_enable
  }
  user_data = var.aws_launch_template_ec2_user_data
  block_device_mappings {
    device_name = var.aws_launch_template_ec2_block_device_mappings_name

    ebs {
      volume_type = var.aws_launch_template_ec2_block_device_mappings_ebs_type
      volume_size = var.aws_launch_template_ec2_block_device_mappings_ebs_size
    }
  }
  lifecycle {
    create_before_destroy = true
  }
  tags = var.aws_tags
}