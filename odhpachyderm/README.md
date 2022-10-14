# Pachyderm

[Pachyderm](https://www.pachyderm.com/products/) is the data foundation for machine learning and offers three different products to fit all machine learning operationalization (MLOps) needs.

**Folders**
There is one main folder in the Pachyderm component

- operator: contains the subscription for the Pachyderm operator
- deployer: contains Job,ServiceAccount,Role,Rolebiding to deploy Pachyderm 

## Installation
### Default storage(Ceph Nano)
  The default storage for Pachyderm is [Ceph Nano](https://github.com/opendatahub-io/odh-manifests/tree/master/ceph) which is included in ODH. So you need to add `Ceph Nano` components with Pachyderm within `KfDef`. This is the   [KfDef manifests example](https://gist.github.com/Jooho/d4cd41263a1f2d875334c6a9cdb3673b).
  

  ~~~
  # Ceph Nano 
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
  # Pachyderm operator
  - kustomizeConfig:
      parameters:
        - name: namespace
          value: openshift-operators
      repoRef:
        name: manifests
        path: odhpachyderm/operator
    name: odhpachyderm-operator
  # Pachyderm deployer
  - kustomizeConfig:
      repoRef:
        name: manifests
        path: odhpachyderm/deployer
    name: odhpachyderm-deployer
  ~~~
### Other storage(AWS,Minio and S3 compatible)
  If you want to use other storage such as AWS S3, Minio and S3 compatible storage, you must provide a secret before creating a KfDef. Please refer to this to create the secret.
  
  Refer to this full [KfDef manifests](https://gist.github.com/Jooho/81c883f05bf024fdb803f93a65942135).
  

  **Note that you must create a secret before creating a KfDef.**

  *Update required parameters:*
  - `storage_secret`: This is a secret name of the credential information for your storage.
  ~~~
  - kustomizeConfig:
      parameters:
        - name: namespace
          value: openshift-operators
      repoRef:
        name: manifests
        path: odhpachyderm/operator
    name: odhpachyderm-operator
  - kustomizeConfig:
      parameters:
        - name: storage_secret             #<=== Must set this
          value: pachyderm-aws-secret   
      repoRef:
        name: manifests
        path: odhpachyderm/deployer
    name: odhpachyderm-deployer
  ~~~
  
## How to create a secret for other storage
There are several ways to create a secret in OpenShift but I am going to show you the typical use-cases for AWS S3 and Minio. Using the oc command line, you can create your own secret for a storage.

**Secret Example**

- *AWS S3*
  ~~~
  $ oc create secret generic pachyderm-aws-secret \
  --from-literal=access-id=XXX  \
  --from-literal=access-secret=XXX \
  --from-literal=region=us-east-2 \
  --from-literal=bucket=pachyderm 
  ~~~

- *Minio*
  ~~~
    $ oc create secret generic pachyderm-minio-secret \
  --from-literal=access-id=XXX  \
  --from-literal=access-secret=XXX \
  --from-literal=custom-endpoint=${minio_ip}
  --from-literal=region=us-east-2 \
  --from-literal=bucket=pachyderm 
  ~~~


*Pachyderm Running Pods*
~~~
$ oc get pod 
etcd-0                          1/1     Running   0          12m
postgres-0                      1/1     Running   0          12m
pachd-874f5958c-7w98p           1/1     Running   0          11m
pg-bouncer-7587d49769-gwn8f     1/1     Running   0          11m
~~~

