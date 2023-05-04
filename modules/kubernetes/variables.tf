variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}
variable "dns_prefix" {
  type = string
}
variable "cluster_name" {
  type    = string
  default = "aks"
}
variable "default_node_pool_name" {
  type    = string
  default = "default"
}
variable "default_node_pool_node_count" {
  type    = number
  default = 1
}
variable "default_node_pool_vm_size" {
  type    = string
  default = "Standard_B2s"
}
variable "zones" {
  default = ["1", "2", "3"]
  type    = list(string)
}
variable "default_node_pool_enable_auto_scaling" {
  default = true
  type    = bool
}
variable "default_node_pool_min_count" {
  default = 1
  type    = number
}
variable "default_node_pool_max_count" {
  default = 3
  type    = number
}
variable "default_node_pool_max_pods" {
  default = 30
  type    = number
}
variable "identity" {
  type    = string
  default = "SystemAssigned"
}
variable "tags" {
  default = {}
}
variable "vnet_subnet_id" {
  type = string
}
variable "network_plugin" {
  default = "azure"
  type    = string
}
variable "private_cluster_enabled" {
  default = true
  type    = bool
}
variable "sku_tier" {
  default = "Free"
  type    = string
}
