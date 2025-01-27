<#
 naming convention <root><num><type>
root = msdotnet ( microservicesdotnet )
num = 1
type
  rg resource group
  cr container registry
  kc kuberneters cluster
#>

# login to azure account
az login
# create resource group
az group create --name msdotnet1rg --location westus
# create container registry
az acr create --resource-group msdotnet1rg --name msdotnet1cr --sku Basic
# create kubernetes cluster
az aks create --resource-group msdotnet1rg --name msdotnet1kc --node-count 1 --enable-addons monitoring --generate-ssh-keys --attach-acr msdotnet1cr
# get the credentials for ?
az aks get-credentials --resource-group msdotnet1rg --name msdotnet1kc
# this writes the credentials to %USERPROFILE%, not %HOME%
set HOME=%USERPROFILE%
kubectl get nodes


# This dashboard setup does not seem to work
## set the admin
kubectl create clusterrolebinding kubernetes-dashboard --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard
## supposed to start the k8 dashboard but it instead displays the AZ resource in browser
## might be just as simple
az aks browse --resource-group msdotnet1rg --name msdotnet1kc

# pushing the docker image to container registry
docker tag shopping-cart-image msdotnet1cr.azurecr.io/shopping-cart-image:1.0.0
az acr login --name msdotnet1cr
docker push msdotnet1cr.azurecr.io/shopping-cart-image:1.0.0

# start the k8 cluster
kubectl apply -f shopping-cart-az.yaml

# kubectl delete?
kubectl delete -f shopping-cart-az.yaml
# az group delete?
az group delete --name msdotnet1rg --yes --no-wait
