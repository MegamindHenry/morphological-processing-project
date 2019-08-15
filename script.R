getwd()
setwd('~/Documents/Github/morphological-processing-project/')

# load libraries
library('WpmWithLdl')
library('readr')
library('dplyr')
library('MASS')

# load data ('/data')
# file1: chars_pic.csv ----------------------character-bitmap filename mapping created by match_char_pic.py
# file2: dict.csv----------------dict created by read_dict.py
# file3: Sbig.rda------------------------semantic matrix

# character-bitmap filename mapping
c2p = read_csv('data/chars_pic.csv')
wlist = c2p$char
flist = c2p$pic
cues = get_graphic_cues(allwords=wlist,
                        fileNames=flist,
                        folder='data/files_char',
                        ext=".png")
write.csv(cues,file = 'data/chars_hog.csv')

dict = read_csv('data/dict.csv', col_names = TRUE)
unique(dict$Str) # 6 unique structures 
one <- dict[is.na(dict$Com2),] # 408 characters with 1 component
one_problematic <- one[one$Str != 'SG',]  # with 1 component but not SG structure
one_clean <- setdiff(one, one_problematic)
two <- dict[!is.na(dict$Com2) & is.na(dict$Com3),]
two_problematic <- two[two$Str == 'SG',]  # with 2 components but SG structure
two_clean <- setdiff(two, two_problematic) # 2 components only AND not SG structure
twochar <- two_clean$Cha 
more <- dict[!is.na(dict$Com3),]

sg <- read_csv('data/sg.csv', col_names = TRUE, col_types = cols('SeR'=col_character(),
                                                              'PhR' = col_character(),
                                                              'Com2' = col_character(),
                                                              'Com3' = col_character(),
                                                              'Com4' = col_character(),
                                                              'Com5' = col_character()))
overlap <- intersect(one_clean$Cha, sg$Cha)
one_new <- union(one_clean[one_clean$Cha != overlap,], sg)
distinct(one_new)
dict_new <- union(one_new, two_clean)
save(dict_new, file = 'dict_new.Rda')
write.csv(dict_new, file = 'data/dict_new.csv', fileEncoding='UTF-8', row.names = FALSE, quote = FALSE)
dict = read_csv('data/dict_new.csv', col_names = TRUE)

rad_po <- read.csv('data/rad_po_data.csv')
ch_rad_po = read.csv('data/chars_rad_po_matrix.csv', header = TRUE, row.names = 1)
ch_hog = read.csv('data/chars_hog_matrix.csv', header = TRUE, row.names = 1)

load('data/Sbig.rda')

ch_rad_po_temp <- tibble::rownames_to_column(ch_rad_po, "Cha")

ch_hog_temp <- tibble::rownames_to_column(ch_hog, "Cha")

Sbig_temp <- tibble::rownames_to_column(as.data.frame(Sbig), "Cha")

Cha_common = Reduce(intersect, list(ch_rad_po_temp$Cha, ch_hog_temp$Cha,Sbig_temp$Cha))

ch_rad_po_clean_temp <- ch_rad_po_temp %>%
  filter(Cha %in% Cha_common) %>%
  arrange(Cha)
ch_rad_po_clean <- ch_rad_po_clean_temp[,-1]

ch_hog_clean_temp <- ch_hog_temp %>%
  filter(Cha %in% Cha_common) %>%
  arrange(Cha)
ch_hog_clean <- ch_hog_clean_temp[,-1]

Sbig_clean_temp <- Sbig_temp %>%
  filter(Cha %in% Cha_common) %>%
  arrange(Cha)
Sbig_clean <- Sbig_clean_temp[,-1]

ch_hog_clean_matrix <- as.matrix(ch_hog_clean)
ch_rad_po_clean_matrix <- as.matrix(ch_rad_po_clean)
Sbig_clean_matrix <- as.matrix(Sbig_clean)

ch_hog_clean_matrix_removed <- ch_hog_clean_matrix[-c(1314, 3670),]
ch_rad_po_clean_matrix_removed <- ch_rad_po_clean_matrix[-c(1314, 3670),]
Sbig_clean_matrix_removed <- Sbig_clean_matrix[-c(1314, 3670),]

save(ch_hog_clean_matrix, file = 'ch_hog_clean_matrix.Rda')
save(ch_rad_po_clean_matrix, file = 'ch_rad_po_clean_matrix.Rda')
save(Sbig_clean_matrix, file = 'Sbig_clean_matrix.Rda')

write.table(ch_hog_clean_matrix, file = 'hog_matrix.csv', quote = FALSE, sep = ",", row.names = FALSE, col.names = FALSE, fileEncoding = "UTF-8")
write.table(ch_rad_po_clean_matrix, file = 'rad_matrix.csv', quote = FALSE, sep = ",", row.names = FALSE, col.names = FALSE, fileEncoding = "UTF-8")
write.table(Sbig_clean_matrix, file = 'Sbig_matrix.csv', quote = FALSE, sep = ",", row.names = FALSE, col.names = FALSE, fileEncoding = "UTF-8")

write.table(ch_hog_clean_matrix_removed, file = 'hog_matrix_removed.csv', quote = FALSE, sep = ",", row.names = FALSE, col.names = FALSE, fileEncoding = "UTF-8")
write.table(ch_rad_po_clean_matrix_removed, file = 'rad_matrix_removed.csv', quote = FALSE, sep = ",", row.names = FALSE, col.names = FALSE, fileEncoding = "UTF-8")
write.table(Sbig_clean_matrix_removed, file = 'Sbig_matrix_removed.csv', quote = FALSE, sep = ",", row.names = FALSE, col.names = FALSE, fileEncoding = "UTF-8")


