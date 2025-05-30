 
****************************************************************
**** Coding for Harmonisation of physcial variables: ASTHMA ****
**** For MCS (Millenium Cohort Study) **************************
**** Martina Narayanan, December 2024 ***************************
****************************************************************

*set maxvar 10000


**** Set paths ***************************************************************
******************************************************************************

* Set input path to the folder that contain all MCS data files downloaded from UKDS *

global input_path "C:\Users\qtnvmna\OneDrive - University College London\CLS raw data recent\MCS"
global input_path2 "C:\Users\qtnvmna\OneDrive - University College London\CLS_studies_raw_data\COVID web survey"

* Set working path to store files
global working_path "C:\Users\qtnvmna\OneDrive - University College London\Harmonisation health\Coding\Asthma"

* Set paths to access each data file

global response "UKDA-8172-stata\stata\stata13\mcs_longitudinal_family_file.dta"
global age3 "UKDA-5350-stata\stata\stata13\mcs2_parent_cm_interview.dta"
global age5 "UKDA-5795-stata\stata\stata13\mcs3_parent_cm_interview.dta"
global age7 "UKDA-6411-stata\stata\stata13\mcs4_parent_cm_interview.dta"
global age11 "UKDA-7464-stata\stata\stata13\mcs5_parent_cm_interview.dta"
global age14 "UKDA-8156-stata\stata\stata13\mcs6_parent_cm_interview.dta"
global covid1 "UKDA-8658-stata\stata\stata13\covid-19_wave1_survey_cls.dta"
global covid2 "UKDA-8658-stata\stata\stata13\covid-19_wave2_survey_cls.dta"
global covid3 "UKDA-8658-stata\stata\stata13\covid-19_wave3_survey_cls.dta"


**** Prepare files, since MCS files cannot be easily merged ******************
******************************************************************************

use "$input_path/$response", replace
gen mcsid = MCSID + string(NOCMHH)
keep mcsid AAOUTC00 BAOUTC00 CAOUTC00 DAOUTC00 EAOUTC00 FAOUTC00 GAOUTC00
save "$working_path/mcs_response.dta", replace 

use "$input_path/$age3", replace 
keep if BELIG00==1 
gen mcsid = MCSID + string(BCNUM00)
keep mcsid BPASMA00
save "$working_path/mcs2_parent_cm_interview.dta", replace

use "$input_path/$age5", replace 
keep if CELIG00==1
gen mcsid = MCSID + string(CCNUM00)
keep mcsid CPASMA00 
save "$working_path/mcs3_parent_cm_interview.dta", replace

use "$input_path/$age7", replace 
keep if DELIG00==1 
gen mcsid = MCSID + string(DCNUM00)
keep mcsid DPASMA00
save "$working_path/mcs4_parent_cm_interview.dta", replace

use "$input_path/$age11", replace
keep if EELIG00==1 
gen mcsid = MCSID + string(ECNUM00)
keep mcsid EPASMA00 EPCLSX0X EPCLSI00
save "$working_path/mcs5_parent_cm_interview_asthma.dta", replace

use "$input_path/$age14", replace
keep if FELIG00==1 
gen mcsid = MCSID + string(FCNUM00)
keep mcsid FPASMA00
save "$working_path/mcs6_parent_cm_interview_asthma.dta", replace

use "$input_path2/$covid1", clear 
keep if CW1_COHORT==4 
gen mcsid = MCSID + string(CW1_CNUM00)
keep mcsid CW1_LLI_3 CW1_LLI_5 CW1_COHORT
save "$working_path/MCS_covid1.dta", replace

use "$input_path2/$covid2", clear 
keep if CW2_COHORT==4 
gen mcsid = MCSID + string(CW2_CNUM00)
keep mcsid CW2_LLI1_3 CW2_LLI1_5 CW2_COHORT
save "$working_path/MCS_covid2.dta", replace

