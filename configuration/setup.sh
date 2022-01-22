echo "setting up borealis agents using clientIt: $1 and secret: $2"
kubectl create namespace borealis-demo-agent-prod
kubectl create namespace borealis-demo-agent-staging
kubectl create namespace borealis-demo-agent-dev
kubectl -n=borealis-demo-agent-prod create secret generic rna-client-credentials --type=string --from-literal=client-secret=$2 --from-literal=client-id=$1
kubectl -n=borealis-demo-agent-staging create secret generic rna-client-credentials --type=string --from-literal=client-secret=$2 --from-literal=client-id=$1
kubectl -n=borealis-demo-agent-dev create secret generic rna-client-credentials --type=string --from-literal=client-secret=$2 --from-literal=client-id=$1
# Optionally Add Armory Chart repo, if you haven't
helm repo add armory https://armory.jfrog.io/artifactory/charts
# Update repo to fetch latest armory charts
helm repo update
# Install or Upgrade armory rna chart
helm upgrade --install armory-rna-prod armory/remote-network-agent \
    --set clientId='encrypted:k8s!n:rna-client-credentials!k:client-id' \
    --set clientSecret='encrypted:k8s!n:rna-client-credentials!k:client-secret' \
    --set agentIdentifier=demo-prod-west-cluster \
    -n borealis-demo-agent-prod
helm upgrade --install armory-rna-staging armory/remote-network-agent \
    --set clientId='encrypted:k8s!n:rna-client-credentials!k:client-id' \
    --set clientSecret='encrypted:k8s!n:rna-client-credentials!k:client-secret' \
    --set agentIdentifier=demo-staging-cluster \
    -n borealis-demo-agent-staging
helm upgrade --install armory-rna-dev armory/remote-network-agent \
    --set clientId='encrypted:k8s!n:rna-client-credentials!k:client-id' \
    --set clientSecret='encrypted:k8s!n:rna-client-credentials!k:client-secret' \
    --set agentIdentifier=demo-dev-cluster \
    -n borealis-demo-agent-dev