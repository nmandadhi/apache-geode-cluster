docker build -t gcr.io/solstice-api-junkyard/geode .
docker push gcr.io/solstice-api-junkyard/geode

kubectl delete all --all
kubectl apply -f k8s/

echo "Waiting for the pods"
sleep 20
kubectl logs -fl app=locator