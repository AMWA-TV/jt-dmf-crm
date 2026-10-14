# Resource manifests

This project includes example CRM manifests for different media workloads and the schema used to validate them. The files are kept as YAML source so they can be consumed directly by tooling.

## Example manifests

- [Audio resource manifest](manifest/resource_manifest_audio.yaml)
- [Data resource manifest](manifest/resource_manifest_data.yaml)
- [Mixed resource manifest](manifest/resource_manifest_mixed.yaml)
- [Video resource manifest](manifest/resource_manifest_video.yaml)

## Schema

- [Resource manifest schema](manifest/schema/resource_manifest_schema.yaml)

The Python validator is available in the repository as [`manifest/validate_manifest.py`](https://github.com/AMWA-TV/jt-dmf-crm/blob/main/manifest/validate_manifest.py).
