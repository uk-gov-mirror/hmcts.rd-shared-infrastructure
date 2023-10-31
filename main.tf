locals {
  common_tags = {
    "Team Name"    = var.team_name
    "Team Contact" = var.team_contact
    "Destroy Me"   = var.destroy_me
    "managedBy"    = var.team_name
    "application"  = "referencedata"
    "builtFrom"    = "https://github.com/hmcts/rd-shared-infrastructure"
    "businessArea" = "CFT"
  }

  tags = merge(var.common_tags, {"Team Contact" = "#referencedata"})
}