use "$input_path2/$covid3", clear 
keep if CW3_COHORT==4
gen mcsid = MCSID + string(CW3_CNUM00)
keep mcsid CW3_LLI1_3 CW3_LLI1_5 CW3_COHORT
save "$working_path/MCS_covid3.dta", replace


**** Merge variables *********************************************************
******************************************************************************

use "$working_path/mcs_response.dta", replace

merge 1:1 mcsid using "$working_path/mcs2_parent_cm_interview.dta", nogen keep(match master)

merge 1:1 mcsid using "$working_path/mcs3_parent_cm_interview.dta", nogen keep(match master)

merge 1:1 mcsid using "$working_path/mcs4_parent_cm_interview.dta", nogen keep(match master)

merge 1:1 mcsid using "$working_path/mcs5_parent_cm_interview_asthma.dta", nogen keep(match master)

merge 1:1 mcsid using "$working_path/mcs6_parent_cm_interview_asthma.dta", nogen keep(match master)

merge 1:1 mcsid using "$working_path/MCS_covid1.dta", nogen keep(match master)

merge 1:1 mcsid using "$working_path/MCS_covid2.dta", nogen keep(match master)

merge 1:1 mcsid using "$working_path/MCS_covid3.dta", nogen keep(match master)


**** Wave 1 (9 months) *******************************************************
*No information on asthma

**** Wave 2 (Age 3) **********************************************************

label define yesno 0 "No" 1 "Yes" .m "DK/refused/not answered"

tab BPASMA00
gen asthma_3_e = BPASMA00
recode asthma_3_e (-1 3 -8=.)(1=1)(2=0)
replace asthma_3_e = .m if BAOUTC00==1 & asthma_3_e==.
label variable asthma_3_e  "Ever had asthma aged 3"
label values asthma_3_e yesno
tab asthma_3_e BAOUTC00, m


**** Wave 3 (Age 5) **********************************************************
tab CPASMA00 
gen asthma_5_e = CPASMA00 
recode asthma_5_e (-9 -8 -1=.)(1=1)(2=0)
replace asthma_5_e = .m if CAOUTC00==1 & asthma_5_e==.
label variable asthma_5_e  "Ever had asthma aged 5"
label values asthma_5_e yesno
tab asthma_5_e CAOUTC00, m


**** Wave 4 (Age 7) **********************************************************
tab DPASMA00
gen asthma_7_e = DPASMA00
recode asthma_7_e (-9 -8 -1=.)(1=1)(2=0)
replace asthma_7_e = .m if DAOUTC00==1 & asthma_7_e==.
label variable asthma_7_e  "Ever had asthma aged 7"
label values asthma_7_e yesno
tab asthma_7_e DAOUTC00, m


**** Wave 5 (Age 11) *********************************************************
tab EPASMA00
gen asthma_11_e = EPASMA00
recode asthma_11_e (-9 -8 -1=.)(1=1)(2=0)
replace asthma_11_e = .m if EAOUTC00==1 & asthma_11_e==.
label variable asthma_11_e  "Ever had asthma aged 11"
label values asthma_11_e yesno
tab asthma_11_e EAOUTC00, m

**** Wave 6 (Age 14) *********************************************************
tab FPASMA00
gen asthma_14_c = FPASMA00
recode asthma_14_c (-9 -8 -1=.)(1=1)(2=0)
replace asthma_14_c = .m if FAOUTC00==1 & asthma_14_c==.
label variable asthma_14_c  "Current asthma aged 14"
label values asthma_14_c yesno
tab asthma_14_c, m

**** Wave 7 (Age 17) *********************************************************
*no specific information on asthma

**** Covid wave 1 (Age 19) ***************************************************

