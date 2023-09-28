
build()
{
  SOURCE=$1
  DESTINATION=$2
  TYPE=$3
  SUFFIX=$4
  echo "kustomize build $SOURCE > ../$DESTINATION"
  kustomize build $SOURCE > ../$DESTINATION
  echo "yq eval 'del(.apiVersion)' ../$DESTINATION -i"
  yq eval 'del(.apiVersion)' ../$DESTINATION -i
  echo "yq eval 'del(.metadata)' ../$DESTINATION -i"
  yq eval 'del(.metadata)' ../$DESTINATION -i
  echo "reordering output...."
  yq eval '{"version": .version, "kind": .kind,"application": .application, "targets":.targets, "manifests":.manifests,"artifacts":.artifacts,"providerOptions":.providerOptions,"strategies": .strategies,"analysis": .analysis,"trafficManagement": .trafficManagement, "webhooks": .webhooks, "deploymentConfig": .deploymentConfig}'  ../$DESTINATION -i
  yq eval '(.targets | key) line_comment="#This section defines the targets to which you are deploying, and their constraints."' ../$DESTINATION -i
  yq eval '(.manifests | key) line_comment="#This section defines the Manifests you are deploying, by default they reach all targets, but you can specify certain targets if needed."' ../$DESTINATION -i
  yq eval '(.strategies | key) line_comment="#This section defines the strategies environments can use to deploy."' ../$DESTINATION -i
  yq eval '(.analysis | key) line_comment="#This section defines queries against your monitoring system that can be used for automated canary analysis."' ../$DESTINATION -i
  yq eval '(.providerOptions | key) line_comment="#This section defines options specific to the cloud provider to which we are deploying."' ../$DESTINATION -i
  yq eval '(.trafficManagement | key) line_comment="#Traffic management configuration"' ../$DESTINATION -i
  yq eval '(.webhooks | key) line_comment="#Webhooks can be used to run external automation."' ../$DESTINATION -i
  yq eval '.analysis.queries[].lowerLimit=0.0' ../$DESTINATION -i
  if [ $TYPE == "lambda" ]
  then
    yq eval 'del(.manifests)' ../$DESTINATION -i
    yq eval "(.artifacts[]) .functionName += \"$SUFFIX\"" ../$DESTINATION -i
    yq eval "(.providerOptions.lambda[]) .name += \"$SUFFIX\"" ../$DESTINATION -i
    yq eval '.kind="lambda"' ../$DESTINATION -i
    yq eval '(.artifacts | key) line_comment="#This section defines the artifacts you are deploying, by default they reach all targets, but you can specify certain targets if needed."' ../$DESTINATION -i
    #temporary, remove features we do not yet support.
    yq eval 'del(.strategies.myBlueGreen)' ../$DESTINATION -i
    yq eval 'del(.strategies.mycanary)' ../$DESTINATION -i
    yq eval 'del(.strategies.rolling)' ../$DESTINATION -i
    yq eval 'del(.trafficManagement)' ../$DESTINATION -i
    #end temporary
  fi
  if [ $TYPE == "k8s" ]
  then
    yq eval '(.manifests | key) line_comment="#This section defines the Manifests you are deploying, by default they reach all targets, but you can specify certain targets if needed."' ../$DESTINATION -i
    yq eval 'del(.artifacts)' ../$DESTINATION -i
    yq eval 'del(.providerOptions)' ../$DESTINATION -i
  fi
}

brew install yq 
build deploy-vanilla deploy.yml k8s $1
build deploy-lambda lambda-deploy.yml lambda $1
build deploy-argo deploy-w-argo.yml k8s $1
