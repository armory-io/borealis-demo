
build()
{
  SOURCE=$1
  DESTINATION=$2
  echo "kustomize build $SOURCE > ../$DESTINATION"
  kustomize build $SOURCE > ../$DESTINATION
  echo "yq eval 'del(.apiVersion)' ../$DESTINATION -i"
  yq eval 'del(.apiVersion)' ../$DESTINATION -i
  echo "yq eval 'del(.metadata)' ../$DESTINATION -i"
  yq eval 'del(.metadata)' ../$DESTINATION -i
  echo "reordering output...."
  yq eval '{"version": .version, "kind": .kind,"application": .application, "targets":.targets, "manifests":.manifests,"strategies": .strategies,"analysis": .analysis,"trafficManagement": .trafficManagement, "webhooks": .webhooks}'  ../$DESTINATION -i
  yq eval '(.targets | key) line_comment="#This section defines the targets to which you are deploying, and their constraints."' ../$DESTINATION -i
  yq eval '(.manifests | key) line_comment="#This section defines the Manifests you are deploying, by default they reach all targets, but you can specify certain targets if needed."' ../$DESTINATION -i
  yq eval '(.strategies | key) line_comment="#This section defines the strategies environments can use to deploy."' ../$DESTINATION -i
  yq eval '(.analysis | key) line_comment="#This section defines queries against your monitoring system that can be used for automated canary analysis."' ../$DESTINATION -i
  yq eval '(.trafficManagement | key) line_comment="#Traffic management configuration"' ../$DESTINATION -i
  yq eval '(.webhooks | key) line_comment="#Webhooks can be used to run external automation."' ../$DESTINATION -i
}

brew install yq
build deploy-vanilla deploy.yml
build deploy-argo deploy-w-argo.yml
