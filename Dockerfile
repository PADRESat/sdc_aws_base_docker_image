ARG PLATFORM=linux/amd64
FROM --platform=$PLATFORM public.ecr.aws/lts/ubuntu:24.04_stable

# Set noninteractive frontend just for the build process
ARG DEBIAN_FRONTEND=noninteractive

# Performs updates and installs git, unzip, python3.12, python3-pip, python3.12-dev and pylint packages
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install --no-install-recommends -y \
    python3-pip \
    python3-venv \
    pylint \
    git \
    wget \
    unzip \
    make \
    cmake \
    build-essential \
    libcurl4-openssl-dev \
    autoconf \
    automake \
    libtool && \
    ln -s /usr/bin/python3 /usr/bin/python

# For sphinx to build in the container
ENV LC_ALL=C

# Copy Python requirements.txt file into image (list of common dependencies)
COPY requirements.txt  .

# Copy test scripts
COPY /container-tests  /container-tests

# Create a virtual environment
RUN python3 -m venv /opt/venv

# Make sure we use the virtualenv Python and pip by updating the PATH
ENV PATH="/opt/venv/bin:$PATH"

# Upgrade pip
RUN  python3 -m pip install --upgrade pip

# To fix spacepy dependency issue
RUN  python3 -m pip install --upgrade --force-reinstall setuptools==59.5.0 setuptools_scm==6.3.2

# Install Python dependencies defined in requirements
RUN  python3 -m pip install -r requirements.txt

# User to run the container
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Delete the default 'ubuntu' user and group if they exist.
# This is a new add in Ubuntu 24.04
# Create the user
RUN (userdel -r ubuntu || true) \
    && groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    # Add sudo support for the non-root user
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME