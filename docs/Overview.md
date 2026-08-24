# JT-DMF Compute Resource Management Overview

## Purpose

This repository captures the JT-DMF Compute Resource Management (CRM) workstream and aligns its top-level structure with AMWA Increment conventions.

## Scope

- Documentation source for Increment-style publishing lives in this docs/ directory.
- Supporting manifests and schema are in manifest/.
- Implementation-related content and upstream dependencies are in lib/.
- Deployment and runnable examples are in example/.

## Current State

The Phase 1 migration establishes template-compatible scaffolding:

- CI workflows for lint/render/docs.
- Rendering support in .render/.
- Lint support in .lint/.
- Repository metadata via spec.yml and zensical.toml.

## Next Documentation Steps

- Expand this docs/ tree with architecture, requirements, and conformance pages.
- Integrate key schema and manifest references from manifest/.
- Keep documentation in this directory as the canonical authored source.
