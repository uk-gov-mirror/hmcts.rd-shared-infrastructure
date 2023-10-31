resource "azurerm_resource_group" "rg" {
  name     = join("-", [var.product, var.env])
  location = var.location
  tags     = merge(local.tags_with_env, tomap({
    "lastUpdated" = timestamp()
  }))
}