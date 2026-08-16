# QR Studio — Spacelift + OpenTofu Demo

Minimal OpenTofu config that manages the QR Studio app's Redis instance on
Render (free tier), orchestrated by Spacelift. Built to try out Spacelift
for an interview, not as a production infra migration — see the main
[qr-studio](https://github.com/<your-username>/qr-studio) repo for the app
itself.

## What this provisions

- `render_keyvalue.redis` — free Render Key Value (Redis-compatible)
  instance used by the backend for rate limiting / abuse protection

## What this does NOT provision

The backend web service and frontend stay on their existing free
deployments (`render.yaml` Blueprint on Render, GitHub Pages), unchanged.
The `render-oss/render` Terraform provider's `render_web_service.plan`
only documents paid tiers (`starter` and up) — no `free` — so managing the
web service here would risk pulling it onto a paid plan. Keeping it on
`render.yaml` keeps the whole stack genuinely free while still giving a
real Spacelift plan/apply workflow to demo, against the Redis resource.

## Prerequisites

- A [Render](https://render.com) account and API key
- A [Spacelift](https://spacelift.io) account (free tier)
- This repo pushed to GitHub, connected as a Spacelift stack (VCS integration)

## Spacelift setup

1. **Create the stack**: Spacelift dashboard → *Stacks* → *New stack* →
   point at this repo, root path `/`. Spacelift auto-detects OpenTofu from
   `.spacelift/config.yml`.
2. **Set environment variables** on the stack (*Environment* tab):
   - `RENDER_API_KEY` — Render dashboard → Account Settings → API Keys (mark as env var, not a TF var)
   - `TF_VAR_render_owner_id` — your Render workspace ID
3. **Trigger a run**: push a commit or click *Trigger* in Spacelift. Review
   the plan, then confirm apply (autodeploy is off by default — see
   `.spacelift/config.yml`).
4. **Wire it to the app**: after apply, copy the (sensitive)
   `redis_internal_connection_string` output into the `REDIS_URL` env var
   on the `qr-studio-backend` service in the Render dashboard, or into
   `render.yaml` if you want it fully declarative.

## Local dry run (optional)

```bash
tofu init
tofu plan -var="render_owner_id=<your-owner-id>"
```

## Cost

`render_keyvalue` on the free plan is $0/month. Free Render services
(including this Redis instance) may be subject to Render's free-tier
limits — check current terms on render.com/docs/free.

## Notes

- Uses the community [`render-oss/render`](https://registry.terraform.io/providers/render-oss/render/latest)
  provider — verify current resource/attribute names against the provider
  docs before applying, community providers change between versions. This
  config was validated with `tofu validate` against provider v1.9.1.
- No state backend is configured here — Spacelift manages state for you.
  For local-only use, add a `backend` block or run with local state.
