//리소스 그룹 변수
variable "resource_group_count" {
  default = 2
  type    = number
}
variable "resource_group_name" {
  default = ["hub-rg", "spoke-rg"]
  type    = list(string)
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

variable "aks_subnet_name" {
  default = "aks-subnet"
  type    = string
}
variable "aks_subnet_address_prefix" {
  default = ["10.2.0.0/24"]
  type    = list(string)
}

variable "vm_subnet_name" {
  default = "vm-subnet"
  type    = string
}
variable "vm_subnet_address_prefix" {
  default = ["10.2.1.0/24"]
  type    = list(string)
}

//firewall 변수
variable "firewall_name" {
  default = "azfw"
  type    = string
}
variable "firewall_zones" {
  default = []
  type    = list(string)
}
variable "firewall_threat_intel_mode" {
  default = "Alert"
  type    = string
}
variable "firewall_sku_name" {
  default = "AZFW_VNet"
  type    = string
}
variable "firewall_sku_tier" {
  default = "Standard"
  type    = string
}
