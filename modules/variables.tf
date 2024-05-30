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