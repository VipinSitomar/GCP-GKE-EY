once cluster created with the defined node pool then with the help of cloud sdk or gcloud cli connected to the cluster using command


gcloud container clusters get-credentials <cluster_name> name --zone <zone> --project <project_id>

once connected can use kubectl command to create or manage yamls

kubectl label nodes <created node pool> pool=nginx-pool

then edited the file by vi editor and created nginx deployment file

kubectl apply -f nginx-deployment.yaml

kubectl expose deployment nginx --type=LoadBalancer --port=80

kubectl get svc nginx

to test the application used github load repo that will put traffic on the created nginx server that been created and when exposed it will show the external ip

curl -L -o hey https://github.com/rakyll/hey/releases/latest/download/hey_linux_amd64
chmod +x hey

hey -z 1m -c 100 http://35.192.183.128(external IP)

IT will show result like this 


Summary:
  Total:        60.1992 secs
  Slowest:      0.6136 secs
  Fastest:      0.2038 secs
  Average:      0.2065 secs
  Requests/sec: 483.2788
  
  Total data:   17892195 bytes
  Size/request: 615 bytes

Response time histogram:
  0.204 [1]     |
  0.245 [28991] |■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
  0.286 [0]     |
  0.327 [0]     |
  0.368 [0]     |
  0.409 [0]     |
  0.450 [100]   |
  0.491 [0]     |
  0.532 [0]     |
  0.573 [0]     |
  0.614 [1]     |


Latency distribution:
  10% in 0.2048 secs
  25% in 0.2052 secs
  50% in 0.2057 secs
  75% in 0.2062 secs
  90% in 0.2069 secs
  95% in 0.2074 secs
  99% in 0.2091 secs

Details (average, fastest, slowest):
  DNS+dialup:   0.0007 secs, 0.2038 secs, 0.6136 secs
  DNS-lookup:   0.0000 secs, 0.0000 secs, 0.0000 secs
  req write:    0.0000 secs, 0.0000 secs, 0.0021 secs
  resp wait:    0.2057 secs, 0.2036 secs, 0.6135 secs
  resp read:    0.0001 secs, 0.0000 secs, 0.0026 secs

Status code distribution:
  [200] 29093 responses


Apart from this can also create github workflow actions that will automate this process

