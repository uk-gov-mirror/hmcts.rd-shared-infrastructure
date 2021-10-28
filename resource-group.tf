
resource "azurerm_resource_group" "rg" {
  name      = join("-", [var.product, var.env])
  location  = var.location
  tags      = var.common_tags
  # tags     = merge(tomap(local.common_tags), tomap({"lastUpdated" = timestamp()}))
}