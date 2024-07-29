# REVIREW and UPDATE ENVIRONMENT and CONFIGURATION
###############################################################################
KUBERNETES_CONTEXT=docker-desktop
###############################################################################

SERVER_NAMESPACE=cti
MONGO_DEPLOYMENT_YAML_FILE=k8s/cti_ns/mongodb.yaml

kubectl config use-context $KUBERNETES_CONTEXT
kubectl create ns $SERVER_NAMESPACE

kubectl config set-context $KUBERNETES_CONTEXT --namespace=$SERVER_NAMESPACE


kubectl delete -f $MONGO_DEPLOYMENT_YAML_FILE -n $SERVER_NAMESPACE

kubectl delete secret mongodb-envs --namespace=$SERVER_NAMESPACE
kubectl create secret generic mongodb-envs --from-env-file k8s/cti_ns/secrets/mongodb-envs --namespace=$SERVER_NAMESPACE
kubectl get secret mongodb-envs  -o jsonpath='{.data}'
echo "secret file is created."


kubectl apply -f $MONGO_DEPLOYMENT_YAML_FILE -n $SERVER_NAMESPACE
kubectl get pod -n $SERVER_NAMESPACE
kubectl get svc -n $SERVER_NAMESPACE


