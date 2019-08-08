setwd('~/Documents/GitHub/morphological-processing-project/remote')
getwd()

load('B.rda')
load('C.rda')

H_B = B %*% ginv(t(B)%*%B)%*%t(B)
Chat = H_B %*% C 
Chat
C
