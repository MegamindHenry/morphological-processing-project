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

```python

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

