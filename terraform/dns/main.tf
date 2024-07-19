terraform {
  backend "azurerm" {
    resource_group_name  = "#{Platform.Azure.ResourceGroup.Demo}"
    storage_account_name = "#{Platform.Azure.StorageAccountName}"
    container_name       = "#{Platform.Azure.ContainerName}"
    key                  = "#{Project.Terraform.DNS.Key}"
  }
}

provider "azurerm" {
  skip_provider_registration = "true"
  features {}
}

variable "resource_group_name" {
  type        = string
  default     = "#{Platform.Azure.ResourceGroup.Shared}"
}

variable "dns_zone_name" {
  type        = string
  default     = "#{Platform.DNS.ZoneName}"
}

variable "dns_records" {
  type        = list(string)
  default     = ["1.2.3.4", "1.2.3.5"]
}

variable "dns_ttl" {
  type        = number
  default     = "#{Platform.DNS.TTL}"
}

resource "azurerm_dns_a_record" "record" {
  name                = "#{Project.Cluster.Name}"
  resource_group_name = var.resource_group_name
  zone_name           = var.dns_zone_name
  ttl                 = var.dns_ttl
  records             = var.dns_records
}