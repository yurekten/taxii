

# REVIREW and UPDATE ENVIRONMENT and CONFIGURATION
###############################################################################
KUBERNETES_CONTEXT=docker-desktop
TAXII_PROXY_IMAGE=yurekten/taxii-proxy
###############################################################################

SERVER_NAMESPACE=app1
APP_TAXII_PROXY_DEPLOYMENT_YAML_FILE=k8s/app1_ns/taxii-client.yaml

docker build -t $TAXII_CLIENT_IMAGE -f Dockerfile.taxii-client .
docker push $TAXII_CLIENT_IMAGE


kubectl config use-context $KUBERNETES_CONTEXT
kubectl create ns $SERVER_NAMESPACE

kubectl config set-context $KUBERNETES_CONTEXT --namespace=$SERVER_NAMESPACE

kubectl delete -f $APP_TAXII_PROXY_DEPLOYMENT_YAML_FILE -n $SERVER_NAMESPACE
kubectl apply  -f $APP_TAXII_PROXY_DEPLOYMENT_YAML_FILE -n $SERVER_NAMESPACE
kubectl get svc -n $SERVER_NAMESPACE
kubectl get pod -n $SERVER_NAMESPACE

