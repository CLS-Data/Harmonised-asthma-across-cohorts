
****************************************************************
**** Coding for Harmonisation of physcial variables: ASTHMA ****
**** For Next Steps ********************************************
**** Martina Narayanan, December 2024 ***************************
****************************************************************

**** Set pathway *************************************************************
******************************************************************************

* Set input path to the folder that contains all data files downloaded from UKDS *

global input_path "C:\Users\qtnvmna\OneDrive - University College London\CLS raw data recent\Next Steps"
global input_path2 "C:\Users\qtnvmna\OneDrive - University College London\CLS_studies_raw_data\COVID web survey"

* Set working path to store files
global working_path "C:\Users\qtnvmna\OneDrive - University College London\Harmonisation health\Coding\Asthma"

* Set paths to access each data file
global response "UKDA-5545-stata\stata\stata13\eul\next_steps_longitudinal_file.dta"
global covid1 "UKDA-8658-stata\stata\stata13\covid-19_wave1_survey_cls.dta"
global covid2 "UKDA-8658-stata\stata\stata13\covid-19_wave2_survey_cls.dta"
global covid3 "UKDA-8658-stata\stata\stata13\covid-19_wave3_survey_cls.dta"

**** Prepare files ***********************************************************
******************************************************************************

use "$input_path2/$covid1", clear // Spring 2020 sweep
keep if CW1_COHORT==3 
keep NSID CW1_LLI_3 CW1_LLI_5 CW1_COHORT
save "$working_path/NS_covid1.dta", replace

use "$input_path2/$covid2", clear // Spring 2020 sweep
keep if CW2_COHORT==3 
keep NSID CW2_LLI1_3 CW2_LLI1_5 CW2_COHORT
save "$working_path/NS_covid2.dta", replace

use "$input_path2/$covid3", clear // Spring 2020 sweep
keep if CW3_COHORT==3
keep NSID CW3_LLI1_3 CW3_LLI1_5 CW3_COHORT
save "$working_path/NS_covid3.dta", replace


**** Merge variables *********************************************************
******************************************************************************

use "$input_path/$response", replace
keep NSID W1OUTCOME W2OUTCOME W3OUTCOME W4OUTCOME W5OUTCOME W6OUTCOME W7OUTCOME W8OUTCOME

merge 1:1 NSID using "$working_path/NS_covid1.dta", nogen keep(match master)

merge 1:1 NSID using "$working_path/NS_covid2.dta", nogen keep(match master)

merge 1:1 NSID using "$working_path/NS_covid3.dta", nogen keep(match master)


**** No information on respiratory symptoms in earlier waves *****************

label define yesno 0 "No" 1 "Yes" .m "DK/refused/not answered"

**** Wave 9 has information on longstanding illness but grouped together as respiratory problems, so cannot differentiate between asthma, wheezy bronchitis and other conditions

**** Covid wave 1 (Age 30) ***************************************************

tab CW1_LLI_3 
gen asthma_30_c1 = .
replace asthma_30_c1 = 1 if CW1_LLI_3==1 
replace asthma_30_c1 = 0 if CW1_LLI_3==2 
replace asthma_30_c1 = .m if asthma_30_c1==. & CW1_COHORT==3
label variable asthma_30_c1 "Current asthma aged 30 (Covid wave 1)"
label values asthma_30_c1 yesno
tab asthma_30_c1

tab CW1_LLI_5  
gen astwh_30_c1 = asthma_30_c1 
replace astwh_30_c1 = 1 if CW1_LLI_5==1
replace astwh_30_c1 = .m if astwh_30_c1==. & CW1_COHORT==3
label variable astwh_30_c1 "Current asthma or wheezy bronchitis aged 30 (Covid wave 1)"
label values astwh_30_c1 yesno
tab astwh_30_c1

**** Covid wave 2 (Age 30) ***************************************************

tab CW1_LLI_3 
tab CW2_LLI1_3 
gen asthma_30_c2 = .
replace asthma_30_c2 = 1 if CW1_LLI_3==1 | CW2_LLI1_3==1
replace asthma_30_c2 = 0 if CW1_LLI_3==2 | CW2_LLI1_3==2
replace asthma_30_c2 = .m if asthma_30_c2==. & (CW1_COHORT==3|CW2_COHORT==3)
label variable asthma_30_c2 "Current asthma aged 30 (Covid wave 2)"
label values asthma_30_c2 yesno
tab asthma_30_c2

