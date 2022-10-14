# Deploying Ray with Open Data Hub

Integration of [Ray](https://docs.ray.io/en/latest/index.html) with Open Data Hub on OpenShift. The ray operator and other components are based on https://docs.ray.io/en/releases-1.13.0/cluster/kubernetes.html

## Components  of the Ray deployment

1. [Ray operator](./operator/base/ray-operator-deployment.yaml): The operator will process RayCluster resources and schedule ray head and worker pods based on requirements. Image Containerfile can be found [here](https://github.com/thoth-station/ray-operator/blob/master/Containerfile). 
2. [Ray CR](./operator/base/ray-custom-resources.yaml):  RayCluster Custom Resource (CR) describes the desired state of ray cluster.
3. [Ray Cluster](./cluster/base/ray-cluster.yaml): Defines an instance of an example Ray Cluster. Image Containerfile can be found [here](https://github.com/thoth-station/ray-ml-worker/blob/master/Containerfile) 
 

## Deploy the RayCluster Components:

Prerequisite to install RayCluster with ODH:

* Cluster admin access
* An ODH deployment
* [Kustomize](https://kustomize.io/) 

### Install Ray

We will use [Kustomize](https://kustomize.io/) to deploy everything we need to use Ray with Open Data Hub. 

#### Install the operator and custom resource 

First use the `oc kustomize` command to generate a yaml containing all the requirements for the operator and the "raycluster" custom resource, then `oc apply` that yaml to deploy the operator to your cluster. 

```bash
$ oc kustomize ray/operator/base > operator_deployment.yaml
```
```bash
$ oc apply -f operator_deployment.yaml -n <your-namespace>
```

#### Confirm the operator is running 

```
$ oc get pods 
NAME                               READY   STATUS    RESTARTS        AGE
ray-operator-867bc855b7-2tzxs      1/1     Running   0               4d19h

```

#### Create a ray cluster 


```bash
$ oc kustomize ray/cluster/base > cluster_deployment.yaml
```
```bash
$ oc apply -f cluster_deployment.yaml -n <your-namespace>
```

#### Confirm the cluster is running 
```
$ oc get pods 
NAME                               READY   STATUS    RESTARTS        AGE
ray-cluster-head-2f866             1/1     Running   0               36m

```

Once the cluster is running you should be able to connect to it to use ray in a python script or jupyter notebook by using `ray.init(ray://<Ray_Cluster_Service_Name>:10001)`. 
```python 
import ray
ray.init(ray://<Ray_Cluster_Service_Name>:10001)
```

That's it! 