tab CW1_LLI_3 
gen asthma_19_c1 = .
replace asthma_19_c1 = 1 if CW1_LLI_3==1  
replace asthma_19_c1 = 0 if CW1_LLI_3==2 
replace asthma_19_c1 = .m if  asthma_19_c1==. & CW1_COHORT==4
label variable asthma_19_c1 "Current asthma aged 19 (Covid wave 1)"
label values asthma_19_c1 yesno
tab asthma_19_c1, m

tab CW1_LLI_5
gen astwh_19_c1 = asthma_19_c1
replace astwh_19_c1 = 1 if CW1_LLI_5==1 
replace astwh_19_c1 = .m if astwh_19_c1==. & CW1_COHORT==4
label variable astwh_19_c1 "Current asthma or wheezy bronchitis aged 19 (Covid wave 1)"
label values astwh_19_c1 yesno
tab astwh_19_c1, m

**** Covid wave 2 (Age 19) ***************************************************
* merge wave 1 and 2 because if CM responded in wave 1 they were not asked in wave 2, and vice versa

tab CW1_LLI_3 
tab CW2_LLI1_3 
gen asthma_19_c2 = .
replace asthma_19_c2 = 1 if CW1_LLI_3==1 | CW2_LLI1_3==1 
replace asthma_19_c2 = 0 if CW1_LLI_3==2| CW2_LLI1_3==2 
replace asthma_19_c2 = .m if  asthma_19_c2==. & (CW1_COHORT==4 | CW2_COHORT==4)
label variable asthma_19_c2 "Current asthma aged 19 (Covid wave 2)"
label values asthma_19_c2 yesno
tab asthma_19_c2, m

tab CW1_LLI_5
tab CW2_LLI1_5
gen astwh_19_c2 = asthma_19_c2
replace astwh_19_c2 = 1 if CW1_LLI_5==1 | CW2_LLI1_5==1
replace astwh_19_c2 = .m if astwh_19_c2==. & (CW1_COHORT==4 | CW2_COHORT==4)
label variable astwh_19_c2 "Current asthma or wheezy bronchitis aged 19 (Covid wave 2)"
label values astwh_19_c2 yesno
tab astwh_19_c2, m

**** Covid wave 3 (Age 20) ***************************************************

tab CW3_LLI1_3 
gen asthma_20_c3 = CW3_LLI1_3
recode asthma_20_c3 (-8 -9 -1=.)(1=1)(2=0)
replace asthma_20_c3 = .m if CW3_COHORT==4 & asthma_20_c3==.
label variable asthma_20_c3 "Current asthma aged 20 (Covid wave 3)"
label values asthma_20_c3 yesno
tab asthma_20_c3 CW3_COHORT, m

tab CW3_LLI1_5
gen astwh_20_c3 = asthma_20_c
replace astwh_20_c3 = 1 if CW3_LLI1_5==1
replace astwh_20_c3 = .m if astwh_20_c3==. & CW3_COHORT!=.
label variable astwh_20_c3 "Current asthma or wheezy bronchitis aged 20 (Covid wave 3)"
label values astwh_20_c3 yesno
tab astwh_20_c3 CW3_COHORT, m

**** All indicators listed ***************************************************
******************************************************************************

tab asthma_3_e
tab asthma_5_e
tab asthma_7_e
tab asthma_11_e
tab asthma_14_c
tab asthma_19_c1
tab astwh_19_c1
tab asthma_19_c2
tab astwh_19_c2
tab asthma_20_c3
tab astwh_20_c3

**** Save data file **********************************************************
******************************************************************************

keep mcsid asthma_3_e asthma_5_e asthma_7_e asthma_11_e asthma_14_c asthma_19_c1 asthma_19_c2 ///
astwh_19_c1 astwh_19_c2 asthma_20_c3 astwh_20_c3

save "$working_path/MCS_asthma.dta", replace


*************************** CROSS-SWEEP INDICATORS ***************************
******************************************************************************

**** Cumulative 'ever measures'

use "$working_path/MCS_asthma.dta", replace

