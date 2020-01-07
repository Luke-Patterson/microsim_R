cat("\014")  
basepath <- rprojroot::find_rstudio_root_file()
setwd(basepath)
options(error=recover)
library(plyr)
library(ggplot2)
library(reshape2)

# read in IMPAQ results
impaq <- read.csv('output/issue_brief_1 nums.csv')
names(impaq)[names(impaq) == "X"] <- "var"
names(impaq)[names(impaq) == "source"] <- "model"

# read in actual results 
actual <- read.csv('issue brief 1 - ACM comparison/actual leave data.csv')
names(actual)[names(actual) == "source"] <- "model"

# melt data together
d <- melt(impaq[c('var','CA','NJ','RI','model')])
d <- rbind(d,melt(actual[c('var','CA','NJ','RI','model')]))
names(d)[names(d) == "variable"] <- "state"

# melt SE separately (all 0's for actual data)
d_se <- melt(impaq[c('var','CA_SE','NJ_SE','RI_SE','model')])
temp_se <- melt(actual[c('var','CA','NJ','RI','model')])
temp_se$variable <- paste0(temp_se$variable,'_SE')
temp_se$value <- 0
d_se <- rbind(d_se,temp_se)
names(d_se)[names(d_se) == "variable"] <- "state"

# add labels to both 
d <- merge(d, actual[c('var','label','Leave_Type')],all.x=TRUE)
d_se <- merge(d_se, actual[c('var','label','Leave_Type')],all.x=TRUE)

# don't want to include those without labels, which have no actual data
d <- d[complete.cases(d),]
d_se <- d_se[complete.cases(d_se),]
d['se_value'] <- d_se['value']

# make graphs 
# Exhibit 1 ---- Comparing Total Benefits 
ggplot(data=d[d['var']=='actual_benefits',], aes(x=state, y=value,fill=model)) +
  # bar chart
  geom_bar(stat="identity", position='dodge') +
  # theme
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  # y axis label
  ylab('Benefits Outlayed (Millions)') +
  # y axis tick labels
  scale_y_continuous(labels = function(x) paste0('$',format(x/1000000, big.mark=",", scientific=FALSE), "M")) +

  # theme of plot text
  theme(plot.title = element_text(size=11, hjust = 0.5,face='bold'), 
        text=element_text(size = 9)) +
  # Data labels
  geom_text(position = position_dodge(width= 1),aes(y=value+250000000,
                label=paste0("$",format(value/1000000, big.mark=",", nsmall=1, digits=2, scientific=FALSE)
                              , "M"))) +
  geom_errorbar(position = position_dodge(width= 1),aes(ymin=value-se_value*1.96, ymax=value+se_value*1.96), width=.2) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
  panel.background = element_blank(), axis.line = element_line(colour = "black"))

ggsave(file="./exhibits/IB1_benefit_outlay.png", width=6.5, dpi=300)

# Exhibit 2 ---- Comparing Total Eligible Workers
ggplot(data=d[d['var']=='eligworker',], aes(x=state, y=value,fill=model)) +
  # bar chart
  geom_bar(stat="identity", position='dodge') +
  # theme
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  # y axis label
  ylab('Eligible Workers (Millions)') +
  # y axis tick labels
  scale_y_continuous(labels = function(x) paste0(format(x/1000000, big.mark=",", scientific=FALSE), "M")) +

  # theme of plot text
  theme(plot.title = element_text(size=11, hjust = 0.5,face='bold'), 
        text=element_text(size = 9)) +
  # Data labels
  geom_text(position = position_dodge(width= 1),aes(y=value+1000000,
                                                       label=paste0(format(value/1000000, big.mark=",", nsmall=1, digits=2, scientific=FALSE)
                                                                    , "M"))) +
  geom_errorbar(position = position_dodge(width= 1),aes(ymin=value-se_value*1.96, ymax=value+se_value*1.96), width=.2)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"))
        
ggsave(file="./exhibits/IB2_eligible_workers.png", width=6.5, dpi=300)

