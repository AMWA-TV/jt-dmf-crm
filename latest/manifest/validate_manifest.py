#!/usr/bin/env python3
"""
YAML Schema Validator for MXL Media Function Resource Manifests

This script validates YAML files against the MXL Media Function Parameters schema.
It uses jsonschema for validation since JSON Schema is widely supported.

Usage:
    python validate_manifest.py <yaml_file>
    python validate_manifest.py manifest/resource_manifest_video.yaml

Requirements:
    pip install pyyaml jsonschema
"""

import sys
import argparse
from pathlib import Path
import yaml
from jsonschema import validate, ValidationError, Draft7Validator
from typing import Dict, Any


def load_yaml_file(file_path: Path) -> Dict[Any, Any]:
    """Load and parse a YAML file."""
    try:
        with open(file_path, 'r') as f:
            data = yaml.safe_load(f)
        return data
    except yaml.YAMLError as e:
        print(f"Error parsing YAML file: {e}")
        sys.exit(1)
    except FileNotFoundError:
        print(f"Error: File not found: {file_path}")
        sys.exit(1)


def load_schema(schema_path: Path) -> Dict[Any, Any]:
    """Load the JSON/YAML schema."""
    return load_yaml_file(schema_path)


def validate_manifest(manifest_data: Dict[Any, Any], schema: Dict[Any, Any]) -> bool:
    """
    Validate the manifest data against the schema.

    Returns:
        True if validation succeeds, False otherwise
    """
    try:
        # Create a validator instance for better error reporting
        validator = Draft7Validator(schema)

        # Check if the manifest is valid
        errors = list(validator.iter_errors(manifest_data))

        if errors:
            print("❌ Validation failed with the following errors:\n")
            for i, error in enumerate(errors, 1):
                print(f"Error {i}:")
                print(f"  Path: {' -> '.join(str(p) for p in error.path)}")
                print(f"  Message: {error.message}")
                if error.context:
                    print(f"  Context: {error.context}")
                print()
            return False
        else:
            print("✅ Validation successful! The manifest conforms to the schema.")
            return True

    except ValidationError as e:
        print(f"❌ Validation error: {e.message}")
        print(f"   Path: {' -> '.join(str(p) for p in e.path)}")
        return False


def print_manifest_summary(manifest_data: Dict[Any, Any]) -> None:
    """Print a summary of the validated manifest."""
    print("\n" + "="*60)
    print("Manifest Summary")
    print("="*60)

    if 'metadata' in manifest_data:
        print(f"Name: {manifest_data['metadata'].get('name', 'N/A')}")
        print(f"Namespace: {manifest_data['metadata'].get('namespace', 'N/A')}")

    if 'spec' in manifest_data:
        spec = manifest_data['spec']
        print(f"Role: {spec.get('role', 'N/A')}")

        if 'inputs' in spec:
            print(f"Number of inputs: {len(spec['inputs'])}")

        if 'outputs' in spec:
            print(f"Number of outputs: {len(spec['outputs'])}")

        if 'requirements' in spec:
            req = spec['requirements']
            if 'cpu' in req:
                print(f"CPU requirement: {req['cpu'].get('cpu', 'N/A')}")
            if 'memory' in req and len(req['memory']) > 0:
                print(f"Memory requirement: {req['memory'][0].get('size', 'N/A')}")

    print("="*60)


def main():
    """Main function to run the validation."""
    parser = argparse.ArgumentParser(
        description='Validate MXL Media Function resource manifest YAML files',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s manifest/resource_manifest_video.yaml
  %(prog)s manifest/resource_manifest_audio.yaml --schema custom_schema.yaml
  %(prog)s manifest/resource_manifest_data.yaml --verbose
        """
    )

    parser.add_argument(
        'manifest',
        type=Path,
        help='Path to the manifest YAML file to validate'
    )

    parser.add_argument(
        '-s', '--schema',
        type=Path,
        default=None,
        help='Path to the schema file (default: schema/resource_manifest_schema.yaml in the same directory as manifest)'
    )

    parser.add_argument(
        '-v', '--verbose',
        action='store_true',
        help='Print detailed manifest summary after validation'
    )

    args = parser.parse_args()

    # Determine schema path
    if args.schema:
        schema_path = args.schema
    else:
        # Default to schema in the same directory as the manifest
        schema_path = Path(__file__).parent / 'schema' / 'resource_manifest_schema.yaml'

    # Check if schema file exists
    if not schema_path.exists():
        print(f"Error: Schema file not found: {schema_path}")
        print("Please specify the schema file using --schema option")
        sys.exit(1)

    # Load files
    print(f"Loading manifest: {args.manifest}")
    manifest_data = load_yaml_file(args.manifest)

    print(f"Loading schema: {schema_path}")
    schema = load_schema(schema_path)

    print("\nValidating manifest...\n")

    # Validate
    is_valid = validate_manifest(manifest_data, schema)

    # Print summary if requested
    if args.verbose and is_valid:
        print_manifest_summary(manifest_data)

    # Exit with appropriate code
    sys.exit(0 if is_valid else 1)


if __name__ == '__main__':
    main()