lab def bin1 0 "No" 1 "Yes" .m "Status uncertain"

*** For asthma 

gen asthma_3 =. 
replace asthma_3 = 1 if asthma_3_e==1
gen asthma_5 =.
replace asthma_5 = 1 if asthma_5_e==1 | asthma_3==1
gen asthma_7 =.
replace asthma_7 = 1 if asthma_7_e==1 | asthma_5==1
gen asthma_11 =. 
replace asthma_11 = 1 if asthma_11_e==1 | asthma_7==1

* Add in 0 if reported no to ever question at that sweep or after and not a 1 
* Remove those who didn't respond to that wave 

replace asthma_11 = 0 if asthma_11_e==0 & asthma_11==.
replace asthma_11 = .m if asthma_11_e==.m & asthma_11==.
replace asthma_11 = . if asthma_11_e==.
lab val asthma_11 bin1 
lab var asthma_11 "Ever had asthma by age 11"
tab asthma_11, m 

replace asthma_7 = .m if asthma_7_e==.m & asthma_11_e==1 & (asthma_5_e!=1 | asthma_3_e!=1) & asthma_7==.
replace asthma_7 = 0 if asthma_7_e==0 & asthma_7==.
replace asthma_7 = 0 if asthma_11_e==0 & asthma_7==.
replace asthma_7 = .m if (asthma_11_e==.m | asthma_7_e==.m) & asthma_7==.
replace asthma_7 = . if asthma_7_e==.
lab val asthma_7 bin1 
lab var asthma_7 "Ever had asthma by age 7"
tab asthma_7, m 

replace asthma_5 = .m if asthma_5_e==.m & asthma_7_e==1 & asthma_3!=1 & asthma_5==.
replace asthma_5 = 0 if asthma_5_e==0 & asthma_5==.
replace asthma_5 = 0 if asthma_7_e==0 & asthma_5==.
replace asthma_5 = 0 if asthma_11_e==0 & asthma_5==.
replace asthma_5 = .m if (asthma_5_e==.m | asthma_11_e==.m | asthma_7_e==.m) & asthma_5==.
replace asthma_5 = . if asthma_5_e==.
lab val asthma_5 bin1 
lab var asthma_5 "Ever had asthma by age 5"
tab asthma_5, m 

replace asthma_3 = .m if asthma_3_e==.m & asthma_5_e==1 & asthma_3==.
replace asthma_3 = 0 if asthma_3_e==0 & asthma_3==.
replace asthma_3 = 0 if asthma_5_e==0 & asthma_3==.
replace asthma_3 = 0 if asthma_7_e==0 & asthma_3==.
replace asthma_3 = 0 if asthma_11_e==0 & asthma_3==.
replace asthma_3 = .m if (asthma_3_e==.m | asthma_5_e==.m | asthma_11_e==.m | asthma_7_e==.m) & asthma_3==.
replace asthma_3 = . if asthma_3_e==.
lab val asthma_3 bin1 
lab var asthma_3 "Ever had asthma by age 3"
tab asthma_3, m 

keep mcsid asthma_3_e asthma_5_e asthma_7_e asthma_11_e asthma_14_c ///
asthma_19_c1 astwh_19_c1 asthma_19_c2 astwh_19_c2 asthma_20_c3 astwh_20_c3 ///
asthma_3 asthma_5 asthma_7 asthma_11

save "$working_path/MCS_asthma.dta", replace


********************************************************************************
*********************** REFORMAT INDICATORS TO DEPOSIT *************************
********************************************************************************

use "$working_path/MCS_asthma.dta", replace

rename (asthma_3_e asthma_5_e asthma_7_e asthma_11_e asthma_14_c ///
asthma_19_c1 astwh_19_c1 asthma_19_c2 astwh_19_c2 asthma_20_c3 astwh_20_c3 ///
asthma_3 asthma_5 asthma_7 asthma_11) ///
(asthma_3_ever asthma_5_ever asthma_7_ever asthma_11_ever asthma_14_current ///
asthma_19_current1 asthmabronc_19_current1 asthma_19_current2 asthmabronc_19_current2 asthma_20_current3 asthmabronc_20_current3 ///
asthma_3_cumul asthma_5_cumul asthma_7_cumul asthma_11_cumul)

