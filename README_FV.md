# Gitops
## Start cluster
```sh
make start
```

## Deploy
```sh
make deploy

kubectl -n prod get canaries
```

### Install addons
```sh
kubectl apply -f addons/kiali.yaml
```

- Get URL
```sh
export INGRESS_HOST=$(kubectl get po -l istio=ingressgateway -n istio-system -o jsonpath='{.items[0].status.hostIP}')
echo $INGRESS_HOST

export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
echo $INGRESS_PORT

# kubectl -n istio-system get svc istio-ingressgateway -ojson | jq .status.loadBalancer.ingress
echo http://$INGRESS_HOST:$INGRESS_PORT

kubectl create secret generic kiali -n istio-system --from-literal=username=admin --from-literal=passphrase=admin
kubectl -n istio-system delete po kiali-569c9f8b6c-l5d8c
```
## Destroy cluster
```sh
make destroy
```