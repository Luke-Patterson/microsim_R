# generate leave length distribution from the restricted FMLA data set
library('plyr')
library('dplyr')

# keep only the leave lengths and the program participation vars
d <- readRDS('restricted_data/d_fmla_restrict.rds')
d <- d[,c('length_own', 'length_matdis', 'length_bond','length_illchild','length_illparent','length_illspouse','resp_len','unaffordable','recStatePay')]
# shuffle the rows to prevent identifiability
rows <- sample(nrow(d))
d <- d[rows,]
write.csv(d,file=paste0(getwd(),'/csv_inputs/leave_length_dist.csv'))