# Exhibit 3 ---- California, Number of leave takers
ggplot(data=d[d['state']=='CA' & grepl('ptake',d$var),], aes(x=Leave_Type, y=value,fill=model)) +
  # bar chart
  geom_bar(stat="identity", position='dodge') +
  # theme
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  # y axis label
  ylab('Participants (Thousands)') +
  # y axis tick labels
  scale_y_continuous(labels = function(x) paste0(format(x/1000, big.mark=",", scientific=FALSE), "K")) +

  # theme of plot text
  theme(plot.title = element_text(size=11, hjust = 0.5,face='bold'),
        text=element_text(size = 9)) +
  # Data labels
  geom_text(position = position_dodge(width= 1),aes(y=value+25000,
                                                       label=paste0(format(value/1000, big.mark=",", nsmall=1, digits=2, scientific=FALSE)
                                                                    , "K"))) +
  geom_errorbar(position = position_dodge(width= 1),aes(ymin=value-se_value*1.96, ymax=value+se_value*1.96), width=.2) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"))
        

ggsave(file="./exhibits/IB3_CA_Leave_Takers.png", width=6.5, dpi=300)

# Exhibit 5 ---- New Jersey, Number of leave takers
ggplot(data=d[d['state']=='NJ' & grepl('ptake',d$var),], aes(x=Leave_Type, y=value,fill=model)) +
  # bar chart
  geom_bar(stat="identity", position='dodge') +
  # theme
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  # y axis label
  ylab('Participants (Thousands)') +
  # y axis tick labels
  scale_y_continuous(labels = function(x) paste0(format(x/1000, big.mark=",", scientific=FALSE), "K")) +
  
  # theme of plot text
  theme(plot.title = element_text(size=11, hjust = 0.5,face='bold'),
        text=element_text(size = 9)) +
  # Data labels
  geom_text(position = position_dodge(width= 1),aes(y=value+4000,
                                                    label=paste0(format(value/1000, big.mark=",", nsmall=1, digits=2, scientific=FALSE)
                                                                 , "K"))) +
  geom_errorbar(position = position_dodge(width= 1),aes(ymin=value-se_value*1.96, ymax=value+se_value*1.96), width=.2)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"))
        

ggsave(file="./exhibits/IB5_NJ_Leave_Takers.png", width=6.5, dpi=300)

# Exhibit 6 ---- New Jersey, leave length
ggplot(data=d[d['state']=='NJ' & grepl('plen',d$var),], aes(x=Leave_Type, y=value,fill=model)) +
  # bar chart
  geom_bar(stat="identity", position='dodge') +
  # theme
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  # y axis label
  ylab('Length of Participation (Weeks)') +
  # y axis tick labels
  scale_y_continuous(labels = function(x) paste0(format(x, big.mark=",", scientific=FALSE))) +
  
  # theme of plot text
  theme(plot.title = element_text(size=11, hjust = 0.5,face='bold'),
        text=element_text(size = 9)) +
  # Data labels
  geom_text(position = position_dodge(width= 1),aes(y=value+2,
                                                    label=paste0(format(value, big.mark=",", nsmall=1, digits=2, scientific=FALSE)))) +
  geom_errorbar(position = position_dodge(width= 1),aes(ymin=value-se_value*1.96, ymax=value+se_value*1.96), width=.2)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"))
        

ggsave(file="./exhibits/IB6_NJ_Leave_Length.png", width=6.5, dpi=300)

# Exhibit 7 ---- Rhode Island, Number of leave takers
ggplot(data=d[d['state']=='RI' & grepl('ptake',d$var),], aes(x=Leave_Type, y=value,fill=model)) +
  # bar chart
  geom_bar(stat="identity", position='dodge') +
  # theme
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  # y axis label
  ylab('Participants (Thousands)') +
  # y axis tick labels
  scale_y_continuous(labels = function(x) paste0(format(x/1000, big.mark=",", scientific=FALSE), "K")) +
  
  # theme of plot text
  theme(plot.title = element_text(size=11, hjust = 0.5,face='bold'),
        text=element_text(size = 9)) +
  # Data labels
  geom_text(position = position_dodge(width= 1),aes(y=value+2500,
                                                    label=paste0(format(value/1000, big.mark=",", nsmall=1, digits=1, scientific=FALSE)
                                                                 , "K"))) +
  geom_errorbar(position = position_dodge(width= 1),aes(ymin=value-se_value*1.96, ymax=value+se_value*1.96), width=.2)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"))
        

ggsave(file="./exhibits/IB7_RI_Leave_Takers.png", width=6.5, dpi=300)

