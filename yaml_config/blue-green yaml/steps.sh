once cluster up and running then kused kubectl command to create deployments


kubectl create deployment nginx-blue --image=nginx --dry-run=client -o yaml > nginx-blue-deployment.yaml

kubectl apply -f nginx-blue-deployment.yaml

kubectl get deployment
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
nginx        2/2     2            2           11m
nginx-blue   1/1     1            1           10s

kubectl label deployment nginx-blue app=nginx version=blue --overwrite

Same for the green deployment

kubectl create deployment nginx-green --image=nginx --dry-run=client -o yaml > nginx-green-deployment.yaml

kubectl apply -f nginx-green-deployment.yaml

kubectl label deployment nginx-green app=nginx version=green --overwrite

kubectl get deployment
NAME          READY   UP-TO-DATE   AVAILABLE   AGE
nginx         2/2     2            2           12m
nginx-blue    1/1     1            1           58s
nginx-green   1/1     1            1           21s

kubectl expose deployment nginx-blue --type=LoadBalancer --name=nginx-service --port=80 --target-port=80

kubectl get svc
NAME            TYPE           CLUSTER-IP       EXTERNAL-IP      PORT(S)        AGE
kubernetes      ClusterIP      34.118.224.1     <none>           443/TCP        50m
nginx           LoadBalancer   34.118.232.165   35.192.183.128   80:30113/TCP   18m
nginx-service   LoadBalancer   34.118.234.120   <pending>        80:30854/TCP   5s


kubectl patch service nginx-service -p '{"spec":{"selector":{"app":"nginx","version":"green"}}}'