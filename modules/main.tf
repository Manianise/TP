# Get jenkins from DckHub
resource "docker_image" "jenkins" {
  name = "jenkins/jenkins:${var.jenkins_version}"
  keep_locally = false
}

# App needs an agent to run
resource "docker_image" "j-agent" {
  name = "mechameleon/node_agent:0.0.5"
}

# Get sonarqube image
resource "docker_image" "sonarqube" {
  name = "sonarqube:community"
  keep_locally = false
}

# Sonarqube needs to run with a database

resource "docker_image" "postgres" {
  name = "postgres:${var.postgres_version}"
  keep_locally = false
}

# configure a docker network

resource "docker_network" "dev-tools-network" {
  name = "dev-tools-network"
  ipam_config {
    subnet = "172.216.0.0/16"
    gateway = "172.216.0.1"
  }
  
}


# All containers are linked to the same docker network

resource "docker_container" "jenkins" {

  image = docker_image.jenkins.image_id
  name  = "devops-pipeline" 

  networks_advanced {
    name = docker_network.dev-tools-network.name
    ipv4_address = "172.216.0.2"
    
  }
  dns = var.nameservers
  ports {
    internal = 8080
    external = 8080
  }

}

# Database container

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
    ipv4_address = "172.216.0.4"
  }
  dns = var.nameservers
  ports {
    internal = 5432
    external = 5432
  }
}

# Sonarqube container

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
    ipv4_address = "172.216.0.5"
  }
  dns = var.nameservers
  ports {
    internal = 9000
    external = 9000
  }
}

# Instanciating remote VM creation with fixed Ips

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "main-subnet"
  }
}

resource "aws_security_group" "main" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "main-sg"
  }
}

resource "aws_instance" "worker" {
  count         = 2
  ami           = "Your AMI ID"  
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main.id
  security_groups = [aws_security_group.main.name]

  tags = {
    Name = "worker-instance-${count.index}"
  }

  user_data = <<-EOF
              #!/bin/bash
              echo "Joining EKS cluster"
              # Install AWS CLI
              sudo apt-get update
              sudo apt-get install -y awscli

              # Install kubectl
              curl -o kubectl https://amazon-eks.s3.us-east-1.amazonaws.com/1.18.9/2020-11-02/bin/linux/amd64/kubectl
              chmod +x ./kubectl
              sudo mv ./kubectl /usr/local/bin

              # Get cluster join command
              aws eks update-kubeconfig --name ${var.cluster_name}

              # Your commands to join the cluster here
              EOF

  private_ip = var.private_ips[count.index]
}

# attribute static IPs

resource "aws_eip" "worker_eip" {
  count      = 2
  instance   = element(aws_instance.worker.*.id, count.index)
  depends_on = [aws_instance.worker]
  vpc = true
}

