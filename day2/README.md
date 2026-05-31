# Docker Compose
docker compose is a tool for defining multi-container apps in a single yaml file
managing networks, volumes and dependencies
Running all services with docker, compose up



**Docker Compose Commands**
Start Services
docker compose up
   
- Start in detached mode (background):
docker compose -f docker-compose.yaml up -d
  
Stop all services (gracefully):
    docker compose down
  - Stop a specific service:
    docker compose stop orders
  - List running services:
    docker compose ps
  - List all services (including stopped):
    docker compose ps -a
  - Restart a specific service:
 
    docker compose restart cart

  - Follow logs of a service:
    docker compose logs -f checkout

Access Containers**
  Connect to a running container:
   docker compose exec ui sh
   docker compose top

docker run --privileged --rm tonistiigi/binfmt --install all
If the host reboots and cross-arch stops working, re-run the docker run --privileged --rm tonistiigi/binfmt --install all command.

Below are the refernce SS

<img width="940" height="256" alt="image" src="https://github.com/user-attachments/assets/39aaa6b6-186f-4649-b86e-f194b920c994" />
Need to see running applications
<img width="940" height="440" alt="image" src="https://github.com/user-attachments/assets/8126e1b9-867e-4d02-ad11-f7a0ee3896ff" />
Stopped explictly order service.
<img width="940" height="479" alt="image" src="https://github.com/user-attachments/assets/a41d46fb-c855-45c1-9d9e-49a90b5aa64d" />
Install binfmt/QEMU emulators (cross-arch)
docker run --privileged --rm tonistiigi/binfmt --install all
If the host reboots and cross-arch stops working, re-run the docker run --privileged --rm tonistiigi/binfmt --install all command.
<img width="940" height="519" alt="image" src="https://github.com/user-attachments/assets/d558b1c6-88d2-4315-a1ef-c046b8aa0c0b" />

<img width="940" height="512" alt="image" src="https://github.com/user-attachments/assets/c0fe0bfa-b22b-495d-b880-6aa308fb0f76" />








 
