skupper@scaleway
================

This is a test of using skupper to expose a GPU service in Kapsule to an other cluster to mutualize resources.

prerequisite
------------

- kubectl CLI
- skupper CLI `curl https://skupper.io/install.sh | sh`


setup
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

cleanup
-------

You can delete created resources in the clusters using `./delete.sh`