* Split up MCSID into cnum and mcsid 
rename mcsid MCSID 
gen mcsid = ""
gen cnum = ""
replace mcsid = substr(MCSID, 1, strlen(MCSID) - 1)
replace cnum = substr(MCSID, strlen(MCSID), 1)
list MCSID mcsid cnum in 1/10 
destring cnum, replace
tab cnum, m 
drop MCSID

lab var mcsid "MCS Research ID - Anonymised Family/Household Identifier"
lab var cnum "Cohort member number in MCS household"

* Sweep-specific indicators 
lab define depositlab1 1 "Asthma reported in sweep" ///
					   2 "No asthma reported in sweep" ///
					   -1 "No information provided" ///
					   -9 "Not in sweep"
foreach var in asthma_3_ever asthma_5_ever asthma_7_ever asthma_11_ever asthma_14_current ///
asthma_19_current1 asthmabronc_19_current1 asthma_19_current2 asthmabronc_19_current2 asthma_20_current3 asthmabronc_20_current3 {   	
	recode `var' 0=2 .m=-1 .=-9			
	lab val `var' depositlab1 			
}
   
lab var asthma_3_ever "Ever had asthma age 3 [Sweep 2]"
lab var asthma_5_ever "Ever had asthma age 5 [Sweep 3]"
lab var asthma_7_ever "Ever had asthma age 7 [Sweep 4]"
lab var asthma_11_ever "Ever had asthma age 11 [Sweep 5]"
lab var asthma_14_current "Currently has asthma age 14 [Sweep 6]"
lab var asthma_19_current1 "Currently has asthma age 19 [Covid survey 1]"
lab var asthmabronc_19_current1 "Ever had asthma or wheezy bronchitis age 19 [Covid survey 1]"
lab var asthma_19_current2 "Currently has asthma age 19 [Covid survey 2]"
lab var asthmabronc_19_current2 "Ever had asthma or wheezy bronchitis age 19 [Covid survey 2]"
lab var asthma_20_current3 "Currently has asthma age 20 [Covid survey 3]"
lab var asthmabronc_20_current3 "Ever had asthma or wheezy bronchitis age 20 [Covid survey 3]"

* Cumulative indicators 
lab define depositlab2 1 "Asthma ever reported up to and including current sweep" ///
					   2 "No asthma reported up to and including current sweep" ///
					   -1 "Not enough information provided" ///
					   -9 "Not in sweep"
foreach var in asthma_3_cumul asthma_5_cumul asthma_7_cumul asthma_11_cumul {
	recode `var' 0=2 .m=-1 .=-9			
	lab val `var' depositlab2			   	
}
lab var asthma_3_cumul "Ever asthma by age 3 [cumulative]"
lab var asthma_5_cumul "Ever asthma by age 5 [cumulative]"
lab var asthma_7_cumul "Ever asthma by age 7 [cumulative]"
lab var asthma_11_cumul "Ever asthma by age 11 [cumulative]"

order mcsid cnum asthma_3_ever asthma_5_ever asthma_7_ever asthma_11_ever asthma_14_current ///
asthma_19_current1 asthma_19_current2 asthma_20_current3 asthmabronc_19_current1 asthmabronc_19_current2 asthmabronc_20_current3 ///
asthma_3_cumul asthma_5_cumul asthma_7_cumul asthma_11_cumul

* REMOVE THIS BEFORE DEPOSITING 	
*log using "$working_path/MCS Codebook", replace 
*codebook 
*log close 

save "$working_path/harmonised_asthma_mcs.dta", replace

