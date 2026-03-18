# -----------------------------------------------------------------------------
# Spoke Virtual Networks (450 per hub, 2700 total)
#
# Each VNet receives a unique /24 from the 10.0.0.0/8 range using cidrsubnet.
# global_index 1 -> 10.0.1.0/24, 2 -> 10.0.2.0/24, …, 256 -> 10.1.0.0/24, etc.
# -----------------------------------------------------------------------------

resource "azurerm_virtual_network" "spokes" {
  for_each = local.vnet_map

  name                = each.value.name
  resource_group_name = azurerm_resource_group.spokes[each.value.hub_key].name
  location            = each.value.location
  address_space       = [cidrsubnet("10.0.0.0/8", 16, each.value.global_index)]
  tags                = var.tags
}
