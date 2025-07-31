#!/bin/bash

echo "Analyzing dependencies..."

# Generate requirements.txt
if [ ! -f requirements.txt ]; then
    echo "Generating requirements.txt..."
    pip install pipreqs
    pipreqs . --force
fi

echo "Found dependencies:"
cat requirements.txt

# Build Docker image
echo "Building with Docker..."
docker build --platform linux/amd64 -t endless-cloud-elf-builder -f - . << 'EOF'
FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y python3 python3-pip gcc g++ build-essential patchelf
RUN ln -sf /usr/bin/python3 /usr/bin/python && ln -sf /usr/bin/pip3 /usr/bin/pip
RUN pip install nuitka
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD python -m nuitka --standalone --onefile --include-module=main --follow-imports --follow-stdlib --assume-yes-for-downloads --enable-plugin=anti-bloat main.py
EOF

# Run build
docker run --rm -v $(pwd):/app endless-cloud-elf-builder

if [ -f "main.bin" ]; then
    echo "Build successful! Generated: main.bin"
    file main.bin
else
    echo "Build failed!"
fi