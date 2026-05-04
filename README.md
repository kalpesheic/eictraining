EIC Training – Day 1
Activities Completed
1.	Created an EC2 instance manually as per the initial setup instructions.
2.	Wrote Terraform code to provision the same EC2 instance programmatically.
3.	Pulled the Docker image of the retail-store-sample application and tested it with different versions.
4.	Executed and practiced basic Docker commands.

Below are the sceen shot for the reference.
Pull Docker Image from Docker Hub
#docker images
#docker pull stacksimplify/retail-store-sample-ui:1.0.0
docker run --name myapp1 -p 8888:8080 -d stacksimplify/retail-store-sample-ui:1.0.0

 
 

 List Running Docker Containers
docker ps
# List all containers
docker ps -a
# List only container IDs
docker ps -q

 

 
 

 

 
