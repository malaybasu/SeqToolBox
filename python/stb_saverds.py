import pickle
import lzma

def stb_saveRDS_xz(obj, file):
    # Open the file in write-binary mode with xz compression
    with lzma.open(file, 'wb') as f:
        # Save the object using pickle
        pickle.dump(obj, f)
