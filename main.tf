locals {
  common_tags = {
    "environment"  = var.env
    "Team Name"    = var.team_name
    "Team Contact" = var.team_contact
    "Destroy Me"   = var.destroy_me
    "managedBy"    = var.team_name
  }

  tags = merge(tomap(var.common_tags), 
    tomap({"Team Contact" = "#referencedata"})
  )
}