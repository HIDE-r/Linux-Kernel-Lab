# ARM64 Linux Kernel Test Environment

This project provides a Docker-based environment for compiling the Linux kernel. It simplifies the setup process by providing a pre-configured Docker image with all the necessary tools and dependencies.

## Prerequisites

- Docker
- direnv (optional, for managing environment variables)

## Getting Started

### 1. Configure Environment

This project uses a `.envrc` file to manage environment variables. You can either use `direnv` to load it automatically, or source it manually.

Create a `.envrc` file in the project root with the following content.

```bash
export ARCH=arm64
export DOCKER_IAMGE=kernel_${ARCH}
export PROJECT_DIR_PATH="$PWD"
export DOCKERFILE=docker/Dockerfile
export DOCKER_ENV_FILE=docker/docker_${ARCH}.env
```

If you are using `direnv`, run `direnv allow` to load the environment variables.

### 2. Build the Docker Image

The Docker image contains all the necessary dependencies for building the kernel. The `scripts/docker_run.sh` script will automatically build the image for you if it doesn't exist.

To manually build the image:

```shell
docker build -t arm64-kernel-builder -f docker/Dockerfile .
```

### 3. Build the Kernel

To build the kernel, simply run the following command. The `scripts/docker_run.sh` script will execute the build process inside the Docker container.

```shell
./scripts/docker_run.sh make -C linux -j$(nproc)
```

This command will:
1. Start a Docker container using the `arm64-kernel-builder` image.
2. Mount the project directory into the container.
3. Execute the `make` command inside the `linux` directory to build the kernel.

### 4. Enter the Docker Environment

You can also get an interactive shell inside the container for debugging or running other commands:

```shell
./scripts/docker_run.sh
```

## Project Structure

- `linux/`: Contains the Linux kernel source code.
- `busybox/`: Contains the BusyBox source code, which provides a lightweight set of common Unix utilities.
- `docker/`: Contains the `Dockerfile` for building the development environment.
- `scripts/`: Contains helper scripts for building and running the environment.
