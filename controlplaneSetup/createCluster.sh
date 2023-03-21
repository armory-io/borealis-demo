echo "usage createcluster <name> <cdaas-clientId> <cdaas-secret>"
export AWS_REGION=us-east-1 # This is used to help encode your environment variables
export AWS_SSH_KEY_NAME=default
export AWS_CONTROL_PLANE_MACHINE_TYPE=t3a.micro
export AWS_NODE_MACHINE_TYPE=t3a.medium
export VPC_ADDON_VERSION=v1.12.2-eksbuild.1
clusterctl generate cluster $1 --kubernetes-version v1.25.0 --control-plane-machine-count=1 --worker-machine-count=6 --infrastructure=aws:v2.0.2 --flavor eks > manifests/eks.yml
# old flavor was eks # eks-managedmachinepool-vpccni

#todo: easiest way to add this label? 
#  labels:
#    type: cdaasDemo

#helm template control-plane-rna armory/remote-network-agent \
#     --set agentIdentifier=$1 \
#     --set 'clientId=encrypted:k8s!n:controlplane-client-credentials!k:client-id' \
#     --set 'clientSecret=encrypted:k8s!n:controlplane-client-credentials!k:client-secret' \
#     --namespace control-plane-rna > tempManifests/RNA.yaml

#cp clusterTemplates/rna.yml manifests



export controlplanecredentials=`kubectl get secret deployable-control-plane-secret -o=go-template='{{index .data "controlplane-client-credentials"}}' | base64 -d`
echo $controlplanecredentials

kubectl create secret generic -n=$1 deployable-control-plane-secret --type=addons.cluster.x-k8s.io/resource-set "--from-literal=controlplane-client-credentials=$controlplanecredentials" --dry-run=client -o yaml > manifests/secret.yml


#helm template armory-rna armory/remote-network-agent \
#     --set agentIdentifier=$1 \
#     --set 'clientId=encrypted:k8s!n:controlplane-client-credentials!k:client-id' \
#     --set 'clientSecret=encrypted:k8s!n:controlplane-client-credentials!k:client-secret' \
#     --namespace armory-rna > tempManifests/rna.yml
#kubectl create configmap rna --from-file=tempManifests/rna.yml -o yaml --dry-run=client >manifests/rna.yml

kubectl create configmap rna --from-file=clusterTemplates/rna.yml -o yaml --dry-run=client >manifests/rna.yml

kubectl create configmap rna-config -n=armory-rna -o yaml --dry-run=client --from-literal=APPLICATION_NAME=rna --from-literal=APPLICATION_ENVIRONMENT=prod --from-literal=APPLICATION_VERSION=v3.0.17 --from-literal=LOGGER_TYPE=console --from-literal=LOGGER_LEVEL=info --from-literal=DISABLE_COLORS=false '--from-literal=oidc_clientId=encrypted:k8s!n:controlplane-client-credentials!k:client-id' '--from-literal=oidc_clientSecret=encrypted:k8s!n:controlplane-client-credentials!k:client-secret' --from-literal=agent_identifier=$1 --from-literal=agent_kubernetesClusterModeEnabled=true>tempManifests/rna-config.yml
kubectl create configmap rna-config --from-file=tempManifests/rna-config.yml -o yaml --dry-run=client >manifests/rna-config.yml


yq -i ".targets.createCluster.namespace = \"$1\"" deployCluster.yml
yq -i ".targets.connectClusterToCdaaS.namespace = \"$1\"" deployCluster.yml
yq -i ".metadata.labels.type=\"cdaasDemo\"" manifests/eks.yml
yq -i '(select(.kind=="AWSManagedControlPlane")|.spec.addons[0])={"name":"vpc-cni","version":"v1.12.2-eksbuild.1","conflictResolution":"overwrite"}' manifests/eks.yml
yq -i '(select(.kind=="AWSManagedControlPlane")|.spec.vpcCni.env[0])={"name":"ENABLE_PREFIX_DELEGATION","value":"true"}' manifests/eks.yml
yq -i '(select(.kind=="EKSConfigTemplate")|.spec.template.serviceIPV6Cidr)="fd54:f67c:892b:56fe::/64"' manifests/eks.yml

kubectl create ns $1 -o yaml --dry-run=client >manifests/cluster-ns.yml
armory deploy start -f deployCluster.yml --add-context cluster=$1

# clusterctl get kubeconfig satwell-temp-feb-23-2023 -n=satwell-temp-feb-23-2023>tempManifests/cluster.kubeconfig
# k --kubeconfig=tempManifests/cluster.kubeconfig -n=armory-rna get all
