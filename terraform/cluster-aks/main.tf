terraform {
  backend "azurerm" {
    resource_group_name  = "#{Platform.Azure.ResourceGroup.Demo}"
    storage_account_name = "#{Platform.Azure.StorageAccountName}"
    container_name       = "#{Platform.Azure.ContainerName}"
    key                  = "#{Project.Terraform.Cluster.Key}"
  }
}

provider "azurerm" {
   features {}
}

variable "resource_group_name" {
  type = string
  default = "#{Project.Cluster.ResourceGroup}"
}

variable "location" {
  type = string
  default = "#{Project.Cluster.Location}"
}

variable "cluster_name" {
  type = string
  default = "#{Project.Cluster.Name}"
}

variable "kubernetes_version" {
  type = string
  default = "1.29.0"
}

variable "client_id" {
  type = string
  default = "#{Project.Azure.Account.Client}"
}

variable "client_secret" {
  type = string
  default = "#{Project.Azure.Account.Password}"
  sensitive = true
}

variable "owner" {
  type = "string"
  default = "demo.octopus.app"
}

variable "subscription_id" {
  type = string
  default = "#{Project.Azure.Account.SubscriptionNumber}"
}

variable "tenant_id" {
  type = string
  default = "#{Project.Azure.Account.TenantId}"
}

resource "random_string" "pool_name" {
  length = 10
  special = false
  upper = false
}

resource "azurerm_kubernetes_cluster" "default" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  kubernetes_version = var.kubernetes_version
  dns_prefix          = var.cluster_name
  role_based_access_control {
  	enabled = true
  }

  default_node_pool {
    name            = var.pool_name
    node_count      = 1
    vm_size         = "Standard_D2_v2"
    enable_auto_scaling = true
    min_count       = 1
    max_count       = 100
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  tags = {
    owner = "${var.owner}"
    managed = "true"
    expires = "false"
  }
}
