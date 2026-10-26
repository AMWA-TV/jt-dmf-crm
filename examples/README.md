# Examples

These examples show two complementary ways to deploy and evaluate a JT-DMF MediaFunction on Kubernetes.

## Riedel MXL sink demo

[riedel-mxl-sink-demo](riedel-mxl-sink-demo/HOWTO.md)

A small, practical deployment example based on the Riedel MXL sink workflow. Use it to understand the basic container, media-flow and Kubernetes resource setup. It is intended as the quickest path to a working demonstration.

## MXL Kubernetes CRM reference

[Media-Transport-Library](Media-Transport-Library/README.md)

A profiling and benchmarking workflow for an FFmpeg/MXL Media Function. It measures CPU usage, NUMA placement, memory bandwidth, cache behavior, stream density and noisy-neighbor effects, then uses those results to produce and validate a JT-DMF CRM manifest.

This example complements the sink demo: the sink demo shows a minimal deployment, while the CRM reference shows how measured workload behavior can inform resource requirements and deployment decisions. The benchmark results are platform-specific and are provided as evidence, not as universal CRM requirements.
