# generate leave length distribution from the restricted FMLA data set
library('plyr')
library('dplyr')

# load restricted data
d <- readRDS('restricted_data/d_fmla_restrict.rds')

# start a data frame to store leave lengths
d_lens <- data.frame()

for (state_pay in c(0,1)){ 
  d_filt <- d[d$recStatePay==state_pay,]
  for (leave in c('length_own', 'length_matdis', 'length_bond','length_illchild','length_illparent','length_illspouse')) {
    
    if (state_pay==1) {
      table <- d_filt %>% filter(get(leave)>0) %>% group_by(get(leave)) %>% summarise(sum(weight)) 
      names(table) <- c('Leave Length, Days', 'Count')
      table <- table %>% mutate(Percent = Count / sum(Count))
    }
    
    if (state_pay==0) {
      table <- d_filt %>% filter(get(leave)>0) %>% group_by(get(leave)) %>% summarise(sum(weight)) 
      names(table) <- c('Leave Length, Days', 'Count')
      table <- table %>% mutate(Percent = Count / sum(Count))
    }
    
    table['State Pay'] <- state_pay
    table['Leave Type'] <- leave
    table['Count'] <- NULL
    d_lens <- rbind(d_lens, table)
  }
}

write.csv(d_lens,file=paste0(getwd(),'/csv_inputs/leave_length_prob_dist.csv'), row.names=FALSE)
