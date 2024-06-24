# Image: Ubuntu 20.04 Stable, Official Image from Canonical
FROM public.ecr.aws/lts/ubuntu:22.04_stable

# Performs updates and installs git, unzip, python3.8, python3-pip, python3.8-dev and pylint packages
# Line 13 is required by the spacepy Python package
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install --no-install-recommends -y python3-pip pylint git wget unzip make && \
    ln -s /usr/bin/python3 /usr/bin/python

# Download Pre-Built CDF Binaries - Version: cdf39_0-dist-cdf
RUN wget https://sdc-aws-support.s3.amazonaws.com/cdf-binaries/cdf39_0-dist-cdf.zip

# Unzip CDF Binaries and move to /usr/local/cdf
RUN unzip cdf39_0-dist-cdf.zip && mv cdf /usr/local/

# For CDF Binaries in path
ENV PATH="${PATH}:/usr/local/cdf/bin"

# For sphinx to build in the container
ENV LC_ALL=C

# Copy Python requirements.txt file into image (list of common dependencies)
COPY requirements.txt  .

# Copy test scripts
COPY /container-tests  /container-tests

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

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    #
    # Add sudo support for the non-root user
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Copy over config.yml in tmp dir
COPY config.yml /tmp
RUN chmod 777 /tmp/config.yml

# Add environment variables to pick up swxsoc core config
ENV SWXSOC_CONFIGDIR=/tmp