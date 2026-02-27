module "components" {
    source = "../../terraform-aws-components"
    component = var.component
    rule_priority = var.rule_priority
  
}