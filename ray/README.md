# Deploying Ray on Open Data Hub via the KubeRay Operator

The code found here is a subset of https://github.com/ray-project/kuberay. Specifically, the manifests needed to enable Ray with an Open Data Hub deployment. 


## Components  of the KubeRay deployment

1. Namespace 'ray-system'
2. Custom Resource Definitions
3. Operator
4. Roles and Service Accounts

## Deploy KubeRay:

### Prerequisites to install KubeRay with ODH:

* Cluster admin access
* An ODH deployment
* [Kustomize](https://kustomize.io/)


## Install KubeRay

```bash
cd operator/base
oc kustomize > deploy_kuberay.yaml
oc create -f deploy_kuberay.yaml
```

#### Confirm the operator is running 

```
$ oc get pods -n ray-system
NAME                               READY   STATUS    RESTARTS        AGE
kuberay-operator-867bc855b7-2tzxs      1/1     Running   0               4d19h

```

#### Create a test cluster 

```bash
$ oc apply -f cluster/ray-cluster-test.yaml
```

#### Confirm the cluster is running 
```
$ oc get RayCluster 
NAME                   DESIRED WORKERS   AVAILABLE WORKERS   STATUS   AGE
kuberay-cluster-test   1                 2                   ready    13s

```

Once the cluster is running you should be able to connect to it to use ray in a python script or jupyter notebook by using `ray.init(ray://<Ray_Cluster_Service_Name>:10001)`. 
```python 
import ray
ray.init('ray://<Ray_Cluster_Service_Name>:10001')
```

That's it! 