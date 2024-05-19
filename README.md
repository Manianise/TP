# Welcome to this practical use of Kubernetes

> ## Before we begin 
>
> Make sure you have minikube, kubernetes and docker installed for any of the apps to run
> Clone the repository
> Every command given below are to be written directly from root directory 

## How to launch the Time app

- kubectl apply -f .\Vlad\time-app\
- minikube service -n default adminer frontend

## How to launch the Wordpress App

- kubectl apply -k .\PA\stateful\
- minikube service -n wp-app wordpress

## How to launch the Nginx App

- kubectl apply -f .\PA\stateless\
- minikube service -n nginx --all