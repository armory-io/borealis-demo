echo "usage createcluster <name> <cdaas-clientId> <cdaas-secret>"
export AWS_REGION=us-east-1 # This is used to help encode your environment variables
export AWS_SSH_KEY_NAME=default
export AWS_CONTROL_PLANE_MACHINE_TYPE=t3a.micro
export AWS_NODE_MACHINE_TYPE=t3a.medium
export VPC_ADDON_VERSION=v1.12.2-eksbuild.1
clusterctl generate cluster $1 --kubernetes-version v1.25.0 --control-plane-machine-count=1 --worker-machine-count=3 --infrastructure=aws:v2.0.2 --flavor eks-managedmachinepool-vpccni > manifests/eks.yml
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
yq -i '(select(.kind=="AWSManagedControlPlane")|.spec.addons[1])={"name":"aws-ebs-csi-driver","version":"v1.17.0-eksbuild.1","conflictResolution":"overwrite"}' manifests/eks.yml
yq -i '(select(.kind=="AWSManagedControlPlane")|.spec.vpcCni.env[0])={"name":"ENABLE_PREFIX_DELEGATION","value":"true"}' manifests/eks.yml
#yq -i '(select(.kind=="AWSManagedControlPlane")|.spec.secondaryCidrBlock)="198.19.0.0/16"' manifests/eks.yml #198.19.0.0/16
#yq -i '(select(.kind=="AWSManagedControlPlane")|.spec.network.cidrBlock)="198.19.0.0/16"' manifests/eks.yml
# use existing default vpc because auto-created ones often don't delete hapilly
#yq -i '(select(.kind=="AWSManagedControlPlane")|.spec.network.vpc.id)="vpc-0e1ae6919dcfdc14d"' manifests/eks.yml
#yq -i '(select(.kind=="AWSManagedControlPlane")|.spec.network.vpc.ipv6.cidrBlock)="2600:1f28:1300::/56"' manifests/eks.yml #2600:1f18:76e6:c300::/56
yq -i '(select(.kind=="AWSManagedControlPlane")|.spec.network.vpc.enableIPv6)="true"' manifests/eks.yml
#yq -i '(select(.kind=="EKSConfigSpec")|.spec.network.vpc.ipv6.cidrBlock)="2600:1f18:76e6:c300::/56"' manifests/eks.yml
yq -i '(select(.kind=="AWSManagedControlPlane")|.spec.network.vpc.ipv6.poolId)="ipam-pool-0ff093b014e327480"' manifests/eks.yml
#yq -i '(select(.kind=="AWSManagedControlPlane")|.spec.network.subnets[0])={"id":"subnet-053034f9605676759"}' manifests/eks.yml
#yq -i '(select(.kind=="AWSManagedControlPlane")|.spec.network.subnets[1])={"id":"subnet-0f5c46f714d13460f"}' manifests/eks.yml
#yq -i '(select(.kind=="AWSManagedControlPlane")|.spec.network.subnets[2])={"id":"subnet-08c1d2c0272967929"}' manifests/eks.yml
#yq -i '(select(.kind=="AWSManagedControlPlane")|.spec.network.subnets[3])={"id":"subnet-00aa2d5d89162fbc9"}' manifests/eks.yml
#yq -i '(select(.kind=="AWSManagedControlPlane")|.spec.network.subnets[4])={"id":"subnet-0cb9716eb14f441c4"}' manifests/eks.yml
#yq -i '(select(.kind=="AWSManagedControlPlane")|.spec.network.subnets[4])={"id":"subnet-01132fcc4883eb3a6"}' manifests/eks.yml
#yq -i '(select(.kind=="AWSManagedControlPlane")|.spec.network.vpc.availabilityZoneSelection)="Random"' manifests/eks.yml
yq -i '(select(.kind=="AWSManagedMachinePool")|.spec.availabilityZones[0])="us-east-1a"' manifests/eks.yml
yq -i '(select(.kind=="AWSManagedMachinePool")|.spec.availabilityZones[1])="us-east-1b"' manifests/eks.yml
yq -i '(select(.kind=="AWSManagedMachinePool")|.spec.availabilityZones[2])="us-east-1c"' manifests/eks.yml

#trying to use ipv6...
#yq -i '(select(.kind=="EKSConfigTemplate")|.spec.template.serviceIPV6Cidr)="2600:1f18:76e6:c300::/56"' manifests/eks.yml

kubectl create ns $1 -o yaml --dry-run=client >manifests/cluster-ns.yml
armory deploy start -f deployCluster.yml --add-context cluster=$1

# clusterctl get kubeconfig satwell-temp-feb-23-2023 -n=satwell-temp-feb-23-2023>tempManifests/cluster.kubeconfig
# k --kubeconfig=tempManifests/cluster.kubeconfig -n=armory-rna get all
