
# Load and clean csv's for FMLA, ACS, and CPS surveys

cat("\014")  
basepath <- rprojroot::find_rstudio_root_file()
setwd(basepath)
options(error=recover)
library(dummies); library(stats); library(rlist); library(plyr); library(dplyr);  library(survey); library(class); library(varhandle)
source("1_cleaning_functions.R")

fmla_csv <- 'fmla_2012_employee_restrict_puf.csv'

# read in FMLA
d_fmla <- read.csv(paste0("./restricted_data/", fmla_csv))
#INPUT: Raw file for FMLA survey
d_fmla <- clean_fmla(d_fmla, save_csv=FALSE, restricted=TRUE)

saveRDS(d_fmla,file=paste0("./restricted_data/","d_fmla_restrict.rds"))