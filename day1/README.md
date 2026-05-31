EIC Training – Day 1
Activities Completed
1.	Created an EC2 instance manually as per the initial setup instructions.
2.	Wrote Terraform code to provision the same EC2 instance programmatically.
3.	Pulled the Docker image of the retail-store-sample application and tested it with different versions.
4.	Executed and practiced basic Docker commands.

Below are the sceen shot for the reference.

<img width="940" height="404" alt="image" src="https://github.com/user-attachments/assets/ad61c7a1-a201-4762-badb-9310d3ce9152" />

<img width="940" height="276" alt="image" src="https://github.com/user-attachments/assets/f89a1315-f830-4b18-be8b-2c2a57e17176" />
<img width="940" height="380" alt="image" src="https://github.com/user-attachments/assets/21946064-2a15-407f-ab5e-a2420dab2dae" />

<img width="940" height="133" alt="image" src="https://github.com/user-attachments/assets/27febc6d-225d-45fe-8f56-
78d5e45e9ff3" />

<img width="940" height="428" alt="image" src="https://github.com/user-attachments/assets/21b52b53-a561-432f-b280-9a3906dceb2c" />
<img width="940" height="254" alt="image" src="https://github.com/user-attachments/assets/1c003978-b3e4-404c-b073-99efcac1c5ab" />


Docker repo

https://hub.docker.com/repository/docker/kalpesheic/retail-store-sample-app-1.2.0.0/tags

The following commands were used to pull and run the application container:
# List available Docker images
docker images

# Pull the application image from Docker Hub
docker pull stacksimplify/retail-store-sample-ui:1.0.0

# Run the Docker container
docker run --name myapp1 -p 8888:8080 -d stacksimplify/retail-store-sample-ui:1.0.0

# Walkthrogh dockerfile

FROM public.ecr.aws/amazonlinux/amazonlinux:2023 AS build-env
create a temporary image used only for compilation 
AL23--> Install mavan+ java--> compile code--> create jar

Install build dependecies
--setopt=install_weak_deps=False = Avoids unnecessary packages.
VOLUME /tmp = Creates mount point.
Set working directory 
WORKDIR /

copy mavan wrappper 
COPY .mvn .mvn
COPY mvnw .
COPY pom.xml .

 
 
 

 

 
