
# load master execution function for testing code
source("0_master_execution_function.R")

# run policy simulation
d <- policy_simulation(
                  # Specify the state we want to simulate a program for. Let's do Wyoming
                  state='WY',
                  
                  # Specify we want to save the output micro-data as a CSV
                  saveCSV=TRUE,
  
                  # Specify some basic leave program characteristics:
                  
                  # 1. wage replacement rate of 50%
                  base_bene_level=.5,
                  
                  # 2. max weekly benefit from program of $2000
                  week_bene_cap=2000,
                  
                  # Some elibility restrictions:
                  
                  # 1. at least $1,000 in previous year earnings
                  earnings=1000,
                  
                  # 2. at least 5 weeks worked in previous year
                  weeks= 5, 
                  
                  # Specify the expected uptake rate of the program among eligible workers;
                  # for this example, let's base it off historical participation rates in New Jersey
                  own_uptake=.03, matdis_uptake=.01, bond_uptake=.01, illparent_uptake=.001,
                  illspouse_uptake=.001, illchild_uptake=.001,
                  
                  # specify name of output files
                  output='tutorial', 
                  
                  # specify type of output 
                  output_stats=c('standard')
)

