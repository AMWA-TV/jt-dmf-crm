#!/bin/bash

# Create shared memory directory for MXL test
sudo mkdir -p /dev/shm/mxltest
sudo chmod 777 /dev/shm/mxltest

# First test source
docker run -d --rm --mount type=bind,source=/dev/shm/mxltest,target=/dev/shm/mxl --mount type=bind,source=../../lib/mxl/lib/tests/data,target=/home/mxl/flow-configs --name mxl-gst-testsrc1 --entrypoint /usr/bin/mxl-gst-testsrc mxldemo:v1 -v /home/mxl/flow-configs/v210_flow.json --domain /dev/shm/mxl
# Second test source
docker run -d --rm --mount type=bind,source=/dev/shm/mxltest,target=/dev/shm/mxl --mount type=bind,source=../../lib/mxl/lib/tests/data,target=/home/mxl/flow-configs --name mxl-gst-testsrc2 --entrypoint /usr/bin/mxl-gst-testsrc mxldemo:v1 -v /home/mxl/flow-configs/v210_flow_01.json --domain /dev/shm/mxl
# Test sink
docker run -d --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --mount type=bind,source=/dev/shm/mxltest,target=/dev/shm/mxl --mount type=bind,source=../../lib/mxl/lib/tests/data,target=/home/mxl/flow-configs --name mxl-gst-testsink --entrypoint /usr/bin/mxl-gst-sink mxldemo:v1 -v 6fbec3b1-1b0f-417d-9059-8b94a47197ed 5fbec3b1-1b0f-417d-9059-8b94a47197ed --domain /dev/shm/mxl

# Interactive mode for debugging
# docker run --rm -v /dev/shm/mxltest:/dev/shm/mxl --mount type=bind,source=../../lib/mxl/lib/tests/data,target=/home/mxl/flow-configs --name mxl-gst-sinktest -it --entrypoint /bin/bash mxldemo:v1