tab CW1_LLI_5 
tab CW2_LLI1_5 
gen astwh_30_c2 = asthma_30_c2
replace astwh_30_c2 = 1 if CW1_LLI_5==1 | CW2_LLI1_5==1
replace astwh_30_c2 = .m if astwh_30_c2==. & (CW1_COHORT==3|CW2_COHORT==3)
label variable astwh_30_c2 "Current asthma or wheezy bronchitis aged 30 (Covid wave 2)"
label values astwh_30_c2 yesno
tab astwh_30_c2


**** Covid wave 3 (Age 31) ***************************************************

tab CW3_LLI1_3 
gen asthma_31_c3 = CW3_LLI1_3
recode asthma_31_c3 (-8 -9 -1=.)(1=1)(2=0)
replace asthma_31_c3 = .m if CW3_COHORT==3 & asthma_31_c3==.
label variable asthma_31_c3 "Current asthma aged 31 (Covid wave 3)"
label values asthma_31_c3 yesno
tab asthma_31_c3

tab CW3_LLI1_5
gen astwh_31_c3 = asthma_31_c3
replace astwh_31_c3 = 1 if CW3_LLI1_5==1
replace astwh_31_c3 = .m if CW3_COHORT==3 & asthma_31_c3==.
label variable astwh_31_c3 "Current asthma or wheezy bronchitis aged 31 (Covid wave 3)"
label values astwh_31_c3 yesno
tab astwh_31_c3


**** Summary of variables ****************************************************

tab asthma_30_c1
tab asthma_30_c2
tab asthma_31_c3
tab astwh_30_c1
tab astwh_30_c2
tab astwh_31_c3

**** Save ********************************************************************

keep NSID asthma_30_c1 asthma_30_c2 asthma_31_c3 astwh_30_c1 astwh_30_c2 astwh_31_c3
order NSID asthma_30_c1 asthma_30_c2 asthma_31_c3 astwh_30_c1 astwh_30_c2 astwh_31_c3

save "$working_path/NextSteps_asthma.dta", replace

********************************************************************************
*********************** REFORMAT INDICATORS TO DEPOSIT *************************
********************************************************************************

use "$working_path/NextSteps_asthma.dta", replace

rename (asthma_30_c1 asthma_30_c2 asthma_31_c3 astwh_30_c1 astwh_30_c2 astwh_31_c3) ///
(asthma_30_current1 asthma_30_current2 asthma_31_current3 asthmabronc_30_current1 asthmabronc_30_current2 asthmabronc_31_current3)

rename NSID nsid
lab var nsid "NSID - Cohort Member ID"	

* Sweep-specific indicators 
lab define depositlab1 1 "Asthma reported in sweep" ///
					   2 "No asthma reported in sweep" ///
					   -1 "No information provided" ///
					   -9 "Not in sweep"
foreach var in asthma_30_current1 asthma_30_current2 asthma_31_current3 asthmabronc_30_current1 asthmabronc_30_current2 asthmabronc_31_current3 {	
	recode `var' 0=2 .m=-1 .=-9			
	lab val `var' depositlab1 			
}
   
lab var asthma_30_current1 "Currently has asthma age 30 [Covid survey 1]"
lab var asthma_30_current2 "Currently has asthma age 30 [Covid survey 2]"
lab var asthma_31_current3 "Currently has asthma age 31 [Covid survey 3]"
lab var asthmabronc_30_current1 "Ever had asthma or wheezy bronchitis age 30 [Covid survey 1]"
lab var asthmabronc_30_current2 "Ever had asthma or wheezy bronchitis age 30 [Covid survey 2]"
lab var asthmabronc_31_current3 "Ever had asthma or wheezy bronchitis age 31 [Covid survey 3]"


* REMOVE THIS BEFORE DEPOSITING 	
log using "$working_path/NextSteps Codebook", replace 
codebook 
log close 

save "$working_path/harmonised_asthma_nextsteps.dta", replace

