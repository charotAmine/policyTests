locals {
  policy_files = fileset(var.policy_folder, "*.json")
 
  policy_files_without_extension = [ for p in local.policy_files: split(".", p)[0] ]
 
  policy_json = {
    for policy in local.policy_files_without_extension:
        policy => jsondecode(file(join("", [var.policy_folder, policy, ".json"])))
  }
}

data "azurerm_subscription" "current" {}

resource "azurerm_policy_definition" "policy" {
  for_each = local.policy_json
   
  name = join("", [var.name_space, "_", each.value.name])
  display_name = join("", [var.name_space, "_", each.value.properties.displayName])
  policy_type  = each.value.properties.policyType
  mode         = each.value.properties.mode
  metadata     = jsonencode(each.value.properties.metadata)
  policy_rule  = jsonencode(each.value.properties.policyRule)
  parameters   = jsonencode(each.value.properties.parameters)
   
  lifecycle {
    ignore_changes = [
      metadata
    ]
  }
}

resource "azurerm_policy_set_definition" "policy_set" {
  name         = join("", [var.name_space, "_PolicySet"])
  display_name = join("", [var.name_space, ": Policy Set"])
  policy_type  = "Custom"
 
  lifecycle {
    ignore_changes = [
      metadata
    ]
  }
  policy_definitions = jsonencode([ for p in local.policy_files_without_extension: {"policyDefinitionId": azurerm_policy_definition.policy[p].id }])
}

resource "azurerm_policy_assignment" "policy_assignment" {
  name    = join("", [var.name_space, "_PA"])
  scope   = data.azurerm_subscription.current.id

  policy_definition_id = azurerm_policy_set_definition.policy_set.id
  description          = join("", [var.name_space, ": policy assignment"])
  display_name         = join("", [var.name_space, "_PA"])
  location             = var.location

  identity {
    type = "SystemAssigned"
  }
}

