# Deploy user microservice to an AWS EC2 instance
- Prerequisites
- Ressources to be created
- Post creation script
- How to deploy
- Tests after deployment

## Prerequisites
- You need Terraform and AWS CLI installed in addition to access keys needed for Terraform to access AWS : check [the prerequisites](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-build#prerequisites)
- One way to create access keys is
    - From the AWS Console, go to IAM, 
    - create a group that has EC2FullAccess policy
    - create a user
    - assign the created user to thee newly created group
    - finally create access keys for that user and save them in a safe place
- Install postman or an other tool to make http calls

## Ressources to be created
The ressources that will be created are defined in main.tf :
1. EC2 instance
2. Security group :
3. Ingress rule : listen on port 8081 from anywhere (exposed for the microservice)
4. Ingress rule : listen on port 5432 from anywhere (exposed for postgresql)
5. Ingress rule : listen on port 22 (ssh) from your ip address
6. Egress rule : free access to anywhere


Note that if you have already a key/pair used to access any EC2 instance using ssh, update the following line in main.tf
`key_name = "myawskey"`,
otherwise, just delete it from main file.

## Post creation script
## How to deploy
## Tests after deployment
