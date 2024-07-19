kubectl get service ingress-nginx-controller --namespace=ingress-nginx

ip=$(kubectl get service ingress-nginx-controller --namespace=ingress-nginx -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
echo "ip=$ip"

while [ -z "$ip" ]
do
  sleep 5
  ip=$(kubectl get service ingress-nginx-controller --namespace=ingress-nginx -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
  echo "ip=$ip"
done

set_octopusvariable "IP" $ip
