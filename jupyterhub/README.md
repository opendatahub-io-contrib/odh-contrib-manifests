# JupyterHub

JupyterHub comes with 2 components:

1. [jupyterhub](#jupyterhub)
2. [notebook-images](#notebook-images)

## jupyterhub

Contains deployment manifests for JupyterHub instance.

## Jupyterhub Architecture

Out of the box Jupyterhub will deploy its components in a High Availibility configuration. This entails 3 copies of the central Jupyterhub server as well as 3 copies of a Traefik Proxy that is reponsible for routing user traffic to notebook pods. To disable HA users can set the `replica` count for Jupyterhub and Traefik to `1`. In its current configuration, jupyterhub server pods will always have 1 leader pod. The other pods will stay on standby and constantly try and get a lock to become the new leader. In case you disable HA, there will always be just the one pod that is acting as the leader and the new pod that comes online in case of failure will become the new leader.  

### Parameters

JupyterHub component comes with 2 parameters exposed vie KFDef.

#### s3_endpoint_url

HTTP endpoint exposed by your S3 object storage solution which will be made available to JH users in `S3_ENDPOINT_URL` env variable.

#### trusted_ca_bundle_path

Full path to a non-publicly trusted ca-bundle file. Used to fill `TRUSTED_CA_BUNDLE_PATH` env variable containing the full path incl. filename to one or more trusted CAs in [Privacy-Enhanced Mail (PEM) file](https://en.wikipedia.org/wiki/Privacy-Enhanced_Mail) format. For use in airgapped environments where SSL server authenticity can only be validated using certificates based on private public key infrastructure (PKI) with root and optionally intermediate certificate authorities (CAs) that are not publicly trusted. Specifically used for example by Elyra for downloading package catalog files from an airgapped e.g. Artifactory or Nexus with private PKI and establishing the SSL chain of trust. See e.g. on-premise Openshift installs with additionalTrustBundle setting that can be injected into configmaps at a namespace for usage on containers.
https://docs.openshift.com/container-platform/4.8/networking/configuring-a-custom-pki.html
This requires `trusted-ca-bundle-path` **overlay** to be enabled as well to work.

#### storage_class

Name of the storage class to be used for PVCs created by JupyterHub component. This requires `storage-class` **overlay** to be enabled as well to work.

#### jupyterhub_groups_config

A ConfigMap containing comma separated lists of groups which would be used as Admin and User groups for JupyterHub. The default ConfgiMap can be found [here](jupyterhub/base/jupyterhub-groups-configmap.yaml).

#### jupyterhub_secret

A Secret containing configuration values like JupyterHub DB password or COOKIE_SECRET. The default Secret can be found [here](jupyterhub/base/jupyterhub-secret.yaml).

##### Examples

```yaml
  - kustomizeConfig:
      overlays:
      - storage-class
      parameters:
        - name: storage_class
          value: standard
        - name: s3_endpoint_url
          value: "s3.odh.com"
      repoRef:
        name: manifests
        path: jupyterhub/jupyterhub
    name: jupyterhub
```
#### trusted_ca_bundle_path in conjunction with S3 storage for Elyra Pipelines metadata and HTTP-location-based built-in catalog connectors (URL catalog, Apache Airflow package connector, Apache Airflow provider package connector). With this overlay, url download is made possible with optional verify parameter pointing to private PKI CA bundle file in env parameter TRUSTED_CA_BUNDLE_PATH)

```yaml
 - kustomizeConfig:
     overlays:
     - trusted-ca-bundle-path
     parameters:
       - name: trusted_ca_bundle_path
         value: "/opt/app-root/etc/jupyter/custom/cacerts/trustedcas.pem"
       - name: s3_endpoint_url
         value: "http://ceph-nano-0"
     repoRef:
       name: manifests
       path: jupyterhub/jupyterhub
   name: jupyterhub
```

### Overlays

JupyterHub component comes with 3 overlays.

#### build

Contains build manifests for JupyterHub images.

#### storage-class

Customizes JupyterHub to use a specific `StorageClass` for PVCs, see `storage_class` parameter.

#### trusted-ca-bundle-path

Customizes JupyterHub to use a specific ENV variable in TRUSTED_CA_BUNDLE_PATH in spawned notebook images. See `trusted_ca_bundle_path` parameter. The ENV variable is used in configmap jupyter-singleuser-profiles, if parameter is defined.

## Notebook Images

Contains manifests for Jupyter notebook images compatible with JupyterHub on OpenShift.

### Parameters

Notebook Images do not provide any parameters.

### Overlays

Notebook Images component comes with 3 overlays.

#### [jupyterhub-idle-culler](jupyterhub/overlays/jupyterhub-idle-culler)

Adds a `DeploymentConfig` of the jupyterhub idle culler. It enables shutting down notebooks that are idle for a certain amount of time.

Changes to the culling timeout value can either be made in the `jupyterhub-cfg` `ConfigMap` or in the cluster settings section of the ODH Dashboard.

**Note:** The culling timeout value in the dashboard and manual configuration fo the culler will **not** work if this overlay is deployed together with the operator, as any change to the jupyterhub-cfg `ConfigMap` will be reverted.


Jupyterhub-idle-culler repository: https://github.com/jupyterhub/jupyterhub-idle-culler

#### [additional](notebook-images/overlays/additional/)

Contains additional Jupyter notebook images.

#### [build](notebook-images/overlays/build/)

Contains build manifests for Jupyter notebook images.

#### [cuda](notebook-images/overlays/cuda/)

Contains build chain manifest for CUDA enabled ubi 7 based images, provides `tensorflow-gpu` enabled notebook image.

*NOTE:* Builds in this overlay require 4 GB of memory and 4 cpus

#### [cuda-11.0.3](notebook-images/overlays/cuda-11.0.3/)

Contains build chain manifest for CUDA 11.0.3 enabled ubi 8 based images with python 3.8 support, provides `tensorflow-gpu` and `pytorch-gpu` enabled notebook image.

*NOTE:* Builds in this overlay require 4-6 GB of memory

## Deploying JupyterHub notebooks to custom namespaces

JupyterHub has support for deploying notebooks to other namespaces. To help facilitate this, we provide a component under `jupyterhub/custom-notebook-deployment`. The steps to deploy are as follows:

1. Create the namespace for JupyterHub to reside in.
2. Create the namespace for the JupyterHub notebooks to reside in.
3. Create a kfdef in the jupyterhub namespace with at least the following Kustomize config in it (note how we are specifying the notebook destination under parameters)

    ```yaml
      - kustomizeConfig:
          overlays:
          - storage-class
          parameters:
            - name: storage_class
              value: standard
            - name: s3_endpoint_url
              value: "s3.odh.com"
            - name: notebook_destination
              value: <namespace from step 2>
          repoRef:
            name: manifests
            path: jupyterhub/jupyterhub
        name: jupyterhub
    ```

4. Create a kfdef in the jupyterhub notebook namespace with the following Kustomize config (note how we are specifying the jupyterhub namespace under parameters).

    ```yaml
        - kustomizeConfig:
          parameters:
            - name: jupyterhub_namespace
              value: <namespace from step 1>
            repoRef:
              name: manifests
              path: jupyterhub/custom-notebook-deployment
          name: jupyterhub-rbac
    ```
