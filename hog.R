setwd('~/Documents/GitHub/morphological-processing-project')
getwd()
load('data/chineselexicaldatabase2.1.rda')
load('data/Sbig.rda')

library('WpmWithLdl')
library('readr')
library('dplyr')

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

ch_re_po = read.csv('data/chars_re_po.csv')
dim(ch_re_po)

ch_hog = read.csv('data/chars_hog_matrix.csv', header = TRUE, row.names = 1)
dim(ch_hog)


dim(Sbig)

write.csv(Sbig,'data/chars_s.csv')
