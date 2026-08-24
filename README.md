The Joint Taskforce on Dynamic Media Facility (JT-DMF) - Compute Resource Management (CRM) is one of the 4 workstreams.

Compute Resource Management in JT-DMF focuses on how a Media Function declare compute resource it needs to run safely.

## Manifest Hierarchy

The JT-DMF CRM uses manifests to declare compute resource requirements for media functions. The system supports both simple single-manifest deployments and more complex multi-profile configurations:

### Resource Manifests (`MxlMediaFunctionParameters`)
Resource manifests are the core component that define the detailed specifications for media functions, including:

- **Media I/O Specifications**: Input and output media characteristics (type, format, resolution, frame rate)
- **Compute Requirements**: CPU limits, CPU class, and memory requirements
- **Timing Constraints**: Latency budgets for processing media units
- **Reference Platform**: Host platform capabilities including CPU generation, network bandwidth, and GPU specifications

For simple deployments, a single resource manifest is sufficient to declare all compute requirements.

### Parent Manifest (`MediaFunctionManifestParent`) - Optional
When multiple workload profiles are needed, an **optional** parent manifest can be used to orchestrate different resource configurations. Located in `manifest/manifest_parent.yaml`, it includes:

- **Workload Profiles**: Named configurations that map processing scenarios (e.g., `4k_processing`, `3g_processing`, `standard_processing`) to specific resource manifests
- **Resource Manifest References**: Each profile references a dedicated resource manifest that defines the compute requirements for that scenario
- **Fallback Manifest**: A default resource manifest used when no workload profile matches the current scenario

### Configuration Patterns

**Simple Deployment** (single resource manifest):
```
resource_manifest.yaml
```

**Multi-Profile Deployment** (with optional parent manifest):
```
Parent Manifest (manifest_parent.yaml)
├── workload_profiles
│   ├── 4k_processing → resource_manifest_4k.yaml
│   ├── 3g_processing → resource_manifest_3g.yaml
│   └── standard_processing → resource_manifest_hd.yaml
└── fallback_manifest → resource_manifest_default.yaml
```

The parent manifest enables flexible resource allocation by allowing the system to select appropriate compute configurations based on the media processing scenario at runtime.
