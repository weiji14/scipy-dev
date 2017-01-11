FROM debian:testing-slim
MAINTAINER Wei Ji Leong <weiji@e-spatial.co.nz>

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# Update repos
RUN apt-get update

# Install python, pip and git
RUN apt-get install -y --no-install-recommends \
    python \
    python-dev \
    python-pip \
    git

# Install gcc compiler
RUN apt-get install -y --no-install-recommends \
    gcc

# Fix: InsecurePlatformWarning
# http://urllib3.readthedocs.org/en/latest/security.html#insecureplatformwarning
RUN apt-get install -y --no-install-recommends \
    libffi-dev \
    libssl-dev \
    && pip install setuptools \
    && pip install --no-cache-dir ndg-httpsclient

# Install numpy and scipy from pip
RUN pip install --no-cache-dir numpy scipy

# Install packages needed to compile scipy from source
RUN apt-get install -y --no-install-recommends \
    g++ \
    gfortran \
    libblas-dev \
    liblapack-dev \
    cython

# Build latest scipy from git (currently 0.19)
RUN pip install --no-cache-dir git+https://github.com/scipy/scipy.git

# Initiate python
CMD ["/usr/bin/python"]

# Cleanup apt-cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/

# TODO Cleanup unneeded compiler packages
# RUN apt-get purge -y \
#    g++
#    gfortran \
#    libblas-dev \
#    liblapack-dev \
#    cython