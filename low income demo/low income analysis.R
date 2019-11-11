cat("\014")  
options(error=recover)


# load simulation data set
d <- read.csv('output/MD_simulation.csv')

# generate dual receiver column based on proportion 
pop_target <- sum(d$PWGTP)*.75
# guess samp size needed based on mean weighted
samp_size <- nrow(d) * .75
samp_idx <- sample(seq_len(nrow(d)), samp_size)
# add/remove individuals to get to pop target
samp_sum <- sum(d[samp_idx,'PWGTP'])
if (samp_sum> pop_target) {
  while (samp_sum> pop_target) {
    samp_idx <- samp_idx[2:length(samp_idx)]
    samp_sum <- sum(d[samp_idx,'PWGTP'])
  }
} else if (samp_sum< pop_target) { 
  while (samp_sum < pop_target){
    remain_idx <- setdiff(rownames(d),samp_idx)
    samp_idx  <- append(samp_idx,remain_idx[2])
    samp_sum <- sum(d[samp_idx,'PWGTP'])
  }
}
# set dual receiver status for
d$dual_receiver <- 0
d[samp_idx, 'dual_receiver'] <- 1
