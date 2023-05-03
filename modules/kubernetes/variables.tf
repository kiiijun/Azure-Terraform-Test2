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
variable "identity" {
  type    = string
  default = "SystemAssigned"
}
variable "tags" {
  default = {}
}
