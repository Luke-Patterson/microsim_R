# generate leave length distribution from the restricted FMLA data set
library('plyr')
library('dplyr')
library('rjson')

# keep only the leave lengths and the program participation vars
d <- readRDS('restricted_data/d_fmla_restrict.rds')
d <- d[,c('length_own', 'length_matdis', 'length_bond','length_illchild','length_illparent','length_illspouse','resp_len','unaffordable','recStatePay','weight')]
# shuffle the rows to prevent identifiability
rows <- sample(nrow(d))
d <- d[rows,]
write.csv(d,file=paste0(getwd(),'/csv_inputs/leave_length_dist.csv'))

# create distributions for verifying same as python JSON file
PFL <- list()
NonPFL <- list()
for (state_pay in c(0,1)){ 
  d_filt <- d[d$recStatePay==state_pay,]
  for (leave in c('length_own', 'length_matdis', 'length_bond','length_illchild','length_illparent','length_illspouse')) {
    if (state_pay==1) {
      table <- d_filt %>% filter(get(leave)>0) %>% group_by(get(leave)) %>% summarise(sum(weight)) 
      names(table) <- c('Leave Length, Days', 'Count')
      table <- table %>% mutate(Percent = Count / sum(Count))
      PFL[[leave]] <- table
    }
    if (state_pay==0) {
      table <- d_filt %>% filter(get(leave)>0) %>% group_by(get(leave)) %>% summarise(sum(weight)) 
      names(table) <- c('Leave Length, Days', 'Count')
      table <- table %>% mutate(Percent = Count / sum(Count))
      NonPFL[[leave]] <- table
    }
  }
}

# load python JSON
pydist <- fromJSON(file = "restricted_data/length_distributions_exact_days.json")
