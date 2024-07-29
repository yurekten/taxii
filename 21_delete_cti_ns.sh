# REVIREW and UPDATE ENVIRONMENT and CONFIGURATION
###############################################################################
KUBERNETES_CONTEXT=docker-desktop
MEDALLION_IMAGE=yurekten/medallion
###############################################################################

SERVER_NAMESPACE=cti
kubectl config use-context $KUBERNETES_CONTEXT
kubectl config set-context $KUBERNETES_CONTEXT --namespace=$SERVER_NAMESPACE

kubectl delete -f k8s/cti_ns/mongodb.yaml -n $SERVER_NAMESPACE
kubectl delete -f k8s/cti_ns/medallion.yaml -n $SERVER_NAMESPACE
kubectl delete secret medallion-config-json medallion-init-envs mongodb-envs --namespace=$SERVER_NAMESPACE

kubectl delete ns $SERVER_NAMESPACE