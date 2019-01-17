# =============================================================================
# Imports
# =============================================================================

# NumPy
import numpy
from   numpy.distutils.core      import setup
from   numpy.distutils.misc_util import Configuration

# Operating System
import os

# =============================================================================
# Global methods
# =============================================================================

def configuration(parent_package = "",
                  top_path       = None):
    """
        Configure "metrics" package.
    """
    # Initialize the configuration for the "metrics" package
    config = Configuration("metrics", parent_package, top_path)
    libraries = []

    # Fix posix operating system 
    if os.name == "posix":
        libraries.append("m")

    # Add the extension modules
    config.add_extension("_calculator",
                         sources            = ["_calculator.pyx"],
                         include_dirs       = [numpy.get_include()],
                         libraries          = libraries,
                         extra_compile_args = ["-O3"])
    
    # Add the data files
    config.add_data_files("_calculator.pxd")

    # Add the tests subpackage
    config.add_subpackage("tests")

    # Return the configuration for the "metrics" package
    return config

# Only called if this file is the main one
if __name__ == "__main__":
    # Setup the files
    setup(**configuration().todict())
