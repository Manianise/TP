variable "docker_ports" {
  type = object({
    int = number
    ext = number
  })
  default = {
      int = 22
      ext = 2000
    }
}

variable "nbr" {
  type = number
  default = 2  
}