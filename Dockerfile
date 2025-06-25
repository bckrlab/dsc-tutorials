FROM debian:stable-slim
# For CUDA support
# FROM nvidia/cuda:12.9.1-cudnn-runtime-ubuntu24.04


# install basic utilities and clean up afterward
RUN apt-get update --allow-releaseinfo-change && \
    apt-get upgrade -y && \
    apt-get -y install --no-install-recommends \
        procps wget curl ca-certificates unzip bzip2 git openssh-client vim tmux build-essential && \
    apt-get -y autoremove && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# install micromamba as root
ENV MAMBA_ROOT_PREFIX=/root/micromamba
RUN curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest | tar -xvj -C /usr/bin --strip-components=1 bin/micromamba \
    && micromamba shell init -s bash --root-prefix ${MAMBA_ROOT_PREFIX}

# copy and install environment
COPY environment.yml /tmp/environment.yml
RUN micromamba create -n dev -f /tmp/environment.yml && micromamba clean --all --yes
ENV CONDA_DEFAULT_ENV=dev

# run commands in mamba env during docker build
ENV MAMBA_DOCKERFILE_ACTIVATE=1

# activate dev environment on default
# ENV PATH="${MAMBA_ROOT_PREFIX}/envs/dev/bin:$PATH"
RUN echo "alias mima=micromamba" >> /root/.bashrc
RUN echo "micromamba activate dev" >> /root/.bashrc

# expose mlflow, tensorboard, jupyter
EXPOSE 5000 6006 8888

WORKDIR /workspace

HEALTHCHECK CMD [ "micromamba", "--version" ]
