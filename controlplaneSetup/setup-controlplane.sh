echo "must pass 5 arguments"
echo "arg 1 - AWS_ACCESS_KEY_ID"
echo "arg 2 - AWS_SECRET_ACCESS_KEY"
echo "arg 3 - AWS_SESSION_TOKEN"
echo "arg 4 - clientID for CDaaS control plane tenant RNA."
echo "arg 5 - clientSecret for CDaaS control plane tenant RNA."
echo " creds must be non-expiring creds with the roles that can be retrieved using"
echo "clusterawsadm bootstrap iam print-policy --document AWSIAMManagedPolicyControllers"

brew install clusterapi
brew install clusterctl
export EKS=true # enable the 'EKS' feature gate...
export ClusterResourceSet=true
export EXP_CLUSTER_RESOURCE_SET=true
export CLUSTER_RESOURCE_SET=true
export EXP_MACHINE_POOL=true
clusterctl init
brew install clusterawsadm
export AWS_REGION=us-east-1 # This is used to help encode your environment variables
export AWS_ACCESS_KEY_ID=$1
export AWS_SECRET_ACCESS_KEY=$2
export AWS_SESSION_TOKEN=$3
# todo: add aws provider per https://cluster-api.sigs.k8s.io/user/quick-start.html ?
clusterawsadm bootstrap iam create-cloudformation-stack --config clusterawsadmconfig.yml
export AWS_B64ENCODED_CREDENTIALS=$(clusterawsadm bootstrap credentials encode-as-profile)
echo "$AWS_B64ENCODED_CREDENTIALS"
#clusterctl init --infrastructure aws
# note: init --infra aws doesn't offer the option to n ot add hardcoded creds.
#clusterctl generate provider --infrastructure aws > clusterManifests/awsProvider.yml
k apply -f clusterManifests/awsProvider.yml

# REMINDER: m,ust manually create an ec2 keypair named 'default'
#export AWS_REGION=us-east-2
#export AWS_SSH_KEY_NAME=default
# Select instance types
#export AWS_CONTROL_PLANE_MACHINE_TYPE=t3a.micro
#export AWS_NODE_MACHINE_TYPE=t3a.medium
#clusterctl generate cluster satwell-temp-dec-28-2022 --kubernetes-version v1.26.0 --control-plane-machine-count=1 --worker-machine-count=3 --infrastructure=aws:v2.0.2 --flavor eks
kubectl create ns armory-rna --dry-run=client -o yaml >tempManifests/ns.yaml
kubectl create configmap namespace --from-file=tempManifests/ns.yml -o yaml --dry-run=client >manifests/ns.yml
kubectl apply -f manifests/ns.yml

kubectl create ns armory-rna
kubectl -n=armory-rna create secret generic controlplane-client-credentials --type=string --from-literal=client-secret=$5 --from-literal=client-id=$4 --dry-run=client -o yaml > controlplane-client-credentials.yaml

helm install --upgrade control-plane-rna armory/remote-network-agent \
     --set agentIdentifier=control-plane-rna \
     --set 'clientId=encrypted:k8s!n:controlplane-client-credentials!k:client-id' \
     --set 'clientSecret=encrypted:k8s!n:controlplane-client-credentials!k:client-secret' \
     --namespace armory-rna

kubectl apply -f "cmdhook.yml" -n armory-rna



kubectl create secret generic -n=armory-rna controlplane-client-credentials --type=string --from-lclient-secret=$5 --from-literal=client-id=$4 --dry-run=client -o yaml > controlplane-client-credentials.yaml
kubectl create secret generic deployable-control-plane-secret --type=addons.cluster.x-k8s.io/resource-set "--from-literal=controlplane-client-credentials=`cat controlplane-client-credentials.yaml`"
rm controlplane-client-credentials.yaml

helm template armory-rna armory/remote-network-agent \
     --set agentIdentifier=default_satwell-temp-feb-23-2023-control-plane \
     --set 'clientId=encrypted:k8s!n:controlplane-client-credentials!k:client-id' \
     --set 'clientSecret=encrypted:k8s!n:controlplane-client-credentials!k:client-secret' \
     --namespace armory-rna > tempManifests/rna.yml
kubectl create configmap rna --from-file=tempManifests/rna.yml -o yaml --dry-run=client >manifests/rna.yml

helm repo add projectcalico https://docs.projectcalico.org/charts
helm repo update

helm template calico projectcalico/tigera-operator --version v3.25.0 > tempManifests/calico.yml
helm show crds projectcalico/tigera-operator >tempManifests/calico-crds.yml
kubectl create configmap calico-crds --from-file=tempManifests/calico-crds.yml -o yaml --dry-run=client >manifests/calico-crds.yml
kubectl create configmap calico-addon --from-file=tempManifests/calico.yml -o yaml --dry-run=client >manifests/calico.yml
kubectl apply -f manifests/calico.yml

kubectl create ns armory-rna --dry-run=client -o yaml >tempManifests/ns.yaml
kubectl create configmap namespace --from-file=tempManifests/ns.yaml -o yaml --dry-run=client >manifests/ns.yml
kubectl apply -f manifests/ns.yml






kubectl apply -f manifests/resources.yml

#TODO: investigate ClusterResourceSet to apply RNA