cat("\014")  
options(error=recover)

# load execution function
source("0_master_execution_function.R")

# simulate a Maryland paid family leave program with Rhode Island's rules
policy_simulation(state='MD',
                        saveCSV=TRUE,
                        makelog=TRUE,
                        base_bene_level=.6,
                        impute_method='logit',
                        place_of_work = TRUE,
                        exclusive_particip = FALSE,
                        ext_resp_len = TRUE, 
                        ext_base_effect=TRUE,
                        bene_effect=FALSE, wait_period=5, full_particip_needer=FALSE, clone_factor=0, week_bene_cap=795, week_bene_min=89,
                        dependent_allow = 10,
                        own_uptake=.95, matdis_uptake=.95, bond_uptake=.75, illparent_uptake=.1,
                        illspouse_uptake=.2, illchild_uptake=.2,
                        maxlen_PFL= 20, maxlen_DI=150, maxlen_own =150, maxlen_matdis =150, maxlen_bond =20, maxlen_illparent=20, 
                        maxlen_illspouse =20, maxlen_illchild =20, maxlen_total=150, earnings=11520,output="MD_simulation", random_seed=123)


