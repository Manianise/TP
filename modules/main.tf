resource "docker_image" "jenkins" {
  name = "jenkins/jenkins"
}

resource "docker_image" "sonarqube" {
  name = "sonarqube:community"
}

resource "docker_network" "dev-tools-network" {
  name = "dev-tools-network"
}

resource "docker_container" "jenkins" {

  image = docker_image.jenkins.image_id
  name  = "devops-pipeline"

  networks_advanced {
    name = docker_network.dev-tools-network.name
  }
  ports {
    internal = 8080
    external = 8080
  }
}

resource "docker_container" "sonarqube" {

  image = docker_image.sonarqube.image_id
  name  = "devops-testing"

  networks_advanced {
    name = docker_network.dev-tools-network.name
  }
  ports {
    internal = 9000
    external = 9000
  }
}