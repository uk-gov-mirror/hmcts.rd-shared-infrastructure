locals {
  servicebus_namespace_name = "${var.product}-servicebus-${var.env}"
  caseworker_topic_name     = "${var.product}-caseworker-topic-${var.env}"
  subscription_name         = "${var.product}-caseworker-subscription-${var.env}"
  queue_name1               = "${var.product}-caseworker-queue-1-${var.env}"
  queue_name2               = "${var.product}-caseworker-queue-2-${var.env}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
}

module "servicebus-namespace" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-namespace?ref=servicebus_tf"
  name                = "${local.servicebus_namespace_name}"
  location            = "${var.location}"
  env                 = "${var.env}"
  common_tags         = "${local.common_tags}"
  resource_group_name = "${local.resource_group_name}"
}

module "caseworker-topic" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-topic?ref=servicebus_topic_tf"
  name                = "${local.caseworker_topic_name}"
  namespace_name      = "${module.servicebus-namespace.name}"
  resource_group_name = "${local.resource_group_name}"
}

module "caseworker-subscription" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-subscription?ref=servicebus_subscription_tf"
  name                = "${local.subscription_name}"
  namespace_name      = "${module.servicebus-namespace.name}"
  topic_name          = "${module.caseworker-topic.name}"
  resource_group_name = "${local.resource_group_name}"
}

# module "caseworker-queue-1" {
#   source              = "git@github.com:hmcts/terraform-module-servicebus-queue?ref=servicebus_queue_tf"
#   name                = local.queue_name1
#   namespace_name      = module.servicebus-namespace.name
#   resource_group_name = azurerm_resource_group.rg.name
# }

# module "caseworker-queue-2" {
#   source              = "git@github.com:hmcts/terraform-module-servicebus-queue?ref=servicebus_queue_tf"
#   name                = local.queue_name2
#   namespace_name      = module.servicebus-namespace.name
#   resource_group_name = azurerm_resource_group.rg.name
# }

# module "caseworker-queue-new-1" {
#   source              = "git@github.com:hmcts/terraform-module-servicebus-queue?ref=servicebus_queue_tf"
#   name                = "queue-new-1"
#   namespace_name      = module.servicebus-namespace.name
#   resource_group_name = azurerm_resource_group.rg.name
# }

# module "caseworker-queue-new-2" {
#   source              = "git@github.com:hmcts/terraform-module-servicebus-queue?ref=servicebus_queue_tf"
#   name                = "queue-new-2"
#   namespace_name      = module.servicebus-namespace.name
#   resource_group_name = azurerm_resource_group.rg.name
# }

resource "azurerm_key_vault_secret" "caseworker-topic-primary-send-listen-conn-str" {
  name         = "caseworker-topic-primary-send-listen-connection-string"
  value        = "${module.caseworker-topic.primary_send_and_listen_connection_string}"
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
}

resource "azurerm_key_vault_secret" "caseworker-topic-secondary-send-listen-conn-str" {
  name         = "caseworker-topic-secondary-send-listen-connection-string"
  value        = "${module.caseworker-topic.secondary_send_and_listen_connection_string}"
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
}

resource "azurerm_key_vault_secret" "caseworker-topic-primary-send-listen-shared-access-key" {
  name         = "caseworker-topic-primary-send-listen-shared-access-key"
  value        = "${module.caseworker-topic.primary_send_and_listen_shared_access_key}"
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
}

resource "azurerm_key_vault_secret" "caseworker-topic-secondary-send-listen-shared-access-key" {
  name         = "caseworker-topic-secondary-send-listen-shared-access-key"
  value        = "${module.caseworker-topic.secondary_send_and_listen_shared_access_key}"
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
}