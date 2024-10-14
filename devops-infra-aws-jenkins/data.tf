data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  tags = {
    Tier = "Private"
  }
}

#data "template_file" "user_data_template" {
#  template = file("${path.module}/templates/user_data_template.tpl")
#
#  /*  vars = {
#
#    devops_domain                  = var.devops_domain
#    instance_profile               = aws_iam_instance_profile.jenkins_slave_instance_profile.arn
#    s3_bucket_name                 = var.s3_bucket_name_with_home_bundle
#    worker_sg_id                   = var.worker_sg_id
#    legacy_stack_id                = local.legacy_stack_id
#    stack                          = local.stack
#    stack_id                       = local.stack_id
#    stack_long                     = local.stack_long
#    environment                    = local.environment
#    legacy_jenkins_ssm_path_prefix = local.legacy_jenkins_ssm_path_prefix
#    jenkins_ssm_path_prefix        = local.jenkins_ssm_path_prefix
#    datadog_ssm_path_prefix        = local.datadog_ssm_path_prefix
#    github_ssm_path_prefix         = local.github_ssm_path_prefix
#    subnets_jenkins_slave          = "test"
#    is_prod                        = var.is_prod
#    jcasc_bucket                   = aws_s3_bucket.jcasc_bucket.id
#  }*/
#}