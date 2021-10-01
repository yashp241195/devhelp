declare -A helper
declare -A hint

hint["kubernetes-basic"]="Deploy express app with loadbalancer service"
helper["kubernetes-basic"]="
hint : ${hint["kubernetes-basic"]}

# DeployWithKubernetes

docker build container
$ docker build -t app-1-k8s:1 .

Deploy on kubernetes with minikube, minikube is a single node cluster made for
testing purpose, minikube requires virtualbox or hyperviser (virtual machine) as well to run on local system

check the minikube working or not by checking it's version
$ minikube version

start the cluster on local machine
$ minikube start 

check the status of nodes on kubernetes cluster with kubectl, a command line tool  
$ kubectl get nodes

To use docker images in kubernetes you need to run 
$ eval $(minikube docker-env)

Important note: You have to run eval $(minikube docker-env) on each terminal you want to use, since it only sets the environment variables for the current shell session.

apply the kubernetes configurations set in K8s/main.yaml to the cluster

$ kubectl apply -f K8s/main.yaml

open minikube dashboard in another window

$ minikube dashboard

run the 'express-test-service' by

$ kubectl get svc

NAME                   TYPE           CLUSTER-IP     EXTERNAL-IP    PORT(S)          AGE
express-test-service   LoadBalancer   10.104.31.77   10.104.31.77   6100:32415/TCP   7m3s
kubernetes             ClusterIP      10.96.0.1      < none >         443/TCP          44h

access the express app in your web browser with http://10.104.31.77:6100/

$ curl 10.104.31.77:6100
{'message':'Welcome : express-test-app-68469d95c7-h75h8 to app-1 '}

incase EXTERNAL-IP of express-test-service stay in pending state use the following commnd
because minikube doesn't provide the loadbalancer. To run the service you need loadbalancer

$ minikube tunnel


### main.yaml
```
apiVersion: v1
kind: Service
metadata:
  name: express-test-service
spec:
  selector:
    app: express-test-app
  ports:
  - protocol: "TCP"
    port: 6100
    targetPort: 3010
  type: LoadBalancer

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: express-test-app
spec:
  selector:
    matchLabels:
      app: express-test-app
  replicas: 2
  template:
    metadata:
      labels:
        app: express-test-app
    spec:
      containers:
      - name: express-test-app
        image: app-1-k8s:1
        imagePullPolicy: Never
        ports:
        - containerPort: 3010

```
### Dockerfile

```
FROM node:16-alpine
WORKDIR /app
COPY package.json /app
RUN npm install -g nodemon
RUN npm install 
COPY . /app
CMD [ "nodemon", "index.js" ]
EXPOSE 3010
```
### .dockerignore

node_modules




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
