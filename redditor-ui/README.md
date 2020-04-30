docker build -t redditorui --file ./DockerfileUi .
docker exec -it redditorui /bin/bash
serve -s build -l 80 
serve -s build -l 32929 &&/dev/null &
sudo npm run build
sudo fuser -k 80/tcp