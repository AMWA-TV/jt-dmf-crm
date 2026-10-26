# JT-DMF CRM repository instructions

## Repository shape

This repository is the source for AMWA IN-003, a work-in-progress description of
compute, memory, storage, network, and accelerator requirements for Media
Functions. The main deliverables are:

- `manifest/`: the YAML resource-manifest examples and their Draft-07 schema.
- `docs/`: the CRM architecture, lifecycle, domain model, and deployment
  guidance. `zensical.toml` configures the documentation site.
- `examples/`: deployment demonstrations. The Riedel demo shows a small
  Kubernetes/DRA deployment; `Media-Transport-Library` is a pinned submodule
  containing the larger profiling and benchmarking reference recipe.
- `lib/mxl/`: the pinned MXL implementation submodule used by the examples.

The intended flow is profile and benchmark a Media Function, translate measured
requirements into a CRM manifest, validate it against the schema, then use an
orchestrator to place and deploy it. CRM describes the resource contract; it
does not prescribe a particular orchestrator implementation.

Do not treat benchmark numbers in the examples as universal requirements. They
are evidence from a platform-specific reference workflow.

## Build, validation, and CI commands

### Manifest validation

The root project has no package manager or root application build. Validate an
individual manifest with Python 3 and the `pyyaml` and `jsonschema` packages:

```bash
python3 -m pip install pyyaml jsonschema
python3 manifest/validate_manifest.py manifest/resource_manifest_video.yaml
python3 manifest/validate_manifest.py manifest/resource_manifest_video.yaml --verbose
python3 manifest/validate_manifest.py path/to/manifest.yaml --schema path/to/resource_manifest_schema.yaml
```

The validator uses `manifest/schema/resource_manifest_schema.yaml` by default,
reports every schema error, and returns a non-zero status on invalid YAML,
missing files, or validation failure. When changing the schema, run it against
all four checked-in examples:

```bash
for f in manifest/resource_manifest_*.yaml; do
  python3 manifest/validate_manifest.py "$f" || exit 1
done
```

### Lint and documentation

The required root lint job is defined in `.github/workflows/lint.yml` and runs
the NMOS linter container:

```bash
docker run --rm -v "$PWD:/workspace" -w /workspace amwa/nmos-lint:latest
```

GitHub Actions is authoritative if the local container invocation differs from
the workflow environment. `.lint/Makefile` is the repository's optional helper
for installing the shared NMOS lint scripts (`make -C .lint build-tools`) and
cleaning them (`make -C .lint distclean`); it is not the lint workflow itself.

Documentation publishing is handled by the reusable
`AMWA-TV/amwa-spec-docs` workflow in `.github/workflows/docs.yml`. Edit the
Markdown under `docs/` and the root `zensical.toml`; do not edit the generated
`site/` output as the source of truth.

### Submodules

Initialize the exact revisions recorded by this repository before working on
the demos or MXL:

```bash
git submodule update --init --recursive
```

For `lib/mxl`, use its `docs/Building.md` and nested agent instructions. Its
CMake presets include `Linux-GCC-Debug`, `Linux-GCC-Release`,
`Linux-Clang-Debug`, `Linux-Clang-Release`, `Darwin-Clang-Debug`, and
`Darwin-Clang-Release`; a typical build is:

```bash
cmake -S lib/mxl -B lib/mxl/build/Linux-GCC-Debug \
  --preset Linux-GCC-Debug
cmake --build lib/mxl/build/Linux-GCC-Debug --target all
ctest --test-dir lib/mxl/build/Linux-GCC-Debug --output-on-failure
ctest --test-dir lib/mxl/build/Linux-GCC-Debug -R 'test-name' --output-on-failure
```

The MXL build has external C++, GStreamer, and optional fabric dependencies.
Do not change submodule contents from the root repository unless the task
explicitly includes a submodule change.

The `Media-Transport-Library` submodule has its own
`.github/copilot-instructions.md` and `.github/claude/CLAUDE.md`; follow those
instructions for its C/C++, Kubernetes, profiling, and CI work. Its focused
Python test commands are:

```bash
cd examples/Media-Transport-Library
make test
./.venv/bin/python -m pytest -q tests/test_cli.py::test_name
```

Use the actual pytest node id from `pytest --collect-only -q` when selecting a
single test.

## Conventions specific to this repository

- Keep the manifest schema and examples synchronized. New or changed manifest
  fields should be represented in `manifest/schema/resource_manifest_schema.yaml`
  and exercised by at least one example.
- Manifest API versions must follow the schema pattern
  `mxl.media.fn/v<digits><lowercase letters><digits>`, and the resource kind is
  `MxlMediaFunctionParameters`.
- Resource quantities use the schema's Kubernetes-like formats: CPU values such
  as `500m` or `2`, and memory sizes such as `512Mi` or `2Gi`. Preserve the
  distinction between declared requirements and `host_capabilities`.
- Keep the architecture narrative consistent across `README.md`,
  `docs/Overview.md`, the schema, examples, and deployment YAML. The four
  architectural tiers are application/UI, Media Functions, container platform,
  and host platform, connected by orchestration and monitoring.
- Kubernetes manifests in examples demonstrate consumption of CRM data; they
  are examples, not a second schema implementation. Prefer updating the
  canonical CRM manifest/schema and then wiring examples to it.
- This is an AMWA Increment and intentionally evolves. Avoid presenting
  draft behavior as a finalized specification; update `CHANGELOG.md` when a
  meaningful public model or example behavior changes.
- Preserve submodule pointers in the superproject. Changes inside a submodule
  belong in that submodule's repository and should be recorded here only as a
  deliberate pointer update.
- Follow the repository's existing SPDX/license-header conventions when adding
  source or documentation files, and retain existing copyright/license text.
