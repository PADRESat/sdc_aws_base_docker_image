ARG IMAGE_PLATFORM=linux/amd64
FROM --platform=$IMAGE_PLATFORM public.ecr.aws/lts/ubuntu:24.04

# Performs updates and installs git, unzip, python3.8, python3-pip, python3.8-dev and pylint packages
# Line 13 is required by the spacepy Python package
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install --no-install-recommends -y python3-full python3-pip pylint git wget unzip make && \
    ln -s /usr/bin/python3 /usr/bin/python

# For sphinx to build in the container
ENV LC_ALL=C
# REQUIRED for Ubuntu 24.04+: Allows pip to install globally despite PEP 668
ENV PIP_BREAK_SYSTEM_PACKAGES=1

# Copy Python requirements.txt file into image (list of common dependencies)
COPY requirements.txt  .

# Copy test scripts
COPY /container-tests  /container-tests

# Upgrade pip
RUN  python3 -m pip install --upgrade --ignore-installed pip 

# To fix spacepy dependency issue
RUN  python3 -m pip install --upgrade --force-reinstall setuptools setuptools_scm

# Install Python dependencies defined in requirements
RUN  python3 -m pip install -r requirements.txt

# User to run the container
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# FIX: Delete default 'ubuntu' user (UID 1000) introduced in Ubuntu 24.04 to prevent conflict
RUN userdel -r ubuntu || true \ 
    # Create the user
    && groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    # Add sudo support for the non-root user
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME