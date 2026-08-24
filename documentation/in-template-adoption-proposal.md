# Proposal: Align This Repository with AMWA IN-TEMPLATE

## Scope and Intent

This proposal describes how to reshape this repository so its governance, documentation, metadata, and CI/CD layout follow the structure used by the AMWA IN-TEMPLATE repository.

The goal is not to force this codebase to become documentation-only, but to make the top-level repository conventionally compatible with AMWA Increment publishing and review workflows.

## Baseline Comparison

### Current top-level state

- Present: README.md, LICENSE, CONTRIBUTE.md, documentation/, example/, lib/, manifest/
- Not present at top-level: .github/workflows docs/lint/render/open_issue, .lint/, .render/, docs/, CONTRIBUTING.md, CHANGELOG.md, NOTICE, spec.yml, zensical.toml
- Documentation currently split across:
  - documentation/JT-DMF-High-Level.pdf
  - lib/mxl/docs/ (inside submodule)

### AMWA IN-TEMPLATE expected top-level shape

- .github/
- .lint/
- .render/
- docs/
- CHANGELOG.md
- CONTRIBUTING.md
- LICENSE
- NOTICE
- README.md
- spec.yml
- zensical.toml

## Recommendation Summary

Adopt a two-layer model:

- Layer 1 (top-level): AMWA Increment document repository layout (template-aligned).
- Layer 2 (project assets): keep implementation and examples under dedicated subdirectories (example/, lib/, manifest/), referenced from docs.

This preserves your current code and submodule strategy while making the repository publishable and reviewable in the same pattern as AMWA Increment docs.

## Proposed Target Structure

```
.
├── .github/
│   ├── scripts/
│   └── workflows/
│       ├── docs.yml
│       ├── lint.yml
│       ├── open_issue.yml
│       └── render.yml
├── .lint/
├── .render/
├── docs/
│   ├── README.md
│   ├── Overview.md
│   ├── Architecture.md
│   ├── Requirements.md
│   ├── ResourceModel.md
│   ├── Conformance.md
│   └── images/
├── CHANGELOG.md
├── CONTRIBUTING.md
├── LICENSE
├── NOTICE
├── README.md
├── spec.yml
├── zensical.toml
├── documentation/
├── example/
├── lib/
└── manifest/
```

## File-by-File Migration Plan

1. Contribution policy file
- Rename CONTRIBUTE.md to CONTRIBUTING.md.
- Rewrite content to match AMWA contribution language (membership, IPR policy, issue/PR expectations).

2. Root metadata and legal files
- Add CHANGELOG.md with AMWA-style short header.
- Add NOTICE using AMWA legal disclaimer text and adjust product naming.
- Keep LICENSE, but decide licensing model for docs:
  - Option A: keep existing project license for code and use per-file doc licensing markers.
  - Option B: adopt template-style top-level doc license statement and move code licenses into subdirectories.

3. README standardization
- Rework README.md to the template format:
  - Title with status
  - Lint/Render badges
  - Intro block with What/Why/How sections
- Add explicit links to implementation assets in lib/, example/, and manifest/.

4. Spec metadata
- Add spec.yml with repository metadata fields:
  - amwa_id
  - url
  - name
  - status
  - repo_name
  - repo_url
  - releases
  - default_branch
  - show_in_index

5. Zensical site config
- Add top-level zensical.toml for docs build.
- Start from AMWA template config, then simplify nav/features to only what this repo needs.

6. Documentation root normalization
- Create top-level docs/ as the canonical authored documentation tree.
- Keep documentation/ as archival/supporting material, not primary spec source.
- Do not directly author canonical Increment docs inside lib/mxl/docs/ because that is in a submodule and can drift from the Increment lifecycle.

7. Lint and render automation
- Add .lint/ and .render/ from the template (including init scripts and Makefiles).
- Add workflows:
  - .github/workflows/lint.yml
  - .github/workflows/render.yml
  - .github/workflows/docs.yml
  - .github/workflows/open_issue.yml

8. Docs publishing scripts
- Add .github/scripts/prepare-docs.sh and upload-site.sh compatible with zensical build and branch/tag behavior.

## Mapping Existing Content into docs/

Recommended initial mapping:

- Existing README summary -> docs/Overview.md intro
- documentation/JT-DMF-High-Level.pdf -> docs/Overview.md as a referenced background artifact
- manifest/schema/resource_manifest_schema.yaml -> docs/ResourceModel.md normative schema section
- manifest/resource_manifest_*.yaml -> docs/ResourceModel.md examples section
- lib/mxl/docs/Architecture.md and related conceptual docs -> selectively imported/summarized into docs/Architecture.md and supporting pages

Important: avoid duplicating large submodule docs verbatim. Prefer concise references plus adapted text that is specific to this Increment.

## CI/CD and Secrets Expectations

To match template workflows, configure repository secrets:

- SSH_HOST
- SSH_USER
- SSH_PRIVATE_KEY
- SSH_KNOWN_HOSTS

Optional based on workflow behavior:

- GITHUB_TOKEN usage for helper script cloning

## Incremental Rollout (Low Risk)

Phase 1: Structural bootstrapping
- Add template files/directories without deleting existing structure.
- Keep current docs and code paths unchanged.

Phase 2: Documentation migration
- Establish docs/ as source of truth.
- Port/adapt key technical content and add navigation.

Phase 3: CI activation
- Enable lint/render/docs workflows.
- Validate generated output and link checks.

Phase 4: Cleanup
- Deprecate or clearly mark legacy doc locations.
- Tighten README and contribution guidance to point only at canonical paths.

## Decision Points Needed from Maintainers

1. AMWA identity fields
- Confirm amwa_id, display name, and publication URL path for spec.yml.

2. Licensing strategy
- Confirm whether docs follow CC terms while code remains under existing software license model.

3. Canonical docs boundary
- Confirm whether any content in lib/mxl/docs/ remains authoritative or is always treated as upstream reference.

4. Publication target
- Confirm whether docs should publish under specs.amwa.tv and under which path.

## Definition of Done

The repository is considered aligned when:

- Top-level file/folder layout matches the IN-TEMPLATE conventions.
- README, CONTRIBUTING, NOTICE, and spec.yml follow AMWA Increment patterns.
- docs/ builds successfully with zensical.
- lint/render/docs workflows pass on main.
- Existing implementation assets remain intact and linked from docs.

## Suggested Next Action

Create a single migration PR that completes Phase 1 only (no content rewrites), then follow with Phase 2 docs-authoring PRs.
