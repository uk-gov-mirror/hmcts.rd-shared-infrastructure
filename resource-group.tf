
resource "azurerm_resource_group" "rg" {
  name     = join("-", [var.product, var.env])
  location = var.location
  tags     = merge(tomap(local.common_tags), tomap({"lastUpdated" = timestamp()}))
}