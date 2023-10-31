locals {
  tags_kv = merge(var.common_tags, tomap({
    "Team Name"    = var.team_name
    "Team Contact" = var.team_contact
    "Destroy Me"   = var.destroy_me
    "managedBy"    = var.team_name
    "application"  = "referencedata"
    "builtFrom"    = "https://github.com/hmcts/rd-shared-infrastructure"
    "businessArea" = "CFT"
  }))

  tags = merge(var.common_tags, tomap({
    "environment"  = var.env
    "Team Name"    = var.team_name
    "Team Contact" = var.team_contact
    "Destroy Me"   = var.destroy_me
    "managedBy"    = var.team_name
    "application"  = "referencedata"
    "builtFrom"    = "https://github.com/hmcts/rd-shared-infrastructure"
    "businessArea" = "CFT"
  }))
}