resource "docker_image" "u-ssh" {
  name = "fredericeducentre/ubuntu-ssh"
}

resource "docker_network" "private_network1" {
  name = "private_network1"
}

resource "docker_network" "private_network2" {
  name = "private_network2"
}

resource "docker_container" "Administration" {
  count = var.nbr
  image = docker_image.u-ssh.image_id
  name  = "Administration${count.index + 1}"
  networks_advanced {
    name = docker_network.private_network1.name
  }
  ports {
    internal = var.docker_ports.int
    external = var.docker_ports.ext + count.index
  }
}
resource "docker_container" "Informatique" {
  count = var.nbr
  image = docker_image.u-ssh.image_id
  name  = "Informatique${count.index + 1}"
  networks_advanced {
    name = docker_network.private_network2.name
  }
  ports {
    internal = var.docker_ports.int
    external = var.docker_ports.ext + count.index + 2
  }
}