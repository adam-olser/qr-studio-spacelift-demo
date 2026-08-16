terraform {
  required_version = ">= 1.6.0"

  required_providers {
    render = {
      source  = "render-oss/render"
      version = "~> 1.5"
    }
  }
}

provider "render" {
  # RENDER_API_KEY env var (set as a Spacelift mounted secret)
  owner_id = var.render_owner_id
}

# The backend web service itself stays on Render's free plan, deployed via
# the existing render.yaml Blueprint in the app repo — the render-oss
# Terraform provider's render_web_service plan enum does not document a
# free tier (starter and up only), so it isn't managed here.
#
# This is a separate Redis instance from the one already running in Render
# (qr-studio-redis / red-d2g6ghv5r7bs73emm30g) — kept independent so this
# demo stack can be applied/destroyed freely without touching production.
resource "render_keyvalue" "redis" {
  name              = "qr-studio-redis-demo"
  plan              = "free"
  region            = var.render_region
  max_memory_policy = "allkeys_lru"
}
