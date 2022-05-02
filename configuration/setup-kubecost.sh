kubectl create namespace kubecost
helm repo add kubecost https://kubecost.github.io/cost-analyzer/
helm repo update
helm upgrade --install kubecost kubecost/cost-analyzer --namespace kubecost --set kubecostToken="$1"  --set service.type=LoadBalancer
#--set ingress.enabled=true --set ingress.paths[0]=\/kubecost --set ingress.hosts=[a34d3aaf6283e4c36b7563ee321c9673-194964128.us-east-2.elb.amazonaws.com] --set ingress.annotations."nginx\.org\/mergeable-ingress-type"=minion
#kubectl port-forward --namespace kubecost deployment/kubecost-cost-analyzer 9090