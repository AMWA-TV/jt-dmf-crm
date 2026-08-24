# \[Work In Progress\] JT-DMF CRM Increment Repository

[![Lint Status](https://github.com/sviengkhou/jt-dmf-crm/workflows/Lint/badge.svg)](https://github.com/sviengkhou/jt-dmf-crm/actions?query=workflow%3ALint)
[![Render Status](https://github.com/sviengkhou/jt-dmf-crm/workflows/Render/badge.svg)](https://github.com/sviengkhou/jt-dmf-crm/actions?query=workflow%3ARender)

This repository holds source material for the JT-DMF Compute Resource Management (CRM) workstream, aligned to the AMWA Increment documentation template.

<!-- INTRO-START -->

### What does it do?

- Defines and documents Compute Resource Management concepts for JT-DMF.
- Provides draft Increment-style documentation under docs/.
- Includes supporting implementation and examples under lib/, manifest/, and example/.

### Why does it matter?

- CRM is required to declare the compute resources a Media Function needs to run safely.
- A template-aligned structure improves consistency, review quality, and publication readiness.
- CI-based lint/render workflows help maintain documentation quality over time.

### How does it work?

- Increment-oriented documentation is authored in docs/.
- Metadata and publication settings are defined in spec.yml and zensical.toml.
- Workflows in .github/workflows run linting and rendering pipelines.

<!-- INTRO-END -->

## Repository Layout

- docs/: Canonical Increment documentation source.
- documentation/: Supporting/legacy background material.
- manifest/: Resource manifests and schema.
- lib/: Code and submodules, including lib/mxl.
- example/: Runtime examples and deployment assets.
