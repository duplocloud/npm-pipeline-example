
output "url" {
  value       = "${var.tenant}.${var.base_domain}"
  description = "URL for accessing the frontend"
}

