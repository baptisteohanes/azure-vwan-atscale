# -----------------------------------------------------------------------------
# Virtual Hub <-> Spoke VNet Connections (one per VNet, 2700 total)
# -----------------------------------------------------------------------------

resource "azurerm_virtual_hub_connection" "this" {
  for_each = local.vnet_map

  name                      = "conn-${each.value.name}"
  virtual_hub_id            = azurerm_virtual_hub.this[each.value.hub_key].id
  remote_virtual_network_id = azurerm_virtual_network.spokes[each.key].id
}
