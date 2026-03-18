# -----------------------------------------------------------------------------
# Resource Groups
# -----------------------------------------------------------------------------

# Dedicated RG for the vWAN resource and virtual hubs
resource "azurerm_resource_group" "vwan" {
  name     = "rg-${var.prefix}-vwan"
  location = "francecentral"
  tags     = var.tags
}

# One RG per virtual hub for spoke VNets (stays within the 800 resources/RG limit)
resource "azurerm_resource_group" "spokes" {
  for_each = local.hubs

  name     = "rg-${var.prefix}-${each.key}"
  location = each.value.location
  tags     = var.tags
}

# -----------------------------------------------------------------------------
# Virtual WAN
# -----------------------------------------------------------------------------

resource "azurerm_virtual_wan" "this" {
  name                = var.prefix
  resource_group_name = azurerm_resource_group.vwan.name
  location            = azurerm_resource_group.vwan.location
  type                = "Standard"
  tags                = var.tags
}

# -----------------------------------------------------------------------------
# Virtual Hubs (3 per region, 6 total)
# -----------------------------------------------------------------------------

resource "azurerm_virtual_hub" "this" {
  for_each = local.hubs

  name                = each.key
  resource_group_name = azurerm_resource_group.vwan.name
  location            = each.value.location
  virtual_wan_id      = azurerm_virtual_wan.this.id
  address_prefix      = each.value.address_prefix
  tags                = var.tags
}
