variable "aws_tags" {
  type    = map(string)
  description = "labels required by the organization to identify who owns each resource and the environment"
}
variable "aws_launch_template_ec2_name" {
  type        = string
  description = "EC2 instance name"
}
variable "aws_launch_template_instance_type" {
  type        = string
  description = "EC2 instance type"
  default = "t2.micro"
}
variable "aws_launch_template_ec2_image_id" {
  type        = string
  description = "EC2 instance image id"
}
variable "aws_launch_template_ec2_name_prefix" {
  type        = string
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name"
}
variable "aws_launch_template_ec2_key_name" {
  type        = string
  description = "The key name to use for the instance."
}

variable "aws_launch_template_ec2_network_interface_public_ip_enable" {
  type        = bool
  description = "Associate a public ip address with the network interface. Boolean value, can be left unset"
  default     = false
}
variable "aws_launch_template_ec2_user_data" {
  type        = string
  description = "The base64-encoded user data to provide when launching the instance."
}
variable "aws_launch_template_ec2_block_device_mappings_name" {
  type        = string
  default     = "/dev/sdf"
  description = "Specify volumes to attach to the instance besides the volumes specified by the AMI. See Block Devices below for details."
}
variable "aws_launch_template_ec2_block_device_mappings_ebs_size" {
  type        = number
  default     = 20
  description = "Specify volumes size to attach to the instance besides the volumes specified by the AMI. See Block Devices below for details."
}
variable "aws_launch_template_ec2_block_device_mappings_ebs_type" {
  type        = string
  default     = "standard"
  description = "Specify volumes type to attach to the instance besides the volumes specified by the AMI. See Block Devices below for details."
}
variable "aws_launch_template_ec2_lifecycle_create_before_destroy_disable" {
  type    = bool
  default = true

}
variable "aws_autoscaling_group_name" {
  type        = string
  description = "EC2 instance autoscaling group name"
}
variable "aws_autoscaling_group_health_check_type" {
  type        = string
  description = "EC2 or ELB. Controls how health checking is done."
}

variable "aws_autoscaling_group_health_check_grace_period" {
  type        = string
  description = "Time after instance comes into service before checking health."
  default     = "1000"
}
variable "aws_autoscaling_group_default_cooldown" {
  type        = string
  description = "Time between a scaling activity and the succeeding scaling activity."
  default     = "60"
}
variable "aws_autoscaling_group_max_size" {
  type        = string
  description = "Maximum size of the Auto Scaling Group."
  default = "1"
}
variable "aws_autoscaling_group_min_size" {
  type        = string
  description = " Minimum size of the Auto Scaling Group. (See also Waiting for Capacity below.)"
  default = "1"
}
variable "aws_autoscaling_group_vpc_zone_identifier" {
  type        = list(string)
  description = "List of subnet IDs to launch resources in. Subnets automatically determine which availability zones the group will reside. Conflicts with availability_zones."
}
variable "aws_autoscaling_group_target_group_arns" {
  type        = list(string)
  description = "Set of aws_alb_target_group ARNs, for use with Application or Network Load Balancing. To remove all target group attachments an empty list should be specified."
  default     = []
}

variable "aws_autoscaling_group_launch_template_version" {
  type        = string
  description = "Template version. Can be version number, $Latest, or $Default"
  default     = "$Latest"
}
variable "aws_autoscaling_group_lifecycle_create_before_destroy_enable" {
  type        = bool
  description = "options to control the life cycle of the resource"
  default     = false
}
