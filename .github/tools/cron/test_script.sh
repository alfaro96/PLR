#!/bin/bash

# Immediately exit with a non-zero status command
set -e

# Ensure that the required packages are installed
python --version
python -c "import numpy; print('NumPy {0}'.format(numpy.__version__))"
python -c "import scipy; print('SciPy {0}'.format(scipy.__version__))"

# Set the format of the code coverage report to XML for
# submitting. Note that deprecation and future warnings
# are raised to anticipate these before stable releases
TEST_CMD="pytest --showlocals --durations=20 --pyargs"
TEST_CMD="$TEST_CMD --cov=sklr"
TEST_CMD="$TEST_CMD --cov-report=xml"
TEST_CMD="$TEST_CMD -Werror::DeprecationWarning"
TEST_CMD="$TEST_CMD -Werror::FutureWarning"

$TEST_CMD sklr