# Open Data Hub Manifests
A repository for kustomize manifests contributed by [Open Data Hub](https://opendatahub.io) community members that provide integrations of value to the greater community

## Community
* Open Data Hub Community: [https://github.com/opendatahub-io/opendatahub-community](https://github.com/opendatahub-io/opendatahub-community)
* Community Discussions: [https://odh-io.slack.com](https://odh-io.slack.com)
* Community meetings: [http://opendatahub.io/community.html](http://opendatahub.io/community.html)


## ODH Contrib Components

Open Data Hub is an end-to-end AI/ML platform on top of OpenShift Container Platform that provides a core set of integrated components to support end end-to-end MLOps workflow for Data Scientists and Engineers. The components currently available as part of the ODH Core deployment are:


| ODH Version | Component                                               |
| ----------- | ------------------------------------------------------- |
|   1.4       | [Ray.io](ray/README.md)                                 |
|   1.4       | [Pachyderm](odhpachyderm/README.md)                     |
|   1.4       | [Superset](superset/README.md)                          |
|   1.3       | [ArgoWorkflows](odhargo/README.md)                      |
|   1.3       | [Hue](hue/README.md)                                    |
|   1.3       | [Hive Thrift Server](thriftserver/README.md)            |
|   1.3       | [Trino](trino/README.md)                                |
|   1.3       | [Radanalytics Spark Operator](radanalyticsio/README.md) |


Any components that were removed with the update to ODH 1.4 have been relocated to the [ODH Contrib](https://github.com/opendatahub-io-contrib) organization under the [odh-contrib-manifests](https://github.com/opendatahub-io-contrib/odh-contrib-manifests) repo.  You can reference the [odh-contrib kfdef](kfdef/odh-contrib.yaml) as a reference on how to deploy any of the odh-contrib-manifests components

## Deploy

We are relying on [Kustomize v3](https://github.com/kubernetes-sigs/kustomize), [kfctl](https://github.com/kubeflow/kfctl) and [Open Data Hub Operator](https://github.com/opendatahub-io/opendatahub-operator/blob/master/operator.md) for deployment.

The two ways to deploy are:

1. Following [Getting Started](http://opendatahub.io/docs/getting-started/quick-installation.html) guide using a KFDef from this repository as the custom resource.
1. Using `kfctl` and follow the documentation at [Kubeflow.org](https://www.kubeflow.org/docs/openshift/). The only change is to use this repository instead of Kubeflow manifests.

## Issues
To submit issues please file a GitHub issue in [odh-contrib-manifests](https://github.com/opendatahub-io/odh-contrib-manifests/issues)
