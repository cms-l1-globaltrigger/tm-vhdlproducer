"""Constants for resources of Virtex chip."""

import hashlib
from glob import glob

BRAMS_TOTAL: int = 1470
SLICELUTS_TOTAL: int = 433200
PROCESSORS_TOTAL: int = 3600
NR_CALOS: int = 12
NR_MUONS: int = 8

def get_files_hash_value(dir_path):
    """Calculate hash value of the content of all .py and .vhd files in 'dir_path'.
    """
    py_files = dir_path+"/**/*.py"
    vhd_files = dir_path+"/**/*.vhd"
    x = hashlib.sha256()
    filenames = []
    for filename_py in glob(py_files, recursive=True):
        filenames.append(filename_py)
    for filename_vhd in glob(vhd_files, recursive=True):
        filenames.append(filename_vhd)
    for filename in filenames:
        with open(filename, 'rb') as f:
            while True:
                # Reading is buffered, so we can read smaller chunks.
                chunk = f.read(x.block_size)
                if not chunk:
                    break
                x.update(chunk)
    return x.hexdigest()

