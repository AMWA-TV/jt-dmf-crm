
<!-- INTRO-START -->
# JT-DMF Compute Resource Management
The JT-DMF Compute Resource Management (CRM) project provides vendors with a platform-agnostic way to declare the resources required by a Media Function.
A CRM manifest describes the compute, memory, storage, networking, accelerator, and other infrastructure resources that a Media Function needs to operate safely and predictably. The manifest is independent of any specific hardware platform, cloud provider, container runtime, or orchestration technology.
## Architecture & System Model
CRM links design-time resource specification with runtime orchestration, deployment, and operational monitoring across four primary architectural tiers as presented in the [JT-DMF-High-Level.pdf](./documentation/JT-DMF-High-Level.pdf):

**Application and UI Tier:** High-level Media Workloads composed of one or more modular Applications.

**Media Functions Tier:** Standardizes core logic into discrete Media Functions. Defines the overall **Media Function Descriptor** and the primary **Manifests Schema** (the contract definition).

**Container Platform Tier:** Receives active **Manifests** consumed by dedicated **Operator(s)** to instantiate the **Media Processing Workload**. As the workload executes, it emits **Media Function Metrics** to monitor real-time performance.

**Host Platform Tier:** Exposes underlying physical hardware capabilities via **System Specifications** to inform scheduling decisions.

**Orchestration & Monitoring:** Cross-tier services responsible for evaluating host specifications against manifest requirements, selecting execution environments, and tracking runtime metrics.

## Purpose of This Repository
The purpose of this repository is to define and demonstrate a standardized approach for creating and using CRM manifests throughout the lifecycle of a Media Function.
It provides examples and guidance for:
1. **Profiling a Media Function**  
   Observing how the Media Function uses compute, memory, storage, network bandwidth, and specialized hardware resources under representative operating conditions.
2. **Benchmarking its performance**  
   Measuring the relationship between allocated resources, workload characteristics, performance, and operational limits.
3. **Producing a CRM manifest**  
   Translating the profiling and benchmarking results into a portable, machine-readable declaration of the resources required by the Media Function.
4. **Deploying the Media Function**  
   Demonstrating how an orchestration layer can consume the manifest, evaluate available infrastructure, select an appropriate execution environment, and deploy the Media Function with the required resources.
## Intended Workflow
The repository supports the following workflow:
```text
Media Function
      |
      v
Profile and Benchmark
      |
      v
Determine Resource Requirements
      |
      v
Produce CRM Manifest
      |
      v
Orchestration Layer
      |
      v
Validate, Place, and Deploy
      |
      v
Monitoring
```
This approach allows resource requirements to be based on measured behavior rather than assumptions or platform-specific deployment configurations.
## Benefits
Using a standardized CRM manifest enables:
- Vendors to describe resource requirements independently of the target platform.
- Orchestrators to make informed placement and scheduling decisions.
- Media Functions to be deployed consistently across heterogeneous infrastructure.
- Infrastructure providers to validate resource availability before deployment.
- Operators to achieve more predictable performance and resource utilization.
- The media industry to improve interoperability between Media Functions, platforms, and orchestration systems.
## Scope
This repository contains:
- CRM manifest definitions and supporting models.
- Example resource manifests for Media Functions.
- Examples of profiling and benchmarking methodologies.
- Guidance for translating benchmark results into resource declarations.
- Examples showing how an orchestration layer can consume a CRM manifest.
- Demonstrations of manifest-based validation, placement, and deployment.
The CRM manifest does not prescribe how an orchestration platform must be implemented. Instead, it provides a common resource description that different orchestration systems can interpret and map to their own infrastructure and deployment models.
<!-- INTRO-END -->
## Repository Layout

- documentation/: Supporting/legacy background material.
- manifest/: Resource manifests and schema.
- lib/: Code and submodules, including lib/mxl.
- example/: Runtime examples and deployment assets.
