terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.53.0"
    }
  }
}


resource "azurerm_public_ip" "pip" {
  name                = var.pip_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
  allocation_method   = "Static"
  tags                = var.tags
}

resource "azurerm_virtual_network_gateway" "vpn_gateway" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  type                = var.type
  vpn_type            = var.vpn_type

  active_active = var.active_active
  enable_bgp    = var.enable_bgp

  sku        = var.vpn_type == "PolicyBased" ? "Basic" : var.sku
  generation = var.sku == "VpnGw1" || var.sku == "VpnGw1AZ" || var.sku == "Basic" ? "Generation1" : "Generation2"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.subnet_id
  }


}
