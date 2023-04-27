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

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "hub_network" {
  source              = "./modules/virtual_network"
  resource_group_name = azurerm_resource_group.rg.name
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
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  vnet_name           = var.spoke_vnet_name
  address_space       = var.spoke_address_space
  tags                = var.tags

  subnets = [
    {
      name : "aks-subnet"
      address_prefixes : var.spoke_aks_subnet_address_prefix
    }
  ]
}

module "vnet_peering" {
  source              = "./modules/virtual_network_peering"
  vnet_1_name         = var.hub_vnet_name
  vnet_1_id           = module.hub_network.vnet_id
  vnet_1_rg           = azurerm_resource_group.rg.name
  vnet_2_name         = var.spoke_vnet_name
  vnet_2_id           = module.spoke_network.vnet_id
  vnet_2_rg           = azurerm_resource_group.rg.name
  peering_name_1_to_2 = "${var.hub_vnet_name}To${var.spoke_vnet_name}"
  peering_name_2_to_1 = "${var.spoke_vnet_name}To${var.hub_vnet_name}"
}
