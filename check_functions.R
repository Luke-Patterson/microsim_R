# check which functions are in each file 
library('NCmisc')

files <- c(
  '0_master_execution_function.R',
  '1_cleaning_functions.R',
  '2_pre_impute_functions.R',
  '3_impute_functions.R',
  '4_post_impute_functions.R',
  '5_output_analysis_functions.R',
  'TEST_execution.R'
)

for (i in files) {
  print(i)
  print(list.functions.in.file(i))
}