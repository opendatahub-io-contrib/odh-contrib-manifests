# Ceph Object Storage

Deploys [cn-core](https://github.com/cn-core) image that provides object storage for minimal cluster deployments based on a release of [ceph-container](https://github.com/ceph/ceph-container).

[Ceph](https://ceph.io) provides S3 compatible object storage via the RADOS GateWay(RGW) Service

***NOTE***: This component includes a SCC that enables runAsUser->RunAsAny

### Folders
There is one main folder in the Ceph Object Storage component
1. object-storage/nano/base: contains all the necessary yaml files to install Ceph Object Storage

### Installation
To install Ceph Object Storage add the following to the `kfctl` yaml file.

```yaml
  - kustomizeConfig:
      repoRef:
        name: manifests
        path: ceph/object-storage/scc
    name: ceph-nano-scc
  - kustomizeConfig:
      repoRef:
        name: manifests
        path: ceph/object-storage/nano
    name: ceph-nano
```

### Additional Info
* When `ceph-nano` is deployed, pods in the namespace can access the object storage using the `ceph-nano-0` service name `http://ceph-nano-0`

* For S3 web portal, execute this command and access the portal with `http://localhost:5001`
  ~~~
  oc port-forward pod/ceph-nano-0 5001 8000
  ~~~
  If you hit `ACCESS_DENY`, please clean brower cache and try it again.

* The ACCESS_KEY and SECRET_KEY created for this deployment can be found in `ceph-nano-credentials` secret.
  ```sh
  oc describe secrets/ceph-nano-credentials

  Name:         ceph-nano-credentials
  Namespace:    odh-ceph
  Labels:       <none>
  Annotations:
  Type:         Opaque

  Data
  ====
  AWS_ACCESS_KEY_ID:      20 bytes
  AWS_SECRET_ACCESS_KEY:  40 bytes
  ```
  ***NOTE***: The ACCESS_KEY and SECRET_KEY will change EVERY time the pod starts
