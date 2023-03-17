# CUDA Build Chain

This overlay contains CUDA build chain to produce CUDA 11.0.3 based images for TensorFlow, PyTorch, and Minimal jupyter notebooks.

When this overlay is applied, the BuildConfigs and Imagestreams required for the build chain will be created by an OpenShift [job](./cuda-build-job.yaml).  Once the BuildConfigs and ImageStreams are deployed, the Open Data Hub operator will no longer reconcile or re-deploy these objects unless the job and buildchain objects are manually deleted by the user. Any changes you make will persist until you manually delete all associated build chain objects and job.

## Build Details:

The CUDA build chain is stored in the cuda-build-chain [configMap](./cuda-buildchain.configmap.yaml). This configmap contains the yaml files for deploying the BuildConfigs and Imagestreams for the CUDA build chain and GPU notebooks.
- `cuda-ubi8-build-chain.yaml`: This yaml contains CUDA build chain which creates the base image which is used by the jupyter notebook images.

- `gpu-notebook.yaml`: This yaml contains CUDA build chain which creates the GPU supported jupyter notebook images like s2i-minimal-gpu-notebook, s2i-tensorflow-gpu-notebook, and  s2i-pytorch-gpu-notebook.

## Resource Requirements:

**_NOTE:_** If users don't have quota restrictions then they can remove the resource requirements from the [gpu-notebook](./gpu-notebook.yaml)

### Minimal GPU Notebook

The Minimal notebook requires atleast **3GB** of memory while build-time as the minimal notebook installs `jupyterhub`, `jupyterlab` and `jupyter notebook` packages along with the supported extension that requires this much amount of memory.
we have added **4GB** generously to avoid issues.

### TensorFlow GPU Notebook

The TensorFlow notebook requires atleast **6GB** of memory while build-time as the TensorFlow notebook installs `jupyterlab` and `jupyter notebook` supported extension and `jupyterlab build` requires this much  amount of memory.
we have added **6GB** generously to avoid issues.

### PyTorch GPU Notebook

The PyTorch notebook requires atleast **6GB** of memory while build-time as the PyTorch notebook installs `jupyterlab` and `jupyter notebook` supported extension and `jupyterlab build` requires this much  amount of memory.
we have added **6GB** generously to avoid issues.

## Deleting CUDA build objects
All the job and all objects created by the job have the `cuda-version = 11.0.3` label applied.  This label can be used to purge all of the CUDA objects so that the operator can restore the original CUDA build chain

```sh
oc delete build -l cuda-version=11.0.3
oc delete bc -l cuda-version=11.0.3
oc delete is -l cuda-version=11.0.3
oc delete cm -l cuda-version=11.0.3
oc delete job -l cuda-version=11.0.3
```
