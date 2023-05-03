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
      name : var.aks_subnet_name
      address_prefixes : var.aks_subnet_address_prefix
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
}
module "vpngw" {
  source              = "./modules/virtual_network_gateway"
  name                = var.vpngw_name
  resource_group_name = azurerm_resource_group.rg[0].name
  location            = var.location
  pip_name            = "${var.vpngw_name}-pip"
  type                = var.vpngw_type
  vpn_type            = var.vpngw_vpn_type
  active_active       = var.vpngw_active_active
  enable_bgp          = var.vpngw_enable_bgp
  sku                 = var.vpngw_sku
  subnet_id           = module.hub_network.subnet_ids["GatewaySubnet"]
}
module "aks" {
  source                       = "./modules/kubernetes"
  cluster_name                 = var.cluster_name
  dns_prefix                   = lower(var.cluster_name)
  resource_group_name          = azurerm_resource_group.rg["${var.resource_group_count}" - 1].name
  location                     = var.location
  default_node_pool_name       = var.default_node_pool_name
  default_node_pool_node_count = var.default_node_pool_node_count
  default_node_pool_vm_size    = var.default_node_pool_vm_size

}
