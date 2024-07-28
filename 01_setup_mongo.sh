# REVIREW and UPDATE ENVIRONMENT and CONFIGURATION
###############################################################################
KUBERNETES_CONTEXT=docker-desktop
MEDALLION_IMAGE=yurekten/medallion
###############################################################################

SERVER_NAMESPACE=cti
MONGO_DEPLOYMENT_YAML_FILE=k8s/cti_ns/mongodb.yaml

kubectl config use-context $KUBERNETES_CONTEXT
kubectl create ns $SERVER_NAMESPACE

kubectl config set-context $KUBERNETES_CONTEXT --namespace=$SERVER_NAMESPACE


kubectl delete -f $MONGO_DEPLOYMENT_YAML_FILE -n $SERVER_NAMESPACE

kubectl apply -f $MONGO_DEPLOYMENT_YAML_FILE -n $SERVER_NAMESPACE
kubectl get pod -n $SERVER_NAMESPACE
kubectl get svc -n $SERVER_NAMESPACE


