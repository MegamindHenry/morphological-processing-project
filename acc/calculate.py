import numpy as np
import h5py

print('Loading...')
hf = h5py.File('matrix.hdf5', 'r')
hog = hf['hog']
rad_po = hf['rad_po']
sbig = hf['sbig']

print('Calculating hog...')
h_hog = hog@np.linalg.pinv(np.transpose(hog)@hog)@np.transpose(hog)
print('Calculating re po...')
h_rad_po = rad_po@np.linalg.pinv(np.transpose(rad_po)@rad_po)@np.transpose(rad_po)

print('Saving...')

with h5py.File('mapping.hdf5', 'w') as fp:
	fp.create_dataset("h_hog", h_hog.shape, dtype='f', data = h_hog)
	fp.create_dataset("h_rad_po", h_rad_po.shape, dtype='f', data = h_rad_po)