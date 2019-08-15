import numpy as np
import h5py

print('Loading hog...')
hog = np.genfromtxt('hog_matrix_removed.csv', delimiter=',')
print('Loading re po ...')
rad_po = np.genfromtxt('rad_matrix_removed.csv', delimiter=',')
print('Loading sbig...')
sbig = np.genfromtxt('Sbig_matrix_removed.csv', delimiter=',')

print('Saving...')

with h5py.File('matrix.hdf5', 'w') as fp:
	fp.create_dataset("hog", hog.shape, dtype='f', data = hog)
	fp.create_dataset("rad_po", rad_po.shape, dtype='f', data = rad_po)
	fp.create_dataset("sbig", sbig.shape, dtype='f', data = sbig)
