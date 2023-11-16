locals {
  rd_data_extract_product         = "rddataextract"
  rd_data_extract_account_name    = join("", [local.rd_data_extract_product, var.env])
  rd_data_extract_container_name  = "rd-data-extract"

  allowed_roles = [
    "Storage Account Delegator",
    "Storage Blob Delegator",
  ]
}

data "azuread_group" "sc_group" {
  display_name     = "DTS Ref Data SC (env:production)"
  security_enabled = true
}

data "azurerm_client_config" "this" {}

data "azurerm_subscription" "primary" {
}

module "storage_account_rd_data_extract" {
  source                   = "git@github.com:hmcts/cnp-module-storage-account?ref=master"
  env                      = var.env
  storage_account_name     = local.rd_data_extract_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_kind             = var.rd_data_extract_storage_account_kind
  account_tier             = "Standard"
  account_replication_type = var.rd_data_extract_storage_repl_type
  access_tier              = var.rd_data_extract_storage_access_tier

  enable_https_traffic_only = true

  pim_roles = {
    "Storage Account Delegator" = {
      principal_id = data.azuread_group.sc_group.id
    }
    "Storage Blob Delegator" = {
      principal_id = data.azuread_group.sc_group.id
    }
  }

  // Tags
  common_tags  = local.tags
  team_contact = var.team_contact
  destroy_me   = var.destroy_me
  default_action = "Allow"
}

resource "azurerm_storage_container" "data_extract_service_container" {
  name                 = local.rd_data_extract_container_name
  storage_account_name = module.storage_account_rd_data_extract.storageaccount_name
}

resource "azurerm_key_vault_secret" "rd_data_extract_storage_account_name" {
  name         = "rd-data-extract-storage-account-name"
  value        = module.storage_account_rd_data_extract.storageaccount_name
  key_vault_id = module.rd_key_vault.key_vault_id
}

resource "azurerm_key_vault_secret" "rd_data_extract_storageaccount_id" {
  name         = "rd-data-extract-storage-account-id"
  value        = module.storage_account_rd_data_extract.storageaccount_id
  key_vault_id = module.rd_key_vault.key_vault_id
}

resource "azurerm_key_vault_secret" "rd_data_extract_storage_account_primary_key" {
  name         = "rd-data-extract-storage-account-primary-key"
  value        = module.storage_account_rd_data_extract.storageaccount_primary_access_key
  key_vault_id = module.rd_key_vault.key_vault_id
}