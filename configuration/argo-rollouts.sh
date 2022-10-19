echo "Installing Argo Rollouts"
kubectl create namespace argo-rollouts
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml

RAW_ARCH=$(uname -m)
OS=
case $(uname) in
  'Linux')
    OS='linux'
    ;;
  'Darwin')
    OS='darwin'
    ;;
  *)
    echo "un-supported OS detected: ${OS}-${RAW_ARCH}, exiting..."
    exit 1
    ;;
esac

curl -LO https://github.com/argoproj/argo-rollouts/releases/latest/download/kubectl-argo-rollouts-${OS}-amd64
chmod +x ./kubectl-argo-rollouts-${OS}-amd64
#export PATH=$PATH:
echo "running command with sudo, enter your password"
sudo mv ./kubectl-argo-rollouts-${OS}-amd64 /usr/local/bin/kubectl-argo-rollouts