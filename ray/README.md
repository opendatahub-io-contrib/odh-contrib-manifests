# Deploying Ray on Open Data Hub via the KubeRay Operator

The code found here is a subset of https://github.com/ray-project/kuberay. Specifically, the manifests needed to enable Ray with an Open Data Hub deployment. 


## Components  of the KubeRay deployment

1. Namespace 'ray-system'
2. Custom Resource Definitions
3. Operator
4. Roles and Service Accounts

## Deploy KubeRay:

Make sure that you have the KubeRay kustomizeConfig in your ODH KfDef. This will ensure that all of the components above get installed as part of your ODH deployment.  

```yaml
 # KubeRay
  - kustomizeConfig:
      repoRef:
        name: manifests-contrib
        path: ray/operator
    name: ray-operator
```

### Confirm the operator is running:

Once ODH is installed, you can confirm the KubeRay operator deployed correctly with `oc get pods -n ray-system`.


```
$ oc get pods -n ray-system
NAME                               READY   STATUS    RESTARTS        AGE
kuberay-operator-867bc855b7-2tzxs      1/1     Running   0               4d19h

```

### Create a test cluster 

Now that the operator is running, let's create a small Ray cluster and make sure the operator can handle the request correctly. From whatever namespace you want to use you can run the following command:

```bash
$ oc apply -f tests/resources/ray/ray-test-cluster-test.yaml
```

### Confirm the cluster is running 
```
$ oc get RayCluster 
NAME                   DESIRED WORKERS   AVAILABLE WORKERS   STATUS   AGE
kuberay-cluster-test   1                 2                   ready    13s

```

Once the cluster is running you should be able to connect to it to use ray in a python script or jupyter notebook by using `ray.init(ray://kuberay-cluster-test-head-svc:10001)`. 
```python 
import ray
ray.init('ray://kuberay-cluster-test-head-svc:10001')
```

### Delete your test cluster

Now that you've confirmed everything is working feel free to delete your Ray test cluster. `oc delete RayCluster kuberay-cluster-test`

That's it! You should now be able to use Ray as part of your Open Data Hub Deployment for distributed and parallel computing.  