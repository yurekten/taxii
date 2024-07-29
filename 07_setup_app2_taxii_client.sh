

# REVIREW and UPDATE ENVIRONMENT and CONFIGURATION
###############################################################################
KUBERNETES_CONTEXT=docker-desktop
TAXII_CLIENT_IMAGE=yurekten/taxii-client
###############################################################################

SERVER_NAMESPACE=app2
APP_TAXII_CLIENT_DEPLOYMENT_YAML_FILE=k8s/app2_ns/taxii-client.yaml

docker build -t $TAXII_CLIENT_IMAGE -f Dockerfile.taxii-client .
docker push $TAXII_CLIENT_IMAGE


kubectl config use-context $KUBERNETES_CONTEXT
kubectl create ns $SERVER_NAMESPACE

kubectl config set-context $KUBERNETES_CONTEXT --namespace=$SERVER_NAMESPACE
kubectl delete secret taxii-client-envs --namespace=$SERVER_NAMESPACE
kubectl create secret generic taxii-client-envs --from-env-file k8s/app2_ns/secrets/taxii-client-envs --namespace=$SERVER_NAMESPACE
kubectl get secret taxii-client-envs  -o jsonpath='{.data}'
echo "secret files are created."

kubectl delete -f $APP_TAXII_CLIENT_DEPLOYMENT_YAML_FILE -n $SERVER_NAMESPACE
kubectl apply  -f $APP_TAXII_CLIENT_DEPLOYMENT_YAML_FILE -n $SERVER_NAMESPACE
kubectl get svc -n $SERVER_NAMESPACE
kubectl get pod -n $SERVER_NAMESPACE

