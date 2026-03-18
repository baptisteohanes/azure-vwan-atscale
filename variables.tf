variable "prefix" {
  description = "Prefix for all resource names"
  type        = string
  default     = "vwan-atscale"
}

variable "resource_group_name" {
  description = "Name of the existing resource group for the vWAN and hubs"
  type        = string
}

variable "vnets_per_hub" {
  description = "Number of spoke VNets per virtual hub"
  type        = number
  default     = 450
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}