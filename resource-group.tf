
resource "azurerm_resource_group" "rg" {
  name     = join("-", [var.product, var.env])
  location = var.location
  tags     = merge(local.common_tags, tomap({"lastUpdated" = timestamp()}))
}