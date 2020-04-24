provider "azurerm" {
  alias           = "mgmt"
  subscription_id = "${var.mgmt_subscription_id}"
  version         = "=1.33.1"
}

locals {
  account_name      = "${replace("${var.product}${var.env}", "-", "")}"
  mgmt_network_name = "core-cftptl-intsvc-vnet"
  mgmt_network_rg_name = "aks-infra-cftptl-intsvc-rg"



  // for each client service two containers are created: one named after the service
  // and another one, named {service_name}-rejected, for storing envelopes rejected by bulk-scan
  client_service_names = ["jrdtest"]
}

data "azurerm_subnet" "trusted_subnet" {
  name                 = "${local.trusted_vnet_subnet_name}"
  virtual_network_name = "${local.trusted_vnet_name}"
  resource_group_name  = "${local.trusted_vnet_resource_group}"
}

data "azurerm_subnet" "jenkins_subnet" {
  provider             = "azurerm.mgmt"
  name                 = "iaas"
  virtual_network_name = "${data.azurerm_virtual_network.mgmt_vnet.name}"
  resource_group_name  = "${data.azurerm_virtual_network.mgmt_vnet.resource_group_name}"
}}

resource "azurerm_storage_account" "storage_account" {
  name                = "${local.account_name}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  location                 = "${azurerm_resource_group.rg.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "BlobStorage"

 // custom_domain {
 //   name          = "${var.external_hostname}"
  //  use_subdomain = "false"
 // }


  network_rules {
    virtual_network_subnet_ids = ["${data.azurerm_subnet.trusted_subnet.id}", "${data.azurerm_subnet.jenkins_subnet.id}"]
    bypass                     = ["Logging", "Metrics", "AzureServices"]
    default_action             = "Deny"
  }

  tags = "${local.tags}"
}

resource "azurerm_storage_container" "service_containers" {
  name                 = "${local.client_service_names[count.index]}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  storage_account_name = "${module.storage_account.storageaccount_name}"
  count                = "${length(local.client_service_names)}"
}

resource "azurerm_storage_container" "service_rejected_containers" {
  name                 = "${local.client_service_names[count.index]}-archive"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  storage_account_name = "${module.storage_account.storageaccount_name}"
  count                = "${length(local.client_service_names)}"
}

resource "azurerm_key_vault_secret" "storage_account_name" {
  name      = "storage-account-name"
  value     = "${module.storage_account.storageaccount_name}"
  vault_uri = "${data.azurerm_key_vault.key_vault.vault_uri}"
}

resource "azurerm_key_vault_secret" "storageaccount_id" {
  name         = "storage-account-id"
  value        = "${module.storage_account.storageaccount_id}"
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
}

resource "azurerm_key_vault_secret" "storage_account_primary_key" {
  name      = "storage-account-primary-key"
  value     = "${module.storage_account.storageaccount_primary_access_key}"
  vault_uri = "${data.azurerm_key_vault.key_vault.vault_uri}"
}

output "storage_account_name" {
  value = "${module.storage_account.storageaccount_name}"
}

output "storage_account_primary_key" {
  sensitive = true
  value     = "${module.storage_account.storageaccount_primary_access_key}"
}
