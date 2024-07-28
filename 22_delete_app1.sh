# REVIREW and UPDATE ENVIRONMENT and CONFIGURATION
###############################################################################
KUBERNETES_CONTEXT=docker-desktop
MEDALLION_IMAGE=yurekten/medallion
###############################################################################

SERVER_NAMESPACE=app1
kubectl config use-context $KUBERNETES_CONTEXT
kubectl config set-context $KUBERNETES_CONTEXT --namespace=$SERVER_NAMESPACE

kubectl delete -f k8s/app1_ns/taxii-client.yaml -n $SERVER_NAMESPACE
kubectl delete -f k8s/app1_ns/taxii-proxy.yaml -n $SERVER_NAMESPACE