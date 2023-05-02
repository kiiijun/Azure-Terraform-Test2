terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.53.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}

data "azurerm_client_config" "current" {
}

resource "azurerm_resource_group" "rg" {
  count    = var.resource_group_count
  name     = var.resource_group_name[count.index]
  location = var.location
  tags     = var.tags
}

module "hub_network" {
  source              = "./modules/virtual_network"
  resource_group_name = azurerm_resource_group.rg[0].name
  location            = var.location
  vnet_name           = var.hub_vnet_name
  address_space       = var.hub_address_space
  tags                = var.tags

  subnets = [
    {
      name : "AzureFirewallSubnet"
      address_prefixes : var.hub_firewall_subnet_address_prefix
    },
    {
      name : "GatewaySubnet"
      address_prefixes : var.hub_gateway_subnet_address_prefix
    }
  ]
}

module "spoke_network" {
  source              = "./modules/virtual_network"
  resource_group_name = azurerm_resource_group.rg["${var.resource_group_count}" - 1].name
  location            = var.location
  vnet_name           = var.spoke_vnet_name
  address_space       = var.spoke_address_space
  tags                = var.tags

  subnets = [
    {
      name : var.default_node_pool_subnet_name
      address_prefixes : var.default_node_pool_subnet_address_prefix
    },
    {
      name : var.additional_node_pool_subnet_name
      address_prefixes : var.additional_node_pool_subnet_address_prefix
    },
    {
      name : var.vm_subnet_name
      address_prefixes : var.vm_subnet_address_prefix
    }
  ]
}

module "vnet_peering" {
  source              = "./modules/virtual_network_peering"
  vnet_1_name         = var.hub_vnet_name
  vnet_1_id           = module.hub_network.vnet_id
  vnet_1_rg           = azurerm_resource_group.rg[0].name
  vnet_2_name         = var.spoke_vnet_name
  vnet_2_id           = module.spoke_network.vnet_id
  vnet_2_rg           = azurerm_resource_group.rg["${var.resource_group_count}" - 1].name
  peering_name_1_to_2 = "${var.hub_vnet_name}-to-${var.spoke_vnet_name}"
  peering_name_2_to_1 = "${var.spoke_vnet_name}-to-${var.hub_vnet_name}"
}

module "firewall" {
  source              = "./modules/firewall"
  name                = var.firewall_name
  resource_group_name = azurerm_resource_group.rg[0].name
  zones               = var.firewall_zones
  threat_intel_mode   = var.firewall_threat_intel_mode
  location            = var.location
  sku_name            = var.firewall_sku_name
  sku_tier            = var.firewall_sku_tier
  pip_name            = "${var.firewall_name}-pip"
  subnet_id           = module.hub_network.subnet_ids["AzureFirewallSubnet"]
  # log_analytics_workspace_id   = module.log_analytics_workspace.id
  # log_analytics_retention_days = var.log_analytics_retention_days
}

module "aks_cluster" {
  source                  = "./modules/aks"
  name                    = var.aks_cluster_name
  location                = var.location
  resource_group_name     = azurerm_resource_group.rg["${var.resource_group_count}" - 1].name
  resource_group_id       = azurerm_resource_group.rg["${var.resource_group_count}" - 1].id
  kubernetes_version      = var.kubernetes_version
  dns_prefix              = lower(var.aks_cluster_name)
  private_cluster_enabled = true
  # automatic_channel_upgrade                = var.automatic_channel_upgrade
  sku_tier                                 = var.sku_tier
  default_node_pool_name                   = var.default_node_pool_name
  default_node_pool_vm_size                = var.default_node_pool_vm_size
  vnet_subnet_id                           = module.spoke_network.subnet_ids[var.default_node_pool_subnet_name]
  default_node_pool_availability_zones     = var.default_node_pool_availability_zones
  default_node_pool_node_labels            = var.default_node_pool_node_labels
  default_node_pool_node_taints            = var.default_node_pool_node_taints
  default_node_pool_enable_auto_scaling    = var.default_node_pool_enable_auto_scaling
  default_node_pool_enable_host_encryption = var.default_node_pool_enable_host_encryption
  default_node_pool_enable_node_public_ip  = var.default_node_pool_enable_node_public_ip
  default_node_pool_max_pods               = var.default_node_pool_max_pods
  default_node_pool_max_count              = var.default_node_pool_max_count
  default_node_pool_min_count              = var.default_node_pool_min_count
  default_node_pool_node_count             = var.default_node_pool_node_count
  default_node_pool_os_disk_type           = var.default_node_pool_os_disk_type
  tags                                     = var.tags
  network_dns_service_ip                   = var.network_dns_service_ip
  network_plugin                           = var.network_plugin
  outbound_type                            = "loadBalancer"
  network_service_cidr                     = var.network_service_cidr
  tenant_id                                = data.azurerm_client_config.current.tenant_id
}
