setwd('~/Documents/Github/morphological-processing-project/')
getwd()
load('chineselexicaldatabase2.1.rda')
load('Sbig.rda')

library('WpmWithLdl')
library('readr')
library('dplyr')
library('MASS')

ch = read_csv('data/chars_pic.csv')
wlist = ch$char
flist = ch$pic
cues = get_graphic_cues(allwords=wlist,
                        fileNames=flist,
                        folder='data/files_char',
                        ext=".png")

write.csv(cues,'data/chars_hog.csv')

ch2 = read_delim('data/char_dict2.1.txt', col_names = TRUE, delim = ' ')
str(ch2)
unique(ch2$Str)

head(ch2$Cha[ch2$Str == 'LRB'])

head(ch2$Cha[ch2$Str == 'HCI'])

head(ch2$Cha[ch2$Str == 'CIR'])

head(ch2$Cha[ch2$Str == 'PicPho'])  # What do we do with this type? discard? actually UD?

rad_po <- read.csv('data/rad_po_data.csv')
ch_rad_po = read.csv('data/chars_rad_po_matrix.csv', header = TRUE, row.names = 1)
dim(ch_rad_po)

ch_hog = read.csv('data/chars_hog_matrix.csv', header = TRUE, row.names = 1)
dim(ch_hog)

load('data/Sbig.rda')
dim(Sbig)

write.csv(Sbig,'data/chars_s.csv')


ch_rad_po_temp <- tibble::rownames_to_column(ch_rad_po, "Cha")

ch_hog_temp <- tibble::rownames_to_column(ch_hog, "Cha")

Sbig_temp <- tibble::rownames_to_column(as.data.frame(Sbig), "Cha")

Cha_common = Reduce(intersect, list(ch_rad_po_temp$Cha, ch_hog_temp$Cha,Sbig_temp$Cha))

ch_rad_po_clean_temp <- ch_rad_po_temp %>%
  filter(Cha %in% Cha_common) %>%
  arrange(Cha)
ch_rad_po_clean_temp[1:30,1:3]
ch_rad_po_clean <- ch_rad_po_clean_temp[,-1]

ch_hog_clean_temp <- ch_hog_temp %>%
  filter(Cha %in% Cha_common) %>%
  arrange(Cha)
ch_hog_clean_temp[1:30, 1:3]
ch_hog_clean <- ch_hog_clean_temp[,-1]

Sbig_clean_temp <- Sbig_temp %>%
  filter(Cha %in% Cha_common) %>%
  arrange(Cha)
Sbig_clean_temp[1:30, 1:3]
Sbig_clean <- Sbig_clean_temp[,-1]

ch_hog_clean_matrix <- as.matrix(ch_hog_clean)
ch_rad_po_clean_matrix <- as.matrix(ch_rad_po_clean)
Sbig_clean_matrix <- as.matrix(Sbig_clean)

save(ch_hog_clean_matrix, file = 'ch_hog_clean_matrix.Rda')
save(ch_rad_po_clean_matrix, file = 'ch_rad_po_clean_matrix.Rda')
save(Sbig_clean_matrix, file = 'Sbig_clean_matrix.Rda')

Hcomp = ch_hog_clean_matrix %*% ginv(t(ch_hog_clean_matrix)%*%ch_hog_clean_matrix)%*%t(ch_hog_clean_matrix)
