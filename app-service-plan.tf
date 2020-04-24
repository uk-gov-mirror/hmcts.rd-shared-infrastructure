locals {
  ase_name = "core-compute-${var.env}"
  asp_name_without_env = "${var.product}"

  asp_capacity = "${var.env == "prod" || var.env == "sprod" ? "4" : "2"}"
  asp_sku_size = "${var.env == "prod" || var.env == "sprod" ? "I2" : "I1"}"
}

module "rd_app_service_plan" {
  source              = "git@github.com:hmcts/cnp-module-app-service-plan?ref=master"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  env                 = "${var.env}"
  ase_name            = "${local.ase_name}"
  asp_name            = "${local.asp_name_without_env}"
  asp_capacity        = "${local.asp_capacity}"
  asp_sku_size        = "${local.asp_sku_size}"
  tag_list            = "${local.common_tags}"
}

output "appServicePlan" {
  value = "${local.asp_name_without_env}-${var.env}"
}

output "appServiceCapacity" {
  value = "${local.asp_capacity}"
}

output "appServiceSkuSize" {
  value = "${local.asp_sku_size}"
}
