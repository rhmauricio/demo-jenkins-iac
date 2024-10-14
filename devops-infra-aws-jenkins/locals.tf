locals {
  stack_id = var.stack_id
    common_tags = {
    stack_id              = local.stack_id
#    stack                 = local.stack
#    layer                 = local.layer
#    environment           = local.environment
#    tool                  = local.tec_presuf
#    origin                = local.origin
#    stack_long            = local.stack_long
    "info:applicationID"  = "CHANGEME"
    "info:env"            = "CHANGEME"
    "business:CostCenter" = "CHANGEME"
    "business:owner"      = "CHANGEME"
  }

}