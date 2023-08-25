# Iter8

[Iter8](https://iter8.tools) is the Kubernetes release optimizer built for DevOps, MLOps, SRE and data science teams. 
Iter8 has a controller that automatically reconfigures the Red Hat OpenShift Service Mesh when the set of versions of an ML model change.
This enables blue-green and canary rollouts of new versions of a model in the cluster.

## Installation 
Following are the steps to install Iter8 as a part of an OpenDataHub install:

1. Install the OpenDataHub operator.
2. Create a `kfctl` file that includes the Iter8 component:

```yaml
- kustomizeConfig:
    repoRef:
      name: manifests
      path: iter8/clusterScoped
  name: kserve
```

3. Install the Red Hat OpenShift Service Mesh component and its prerequisites as described [here](https://docs.openshift.com/container-platform/4.8/service_mesh/v2x/installing-ossm.html).
4. Deploy a `ServiceMeshControlPlane` in project `istio-system` as described [here](https://docs.openshift.com/container-platform/4.8/service_mesh/v2x/ossm-create-smcp.html). Edit it to [disable automatic NetworkPolicy creation](https://docs.openshift.com/container-platform/4.13/service_mesh/v2x/ossm-traffic-manage.html#ossm-config-disable-networkpolicy_traffic-management). 
5. Add your user project(s) to a `ServiceMeshMemberRoll`.

## Using Iter8 in ODH

Iter8 can be used with Model Mesh Serving or with KServe.

### Model Mesh Serving

See tutorials for [blue-green](https://iter8.tools/0.15/tutorials/integrations/kserve-mm/blue-green/) and [canary](https://iter8.tools/0.15/tutorials/integrations/kserve-mm/canary/) rollout.

### KServe

See tutorials for [blue-green](https://iter8.tools/0.15/tutorials/integrations/kserve/blue-green/) and [canary](https://iter8.tools/0.15/tutorials/integrations/kserve/canary/) rollout.
