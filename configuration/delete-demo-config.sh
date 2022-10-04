helm uninstall armory-rna-prod \
    -n borealis-demo-agent-prod
helm uninstall prometheus -n=borealis-demo-infra
#do not delete demo agent prod, we want the secret in it kept around!!!
#kubectl delete namespace borealis-demo-agent-prod
kubectl delete ns borealis-demo-agent-prod-eu borealis-demo-agent-staging borealis-demo-agent-dev borealis-demo-infra
kubectl delete ns borealis-demo-agent-staging
kubectl delete ns borealis-demo-agent-dev

kubectl delete ns borealis-demo-infra

#kubectl delete namespace borealis-demo-agent-staging
#kubectl delete namespace borealis-demo-agent-dev