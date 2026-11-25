resource "local_file" "service_env" {
  filename        = "${path.module}/../generated/service.env"
  file_permission = "0644"

  content = <<-EOT
    APP_NAME=${var.app_name}
    APP_ENV=${var.app_env}
    LOG_LEVEL=${var.log_level}
    PORT=${var.port}
    FAIL_MODE=${var.fail_mode}
  EOT
}

output "service_env_file" {
  description = "Path of the generated env file"
  value       = local_file.service_env.filename
}
