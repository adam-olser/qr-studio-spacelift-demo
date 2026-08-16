variable "render_owner_id" {
  description = "Render workspace/owner ID (starts with 'tea-' or 'usr-'), from Render dashboard > Account Settings."
  type        = string
}

variable "render_region" {
  description = "Render region for services."
  type        = string
  default     = "oregon"
}
