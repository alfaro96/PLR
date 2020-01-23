#!/bin/bash

# This script is meant to be called
# by the "Install dependencies" step
# defined in integration.yml

# The behaviour of the script is controlled by
# the named step defined in the integration.yml
# in the folder .github/workflows of the project

# Exit immediately if a command
# exits with a non-zero status
set -e

# Obtain the name of the Operating System
case $(uname | tr "[:upper:]" "[:lower:]") in
    linux*)
        export OSNAME=linux
    ;;
    darwin*)
        export OSNAME=osx
esac

# The following steps are only
# required by Linux environments

# Install gcc-6 and g++-6, since it
# is needed by some extension modules
if [ $OSNAME == "linux" ]; then
    sudo apt-add-repository -y ppa:ubuntu-toolchain-r/test
    sudo apt-get update
    sudo apt-get install -y gcc-6 g++-6
fi

# Set the default compilers
if [ $OSNAME == "linux" ]; then
    export CC=/usr/bin/gcc-6
    export CXX=/usr/bin/g++-6
fi

# Install and update the dependencies

# Pip and Setuptools
echo "Upgrading pip and setuptools"
pip install --upgrade pip setuptools

# NumPy, SciPy and Cython
echo "Installing numpy, scipy and cython"
pip install numpy==$NUMPY_VERSION scipy==$SCIPY_VERSION cython==$CYTHON_VERSION

# Pytest
echo "Installing pytest"
pip install pytest==4.6.4 pytest-cov

# Codecov
echo "Installing codecov"
pip install --upgrade codecov

# Print the Python, NumPy and SciPy versions
python --version
python -c 'import numpy; print("NumPy {}".format(numpy.__version__))'
python -c 'import scipy; print("SciPy {}".format(scipy.__version__))'

# Build scikit-lr in the install.sh script
# to collapse the verbose build output in
# the GitHub Actions output when it succeeds
python setup.py develop
