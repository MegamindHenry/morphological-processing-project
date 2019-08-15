import numpy as np
import h5py

def unit_vec(x):
	norm = np.linalg.norm(x, axis=1)
	return x/norm[:,None]

def acc(x, y):
	num_row = np.size(x, 0)
	x = unit_vec(x)
	y = unit_vec(y)

	results = np.argmax(np.dot(x, y.T), axis=0)

	correct = 0

	for i, x in enumerate(results):
		if x == i:
			correct += 1

	return correct/num_row

print('Loading...')
hf = h5py.File('mapping.hdf5', 'r')
h_hog = hf['h_hog'][:,:]
h_rad_po = hf['h_rad_po'][:,:]

hf = h5py.File('matrix.hdf5', 'r')
hog = hf['hog'][:,:]
rad_po = hf['rad_po'][:,:]
sbig = hf['sbig'][:,:]
sonehot = np.identity(3960)

print('Calculating...')
acc_hog_rad = acc(rad_po, h_hog@rad_po)
print('Hog to Rad Acc: {}'.format(acc_hog_rad))
acc_rad_sbig = acc(sbig, h_rad_po@sbig)
print('Rad to Sbig: {}'.format(acc_rad_sbig))
acc_hog_sbig = acc(sbig, h_hog@sbig)
print('Hog to Sbig: {}'.format(acc_hog_sbig))

acc_hog_sonehot = acc(sonehot, h_rad_po@sonehot)
print('Hog to S onehot: {}'.format(acc_hog_sonehot))
acc_rad_sonehot = acc(sonehot, h_hog@sonehot)
print('Rad to S onehot: {}'.format(acc_hog_sonehot))
