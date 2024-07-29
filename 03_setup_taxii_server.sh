# REVIREW and UPDATE ENVIRONMENT
KUBERNETES_CONTEXT=docker-desktop
MEDALLION_IMAGE=yurekten/medallion


TAXII_DEPLOYMENT_YAML_FILE=k8s/cti_ns/medallion.yaml
SERVER_NAMESPACE=cti


docker build -t $MEDALLION_IMAGE -f Dockerfile.medallion .
docker push $MEDALLION_IMAGE


kubectl config use-context $KUBERNETES_CONTEXT
kubectl create ns $SERVER_NAMESPACE

kubectl config set-context $KUBERNETES_CONTEXT --namespace=$SERVER_NAMESPACE

kubectl delete -f $TAXII_DEPLOYMENT_YAML_FILE -n $SERVER_NAMESPACE
kubectl delete secret medallion-config-json --namespace=$SERVER_NAMESPACE
kubectl create secret generic medallion-config-json --from-file k8s/cti_ns/secrets/medallion-config.json --namespace=$SERVER_NAMESPACE
kubectl delete secret medallion-init-envs --namespace=$SERVER_NAMESPACE
kubectl create secret generic medallion-init-envs --from-env-file k8s/cti_ns/secrets/medallion-init-envs --namespace=$SERVER_NAMESPACE
kubectl get secret medallion-init-envs  -o jsonpath='{.data}'
echo "secret files are created."


kubectl apply  -f $TAXII_DEPLOYMENT_YAML_FILE -n $SERVER_NAMESPACE
kubectl get secret medallion-config-json  -o jsonpath='{.data.medallion\-config\.json}' | base64 -d

kubectl get svc -n $SERVER_NAMESPACE
kubectl get pod -n $SERVER_NAMESPACE

