output "redis_id" {
  description = "Render key-value (Redis) instance ID."
  value       = render_keyvalue.redis.id
}

output "redis_internal_connection_string" {
  description = "Internal connection string, set as REDIS_URL on the backend web service (managed via render.yaml, not here)."
  value       = render_keyvalue.redis.connection_info.internal_connection_string
  sensitive   = true
}
