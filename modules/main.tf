resource "docker_image" "u-ssh" {
  name = "fredericeducentre/ubuntu-ssh"
}

resource "docker_network" "network" {
  count = length(var.networks)
  name = var.networks[count.index]
}

resource "docker_container" "ubuntu" {
  count = 4
  image = docker_image.u-ssh.image_id
  name  = count.index < 2 ? "Informatique_${count.index}" : "Administration_${count.index}"

  networks_advanced {
    name = docker_network.network[count.index < 2 ? 0 : 1].name
  }
  ports {
    internal = var.docker_ports.int
    external = var.docker_ports.ext + count.index
  }
}