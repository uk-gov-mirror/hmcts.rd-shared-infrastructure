locals {
  component    = "sbtest"
  sb_name      = "${var.product}-${local.component}-${var.env}"
  topic_name   = "${var.product}-${local.component}-topic-${var.env}"
  sub_name     = "${var.product}-${local.component}-subscription-${var.env}"
  queue_name   = "${var.product}-${local.component}-queue-${var.env}"
  rg_test      = azurerm_resource_group.rg-test.name
}

resource "azurerm_resource_group" "rg-test" {
  name     = "${var.product}-${local.component}-${var.env}"
  location = var.location
  tags     = merge(local.common_tags, map("lastUpdated", timestamp()))
}

module "sbtest-servicebus-namespace" {
  # source              = "git@github.com:hmcts/terraform-module-servicebus-namespace?ref=servicebus_tf"
  source              = "git@github.com:hmcts/terraform-module-servicebus-namespace?ref=master"
  name                = local.sb_name
  location            = var.location
  env                 = var.env
  common_tags         = local.common_tags
  resource_group_name = local.rg_test
}

module "sbtest-queue" {
  # source              = "git@github.com:hmcts/terraform-module-servicebus-queue?ref=servicebus_queue_tf"
  source              = "git@github.com:hmcts/terraform-module-servicebus-queue?ref=master"
  name                = local.queue_name
  namespace_name      = module.sbtest-servicebus-namespace.name
  resource_group_name = local.rg_test
}

module "sbtest-topic" {
  # source              = "git@github.com:hmcts/terraform-module-servicebus-topic?ref=servicebus_topic_tf"
  source              = "git@github.com:hmcts/terraform-module-servicebus-topic?ref=master"
  name                = local.topic_name
  namespace_name      = module.sbtest-servicebus-namespace.name
  resource_group_name = local.rg_test
}

module "sbtest-subscription" {
  # source              = "git@github.com:hmcts/terraform-module-servicebus-subscription?ref=servicebus_subscription_tf"
  source              = "git@github.com:hmcts/terraform-module-servicebus-subscription?ref=master"
  name                = local.sub_name
  namespace_name      = module.sbtest-servicebus-namespace.name
  topic_name          = module.sbtest-topic.name
  resource_group_name = local.rg_test
}