# Python to ELF Builder for Endless Cloud

A simple tool to package Python projects into Linux ELF executables for Endless Cloud Components.

## Usage

### Using Docker

1. Clone the repository and run the build script:
```shell
./build.sh
```

2. Test the executable:
```shell
./run.sh
```

### Without Docker (Ubuntu 22.04/24.04)

1. Install Nuitka:
```shell
pip install nuitka
```

2. Build the executable:
```shell
python -m nuitka --standalone
--onefile
--include-module=main
--follow-imports
--follow-stdlib
--assume-yes-for-downloads
--enable-plugin=anti-bloat
main.py
```

The build process will generate `main.bin`, which is a standalone Linux ELF executable that can be deployed to Endless Cloud Components.