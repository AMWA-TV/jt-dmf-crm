# MXL Sink Demo HOWTO

## Goal of This Example

This example shows how to derive a media-function resource manifest from host benchmarking and application profiling data, then use that information in a Kubernetes deployment.

The workflow demonstrated in this directory is:

1. Benchmark the reference host to capture capabilities such as CPU topology, installed memory, and memory throughput.
2. Profile the `mxl-gst-sink` media function on that host to measure its CPU, memory, and memory-throughput requirements.
3. Convert those measurements into a media-function resource manifest, such as `manifest/resource_manifest_mxl_sink.yaml`.
4. Use a Kubernetes example with Dynamic Resource Allocation (DRA) to translate the manifest into standard pod resource requests plus a custom memory-throughput resource claim.

In short, the goal is to show how benchmark and profiling data can be turned into a YAML resource manifest and then consumed by a Kubernetes deployment for placement and resource allocation.

This document describes how to build the MXL container image, prepare the benchmarking environment, deploy the demo on a kind cluster with the memory-throughput DRA driver, and profile the running application.


## Requirements

- Kind : https://kind.sigs.k8s.io/
- helm : https://helm.sh/docs/intro/install/
- Kuberntes v1.35 or greater
- kubectl : https://kubernetes.io/docs/tasks/tools/

## 1. Benchmark the Host Machine

### 1.1 CPU Information

Collect CPU details:

```bash
lscpu
```

### 1.2 Memory Capacity

Collect memory topology and installed DIMM information:

```bash
lsmem
sudo dmidecode --type memory
```

### 1.3 Memory Throughput with Intel MLC

Download Intel MLC:

[Intel MLC Download](https://www.intel.com/content/www/us/en/developer/articles/tool/intelr-memory-latency-checker.html)

Install the software:

```bash
mkdir mlc
tar -xvf mlc_v3.12.tgz -C ./mlc
```

Run the memory throughput test:

```bash
cd mlc/Linux
./mlc
```

## 2. Build the MXL Container Image

Clone the repository and build the demo image:

```bash
git clone --recursive https://github.com/AMWA-TV/jt-dmf-crm.git
cd jt-dmf-crm
## Ensure to checkout the right branch here for the demo.
cd lib/mxl
docker build --network=host -t mxldemo:v1 -f examples/Dockerfile .
```

## 3. Prepare the kind Cluster and DRA Driver


### 3.1 Clone the DRA Driver Repository

```bash
git clone -b fork/main https://github.com/dtrembl/mem-throughput-dra-driver.git
cd mem-throughput-dra-driver
```

### 3.2 Build the DRA Driver Image

Run this step only if the driver image is not already available:

```bash
./demo/build-driver.sh
```

### 3.3 Start the kind Kubernetes Cluster

```bash
./demo/clusters/kind/create-cluster.sh
```

### 3.4 Activate the DRA Driver

```bash
helm upgrade -i \
  --create-namespace \
  --namespace dra-memory-driver \
  dra-memory-driver \
  deployments/helm/dra-memory-driver
```

## 4. Start the MXL DRA Demo

### 4.1 Copy the Flow Configuration to the Worker Node

```bash
cd <DEMO_DIR>/jt-dmf-crm
docker cp lib/mxl/lib/tests/data dra-memory-driver-cluster-worker:/root
```

### 4.2 Load the Container Image into the Worker Node

```bash
kind load docker-image mxldemo:v1 --name dra-memory-driver-cluster
```

### 4.3 Create the Shared Memory Directory

Create the `/dev/shm/mxl` directory and allow all users to write to it:

```bash
docker exec dra-memory-driver-cluster-worker sh -c "cd /dev/shm && mkdir mxl && chmod 777 mxl"
```

### 4.4 Useful Demo Commands

Start the demo:

```bash
cd <DEMO_DIR>/jt-dmf-crm/example/riedel-mxl-sink-demo/kubernetes/
kubectl apply --filename=kubernetes_mxl_player.yaml
kubectl apply --filename=kubernetes_mxl_sink.yaml
```

Delete the demo:

```bash
cd <DEMO_DIR>/jt-dmf-crm/example/riedel-mxl-sink-demo/kubernetes/
kubectl delete --filename=kubernetes_mxl_player.yaml
kubectl delete --filename=kubernetes_mxl_sink.yaml
```

Delete the kind cluster when you are done:

```bash
cd <DEMO_DIR>/mem-throughput-dra-driver
./demo/clusters/kind/delete-cluster.sh
```

## 5. Profile the Application

Before profiling, start the demo by following the commands in the previous section.

### 5.1 CPU Profiling

```bash
sudo perf stat -p $(ps aux | grep '[m]xl-gst-sink' | awk '{print $2}')
```

### 5.2 Memory Usage Profiling

```bash
cat /proc/$(ps aux | grep '[m]xl-gst-sink' | awk '{print $2}')/status
```

### 5.3 Memory Throughput with Intel PCM

Set up Intel PCM:

```bash
git clone --recursive https://github.com/intel/pcm.git
cd pcm
mkdir build
cd build
cmake ..
cmake --build .
sudo modprobe msr
```

Measure throughput with `mxl-sink` running:

```bash
./bin/pcm-memory -i=10 -csv
```

Stop `mxl-sink` and run the measurement again with the producers only:

```bash
kubectl delete --filename=<DEMO_DIR>/jt-dmf-crm/example/riedel-mxl-sink-demo/kubernetes/kubernetes_mxl_sink.yaml
./bin/pcm-memory -i=10 -csv
```

