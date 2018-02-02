
library(XML)
library(dplyr)
library(nddspiro)

indices <- as.list(c("FEV1",
                     "FEV6",
                     "FVC",
                     "FEV1_FVC",
                     "PEFR",
                     "FEF2575",
                     "FET",
                     "BEV",
                     "EOTV",
                     "VCmax"))

x <- nddspiro.read("./data/example_ndd.xml", indices, traces=3, accepted_only=TRUE, add_GLI=TRUE)

write.csv(x, "./output/example_ndd.csv")


