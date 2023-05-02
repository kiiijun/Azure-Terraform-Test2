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
variable "default_node_pool_subnet_name" {
  default = "system-subnet"
  type    = string
}
variable "default_node_pool_subnet_address_prefix" {
  default = ["10.2.1.0/24"]
  type    = list(string)
}
variable "additional_node_pool_subnet_name" {
  default = "user-subnet"
  type    = string
}
variable "additional_node_pool_subnet_address_prefix" {
  default = ["10.2.2.0/24"]
  type    = list(string)
}
variable "vm_subnet_name" {
  default = "vm-subnet"
  type    = string
}
variable "vm_subnet_address_prefix" {
  default = ["10.2.3.0/24"]
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

//aks
variable "aks_cluster_name" {
  default = "spoke-aks"
  type    = string
}
variable "kubernetes_version" {
  default = "1.25.6"
  type    = string
}
variable "sku_tier" {
  default = "Free"
  type    = string
}


//default node pool 변수
variable "default_node_pool_name" {
  default = "system"
  type    = string
}
variable "default_node_pool_vm_size" {
  default = "Standard_B2s"
  type    = string
}
variable "default_node_pool_availability_zones" {
  default = []
  type    = list(string)
}
variable "default_node_pool_node_labels" {
  default = {}
  type    = map(any)
}
variable "default_node_pool_node_taints" {
  default = []
  type    = list(string)
}
variable "default_node_pool_enable_auto_scaling" {
  default = true
  type    = bool
}
variable "default_node_pool_enable_host_encryption" {
  default = false
  type    = bool
}
variable "default_node_pool_enable_node_public_ip" {
  default = false
  type    = bool
}
variable "default_node_pool_max_pods" {
  default = 30
  type    = number
}
variable "default_node_pool_max_count" {
  type    = number
  default = 10
}
variable "default_node_pool_min_count" {
  type    = number
  default = 3
}
variable "default_node_pool_node_count" {
  type    = number
  default = 3
}
variable "default_node_pool_os_disk_type" {
  type    = string
  default = "Managed"
}
variable "network_dns_service_ip" {
  default = "10.2.0.10"
  type    = string
}
variable "network_plugin" {
  default = "azure"
  type    = string
}
variable "network_service_cidr" {
  default = "10.2.0.0/24"
  type    = string
}
variable "role_based_access_control_enabled" {
  default = false
  type    = bool
}
