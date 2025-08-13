#!/bin/bash

docker run --platform linux/amd64 --rm -it -v $(pwd):/app -w /app -p 8000:8000 ubuntu:24.04 ./main.bin
