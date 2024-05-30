resource "docker_image" "jenkins" {
  name = "jenkins/jenkins"
}

resource "docker_image" "sonarqube" {
  name = "sonarqube:community"
}

resource "docker_image" "postgres" {
  name = "postgres:${var.postgres_version}"
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

resource "docker_container" "postgres" {
  image = docker_image.postgres.image_id
  name  = "devops-db"

  env = [
    "POSTGRES_USER=${var.postgres_user}",
    "POSTGRES_PASSWORD=${var.postgres_password}",
    "POSTGRES_DB=${var.postgres_db}"
    
  ]

  networks_advanced {
    name = docker_network.dev-tools-network.name
  }

  ports {
    internal = 5432
    external = 5432
  }
}

resource "docker_container" "sonarqube" {

  image = docker_image.sonarqube.image_id
  name  = "devops-testing"

  env = [
    "SONAR_JDBC_URL=jdbc:postgresql://${docker_container.postgres.hostname}:5432/${var.postgres_db}",
    "SONAR_JDBC_USERNAME=${var.postgres_user}",
    "SONAR_JDBC_PASSWORD=${var.postgres_password}",
  ]

  networks_advanced {
    name = docker_network.dev-tools-network.name
  }
  ports {
    internal = 9000
    external = 9000
  }
}