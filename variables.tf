//리소스 그룹 변수
variable "resource_group_name" {
  default = "test-rg"
  type    = string
}
variable "location" {
  default = "Korea Central"
  type    = string
}
variable "tags" {
  default = {}
}

//허브 vnet 변수
variable "hub_vnet_name" {
  default = "hub-vnet"
  type    = string
}
variable "hub_address_space" {
  default = ["10.1.0.0/16"]
  type    = list(string)
}
variable "hub_firewall_subnet_address_prefix" {
  default = ["10.1.0.0/24"]
  type    = list(string)
}
variable "hub_gateway_subnet_address_prefix" {
  default = ["10.1.1.0/24"]
  type    = list(string)
}

//스포크 vnet 변수
variable "spoke_vnet_name" {
  default = "spoke-vnet"
  type    = string
}
variable "spoke_address_space" {
  default = ["10.2.0.0/16"]
  type    = list(string)
}
variable "spoke_aks_subnet_address_prefix" {
  default = ["10.2.0.0/24"]
  type    = list(string)
}
