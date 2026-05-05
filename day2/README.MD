Docker Compose Commands

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



 
