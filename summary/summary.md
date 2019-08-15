### Calculate Acc

Since calculating accuracy takes plenty of computation power, we split the calculation into several smaller calculations. Files were located in the acc folder. In general, we you have three matrices(hog, radical and s matrices) in csv format. You can run save_matrix.py to convert csv format into hdf5 format since reading csv into numpy matrix is to slow. After, you can run calculate.py to calculate h matrices. Finally, you can run acc.py to calculate accuracy.


1. First, we calculate the h matrix for hog features and radical features. After calculating the h matrix, we saved it into h5 file to use it later. Below is the code:

```python
print('Calculating hog...')
h_hog = hog@np.linalg.pinv(np.transpose(hog)@hog)@np.transpose(hog)
print('Calculating re po...')
h_rad_po = rad_po@np.linalg.pinv(np.transpose(rad_po)@rad_po)@np.transpose(rad_po)

print('Saving...')
with h5py.File('mapping.hdf5', 'w') as fp:
	fp.create_dataset("h_hog", h_hog.shape, dtype='f', data = h_hog)
	fp.create_dataset("h_rad_po", h_rad_po.shape, dtype='f', data = h_rad_po)
```

2. Then, we multiply h matrix with original matrix to get the hat matrix:
```python
h_hog@rad_po
h_rad_po@sbig
...
```

3. Then, in order to calculate the cosine similarity matrix effectively, we first convert all matrices into unit vector matrix and then perform a dot multiplication for both matrices.

4. Finally, we find out the max value and calculate the correctness. Codes are like below:


```python
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
```