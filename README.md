skupper@scaleway
================

This is a test of using skupper to expose a GPU service in Kapsule to an other cluster to mutualize resources.

Pre-requisites
--------------

- kubectl CLI
- skupper CLI: `curl https://skupper.io/install.sh | sh`

Setup
-----

Create 2 Kapsule cluster named `skupper-prod` and `skupper-preprod`

`skupper-prod` should have at least one GPU node tainted with `node=gpu:NoSchedule`

Download both kubeconfig files and add them in the folder. They should be named `kubeconfig-skupper-prod.yaml` and `kubeconfig-skupper-preprod.yaml`

Run installation script:

```
./install.sh
```

This will:

- Create a prod namespace, install ollama deployment and expose it to preprod
- Create a preprod namespace, install chatbot deployment and expose it via loadbalancer

Go to `http://<chatbot external IP>:8080` to query chatbot in preprod without having a GPU node.

Sample output
-------------

```
$ ./install.sh
--- Setup in preprod
namespace/preprod created
Context "admin@skupper-preprod" modified.
Waiting for LoadBalancer IP or hostname...
Waiting for status...
Skupper is now installed in namespace 'preprod'.  Use 'skupper status' to get more information.
Token written to ./preprod.token
--- Setup in prod
namespace/prod created
Context "admin@skupper-prod" modified.
Waiting for status...
Skupper is now installed in namespace 'prod'.  Use 'skupper status' to get more information.
Site configured to link to https://195.154.74.11:8081/d6227efe-2dbb-11ef-b730-acde48001122 (name=link1)
Check the status of the link using 'skupper link status'.
--- Building prod GPU service
deployment.apps/ollama created
Waiting for deployment "ollama" rollout to finish: 0 of 1 updated replicas are available...
deployment "ollama" successfully rolled out
--- Expose prod GPU service to other cluster
deployment ollama exposed as ollama
--- Show exposed GPU service in preprod
NAME     TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)     AGE
ollama   ClusterIP   10.40.48.224   <none>        11434/TCP   0s
--- Building preprod chatbot service
deployment.apps/chatbot created
Waiting for deployment "chatbot" rollout to finish: 0 of 1 updated replicas are available...
deployment "chatbot" successfully rolled out
--- Exposing preprod chatbot service via loadbalancer
service/chatbot exposed
--- Waiting for external IP
--- Show exposed chatbot service
NAME      TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)          AGE
chatbot   LoadBalancer   10.39.94.234   X.X.X.X         8080:30646/TCP   41s
```

cleanup
-------

You can delete created resources in the clusters using `./delete.sh`

