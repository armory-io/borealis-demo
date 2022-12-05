
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
}

brew install yq
build deploy-vanilla deploy-kustomize-vanilla.yml