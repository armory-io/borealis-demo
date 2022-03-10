helm uninstall armory-rna-prod \
    -n borealis-demo-agent-prod
helm uninstall armory-rna-prod-eu \
    -n borealis-demo-agent-prod-eu
helm uninstall armory-rna-staging \
    -n borealis-demo-agent-staging
helm uninstall armory-rna-dev \
    -n borealis-demo-agent-dev
helm uninstall prometheus -n=borealis-demo-infra
#kubectl delete namespace borealis-demo-agents
#kubectl delete namespace borealis-demo-agent-prod
#kubectl delete namespace borealis-demo-agent-staging
#kubectl delete namespace borealis-demo-agent-dev