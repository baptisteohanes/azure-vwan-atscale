variable "prefix" {
  description = "Prefix for all resource names"
  type        = string
  default     = "vwan-atscale"
}

variable "vnets_per_hub" {
  description = "Number of spoke VNets per virtual hub"
  type        = number
  default     = 150
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}