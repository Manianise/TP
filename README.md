# Simple Terraform infrastructure using Docker provider

## Before we begin

This example will simply create 4 docker containers with 2 networks, one for every two. 
The goal is to show that with just a few lines of code you can make two private networks that don't communicate with one another

> ### Here is the list of commands on how to init the project
> - make sure terraform is installed in your environment
> - terraform init
> - terraform apply

## /!\ For some reason you sometimes need to terraform init twice in order for the project to work
