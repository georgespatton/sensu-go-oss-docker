# sensu-go-oss-docker
Builds a sensu-go Docker container using only the OSS, non-enterprise components.  This contains both the sensu go server as well as the sensu go agent in the same container, allowing you to run the docker container as either role.

#### To build:
`$ sudo docker build .`

#### sensu-backend server initialization 
`$ sudo docker run -d <new_image> sensu-backend init`

#### sensu-backend server run post initialization
`$ sudo docker run -d <new_image> sensu-backend start`

#### sensu-agent for running docker image as a client
`$ sudo docker run -d <new_image> sensu-agent start`

#### To view stdout logs:
`sudo docker logs <new_container_hash>`
