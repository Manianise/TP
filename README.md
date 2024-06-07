# Quick Devops Tools installation using Terraform

><img src="./assets/svg/assets.svg" width="70" height="70"><img src="./assets/svg/jenkins.svg" width="70" height="70"><img src="./assets/svg/sonarqube-svgrepo-com.svg" width="100" height="70"><img src="./assets/svg/terralogo.svg" width="70" height="70">

## Installation requirements :

- You need to have Terraform installed : [Terraform install](https://developer.hashicorp.com/terraform/tutorials/docker-get-started/install-cli)
- You need to have Docker Desktop or Docker Engine installed : [Docker install](https://docs.docker.com/engine/install/)

### This will automatically do the following :

- Quick installation of Jenkins
- Quick installation of Sonarqube with postgres database (/!\ credentials unsafe, change them here : [creds](./modules/variables.tf))

### Run the following commands to initialize :

- Terraform init
- Terraform apply

> Containers will listen on port 8080 and 9000 for both Jenkins and Sonarqube on your local machine

### Easy to delete instance

- Simply run a Terraform destroy command

### Initiating Jenkins agent

- To create an agent, follow the steps written here [jenkins inbound agent](https://hub.docker.com/r/jenkins/inbound-agent) then run :
> docker run --init --network=dev-tools-network --name=node_agent mechameleon/node_agent:0.0.2 -url http://devops-pipeline:8080 -workDir=/home/jenkins/agent -secret <your_secret> -name node_agent
> /!\ : don't forget to replace <your_secret> by the secret provided by jenkins node manager interface !


### Setting up a Pipeline 
### Setting up Sonarqube
### Bare in mind !

- Master should never be used as an agent for security purposes. Change settings in "system administration > number of executors" to 0
- Git projects must be linked with webhooks : [learn more about git webhooks](https://docs.github.com/en/webhooks/about-webhooks)
- Sonarqube must be linked to your Jenkins pipelines in order to start testing : [Learn more about Sonarqube webhooks](https://docs.sonarsource.com/sonarqube/latest/project-administration/webhooks/)
- default user/password is admin. You will be prompted to change them on install