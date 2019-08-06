setwd('~/Documents/GitHub/morphological-processing-project')
getwd()
load('data/chineselexicaldatabase2.1.rda')
load('data/Sbig.rda')

library('WpmWithLdl')
library('readr')
library('dplyr')
library('MASS')

data(ch)
wlist = ch$Word[1:3]
flist = ch$bitmapFileName[1:3]
cues = get_graphic_cues(allwords=wlist,
                        fileNames=flist,
                        folder=system.file("extdata", package="WpmWithLdl"),
                        ext=".png")


ch = read_csv('data/chars_pic.csv')
wlist = ch$char
flist = ch$pic
cues = get_graphic_cues(allwords=wlist,
                        fileNames=flist,
                        folder='data/files_char',
                        ext=".png")

write.csv(cues,'data/chars_hog.csv')

ch = read_delim('data/char_dict2.1.txt', col_names = TRUE, delim = ' ')

unique(ch$Str)

head(ch$Cha[ch$Str == 'LRB'])

head(ch$Cha[ch$Str == 'HCI'])

head(ch$Cha[ch$Str == 'CIR'])

ch_re_po = read.csv('data/chars_re_po_matrix.csv', header = TRUE, row.names = 1)
dim(ch_re_po)
View(ch_re_po)

ch_hog = read.csv('data/chars_hog_matrix.csv', header = TRUE, row.names = 1)
dim(ch_hog)
view(ch_hog)

load('data/Sbig.rda')
dim(Sbig)
view(Sbig)

write.csv(Sbig,'data/chars_s.csv')


ch_re_po_temp <- tibble::rownames_to_column(ch_re_po, "Cha")

ch_hog_temp <- tibble::rownames_to_column(ch_hog, "Cha")

Sbig_temp <- tibble::rownames_to_column(as.data.frame(Sbig), "Cha")

Cha_common = Reduce(intersect, list(ch_re_po_temp$Cha, ch_hog_temp$Cha,Sbig_temp$Cha))

ch_re_po_clean_temp <- ch_re_po_temp %>%
  filter(Cha %in% Cha_common) %>%
  arrange(Cha)
ch_re_po_clean_temp[1:30,1:3]
ch_re_po_clean <- ch_re_po_clean_temp[,-1]

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


Hcomp = ch_hog_clean %*% ginv(t(ch_hog_clean)%*%ch_hog_clean)%*%t(ch_hog_clean)
