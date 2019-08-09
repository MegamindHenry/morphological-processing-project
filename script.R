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

c2p = read_csv('data/chars_pic.csv')
chars <- c2p$char # 4895 chars

dict = read_csv('data/dict.csv', col_names = TRUE)
unique(dict$Str)
dchar <- dict$Cha  # 5807 characters
one <- dict[is.na(dict$Com2),] # 408 characters with 1 component
one_problematic <- one[one$Str != 'SG',]  # with 1 component but not SG structure
one_clean <- setdiff(one, one_problematic)
two <- dict[!is.na(dict$Com2) & is.na(dict$Com3),]
two_problematic <- two[two$Str == 'SG',]  # with 2 components but SG structure
two_clean <- setdiff(two, two_problematic) # 2 components only AND not SG structure
twochar <- two_clean$Cha # 4886 characters with 2 components only and not SG structure
more <- dict[!is.na(dict$Com3),]  # 461

sg <- read_csv('data/sg.csv', col_names = TRUE, col_types = cols('SeR'=col_character(),
                                                              'PhR' = col_character(),
                                                              'Com2' = col_character(),
                                                              'Com3' = col_character(),
                                                              'Com4' = col_character(),
                                                              'Com5' = col_character()))
overlap <- intersect(one_clean$Cha, sg$Cha)
one_new <- union(one_clean[one_clean$Cha != overlap,], sg)
distinct(one_new)
dict_new <- union(one_new, two_clean)  # 5211 characters!
save(dict_new, file = 'dict_new.Rda')
save(dict_new, file = 'dict_new.csv')


Sbig <- load('data/Sbig.rda')
names <- rownames(Sbig) # set of 4708 characters in semantic matrix
# length(unique(names))==length(names)



