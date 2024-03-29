# morphological-processing-project
Title:	Summary for Morphological Processing Project 
Author: Xuefeng Luo
		Jingwen Li
Date:	Aug 15, 2019

### General Instruction

Our codes are in [https://github.com/MegamindHenry/morphological-processing-project](https://github.com/MegamindHenry/morphological-processing-project)

All data were excluded from github.


###  Generating HoG matrix

Files used:

- `chars.txt`
- `files_char` (folder containing bitmap files)

1. Create a character-bitmap filename mapping using `match_char_pic.py`. The resulting data frame contains two columns: `char` for characters and `pic` for the characters' corresponding bitmap files.

2. Use the `WpmWithLdl::get_graphic_cues` function to obtain cues for all characters, save it as `chars_hog.csv`.

   ```R
   c2p = read_csv('data/chars_pic.csv')
   wlist = c2p$char
   flist = c2p$pic
   cues = get_graphic_cues(allwords=wlist,
                           fileNames=flist,
                           folder='data/files_char',
                           ext=".png")
   write.csv(cues,file = 'data/chars_hog.csv')
   ```

3.  Then **manually** change the headers of the `chars_hog.csv` file from `"", "x"` to `"Cha","Hog"` so that `hog_matrix.py` could work properly.

4.  Use `hog_matrix.py` to generate the HoG matrix,  `chars_hog_matrix.csv`.



### Generating the radical matrix

Files used:

- `char_dict2.1.txt`

1.  Use `read_dict.py`  with `filename='char_dict2.1.txt'`  to read the file and generate `dict.csv`

2.  Fix problem with single character words: characters with `SG` structure but have more than 1 component. Their components are replaced by the character itself so that all `SG` structured characters have one component only. The resulting file is `sg.csv`

3. Obtain a revised dictionary, save it as `dict_new.csv`.

   ```R
   dict = read_csv('data/dict.csv', col_names = TRUE)
   unique(dict$Str) # 6 unique structures 
   one <- dict[is.na(dict$Com2),] # 408 characters with 1 component
   one_problematic <- one[one$Str != 'SG',]  # with 1 component but not SG structure
   one_clean <- setdiff(one, one_problematic)
   two <- dict[!is.na(dict$Com2) & is.na(dict$Com3),]
   two_problematic <- two[two$Str == 'SG',]  # with 2 components but SG structure
   two_clean <- setdiff(two, two_problematic)
   
   sg <- read_csv('data/sg.csv', col_names = TRUE, col_types = cols('SeR'=col_character(),
        'PhR' = col_character(),
        'Com2' = col_character(),
        'Com3' = col_character(),
        'Com4' = col_character(),
        'Com5' = col_character()))
   
   overlap <- intersect(one_clean$Cha, sg$Cha)
   one_new <- union(one_clean[one_clean$Cha != overlap,], sg)
   dict_new <- union(one_new, two_clean)
   write.csv(dict_new, file = 'data/dict_new.csv', fileEncoding='UTF-8', row.names = FALSE, quote = FALSE)
   ```

4. Use `rad_po_matrix.py` to generate the radical matrix, as `chars_rad_po_matrix.csv. `It also generates `rad_po_data.csv`. 

### Semantic matrix (`Sbig.Rda`)

```R
load('data/Sbig.rda')
```



### Semantic matrix (one-hot encoded)

One-hot encoding matrix was generated by numpy in python, using identity() function.

```python
sonehot = np.identity(3960)
```



### Find common characters and clean up the matrices

```R
# read data
rad_po <- read.csv('data/rad_po_data.csv')
ch_rad_po = read.csv('data/chars_rad_po_matrix.csv', header = TRUE, row.names = 1)
ch_hog = read.csv('data/chars_hog_matrix.csv', header = TRUE, row.names = 1)

# change row names to a "Cha" column
ch_rad_po_temp <- tibble::rownames_to_column(ch_rad_po, "Cha")
ch_hog_temp <- tibble::rownames_to_column(ch_hog, "Cha")
Sbig_temp <- tibble::rownames_to_column(as.data.frame(Sbig), "Cha")

# find the common characters
Cha_common = Reduce(intersect, list(ch_rad_po_temp$Cha, ch_hog_temp$Cha,Sbig_temp$Cha))

# clean up the three matrices based on the common characters
ch_rad_po_clean_temp <- ch_rad_po_temp %>%
  filter(Cha %in% Cha_common) %>%
  arrange(Cha)
ch_rad_po_clean <- ch_rad_po_clean_temp[,-1] # remove the 'Cha' column

ch_hog_clean_temp <- ch_hog_temp %>%
  filter(Cha %in% Cha_common) %>%
  arrange(Cha)
ch_hog_clean <- ch_hog_clean_temp[,-1] # remove the 'Cha' column

Sbig_clean_temp <- Sbig_temp %>%
  filter(Cha %in% Cha_common) %>%
  arrange(Cha)
Sbig_clean <- Sbig_clean_temp[,-1] # remove the 'Cha' column

# save the clean version of matrices
ch_hog_clean_matrix <- as.matrix(ch_hog_clean)
ch_rad_po_clean_matrix <- as.matrix(ch_rad_po_clean)
Sbig_clean_matrix <- as.matrix(Sbig_clean)

write.table(ch_hog_clean_matrix, file = 'hog_matrix.csv', quote = FALSE, sep = ",", row.names = FALSE, col.names = FALSE, fileEncoding = "UTF-8")
write.table(ch_rad_po_clean_matrix, file = 'rad_matrix.csv', quote = FALSE, sep = ",", row.names = FALSE, col.names = FALSE, fileEncoding = "UTF-8")
write.table(Sbig_clean_matrix, file = 'Sbig_matrix.csv', quote = FALSE, sep = ",", row.names = FALSE, col.names = FALSE, fileEncoding = "UTF-8")

# remove rows where in the semantic matrix are all NAs
ch_hog_clean_matrix_removed <- ch_hog_clean_matrix[-c(1314, 3670),]
ch_rad_po_clean_matrix_removed <- ch_rad_po_clean_matrix[-c(1314, 3670),]
Sbig_clean_matrix_removed <- Sbig_clean_matrix[-c(1314, 3670),]

# save removed matrices separately
write.table(ch_hog_clean_matrix_removed, file = 'hog_matrix_removed.csv', quote = FALSE, sep = ",", row.names = FALSE, col.names = FALSE, fileEncoding = "UTF-8")
write.table(ch_rad_po_clean_matrix_removed, file = 'rad_matrix_removed.csv', quote = FALSE, sep = ",", row.names = FALSE, col.names = FALSE, fileEncoding = "UTF-8")
write.table(Sbig_clean_matrix_removed, file = 'Sbig_matrix_removed.csv', quote = FALSE, sep = ",", row.names = FALSE, col.names = FALSE, fileEncoding = "UTF-8")
```



### Calculate Acc

Since calculating accuracy takes plenty of computation power, we split the calculation into several smaller calculations. Files were located in the acc folder. In general, we have three matrices(hog, radical and s matrices) in csv format. You can run save_matrix.py to convert csv format into hdf5 format since reading csv into numpy matrix is to slow. After, you can run calculate.py to calculate h matrices. Finally, you can run acc.py to calculate accuracy.


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

### Results

The results were quite interesting. For sbig matrix, the direct path was 0.6583 and the indirect path was 1 and 0.5686. If we use one-hot encoding as semantic matrix, then accuracies were 1 for both direct path and indirect path.

|                     | sbig   | one-hot |
|---------------------|--------|---------|
| hog to radical      | 1      | 1       |
| radical to semantic | 0.5686 | 1       |
| hog to semantic     | 0.6583 | 1       |

### Time

We haven't counted our time precisely, but roughly we spent 50 hours in total.

### References

Baayen, R. H., Chuang, Y. Y., & Blevins, J. P. (2018). Inflectional morphology with linear mappings. The mental lexicon, 13(2), 230-268.


