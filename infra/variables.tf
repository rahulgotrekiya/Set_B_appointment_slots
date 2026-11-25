# Input variables for the appointment slots service config

variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = "appointment-slots"
}

variable "app_env" {
  description = "Environment name (dev, test, prod)"
  type        = string
  default     = "dev"
}

variable "log_level" {
  description = "Log level for the application"
  type        = string
  default     = "INFO"

  validation {
    condition     = contains(["DEBUG", "INFO", "WARNING", "ERROR"], var.log_level)
    error_message = "log_level must be one of DEBUG, INFO, WARNING, ERROR."
  }
}

variable "port" {
  description = "Port the application listens on"
  type        = number
  default     = 8080

  validation {
    condition     = var.port >= 1024 && var.port <= 65535
    error_message = "port must be between 1024 and 65535."
  }
}

variable "fail_mode" {
  description = "Set to 1 to make /readyz return 503 (for the incident test only)"
  type        = number
  default     = 0

  validation {
    condition     = var.fail_mode == 0 || var.fail_mode == 1
    error_message = "fail_mode must be 0 or 1."
  }
}
