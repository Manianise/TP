variable "docker_ports" {
  type = object({
    int = number
    ext = number
  })
  default = {
      int = 22
      ext = 2222
    }
}

variable "networks" {
  type = list(string)
  default = ["network1", "network2"]
}

variable "postgres_user" {
  description = "The username for the PostgreSQL database"
  type        = string
  default     = "default_user"
}

variable "postgres_password" {
  description = "The password for the PostgreSQL database"
  type        = string
  default     = "default_password"
  sensitive   = true
}

variable "postgres_db" {
  description = "The name of the PostgreSQL database"
  type        = string
  default     = "default_db"
}

variable "postgres_version" {
  description = "The version of PostgreSQL to use"
  type        = string
  default     = "latest"
}

