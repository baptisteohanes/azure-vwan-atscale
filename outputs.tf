output "vwan_id" {
  description = "ID of the Virtual WAN"
  value       = azurerm_virtual_wan.this.id
}

output "virtual_hub_ids" {
  description = "Map of virtual hub names to their IDs"
  value       = { for k, v in azurerm_virtual_hub.this : k => v.id }
}

output "spoke_vnet_count" {
  description = "Total number of spoke VNets created"
  value       = length(azurerm_virtual_network.spokes)
}
