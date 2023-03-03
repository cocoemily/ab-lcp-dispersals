library(tidyverse)
library(binford)

Retal = readxl::read_xlsx(file.choose()) ##supp table from Raichlen et al 2014 paper
levy1 = readLines("analysis-scripts/path-length-choice/levy-1-steps.txt", n = 3)
levy2 = readLines("analysis-scripts/path-length-choice/levy-2-steps.txt", n = 3)
binford = LRB

levy1.1 = map(strsplit(levy1[1], " "), as.numeric)[[1]]
summary(levy1.1)
levy1.2 = map(strsplit(levy1[2], " "), as.numeric)[[1]]
summary(levy1.2)
levy1.3 = map(strsplit(levy1[3], " "), as.numeric)[[1]]
summary(levy1.3)

levy2.1 = map(strsplit(levy2[1], " "), as.numeric)[[1]]
summary(levy2.1)
levy2.2 = map(strsplit(levy2[2], " "), as.numeric)[[1]]
summary(levy2.2)
levy2.3 = map(strsplit(levy2[3], " "), as.numeric)[[1]]
summary(levy2.3)


summary(Retal$`total path (km)`)
Retal.out = Retal %>% filter(`trip segment` == "outbound")
total.path = (Retal.out$`total path (km)`) #total path length for one bout of foraging
summary(total.path)
summary(binford$kmov) #distance moved per year
summary(binford$kspmov) #average distance per move (km)


ks.test(levy1.1, total.path)
ks.test(levy1.2, total.path)
ks.test(levy1.3, total.path)

ks.test(levy2.1, total.path)
ks.test(levy2.2, total.path)
ks.test(levy2.3, total.path)

# ks.test(levy1.1, binford$kmov)
# ks.test(levy1.2, binford$kmov)
# ks.test(levy1.3, binford$kmov)
# 
# ks.test(levy2.1, binford$kmov)
# ks.test(levy2.2, binford$kmov)
# ks.test(levy2.3, binford$kmov)


