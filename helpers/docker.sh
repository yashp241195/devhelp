declare -A helper
declare -A hint

hint["docker-basic"]="Create and Upload docker container"
helper["docker-basic"]="
hint : ${hint["docker-basic"]}

// check if docker installed or not
$ docker version 

// run will get the image from docker-hub if not present locally 
$ docker run hello-world

// list all docker images available locally 
$ docker image --list

// -d - run the container in detached mode (in the background)
// -p 80:80 - map port 80 of the host to port 80 in the container
// docker/getting-started - the image to use

$ docker run -d -p 80:80 docker/getting-started

// see the running docker containers
$ docker ps

// stop the container
$ docker stop <the-container-id>

// remove the container
$ docker rm <the-container-id>

// Building the image from current directory

// .dockerignore will have all the files you wish not to include
node_modules

// inside Dockerfile
FROM node:16-alpine
WORKDIR /app
COPY package.json /app
RUN npm install -g nodemon
RUN npm install 
COPY . /app
CMD [ 'nodemon', 'index.js' ]
EXPOSE 8080

// build the image with tag myimage
$ docker build -t myimage .

"

hint["docker-compose"] = "Create servers with docker-composer"
helper["docker-compose"]="
hint : ${hint["docker-compose"]}

version: '3'
services:
  api-server:
    build: .
    image: api-server
    ports:
      - '5000:8080'
    networks:
      - mern-app
    depends_on:
      - mongo
  mongo:
    image: mongo:3.6.19-xenial
    ports:
      - "27017:27017"
    networks:
      - mern-app
    volumes:
      - mongo-data:/data/db
networks:
  mern-app:
    driver: bridge
volumes:
  mongo-data:
    driver: local

// start the containers with the above configurations
$ docker-compose up

// stop the containers started with docker-compose
$ docker-compose down
"

echo "${helper[$1]}"

if [[ $1 == "--list" ]];
then 
for i in "${!hint[@]}"; do echo "$i - ${hint[$i]}"; done
elif [[ $1 == "--all" ]];
then
echo ""
fi
echo " "