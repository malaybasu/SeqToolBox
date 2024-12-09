import os
from datetime import datetime

# Global version variable (initially None)
VERSION = None

def stb_outfile_name(filename, dir="./out", version=None):
    global VERSION
    
    # Use the passed version if provided, otherwise use the global VERSION or fallback to the default
    if version is not None:
        VERSION = version
    elif VERSION is None:
        VERSION = datetime.now().strftime("%Y%m%d")
    
    # Remove trailing slash from directory if present
    dir = dir.rstrip(os.sep)
    
    # Return the file path with the version prepended to the filename
    return os.path.join(dir, f"{VERSION}-{filename}")

