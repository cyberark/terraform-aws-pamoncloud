locals {
  components = [
    "Vault",
    "CPM",
    "PVWA",
    "PSM",
    "PSMP",
    "PTA",
    "Bastion"
  ]

  rules = flatten([
    for component, rules in var.rules : [
      for rule_name, rule in rules : {
        component = component
        rule_name = rule_name
        rule      = rule
      }
    ] if !(component == "Bastion" && length(var.bastion_access_cidr) == 0)
  ])
}


resource "aws_security_group" "security_group" {
  for_each    = toset(local.components)
  vpc_id      = module.pam_vpc.vpc_id
  name        = "${each.key}-SG"
  description = "Security group for ${each.key} instances"

  tags = {
    Name = "${each.key}-SG"
  }
}

resource "aws_security_group_rule" "rules_with_cidr" {
  for_each = { for rule in local.rules : rule.rule_name => rule }

  type              = each.value.rule[0]
  from_port         = each.value.rule[1]
  to_port           = each.value.rule[2]
  protocol          = each.value.rule[3]
  description       = each.value.rule[4]
  security_group_id = aws_security_group.security_group[each.value.component].id

  cidr_blocks = (
    contains(keys(local.cidr_map), each.value.rule[5])
    ? local.cidr_map[each.value.rule[5]]
    : (each.value.rule[5] != null
      ? [lookup(local.subnet_cidr_map, each.value.rule[5], each.value.rule[5])]
      : [])
  )

  depends_on = [aws_security_group.security_group]
}