
# REVIREW and UPDATE ENVIRONMENT and CONFIGURATION
###############################################################################
KUBERNETES_CONTEXT=docker-desktop
TAXII_PROXY_IMAGE=yurekten/taxii-proxy
###############################################################################

SERVER_NAMESPACE=app2
APP_TAXII_PROXY_DEPLOYMENT_YAML_FILE=k8s/app2_ns/taxii-proxy.yaml

docker build -t $TAXII_PROXY_IMAGE -f Dockerfile.taxii-proxy .
docker push $TAXII_PROXY_IMAGE


kubectl config use-context $KUBERNETES_CONTEXT
kubectl create ns $SERVER_NAMESPACE

kubectl config set-context $KUBERNETES_CONTEXT --namespace=$SERVER_NAMESPACE

kubectl delete secret taxii-proxy-auth-json --namespace=$SERVER_NAMESPACE
kubectl delete secret taxii-proxy-envs --namespace=$SERVER_NAMESPACE

kubectl create secret generic taxii-proxy-auth-json --from-file k8s/app2_ns/secrets/taxii-proxy-auth.json --namespace=$SERVER_NAMESPACE
kubectl create secret generic taxii-proxy-envs --from-env-file k8s/app2_ns/secrets/taxii-proxy-envs --namespace=$SERVER_NAMESPACE
kubectl get secret taxii-proxy-auth-json  -o jsonpath='{.data.taxii\-proxy\-auth\.json}' | base64 -d
kubectl get secret taxii-proxy-envs  -o jsonpath='{.data}'
echo "secret files are created."

kubectl delete -f $APP_TAXII_PROXY_DEPLOYMENT_YAML_FILE -n $SERVER_NAMESPACE
kubectl apply  -f $APP_TAXII_PROXY_DEPLOYMENT_YAML_FILE -n $SERVER_NAMESPACE
kubectl get svc -n $SERVER_NAMESPACE
kubectl get pod -n $SERVER_NAMESPACE

