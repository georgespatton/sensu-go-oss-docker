# sensu-go-oss-docker
Builds a sensu-go Docker container using only the OSS, non-enterprise components.

#To build:
$ sudo docker build .

# sensu-backend server initialization 
$ sudo docker run -d <new_image> sensu-backend init

# sensu-backend server run post initialization
$ sudo docker run -d <new_image> sensu-backend start

# sensu-agent for running docker image as a client
$ sudo docker run -d <new_image> sensu-agent start

# to view stdout logs:
sudo docker logs <new_container_hash>
