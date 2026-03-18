locals {
  hubs = {
    "vhub01" = { location = "francecentral", address_prefix = "192.168.1.0/24" }
    "vhub02" = { location = "francecentral", address_prefix = "192.168.2.0/24" }
    "vhub03" = { location = "francecentral", address_prefix = "192.168.3.0/24" }
    "vhub04" = { location = "swedencentral", address_prefix = "192.168.4.0/24" }
    "vhub05" = { location = "swedencentral", address_prefix = "192.168.5.0/24" }
    "vhub06" = { location = "swedencentral", address_prefix = "192.168.6.0/24" }
  }

  # Sorted keys to guarantee deterministic global VNet index ordering
  hub_keys = sort(keys(local.hubs))

  # Flat list of all spoke VNets with a globally unique index for IP assignment
  # Global index starts at 1 so the first VNet gets 10.0.1.0/24 (skipping 10.0.0.0/24)
  vnet_list = flatten([
    for hub_idx, hub_key in local.hub_keys : [
      for vnet_idx in range(var.vnets_per_hub) : {
        key          = "${hub_key}-vnet${format("%04d", vnet_idx + 1)}"
        name         = "vnet-${hub_key}-${format("%04d", vnet_idx + 1)}"
        hub_key      = hub_key
        location     = local.hubs[hub_key].location
        global_index = hub_idx * var.vnets_per_hub + vnet_idx + 1
      }
    ]
  ])

  vnet_map = { for v in local.vnet_list : v.key => v }
}
