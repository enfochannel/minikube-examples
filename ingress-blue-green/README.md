<b>minikube Blue/Green Deployment</b>

<i>with docker driver ingress controller doesn't work and thus it requires hyperkit. Make sure we use hyperkit driver</i>

start the minikube (./fireminikube.sh)

eval $(minikube -p minikube docker-env)

enable ingress addons:

minikube addons enable ingress

Assuming docker is already installed.

Create a docker image

docker build -t hello-kube:v1 ../apps/hello-kube/.

create a namespace prod

run kubectl apply --filename ./manifest-prod.yaml

this will create deployment,service,ingress,hpa

kubectl get deployments,serivces,ingress --namespace prod

get the minikube ip

update the /etc/hosts/ with new ip hello-kube.info[ingress host name]

curl hello-kube.info
Hello Kubernetes World! Sky is Blue!

Now change the application code: 

Change the line in server.js
Hello Kubernetes World! Grass is Green!

update the image with newer version
docker build -t hello-kube:v2 ../apps/hello-kube/.

verify you have two images now:
docker images
REPOSITORY                                 TAG        IMAGE ID       CREATED          SIZE
hello-kube                                 v2         58fe03670ff2   34 minutes ago   944MB
hello-kube                                 v1         20b51b5a8d56   42 minutes ago   944MB

create a new deployment:
kubectl apply --filename ./manifest-deployment-bg.yaml
deployment.apps/hello-kube-green created

Make sure deployment is created:
get deployments --namespace prod
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
hello-kube         2/2     2            2           3m59s
hello-kube-green   2/2     2            2           14s

Create a new service for testing. Before making this service to public
kubectl apply --filename ./manifest-service-prod-green.yaml
service/prod-green-service created

get services --namespace prod
NAME                 TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
prod-green-service   NodePort   10.107.8.18    <none>        8080:32057/TCP   9s
prod-service         NodePort   10.111.69.40   <none>        8080:32056/TCP   4m29s

minikube service prod-green-service --namespace prod --url
http://[ip_address]:[port]

Once testing is done, is a right time to update the service. Remember instead of updating the ingress we are updating the service so that ingress will always point to one service.

ccat manifest-service-prod-update.yaml 
apiVersion: v1
kind: Service
metadata: 
  name: prod-service
  labels:
    app: hello-kube
    version: v2
    env: prod
  namespace: prod
spec: 
  ports: 
    - 
      nodePort: 32056
      port: 8080
      protocol: TCP
      targetPort: 8080
  sessionAffinity: None
  type: NodePort
  selector:
    app: hello-kube
    version: v2

Notice the version is pointing to version 2

Once service is update, you can hello-kube.info in browser. You should see the updated web page, i.e.,
Hello Kubernetes World! Grass is Green!