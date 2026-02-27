# module "components" {
#     source = "../../terraform-aws-components"
#     component = var.component
#     rule_priority = var.rule_priority
  
# }

module "components" {
  source = "git::https://github.com/devops-cloud-shop/terraform-roboshop-components.git?ref=main"
  for_each = var.components
  component = each.key
  rule_priority = each.value.rule_priority
}