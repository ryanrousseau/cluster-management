terraform {
  backend "azurerm" {
    resource_group_name  = "#{Platform.Azure.ResourceGroup.Demo}"
    storage_account_name = "#{Platform.Azure.StorageAccountName}"
    container_name       = "#{Platform.Azure.ContainerName}"
    key                  = "#{Project.Terraform.Cluster.Key}"
  }

  required_providers {
    rancher2 = {
      source = "rancher/rancher2"
    }
  }
}

provider "azurerm" {
   features {}
}

provider "rancher2" {
  api_url = var.rancher_url
  token_key = var.rancher_token
}

variable "rancher_url" {
  type = string
  default = "#{Platform.Rancher.Url}"
}

variable "rancher_token" {
  type = string
  default = "#{Project.Rancher.Token}"
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

resource "rancher2_cloud_credential" "azure_cloud_credentials" {
  name = "${var.cluster_name}-creds"
  azure_credential_config {
    client_id = var.client_id
    client_secret = var.client_secret
    subscription_id = var.subscription_id
    tenant_id = var.tenant_id
  }
}

resource "rancher2_cluster" "cluster_az" {
  name         = var.cluster_name
  description  = "Terraform"
  
  aks_config_v2 {
    cloud_credential_id = rancher2_cloud_credential.azure_cloud_credentials.id
    name = var.cluster_name
    resource_group = var.resource_group_name
    resource_location = var.location
    kubernetes_version = var.kubernetes_version
    dns_prefix = var.cluster_name
    network_plugin = "kubenet"
    node_pools {
      availability_zones = ["1", "2", "3"]
      name = "p${random_string.pool_name.result}"
      count = 1
      enable_auto_scaling = true
      min_count = 1
      max_count = 5
      orchestrator_version = var.kubernetes_version
      os_disk_size_gb = 128
      vm_size = "Standard_D2_v2"
    }
  }
}

output "cluster_id" {
  value =  rancher2_cluster.cluster_az.id
}