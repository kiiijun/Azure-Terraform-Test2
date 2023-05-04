terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.53.0"
    }
  }
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                    = var.cluster_name
  location                = var.location
  resource_group_name     = var.resource_group_name
  dns_prefix              = var.dns_prefix
  tags                    = var.tags
  private_cluster_enabled = var.private_cluster_enabled
  sku_tier                = var.sku_tier

  default_node_pool {
    vnet_subnet_id      = var.vnet_subnet_id
    name                = var.default_node_pool_name
    node_count          = var.default_node_pool_node_count
    vm_size             = var.default_node_pool_vm_size
    zones               = var.zones
    enable_auto_scaling = var.default_node_pool_enable_auto_scaling
    min_count           = var.default_node_pool_min_count
    max_count           = var.default_node_pool_max_count
    max_pods            = var.default_node_pool_max_pods
  }
  network_profile {
    network_plugin = var.network_plugin
  }

  identity {
    type = var.identity
  }
}
