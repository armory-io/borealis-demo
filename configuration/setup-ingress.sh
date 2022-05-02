
kubectl create ns ingress
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update
helm install my-release nginx-stable/nginx-ingress -n=ingress
kubectl annotate ingressclass nginx ingressclass.kubernetes.io/is-default-class=true
kubectl create ns borealis-prod-eu