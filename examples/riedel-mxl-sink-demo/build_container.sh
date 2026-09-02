#!/bin/bash

cd ../../lib/mxl && docker build --network=host -t mxldemo:v1 -f examples/Dockerfile .