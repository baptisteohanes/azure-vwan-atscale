# -----------------------------------------------------------------------------
# Resource Group (existing)
# -----------------------------------------------------------------------------

data "azurerm_resource_group" "vwan" {
  name = var.resource_group_name
}

# -----------------------------------------------------------------------------
# Virtual WAN
# -----------------------------------------------------------------------------

resource "azurerm_virtual_wan" "this" {
  name                = var.prefix
  resource_group_name = data.azurerm_resource_group.vwan.name
  location            = data.azurerm_resource_group.vwan.location
  type                = "Standard"
  tags                = var.tags
}

# -----------------------------------------------------------------------------
# Virtual Hubs (3 per region, 6 total)
# -----------------------------------------------------------------------------

resource "azurerm_virtual_hub" "this" {
  for_each = local.hubs

  name                = each.key
  resource_group_name = data.azurerm_resource_group.vwan.name
  location            = each.value.location
  virtual_wan_id      = azurerm_virtual_wan.this.id
  address_prefix      = each.value.address_prefix
  tags                = var.tags
}
