# Docker Lambda Base Image Repository

| **CodeBuild Status** |![aws build status](https://codebuild.us-east-2.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoieGwxQ2UvcUxkRHRDNldsa2RPVWN0eEo3YjU3VUw3Ym50eUlBV0Y1c29qTFZLcUI0RjV1djBpTmN1dGMySWZsYjAyQ0lDWmtMVXIwSFlKTG9GaGtRMU40PSIsIml2UGFyYW1ldGVyU3BlYyI6IkdyOUZZWHJ2OVhSRHZDUTMiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=main)|
|-|-|
| **Docs Status** |![Documentation Status](https://readthedocs.org/projects/sdc-aws-base-docker-image/badge/?version=latest)



### **Description**:
This repository is to define the image to be used for the development environments (vscode `.devcontainers`) as well as the base container for the lambda functions. It includes all needed packages for development.

This container is built and pushed to the public repo ECR automatically by AWS Codebuild.

### **Base Image**: Ubuntu 22.04 ([public.ecr.aws/lts/ubuntu:22.04_stable](https://gallery.ecr.aws/lts/ubuntu))

### **ECR Repo:** Docker Lambda Base Image ([public.ecr.aws/w5r9l1c8/swsoc-docker-lambda-base:latest](https://gallery.ecr.aws/w5r9l1c8/swsoc-docker-lambda-base))

## Included OS Packages
- git
- wget
- unzip
- python3.10
- python3-pip
- pylint

## Included Python Packages
- swxsoc (For instrument packages)
- awslambdaric (For use with interfacing with AWS Lambda)

### **Tests:**
Checks whether the container contains the specified OS and Python requirements using the Container Structure Test ([CST testing suite](https://github.com/GoogleContainerTools/container-structure-test)). 

### **How to Contribute:**
To make a change to this container image, please `fork` this repo, make the requested change and create a `Pull Request` with the change. The PR will trigger a first set of tests to ensure your changes don't break anything in the environment. It will then require two formal reviews/approvals by the project admins. Once it's been approved it can then be **Squashed and Merged** into the main branch of the repo. The CI/CD pipeline from this point will re-run tests and push the image to ECR. After the image has been successfully pushed you can then rebuilt your container in your development environment or you can manually pull the image start to use it.

### **Development Environment Troubleshooting:**
If you experience any issues in your development environment (`.devcontainer` environment on VSCode) when pulling this image from ECR, ensure you have the latest build by rebuilding your container to pull from latest.

## Dockerfile Details
This Docker image is built from the official Canonical Ubuntu 22.04 image. It updates the system and installs necessary packages such as git, unzip, python3.10, python3-pip, and pylint. 

This Dockerfile also includes a process to download pre-built CDF binaries for data format support and copies a Python requirements.txt file into the image to be used for installing Python dependencies. 

Furthermore, it contains a test script to check if the container includes the specified OS and Python requirements using the Container Structure Test. 

The Dockerfile finally creates a user 'vscode' with sudo support to run the container.

