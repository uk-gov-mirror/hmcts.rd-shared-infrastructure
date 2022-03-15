locals {
  servicebus_namespace_name_premium                     = join("-", [var.product, "servicebus", var.env, "premium"])
}

module "servicebus-namespace-premium" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-namespace?ref=master"
  name                = local.servicebus_namespace_name_premium
  location            = var.location
  env                 = var.env
  common_tags         = local.common_tags
  resource_group_name = local.resource_group_name
}

module "caseworker-topic-premium" {
  source                = "git@github.com:hmcts/terraform-module-servicebus-topic?ref=master"
  name                  = local.caseworker_topic_name
  namespace_name        = module.servicebus-namespace.name
  resource_group_name   = local.resource_group_name
}

module "caseworker-subscription-premium" {
  source                = "git@github.com:hmcts/terraform-module-servicebus-subscription?ref=master"
  name                  = local.caseworker_subscription_name
  namespace_name        = module.servicebus-namespace-premium.name
  topic_name            = module.caseworker-topic.name
  resource_group_name   = local.resource_group_name
}

module "judicial-topic-premium" {
  source                = "git@github.com:hmcts/terraform-module-servicebus-topic?ref=master"
  name                  = local.judicial_topic_name
  namespace_name        = module.servicebus-namespace-premium.name
  resource_group_name   = local.resource_group_name
}

module "judicial-subscription-premium" {
  source                = "git@github.com:hmcts/terraform-module-servicebus-subscription?ref=master"
  name                  = local.judicial_subscription_name
  namespace_name        = module.servicebus-namespace-premium.name
  topic_name            = module.judicial-topic.name
  resource_group_name   = local.resource_group_name
}

module "am-orm-judicial-test-pr-subscription-premium" {
  source                = "git@github.com:hmcts/terraform-module-servicebus-subscription?ref=master"
  count                 = lower(var.env) == "aat" ? 1 : 0
  name                  = "am-orm-judicial-preview-functional-test"
  namespace_name        = module.servicebus-namespace-premium.name
  topic_name            = module.judicial-topic.name
  resource_group_name   = local.resource_group_name
}

resource "azurerm_key_vault_secret" "caseworker-topic-primary-send-listen-shared-access-key-premium" {
  name         = "caseworker-topic-primary-send-listen-shared-access-key"
  value        = module.caseworker-topic.primary_send_and_listen_shared_access_key
  key_vault_id = module.rd_key_vault.key_vault_id
}

resource "azurerm_key_vault_secret" "judicial-topic-primary-send-listen-shared-access-key-premium" {
  name         = "judicial-topic-primary-send-listen-shared-access-key"
  value        = module.judicial-topic.primary_send_and_listen_shared_access_key
  key_vault_id = module.rd_key_vault.key_vault_id
}

resource "azurerm_key_vault_secret" "caseworker-topic-primary-connection-string-premium" {
  name         = "caseworker-topic-primary-connection-string"
  value        = module.caseworker-topic.primary_send_and_listen_connection_string
  key_vault_id = module.rd_key_vault.key_vault_id
}

resource "azurerm_key_vault_secret" "judicial-topic-primary-connection-string-premium" {
  name         = "judicial-topic-primary-connection-string"
  value        = module.judicial-topic.primary_send_and_listen_connection_string
  key_vault_id = module.rd_key_vault.key_vault_id
}