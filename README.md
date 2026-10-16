# \[Work In Progress\] AMWA IN-003: Compute Resource Management Manifest and Examples

[![Lint Status](https://github.com/AMWA-TV/in-003/actions/workflows/lint.yml/badge.svg)](https://github.com/AMWA-TV/in-003/actions/workflows/lint.yml)
[![Zensical Render Status](https://github.com/AMWA-TV/in-003/actions/workflows/docs.yml/badge.svg)](https://github.com/AMWA-TV/in-003/actions/workflows/docs.yml)
[![License](https://img.shields.io/github/license/AMWA-TV/in-003)](https://github.com/AMWA-TV/in-003/blob/HEAD/LICENSE)
[![Issues](https://img.shields.io/github/issues/AMWA-TV/in-003)](https://github.com/AMWA-TV/in-003/issues)

This repository holds the source of a work artifact published as an **AMWA Increment (IN)** from the [Advanced Media Workflow Association](https://amwa.tv)

<!-- INTRO-START -->

### What does it do?

- Defines a common, platform-agnostic description of the compute, memory, storage, network, and accelerator resources required by a Media Function.
- Provides a manifest schema and working examples for expressing those resource requirements in a portable way.
- Connects profiling, benchmarking, and deployment workflows into a repeatable CRM process.

### Why does it matter?

- Media Function workloads need predictable resource allocation across heterogeneous infrastructure.
- A standardized manifest helps orchestration systems place workloads accurately and validate resource availability.
- It enables consistent, interoperable resource declarations across vendor implementations and deployment environments.

### How does it work?

- The repository defines a resource manifest model and example payloads for Media Functions.
- It shows how profiling and benchmarking results can be translated into portable declarations of required resources.
- The resulting manifests can be consumed by orchestration and deployment systems to validate placement and scheduling decisions.

This work artifact is published as an **AMWA Increment (IN)**. Increments are intended to make public the ongoing progress of a working group without locking decisions into a formal specification. While the technical details contained in this repository do not constitute a stable or finalized specification, readers should note that Increments are Draft Specifications as defined in the AMWA IPR Policy. The provisions of the policy apply, including the requirement for early disclosure. You can expect the content to evolve incrementally based on ongoing testing, consensus-building, and community input. Public review is encouraged! Please post an Issue to the Repo to submit questions, feedback, or propose changes.

<!-- INTRO-END -->

## Repository Layout

- documentation/: Supporting background material.
- manifest/: Resource manifests and schema.
- lib/: Code and submodules, including lib/mxl.
- examples/: Runtime examples and deployment assets.
