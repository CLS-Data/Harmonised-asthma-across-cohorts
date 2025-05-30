 
*****************************************************************************
**** Coding for Harmonisation of physcial variables: ASTHMA *****************
**** For BCS (1970 British Cohort Study) ************************************
**** Martina Narayanan, December 2024 ****************************************
*****************************************************************************

**** Set paths **************************************************************
*****************************************************************************

* Set input path to the folder that contain all NCDS data files downloaded from UKDS *

global input_path "C:\Users\qtnvmna\OneDrive - University College London\CLS raw data recent\BCS"

global input_path2 "C:\Users\qtnvmna\OneDrive - University College London\CLS_studies_raw_data\COVID web survey"

* Set working path to store files
global working_path "C:\Users\qtnvmna\OneDrive - University College London\Harmonisation health\Coding\Asthma"

* Set paths to access each data file

global response "UKDA-5641-stata\stata\stata13\bcs70_response_1970-2016.dta"
global birth "UKDA-2666-stata\stata\stata9\bcs7072a.dta"
global age2 "UKDA-2666-stata\stata\stata9\bcs7072b.dta"
global age5 "UKDA-2699-stata\stata\stata11\f699a.dta"
global age5b "UKDA-2699-stata\stata\stata11\f699b.dta"
global age10 "UKDA-3723-stata\stata\stata13_se\sn3723.dta"
global age16 "UKDA-3535-stata\stata\stata13_se\bcs7016x.dta"
global age26 "UKDA-3833-stata\stata\stata11\bcs96x.dta"
global age29 "UKDA-5558-stata\stata\stata11_se\bcs2000.dta"
global age34 "UKDA-5585-stata\stata\stata13_se\bcs_2004_followup.dta"
global age38 "UKDA-6557-stata\stata\stata11_se\bcs_2008_followup.dta"
global age42 "UKDA-7473-stata\stata\stata13\bcs70_2012_flatfile.dta"
global age46 "UKDA-8547-stata\stata\stata13\bcs_age46_main.dta"
global age51 "UKDA-9347-stata\stata\stata13\bcs11_age51_main.dta"
global covid1 "UKDA-8658-stata\stata\stata13\covid-19_wave1_survey_cls.dta"
global covid2 "UKDA-8658-stata\stata\stata13\covid-19_wave2_survey_cls.dta"
global covid3 "UKDA-8658-stata\stata\stata13\covid-19_wave3_survey_cls.dta"

* Prepare Covid waves to be merged later

use "$input_path2/$covid1", clear // Spring 2020 sweep
keep if CW1_COHORT==2
keep BCSID CW1_LLI_3 CW1_LLI_5 CW1_COHORT
save "$working_path/BCS_covid1.dta", replace

use "$input_path2/$covid2", clear // Spring 2020 sweep
keep if CW2_COHORT==2
keep BCSID CW2_LLI1_3 CW2_LLI1_5 CW2_COHORT
save "$working_path/BCS_covid2.dta", replace

use "$input_path2/$covid3", clear // Spring 2020 sweep
keep if CW3_COHORT==2
keep BCSID CW3_LLI1_3 CW3_LLI1_5 CW3_COHORT
save "$working_path/BCS_covid3.dta", replace


**** Merge variables ********************************************************
*****************************************************************************

*** Start with response data file to make sure we have the complete sample 
use "$input_path/$response", replace

keep BCSID SEX OUTCME01 OUTCME02 OUTCME03 OUTCME04 OUTCME05 OUTCME06 OUTCME07 OUTCME08 OUTCME09 OUTCME10

rename BCSID bcsid

merge 1:1 bcsid using "$input_path/$birth", keepusing(a0255) nogen keep(match master)

merge 1:1 bcsid using "$input_path/$age2", keepusing(b0155 b0156 b0157 b0158) nogen keep(match master)

merge 1:1 bcsid using "$input_path/$age5", keepusing(d003) nogen keep(match master)

merge 1:1 bcsid using "$input_path/$age5b", ///
keepusing(e087 e088 e089 e090 e091 e092 e093 e088) nogen keep(match master)

merge 1:1 bcsid using "$input_path/$age10", ///
keepusing(b7_1 b7_2 b7_3 b7_9 b7_10 b7_11 b7_12 b7_20 b19_1 b19_2 meb4_26 meb4_27 meb4_28 meb4_29 meb4_30 meb4_31 meb4_32 meb4_33 meb4_34 meb4_35 meb4_36 meb4_37 meb4_38 meb4_39 meb4_40 pent1_2 pent2_2 pent3_2 pent4_2 pent5_2 pent6_2 pent7_2 pent8_2 pent9_2 pent10_2 pent11_2 pent12_2 pent13_2 pent14_2 pent15_2 pent16_2 pent17_2 pent18_2 pent19_2 pent20_2 mea7_2 mea7_5 mea7_8 mea7_11 mea7_14 mea7_17 mea7_4 mea7_7 mea7_10 mea7_13 mea7_16 mea7_19) nogen keep(match master)

merge 1:1 bcsid using "$input_path/$age16", ///
keepusing(ob9_1 ob9_2 ob9_4 ob9_6 ob9_8 ob9_9 ob9_10 ob9_17 ob9_18 rc3_6 rc3_7) nogen keep(match master)

merge 1:1 bcsid using "$input_path/$age26", ///
keepusing(b960448 b960514 b960566 q41oth1 q41oth2 q41oth3 q41oth4 q41oth5 q41oth6) nogen keep(match master)

merge 1:1 bcsid using "$input_path/$age29", ///
keepusing(hhfbane1 hhfbane2 hhfbane3 hhfbane4 hhfbane5 cl1age4 cl112m4) nogen keep(match master)

merge 1:1 bcsid using "$input_path/$age34", ///
keepusing(bd7hpb01 b7asth2m b7lsiany b7khpb1 b7xlsa b7xlsb b7xlsc b7xlsd b7xlse b7xlsa2 b7xlsb2 b7xlsc2 b7xlsd2 ///
		   b7xlsa3 b7xlsb3 b7xlsc3 b7xlsa4 b7xlsb4 b7xlsa5 b7xlsb5 b7xlsa6 ///
		   b7xlsa7 b7xkhlba b7xkhlbb b7xkhlbc b7xkhlbd ///
		   b7lsge b7lsge2 b7lsge3 b7lsge4 b7lsge5 b7lsge6 b7lsge7) nogen keep(match master)
		   
merge 1:1 bcsid using "$input_path/$age38", ///
keepusing(b8khpb01) nogen keep(match master)

rename bcsid BCSID

merge 1:1 BCSID using "$input_path/$age42", ///
keepusing(B9KHPB02) nogen keep(match master)

merge 1:1 BCSID using "$input_path/$age46", ///
keepusing(B10KHPB01) nogen keep(match master)

rename BCSID bcsid

merge 1:1 bcsid using "$input_path/$age51", ///
keepusing(b11khlpb01 b11asthage b11outcome) nogen keep(match master)

rename bcsid BCSID

merge 1:1 BCSID using "$working_path/BCS_covid1.dta", ///
nogen keep(match master)

merge 1:1 BCSID using "$working_path/BCS_covid2.dta", ///
nogen keep(match master)

merge 1:1 BCSID using "$working_path/BCS_covid3.dta", ///
nogen keep(match master)

**** Wave 0 (Birth) *********************************************************
* No specific information

**** 22 month subsample *****************************************************

* Any infections? Responses coded into conditions
* Since this is a subsample it can't stand on it's own, but it can feed into the creation of cross-wave indicators

tab b0155 
tab b0156 
tab b0157 
tab b0158

gen asthma_22m_ls = .
replace asthma_22m_ls = 0 if b0155==2
replace asthma_22m_ls = 1 if b0155==1 & b0156==20
replace asthma_22m_ls = 1 if b0155==1 & b0157==20
replace asthma_22m_ls = 0 if b0155==1 & b0157!=20 & b0156!=20
replace asthma_22m_ls = .m if OUTCME01==1 & asthma_22m_ls==.
tab asthma_22m_ls OUTCME01, m

 
* Other questions about respiratory disease, with ICD9 codes at 22 months, but no occurence of asthma (ICD9 code 493)

**** Wave 1 (Age 5) *********************************************************

* Some questions about attacks of wheeziness whatever the cause, and followed up from there a question about what diagnosis the doctor gave

tab e087
tab e093
gen asthma_5_e = .
replace asthma_5_e = 1 if e093==1 | e093==2
replace asthma_5_e = 0 if e087==2 
replace asthma_5_e = 0 if e087==1 & (e093==3 | e093==4 | e093==5)
replace asthma_5_e = 0 if e087==3 & (e093==3 | e093==4 | e093==5)
replace asthma_5_e = .m if e087==1 & (e093==-3 | e093==-1)
replace asthma_5_e = .m if e087==3 & (e093==-3 | e093==-1)
replace asthma_5_e = .m if e087==-3|e087==-2
replace asthma_5_e = .m if OUTCME02==1 & asthma_5_e==.
label define yesno 0 "no" 1 "yes" .m "DK/refused/not answered"
label variable asthma_5_e "Ever had asthma aged 5"
label values asthma_5_e yesno
tab asthma_5_e OUTCME02, m

gen astwh_5_e = .
replace astwh_5_e = 1 if e093==1 | e093==2 | e093==3 
replace astwh_5_e = 0 if e087==2 
replace astwh_5_e = 0 if e087==1 & (e093==4 | e093==5)
replace astwh_5_e = 0 if e087==3 & (e093==4 | e093==5)
replace astwh_5_e = .m if e087==-3|e087==-2
replace astwh_5_e = .m if e087==1 & (e093==-2 | e093==-3)
replace astwh_5_e = .m if e087==3 & (e093==-2 | e093==-3)
replace astwh_5_e = .m if OUTCME02==1 & astwh_5_e==.
label variable astwh_5_e "Ever had asthma or wheezy bronchitis aged 5"
label values astwh_5_e yesno
tab astwh_5_e OUTCME02, m

* Age of first occurence
tab e088
gen aage_5 = e088
recode aage_5 (-3 -2 -1=.m)
replace aage_5 = .m if OUTCME02==1 & aage_5==.
gen asthmaage_5 = aage_5 if asthma_5_e == 1
label define age_5 0 "< 1 Year" 1 "1 - 2 Years" 2 "2 - 3 Years" 3 "3 - 4 Years" 4 "4 - 5 Years" 5 "> 5 Years"
label variable asthmaage_5 "Asthma age of first onset age 5"
label values asthmaage_5 age_5
tab asthmaage_5 OUTCME02, m

gen astwhage_5 = aage_5 if astwh_5_e == 1
label variable astwhage_5 "Asthma or wheezy bronchitis age of first onset age 5"
label values astwhage_5 age_5
tab astwhage_5 OUTCME02, m

* Use number of attacks in the last 12 months to create an indicator for current asthma10
tab e091
gen asthma_5_c = asthma_5_e
replace asthma_5_c = 0 if asthma_5_e==1 & e091==0
replace asthma_5_c = .m if asthma_5_e==1 & (e091==-4 | e091==-3 | e091==-1)
label variable asthma_5_c "Current asthma aged 5"
label values asthma_5_c yesno
tab asthma_5_c OUTCME02, m

gen astwh_5_c = astwh_5_e
replace astwh_5_c = 0 if astwh_5_e==1 & e091==0
replace astwh_5_c = .m if astwh_5_e==1 & (e091==-4 | e091==-3 | e091==-1)
label variable astwh_5_c "Current asthma or wheezy bronchitis aged 5"
label values astwh_5_c yesno
tab astwh_5_c OUTCME02, m


**** Wave 2 (Age 10) ********************************************************

tab b7_1 
tab b7_2
tab b7_3

gen asthma_10_e = .
replace asthma_10_e = 1 if b7_1==1 & b7_2==1
replace asthma_10_e = 0 if b7_1==2
replace asthma_10_e = .m if b7_1==3
replace asthma_10_e = 0 if b7_1==1 & b7_2!=1
replace asthma_10_e = .m if b7_1==1 & b7_2==-3
replace asthma_10_e = .m if OUTCME03==1 & asthma_10_e==.
label values asthma_10_e yesno
label variable asthma_10_e "Ever had asthma aged 10"
tab asthma_10_e OUTCME03, m

gen astwh_10_e = .
replace astwh_10_e = 1 if b7_2==1 | b7_3==1
replace astwh_10_e = 0 if b7_1==2
replace astwh_10_e = .m if b7_1==3
replace astwh_10_e = 0 if b7_1==1 & b7_2!=1 & b7_3!=1
replace astwh_10_e = .m if b7_1==1 & b7_2==-3 & b7_3==-3
replace astwh_10_e = .m if OUTCME03==1 & astwh_10_e==.
label values astwh_10_e yesno
label variable astwh_10_e "Ever had asthma or wheezy bronchitis aged 10"
tab astwh_10_e OUTCME03, m

* feed in information on longstanding illnesses
gen pent_indicator =.
forval i = 1/20 {
	replace pent_indicator = 1 if pent`i'_2 == "493" & b19_1 == 1 | ///
								  pent`i'_2 == "4930" & b19_1 == 1
} 

tab asthma_10_e pent_indicator, m
*one additional case identified where yes to asthma in longstanding illness while no to asthma in direct questions
replace asthma_10_e = 1 if pent_indicator==1
tab asthma_10_e OUTCME03, m
replace astwh_10_e = 1 if pent_indicator==1
*one case where recorded as dead but report on asthma

* age when it started
tab b7_9
tab b7_10
tab b7_11
tab b7_12
gen asthmaage_10 = .
replace asthmaage_10 = 1 if b7_9==1
replace asthmaage_10 = 2 if b7_9==. & b7_10==1
replace asthmaage_10 = 3 if b7_9==. & b7_10==. & b7_11==1
replace asthmaage_10 = 4 if b7_9==. & b7_10==. & b7_11==. & b7_12==1
replace asthmaage_10 = 0 if asthma_10_e==0
replace asthmaage_10 = . if asthma_10_e==.
replace asthmaage_10 = .m if OUTCME03==1 & asthmaage_10==.
label define age_10 0 "no asthma" 1 "under one" 2 "1 to 5" 3 "5 to 9" 4 "since 9"
label values asthmaage_10 age_10
label variable asthmaage_10 "When did asthma start?"
tab asthmaage_10 OUTCME03, m

gen astwhage_10 = .
replace astwhage_10 = 1 if b7_9==1
replace astwhage_10 = 2 if b7_9==. & b7_10==1
replace astwhage_10 = 3 if b7_9==. & b7_10==. & b7_11==1
replace astwhage_10 = 4 if b7_9==. & b7_10==. & b7_11==. & b7_12==1
replace astwhage_10 = 0 if astwh_10_e==0
replace astwhage_10 = . if astwh_10_e==.
replace astwhage_10 = .m if OUTCME03==1 & astwhage_10==.
label values astwhage_10 age_10
label variable astwhage_10 "When did asthma or wheezy bronchitis start?"
tab astwhage_10 OUTCME03, m

*current asthma
gen asthma_10_c = .
replace asthma_10_c = 1 if b7_12==1 & asthma_10_e==1
replace asthma_10_c = 0 if asthma_10_e==0
replace asthma_10_c = 0 if b7_9==1 & b7_12==. & asthma_10_e==1 
replace asthma_10_c = 0 if b7_10==1 & b7_12==. & asthma_10_e==1 
replace asthma_10_c = 0 if b7_11==1 & b7_12==. & asthma_10_e==1 
replace asthma_10_c = .m if OUTCME03==1 & asthma_10_c==.
label values asthma_10_c yesno
label variable asthma_10_c "Current asthma aged 10"
tab asthma_10_c OUTCME03, m

gen astwh_10_c = .
replace astwh_10_c = 1 if b7_12==1 & astwh_10_e==1
replace astwh_10_c = 0 if astwh_10_e==0
replace astwh_10_c = 0 if b7_9==1 & b7_12==. & astwh_10_e==1 
replace astwh_10_c = 0 if b7_10==1 & b7_12==. & astwh_10_e==1 
replace astwh_10_c = 0 if b7_11==1 & b7_12==. & astwh_10_e==1 
replace astwh_10_c = .m if OUTCME03==1 & astwh_10_c==.
label values astwh_10_c yesno
label variable astwh_10_c "Current asthma or wheezy bronchitis aged 10"
tab astwh_10_c OUTCME03, m

* This is wheezing during the past 12 months, not specific enough to determine whether it is asthma or wheezy bronchitis
* tab b7_20

* This is asthma at 10 based on doctor information
* one reported dead, one not issued but information here on this varaible nonetheless
tab meb4_26
tab meb4_27
tab meb4_28
tab meb4_29
tab meb4_30

gen asthma_10_ed = .
replace asthma_10_ed = 1 if meb4_26==1|meb4_27==1|meb4_28==1
replace asthma_10_ed = 0 if meb4_29==1
replace asthma_10_ed = .m if OUTCME03==1 & asthma_10_ed==.
label variable asthma_10_ed "Ever had asthma aged 10 reported by doctor"
label values asthma_10_ed yesno
tab asthma_10_ed OUTCME03, m

gen asthma_10_cd = .
replace asthma_10_cd = 1 if meb4_26==1
replace asthma_10_cd = 0 if meb4_29==1
replace asthma_10_cd = 0 if meb4_27==1 & meb4_26==.
replace asthma_10_cd = 0 if meb4_28==1 & meb4_26==.
replace asthma_10_cd = .m if OUTCME03==1 & asthma_10_cd==.
label variable asthma_10_cd "Current asthma aged 10 reported by doctor"
label values asthma_10_cd yesno
tab asthma_10_cd OUTCME03, m

tab asthma_10_e asthma_10_ed, m
tab asthma_10_c asthma_10_cd, m

* Feed in information about 'longstanding illness' from doctor reports (has now or ever had, so this can only feed in to ever indicators)

tab mea7_2
tab mea7_5
tab mea7_8
tab mea7_11
tab mea7_14
tab mea7_17

gen asthma_10_m = .m
gen asthmaage_10_m = .m
* & mea7_1 == 1 
foreach i in 2 5 8 11 14 17 {
	replace asthma_10_m = 1 if mea7_`i' == "493" | ///
								  mea7_`i' == "4930" | ///
								  mea7_`i' == "4930F" | ///
								  mea7_`i' == "4932" | ///
								  mea7_`i' == "4935"  | ///
								  mea7_`i' == "4939"  | ///
								  mea7_`i' == "4930X" | ///
								  mea7_`i' == "49390"
	if `i' == 2 {
		replace asthmaage_10_m = mea7_4 if asthma_10_m !=.m & asthmaage_10_m == .m
	} 
	if `i' == 5 {
		replace asthmaage_10_m = mea7_7 if asthma_10_m !=.m & asthmaage_10_m == .m 
	} 
	if `i' == 8 {
		replace asthmaage_10_m = mea7_10 if asthma_10_m !=.m & asthmaage_10_m == .m 
	} 
	if `i' == 11 {
		replace asthmaage_10_m = mea7_13 if asthma_10_m !=.m & asthmaage_10_m == .m
	} 
	if `i' == 14 {
		replace asthmaage_10_m = mea7_16 if asthma_10_m !=.m & asthmaage_10_m == .m
	} 
	if `i' == 17 {
		replace asthmaage_10_m = mea7_19 if asthma_10_m !=.m & asthmaage_10_m == .m
	} 
}
tab asthmaage_10_m, m 
tab asthma_10_m, m 

tab asthmaage_10 asthmaage_10_m, m
tab asthma_10_ed asthma_10_m, m 
* 8 cases where doctor reported no to direct asthma question but asthma came up as diagnosis in doctor report on longstanding illness type questions
* 11 cases where missing doctor report to direct asthma question but came up as diagnosis in doctor report on longstanding illness type questions
replace asthma_10_ed = 1 if asthma_10_m==1
tab asthma_10_ed OUTCME03, m

* derive doctor reported variables for asthma and wheezy bronchitis

tab meb4_31
tab meb4_32
tab meb4_33
tab meb4_34
tab meb4_35

gen astwh_10_ed = .
replace astwh_10_ed = 1 if meb4_26==1|meb4_27==1|meb4_28==1|meb4_31==1|meb4_32==1|meb4_33==1
replace astwh_10_ed = 0 if meb4_29==1 & meb4_34==1
replace astwh_10_ed = .m if OUTCME03==1 & astwh_10_ed==.
replace astwh_10_ed = 1 if asthma_10_m==1
label variable astwh_10_ed "Ever had asthma or wheezy bronchitis aged 10 reported by doctor"
label values astwh_10_ed yesno
tab astwh_10_ed OUTCME03, m

gen wheezy = .
replace wheezy = 1 if meb4_31==1
replace wheezy = 0 if meb4_34==1
replace wheezy = 0 if meb4_32==1 & meb4_31==.
replace wheezy = 0 if meb4_33==1 & meb4_31==.
replace wheezy = .m if OUTCME03==1 & wheezy==.

gen astwh_10_cd = .
replace astwh_10_cd = 1 if asthma_10_cd == 1 | wheezy == 1
replace astwh_10_cd = 0 if asthma_10_cd == 0 & wheezy == 0
replace astwh_10_cd = .m if asthma_10_cd == .m & wheezy == .m
replace astwh_10_cd = .m if asthma_10_cd == .m & wheezy == 0
replace astwh_10_cd = .m if asthma_10_cd == .m & wheezy == .
replace astwh_10_cd = .m if asthma_10_cd == 0 & wheezy == .m
replace astwh_10_cd = .m if asthma_10_cd == . & wheezy == .m
label variable astwh_10_cd "Current asthma or wheezy bronchitis aged 10 reported by doctor"
label values astwh_10_cd yesno
tab astwh_10_cd OUTCME03, m

**** Wave 4 (age 16) ********************************************************

* ever
tab ob9_1 
tab ob9_8
tab ob9_9 
tab ob9_10 

gen asthma_16_e = .
replace asthma_16_e = 1 if ob9_1==1 & ob9_8==1
replace asthma_16_e = 0 if ob9_1==2
replace asthma_16_e = 0 if ob9_1==1 & ob9_8!=1
replace asthma_16_e = .m if ob9_1==1 & ob9_8==2 & ob9_9==2 & ob9_10==2
replace asthma_16_e = .m if OUTCME04==1 & asthma_16_e==.
label variable asthma_16_e "Ever had asthma aged 16"
label values asthma_16_e yesno
tab asthma_16_e OUTCME04, m

gen astwh_16_e = .
replace astwh_16_e = 1 if ob9_1==1 & ob9_8==1
replace astwh_16_e = 1 if ob9_1==1 & ob9_9==1
replace astwh_16_e = 0 if ob9_1==2
replace astwh_16_e = 0 if ob9_1==1 & (ob9_8!=1 & ob9_9!=1)
replace astwh_16_e = .m if ob9_1==1 & ob9_8==2 & ob9_9==2 & ob9_10==2
replace astwh_16_e = .m if OUTCME04==1 & astwh_16_e==.
label variable astwh_16_e "Ever had asthma or wheezy bronchitis aged 16"
label values astwh_16_e yesno
tab astwh_16_e OUTCME04, m

* age started
tab ob9_2 
tab ob9_4 
tab ob9_6
tab ob9_17
*work with ob9_17 because less missing than on the other 3 variables
gen asthmaage_16 = ob9_17
recode asthmaage_16 (-4 -2 -1 8 = .)
replace asthmaage_16 = .n if asthma_16_e==0
replace asthmaage_16 = .n if asthma_16_e==.m
replace asthmaage_16 = .m if OUTCME04==1 & asthmaage_16==.
label define age_16 1 "Before 1st Birthday" 2 "1st-2nd Birthday" 3 "2nd-5th Birthday" 4 "5th-7th Birthday" 5 "7th-10th Birthday" 6 "> 10th not last 12mt" 7 "In last 12 months"
label values asthmaage_16 age_16
tab asthmaage_16 OUTCME04, m

gen astwhage_16 = ob9_17
recode astwhage_16 (-4 -2 -1 8 = .)
replace astwhage_16 = .n if astwh_16_e==0
replace astwhage_16 = .n if astwh_16_e==.m
replace astwhage_16 = .m if OUTCME04==1 & astwhage_16==.
label values astwhage_16 age_16
tab astwhage_16 OUTCME04, m

* current
tab ob9_18 
gen asthma_16_c = asthma_16_e
replace asthma_16_c = 0 if asthma_16_e==1 & ob9_18!=7
replace asthma_16_c = .m if asthma_16_e==1 & (ob9_18==-1 | ob9_18==-2 | ob9_18==-4 | ob9_18==8)
label variable asthma_16_c "Current asthma aged 16"
label values asthma_16_c yesno
tab asthma_16_c OUTCME04, m

tab ob9_18 
gen astwh_16_c = astwh_16_e
replace astwh_16_c = 0 if astwh_16_e==1 & ob9_18!=7
replace astwh_16_c = .m if astwh_16_e==1 & (ob9_18==-1 | ob9_18==-2 | ob9_18==-4 | ob9_18==8)
label variable astwh_16_c "Current asthma or wheezy bronchitis aged 16"
label values astwh_16_c yesno
tab astwh_16_c OUTCME04, m

* doctor report
tab rc3_6
gen asthma_16_ed = rc3_6
recode asthma_16_ed (-2 -1 5 =.)(1 2 3 6=1)(4=0)
replace asthma_16_ed = .m if OUTCME04==1 & asthma_16_ed==.
label variable asthma_16_ed "Ever had asthma age 16 doctor report"
label values asthma_16_ed yesno
tab asthma_16_ed OUTCME04, m

gen asthma_16_cd = rc3_6
recode asthma_16_cd (-2 -1 5 =.)(1 6=1)(2 3 4=0)
replace asthma_16_cd = .m if OUTCME04==1 & asthma_16_cd==.
label variable asthma_16_cd "Current asthma age 16 doctor report"
label values asthma_16_cd yesno
tab asthma_16_cd OUTCME04, m

tab asthma_16_e asthma_16_ed, m
tab asthma_16_c asthma_16_cd, m

tab rc3_7
gen wheezy_16 = rc3_7
recode wheezy_16 (-2 -1 5 =.)(1 2 3 6=1)(4=0)
replace wheezy_16 = .m if OUTCME04==1 & wheezy_16==.
gen astwh_16_ed = .
replace astwh_16_ed = 1 if asthma_16_ed ==1 | wheezy_16 ==1
replace astwh_16_ed = 0 if asthma_16_ed ==0 & wheezy_16 ==0
replace astwh_16_ed = .m if asthma_16_ed ==0 & wheezy_16 ==.m
replace astwh_16_ed = .m if asthma_16_ed ==.m & wheezy_16 ==.
replace astwh_16_ed = .m if asthma_16_ed ==.m & wheezy_16 ==0
replace astwh_16_ed = .m if asthma_16_ed ==. & wheezy_16 ==.m
replace astwh_16_ed = .m if asthma_16_ed ==.m & wheezy_16 ==.m
label variable astwh_16_ed "Ever had asthma or wheezy bronchitis aged 16 doctor report"
label values astwh_16_ed yesno
tab astwh_16_ed OUTCME04, m

gen wheezy_16c = rc3_7
recode wheezy_16c (-2 -1 5 =.)(1 6=1)(2 3 4=0)
replace wheezy_16c = .m if OUTCME04==1 & wheezy_16c==.
gen astwh_16_cd = .
replace astwh_16_cd = 1 if asthma_16_cd ==1 | wheezy_16c ==1
replace astwh_16_cd = 0 if asthma_16_cd ==0 & wheezy_16c ==0
replace astwh_16_cd = .m if asthma_16_cd ==0 & wheezy_16c ==.m
replace astwh_16_cd = .m if asthma_16_cd ==.m & wheezy_16c ==.
replace astwh_16_cd = .m if asthma_16_cd ==.m & wheezy_16c ==0
replace astwh_16_cd = .m if asthma_16_cd ==. & wheezy_16c ==.m
replace astwh_16_cd = .m if asthma_16_cd ==.m & wheezy_16c ==.m
label variable astwh_16_cd "Current asthma or wheezy bronchitis aged 16 doctor report"
label values astwh_16_cd yesno
tab astwh_16_cd OUTCME04, m

* we can differentiate between start of onset before 1 and after 1, but that no more than that, so decided not to create an age of onset variable for doctor diagnosis

**** Wave 5 (Age 26) ********************************************************

* Item is not have you ever, but instead have you had it since 16. So the last 10 years, therefore we feed in age 16 information

tab b960448
gen asthma_26_e = b960448
replace asthma_26_e = 1 if asthma_26_e==0 & asthma_16_e==1
replace asthma_26_e = .m if asthma_26_e==0 & (asthma_16_e==.m | asthma_16_e==.)
replace asthma_26_e = .m if OUTCME05==1 & asthma_26_e==.
label value asthma_26_e yesno
label variable asthma_26_e "Ever had asthma aged 26"
tab asthma_26_e OUTCME05, m

* enrich with longstanding illness variable
global Dis q41oth1 q41oth2 q41oth3 q41oth4 q41oth5 q41oth6  
gen OthDisDiab =. 
foreach diag in $Dis {
	replace OthDisDiab = 1 if b960566 == 1 & (`diag' == 493)
} 
tab OthDisDiab OUTCME05, m 
tab asthma_26_e OthDisDiab, m 
replace asthma_26_e = 1 if OthDisDiab==1
tab asthma_26_e OUTCME05, m

*current

tab b960514
gen asthma_26_c = asthma_26_e
replace asthma_26_c = 0 if b960514!=1 & asthma_26_e==1
replace asthma_26_c = .m if OUTCME05==1 & asthma_26_c==.
label variable asthma_26_c "Current asthma aged 26"
label values asthma_26_c yesno
tab asthma_26_c OUTCME05, m

**** Wave 6 (Age 30) ********************************************************

* ever had
tab hhfbane1 
tab hhfbane2
tab hhfbane3
tab hhfbane4
tab hhfbane5
tab cl1age4
tab cl112m4

gen asthma_30_e = hhfbane1
recode asthma_30_e (1 2 3 5 6= 0)(4=1)(8 9=.)
replace asthma_30_e = 1 if hhfbane2==4|hhfbane3==4|hhfbane4==4|hhfbane5==4
replace asthma_30_e = .m if OUTCME06==1 & asthma_30_e==.
label values asthma_30_e yesno
label variable asthma_30_e "Ever had asthma aged 30"
tab asthma_30_e OUTCME06, m

* age started
tab cl1age4
recode cl1age4 (99 98=.)
gen asthma30age = cl1age4

* now
tab cl112m4
gen asthma_30_c = asthma_30_e
replace asthma_30_c = 0 if cl112m4==2
replace asthma_30_c = .m if cl112m4==8
label variable asthma_30_c "Current asthma aged 30"
label values asthma_30_c yesno
tab asthma_30_c


**** Wave 7 (Age 34) ********************************************************

* Use longstanding illness responses to create indicator for asthma since no direct question about just asthma
tab b7lsiany 
tab b7xlsa
tab b7khpb1
tab b7xkhlba

global lsi b7xlsa b7xlsb b7xlsc b7xlsd b7xlse b7xlsa2 b7xlsb2 b7xlsc2 b7xlsd2 ///
		   b7xlsa3 b7xlsb3 b7xlsc3 b7xlsa4 b7xlsb4 b7xlsa5 b7xlsb5 b7xlsa6 ///
		   b7xlsa7 b7xkhlba b7xkhlbb b7xkhlbc b7xkhlbd
gen asthma_34_l =.
replace asthma_34_l = 0 if b7lsiany==2 & b7khpb1==2
replace asthma_34_l = 0 if b7lsiany==1 & asthma_34_l!=1
replace asthma_34_l = 0 if b7khpb1==1 & asthma_34_l!=1	
foreach diag in $lsi {
	replace asthma_34_l = 1 if `diag' == "J45"  
} 
replace asthma_34_l = .m if OUTCME07==1 & asthma_34_l==.
label variable asthma_34_l "Current asthma based on longstanding illness question aged 34"
label values asthma_34_l yesno
tab asthma_34_l OUTCME07, m


* Find age at diagnosis for these
rename b7lsge b7lsge1 // renaming so easier to loop
forval i = 1/7 {
	recode b7lsge`i' -9/-8=.m -1=.n 
}
global lsi1 b7xlsa  b7xlsb  b7xlsc b7xlsd b7xlse
global lsi2 b7xlsa2 b7xlsb2 b7xlsc2 b7xlsd2
global lsi3 b7xlsa3 b7xlsb3 b7xlsc3 
global lsi4 b7xlsa4 b7xlsb4  
global lsi5 b7xlsa5 b7xlsb5
global lsi6 b7xlsa6 
global lsi7 b7xlsa7 
gen asthmaage1 =. 
foreach diag in $lsi1 {
	replace asthmaage1 = b7lsge1 if `diag' == "J45" 
}
gen asthmaage2 =. 
foreach diag in $lsi2 {
	replace asthmaage2 = b7lsge2 if `diag' == "J45"
}
gen asthmaage3 =. 
foreach diag in $lsi3 {
	replace asthmaage3 = b7lsge3 if `diag' == "J45"
}
gen asthmaage4 =. 
foreach diag in $lsi4 {
	replace asthmaage4 = b7lsge4 if `diag' == "J45"
}
gen asthmaage5 =. 
foreach diag in $lsi5 {
	replace asthmaage5 = b7lsge5 if `diag' == "J45" 
}
gen asthmaage6 =. 
foreach diag in $lsi6 {
	replace asthmaage6 = b7lsge6 if `diag' == "J45"  
}
gen asthmaage7 =. 
foreach diag in $lsi7 {
	replace asthmaage7 = b7lsge7 if `diag' == "J45"  
}
egen asthmaage_34 = rowmin(asthmaage1 asthmaage2 asthmaage3 asthmaage4 asthmaage5 asthmaage6 ///
						 asthmaage7) 
replace asthmaage_34 = .n if OUTCME07==1 & asthma_34_l==0
replace asthmaage_34 = .m if OUTCME07==1 & asthmaage_34==.
tab asthmaage_34 OUTCME07, m
tab asthma_34_l asthmaage_34,m

* Indicators for asthma and wheezy bronchitis grouped together
* WARNING: It looks like information collected since last interview so bring in previous waves. Unfortunately we only have asthma from age 30 and 26, not wheezy bronchitis, so that information is missing

tab bd7hpb01 
tab b7asth2m 

gen astwh_34_e = bd7hpb01 
recode astwh_34_e (-9 -8 -7=.m)
replace astwh_34_e = .m if OUTCME07==1 & astwh_34_e==.
replace astwh_34_e = 1 if asthma_30_e==1 & OUTCME07==1
replace astwh_34_e = 1 if astwh_16_e==1 & OUTCME07==1
label variable astwh_34_e "Ever had asthma or wheezy bronchitis aged 34 (limited information)"
label values astwh_34_e yesno
tab astwh_34_e OUTCME07, m

gen astwh_34_c = astwh_34_e
replace astwh_34_c = 0 if b7asth2m==2
replace astwh_34_c = .m if OUTCME07==1 & astwh_34_c==.
label variable astwh_34_c "Current asthma or wheezy bronchitis aged 34"
label values astwh_34_c yesno
tab astwh_34_c OUTCME07, m


**** Wave 8 (Age 38) ********************************************************
* only asthma and wheezy bronchitis grouped together


tab b8khpb01
gen astwh_38_c = b8khpb01
recode astwh_38_c (-8 -1=.m)
replace astwh_38_c = .m if OUTCME08==1 & astwh_38_c==.
label variable astwh_38_c "Current asthma or wheezy bronchitis aged 38"
label values astwh_38_c yesno
tab astwh_38_c OUTCME08, m

**** Wave 9 (Age 42) ********************************************************
* only asthma and wheezy bronchitis grouped together
* WARNING: note that it asks 'since last wave' and 38 was currently, so include 34 ever question as well (still possible we missed some who had this condition after 34 but not at 38)

tab B9KHPB02
gen astwh_42_e = B9KHPB02
recode astwh_42_e (-1=.m)
replace astwh_42_e = 1 if OUTCME09==1 & astwh_38_c==1
replace astwh_42_e = 1 if OUTCME09==1 & astwh_34_e==1
replace astwh_42_e = .m if OUTCME09==1 & astwh_42_e==.
label variable astwh_42_e "Ever had asthma or wheezy bronchitis aged 42 (limited information)"
label values astwh_42_e yesno
tab astwh_42_e OUTCME09, m

**** Wave 10 (Age 46) *******************************************************
* only asthma and wheezy bronchitis grouped together
* since last interview have you had, so need to feed in information from age 42, but since that is based on limited information this one is therefore also limited

tab B10KHPB01
gen astwh_46_e = B10KHPB01
recode astwh_46_e (-8=.m)
replace astwh_46_e = 1 if OUTCME10==1 & astwh_42_e==1
replace astwh_46_e = .m if OUTCME10==1 & astwh_46_e==.
label variable astwh_46_e "Ever had asthma or wheezy bronchitis aged 46"
label values astwh_46_e yesno
tab astwh_46_e OUTCME10, m

**** Wave 11 (Age 51)

tab b11khlpb01 
gen astwh_51_e = b11khlpb01
recode astwh_51_e (-9 -8 -3 -2 -1=.m)
replace astwh_51_e = 1 if astwh_46_e==1 & (b11outcome==1 | b11outcome==2)
replace astwh_51_e = .m if astwh_51_e==. & (b11outcome==1 | b11outcome==2)
label values astwh_51_e yesno
label variable astwh_51_e "Ever had asthma or wheezy bronchitis aged 51"

tab b11asthage
gen astwhage_51 = b11asthage
recode astwhage_51 (-8 -3 -1=.m)

**** Covid wave 1 (Age 50) **************************************************

tab CW1_LLI_3  
gen asthma_50_c1 = .
replace asthma_50_c1 = 1 if CW1_LLI_3==1
replace asthma_50_c1 = 0 if CW1_LLI_3==2
replace asthma_50_c1 = .m if asthma_50_c1==. & CW1_COHORT==2
label variable asthma_50_c1 "Current asthma aged 50 (Covid survey wave 1)"
label values asthma_50_c1 yesno
tab asthma_50_c1, m

tab CW1_LLI_5
gen astwh_50_c1 = asthma_50_c1
replace astwh_50_c1 = 1 if CW1_LLI_5==1 
replace astwh_50_c1 = .m if asthma_50_c1==. & CW1_COHORT==2
label values astwh_50_c1 yesno
label var astwh_50_c1 "Current asthma or wheezy bronchitis aged 50 (Covid wave 1)"
tab astwh_50_c1, m

**** Covid wave 2 (Age 50) **************************************************

tab CW1_LLI_3  
tab CW2_LLI1_3 
gen asthma_50_c2 = .
replace asthma_50_c2 = 1 if CW1_LLI_3==1 | CW2_LLI1_3==1
replace asthma_50_c2 = 0 if CW1_LLI_3==2 | CW2_LLI1_3==2
replace asthma_50_c2 = .m if asthma_50_c2==. & (CW1_COHORT==2 |CW2_COHORT==2)
label variable asthma_50_c2 "Current asthma aged 50 (Covid survey wave 2)"
label values asthma_50_c2 yesno
tab asthma_50_c2, m

tab CW1_LLI_5
tab CW2_LLI1_5
gen astwh_50_c2 = asthma_50_c2
replace astwh_50_c2 = 1 if CW1_LLI_5==1 | CW2_LLI1_5==1
replace astwh_50_c2 = .m if asthma_50_c2==. & (CW1_COHORT==2 |CW2_COHORT==2)
label values astwh_50_c2 yesno
label var astwh_50_c2 "Current asthma or wheezy bronchitis aged 50 (Covid wave 2)"
tab astwh_50_c2, m

**** Covid wave 3 (Age 51) **************************************************

tab CW3_LLI1_3 
gen asthma_51_c3 = CW3_LLI1_3
recode asthma_51_c3 (-8 -9 -1=.)(1=1)(2=0)
replace asthma_51_c3 = .m if CW3_COHORT==2 & asthma_51_c3==.
label variable asthma_51_c3 "Current asthma aged 51 (Covid survey wave 3)"
label values asthma_51_c3 yesno
tab asthma_51_c3 CW3_COHORT, m

tab CW3_LLI1_5
gen astwh_51_c3 = asthma_51_c3
replace astwh_51_c3 = 1 if CW3_LLI1_5==1
replace astwh_51_c3 = .m if (CW3_LLI1_5==-8|CW3_LLI1_5==-9|CW3_LLI1_5==-1) & asthma_51_c3!=1
label values astwh_51_c3 yesno
label var astwh_51_c3 "Current asthma or wheezy bronchitis aged 51 (Covid wave 3)"
tab astwh_51_c3 CW3_COHORT, m

**** All indicators listed ***************************************************

tab asthma_22m_ls
tab asthma_5_e
tab astwh_5_e
tab asthmaage_5
tab astwhage_5
tab asthma_5_c
tab astwh_5_c
tab asthma_10_e
tab astwh_10_e
tab asthmaage_10
tab astwhage_10
tab asthma_10_c
tab astwh_10_c
tab asthma_10_ed 
tab asthma_10_cd
tab asthmaage_10_m
tab astwh_10_ed
tab astwh_10_cd
tab asthma_16_e
tab astwh_16_e
tab asthmaage_16
tab astwhage_16
tab asthma_16_c
tab astwh_16_c
tab asthma_16_ed
tab asthma_16_cd
tab astwh_16_ed
tab astwh_16_cd
tab asthma_26_e
tab asthma_26_c
tab asthma_30_e
tab asthma30age
tab asthma_30_c
tab asthma_34_l
tab asthmaage_34
tab astwh_34_e
tab astwh_34_c
tab astwh_38_c
tab astwh_42_e
tab astwh_46_e
tab astwh_51_e
tab astwhage_51
tab asthma_50_c1
tab astwh_50_c1
tab asthma_50_c2
tab astwh_50_c2
tab asthma_51_c3
tab astwh_51_c3

**** Save data file **********************************************************
******************************************************************************

keep BCSID SEX asthma_22m_ls asthma_5_e astwh_5_e asthmaage_5 astwhage_5 asthma_5_c ///
astwh_5_c asthma_10_e astwh_10_e asthmaage_10 astwhage_10 asthma_10_c astwh_10_c ///
asthma_10_ed asthma_10_cd asthmaage_10_m astwh_10_ed astwh_10_cd asthma_16_e ///
astwh_16_e asthmaage_16 astwhage_16 asthma_16_c astwh_16_c asthma_16_ed asthma_16_cd ///
astwh_16_ed astwh_16_cd asthma_26_e asthma_26_c asthma_30_e asthma30age asthma_30_c ///
asthma_34_l asthmaage_34 astwh_34_e astwh_34_c astwh_38_c astwh_42_e astwh_46_e ///
astwh_51_e astwhage_51 asthma_50_c1 astwh_50_c1 asthma_50_c2 astwh_50_c2 asthma_51_c3 astwh_51_c3

save "$working_path/BCS_asthma.dta", replace


*************************** CROSS-SWEEP INDICATORS *****************************

**** Cumulative 'ever measures'

use "$working_path/BCS_asthma.dta", replace

lab def bin1 0 "No" 1 "Yes" .m "Status uncertain"

*** For asthma 

gen asthma_5 =. 
replace asthma_5 = 1 if asthma_5_e == 1 | asthma_5_c ==1 | asthma_22m_ls ==1
gen asthma_10 = .
replace asthma_10 = 1 if asthma_10_e==1 | asthma_10_c==1 | asthma_10_ed==1 | asthma_10_cd==1 | asthma_5==1
gen asthma_16 = .
replace asthma_16 = 1 if asthma_16_e==1 | asthma_16_c==1 | asthma_16_ed==1 | asthma_16_cd==1 | asthma_10==1
gen asthma_26 = .
replace asthma_26 = 1 if asthma_26_e==1 | asthma_26_c==1 | asthma_16==1
gen asthma_30 = .
replace asthma_30 = 1 if asthma_30_e==1 | asthma_30_c==1 | asthma_26==1

* Age when first found out had asthma

recode asthmaage_10 (0=.m)(1=0)(2=5)(3 4=10), into(asthmaage_10_r)
recode asthmaage_10_m (-5 -4 -3=.m), into(asthmaage_10_m_r)
recode asthmaage_16 (1=0)(2=1)(3=5) (4=7)(5=10)(6 7=16), into(asthmaage_16_r)
gen asthmaage =. 
replace asthmaage = .n if asthma_30 != 1 // last cumulative indicator is a no 
replace asthmaage = asthmaage_5 if (asthmaage_5 != .m & asthmaage_5 != .n) & asthmaage ==. 
replace asthmaage = asthmaage_10_r if asthmaage ==. & (asthmaage_10_r != .m & asthmaage_10_r!= .n) 
replace asthmaage = asthmaage_10_m_r if asthmaage ==. & (asthmaage_10_m_r != .m & asthmaage_10_m_r != .n)
replace asthmaage = asthmaage_16_r if asthmaage ==. & (asthmaage_16_r!= .m & asthmaage_16_r!= .n)
replace asthmaage = asthma30age if asthmaage ==. & (asthma30age!= .m & asthma30age!= .n)
replace asthmaage = asthmaage_34 if asthmaage ==. & (asthmaage_34!= .m & asthmaage_34!= .n)

* Use age first found out had asthma
replace asthma_5 = 1 if asthmaage <= 5
replace asthma_10 = 1 if asthmaage <= 10
replace asthma_16 = 1 if asthmaage <= 16
replace asthma_26 = 1 if asthmaage <= 26
replace asthma_30 = 1 if asthmaage <= 30

* Add in 0 if reported no to ever question at that sweep or after and not a 1 
* Remove those who didn't respond to that wave 

replace asthma_30 = 0 if asthma_30_e == 0 & asthma_30 ==.
replace asthma_30 = 0 if astwh_34_e == 0 & asthma_30 ==.
replace asthma_30 = 0 if astwh_42_e == 0 & asthma_30 ==.
replace asthma_30 = 0 if astwh_46_e == 0 & asthma_30 ==.
replace asthma_30 = .m if (asthma_30_e==.m | astwh_34_e==.m | astwh_42_e==.m | astwh_46_e==.m) & asthma_30==.
replace asthma_30 = . if asthma_30_e == .
lab val asthma_30 bin1  
lab var asthma_30 "Ever had asthma by age 30"
tab asthma_30, m 

replace asthma_26 = 0 if asthma_26_e == 0 & asthma_26 == .
replace asthma_26 = 0 if asthma_30_e == 0 & asthma_26 ==.
replace asthma_26 = 0 if astwh_34_e == 0 & asthma_26 ==.
replace asthma_26 = 0 if astwh_42_e == 0 & asthma_26 ==.
replace asthma_26 = 0 if astwh_46_e == 0 & asthma_26 ==.
replace asthma_26 = .m if (asthma_26_e == .m | asthma_30_e == .m | astwh_34_e==.m | astwh_42_e == .m | astwh_46_e == .m) & asthma_26 == .
replace asthma_26 = . if asthma_26_e ==.
lab val asthma_26 bin1 
lab var asthma_26 "Ever had asthma by age 26"
tab asthma_26, m 

replace asthma_16 = 0 if asthma_16_e == 0 & asthma_16 == .
replace asthma_16 = 0 if asthma_16_ed == 0 & asthma_16 == .
replace asthma_16 = 0 if asthma_26_e == 0 & asthma_16 == .
replace asthma_16 = 0 if asthma_30_e == 0 & asthma_16 ==.
replace asthma_16 = 0 if astwh_34_e == 0 & asthma_16 ==.
replace asthma_16 = 0 if astwh_42_e == 0 & asthma_16 ==.
replace asthma_16 = 0 if astwh_46_e == 0 & asthma_16 ==.
replace asthma_16 = .m if (asthma_16_e == .m | asthma_26_e == .m | asthma_30_e == .m | astwh_34_e==.m | astwh_42_e == .m | astwh_46_e == .m) & asthma_16 == .
replace asthma_16 = . if asthma_16_e ==.
lab val asthma_16 bin1 
lab var asthma_16 "Ever had asthma by age 16"
tab asthma_16, m 

replace asthma_10 = 0 if asthma_10_e == 0 & asthma_10 == .
replace asthma_10 = 0 if asthma_10_ed == 0 & asthma_10 == .
replace asthma_10 = 0 if asthma_16_e == 0 & asthma_10 == .
replace asthma_10 = 0 if asthma_16_ed == 0 & asthma_10 == .
replace asthma_10 = 0 if asthma_26_e == 0 & asthma_10 == .
replace asthma_10 = 0 if asthma_30_e == 0 & asthma_10 ==.
replace asthma_10 = 0 if astwh_34_e == 0 & asthma_10 ==.
replace asthma_10 = 0 if astwh_42_e == 0 & asthma_10 ==.
replace asthma_10 = 0 if astwh_46_e == 0 & asthma_10 ==.
replace asthma_10 = .m if (asthma_10_e==.m | asthma_16_e==.m | asthma_26_e==.m | asthma_30_e==.m | astwh_34_e==.m | astwh_42_e==.m | astwh_46_e==.m) & asthma_10==.
replace asthma_10 = . if asthma_10_e ==.
lab val asthma_10 bin1 
lab var asthma_10 "Ever had asthma by age 10"
tab asthma_10, m 

replace asthma_5 = 0 if asthma_5_e == 0 & asthma_5 == .
replace asthma_5 = 0 if asthma_10_e == 0 & asthma_5 == .
replace asthma_5 = 0 if asthma_10_ed == 0 & asthma_5 == .
replace asthma_5 = 0 if asthma_16_e == 0 & asthma_5 == .
replace asthma_5 = 0 if asthma_16_ed == 0 & asthma_5 == .
replace asthma_5 = 0 if asthma_26_e == 0 & asthma_5 == .
replace asthma_5 = 0 if asthma_30_e == 0 & asthma_5 ==.
replace asthma_5 = 0 if astwh_34_e == 0 & asthma_5 ==.
replace asthma_5 = 0 if astwh_42_e == 0 & asthma_5 ==.
replace asthma_5 = 0 if astwh_46_e == 0 & asthma_5 ==.
replace asthma_5 = .m if (asthma_5_e==.m | asthma_10_e==.m | asthma_16_e==.m | asthma_26_e==.m | asthma_30_e==.m | astwh_34_e==.m | astwh_42_e==.m | astwh_46_e==.m) & asthma_5==.
replace asthma_5 = . if asthma_5_e ==.
lab val asthma_5 bin1 
lab var asthma_5 "Ever had asthma by age 5"
tab asthma_5, m 


*** For asthma and wheezy bronchitis

gen astwh_5 =. 
replace astwh_5 = 1 if astwh_5_e == 1 | astwh_5_c ==1 | asthma_22m_ls ==1
gen astwh_10 = .
replace astwh_10 = 1 if astwh_10_e==1 | astwh_10_c==1 | astwh_10_ed==1 | astwh_10_cd==1 | astwh_5==1
gen astwh_16 = .
replace astwh_16 = 1 if astwh_16_e==1 | astwh_16_c==1 | astwh_16_ed==1 | astwh_16_cd==1 | astwh_10==1
gen astwh_34 = .
replace astwh_34 = 1 if astwh_34_e==1 | astwh_34_c==1 | asthma_26_e==1 | asthma_26_c==1 | asthma_30_e==1 | asthma_30_c==1 | astwh_16==1
gen astwh_42 = .
replace astwh_42 = 1 if astwh_42_e==1 | astwh_38_c==1 | astwh_34==1
gen astwh_46 = .
replace astwh_46 = 1 if astwh_46_e==1 | astwh_42==1
gen astwh_51 = .
replace astwh_51 = 1 if astwh_51_e==1 | astwh_50_c1==1 | astwh_50_c2==1 | astwh_51_c3==1 | astwh_46 ==1

* Age when first found out had asthma

recode astwhage_10 (0=.m)(1=0)(2=5)(3 4=10), into(astwhage_10_r)
recode astwhage_16 (1=0)(2=1)(3=5) (4 5=10)(6 7=16), into(astwhage_16_r)
gen astwhage =. 
replace astwhage = .n if astwh_46 != 1 // last cumulative indicator is a no 
replace astwhage = astwhage_5 if astwhage ==. & (astwhage_5 != .m & astwhage_5 != .n)
replace astwhage = asthmaage_10_m_r if astwhage ==. & (asthmaage_10_m_r != .m & asthmaage_10_m_r != .n) 
replace astwhage = astwhage_10_r if astwhage ==. & (astwhage_10_r != .m & astwhage_10_r!= .n) 
replace astwhage = astwhage_16_r if astwhage ==. & (astwhage_16_r!= .m & astwhage_16_r!= .n)
replace astwhage = asthma30age if astwhage ==. & (asthma30age!= .m & asthma30age!= .n)
replace astwhage = asthmaage_34 if astwhage ==. & (asthmaage_34!= .m & asthmaage_34!= .n)
replace astwhage = astwhage_51 if astwhage ==. & (astwh_51!= .m & astwh_51!= .n)

* Use age first found out had asthma
replace astwh_5 = 1 if astwhage <= 5
replace astwh_10 = 1 if astwhage <= 10
replace astwh_16 = 1 if astwhage <= 16
replace astwh_34 = 1 if astwhage <= 34
replace astwh_51 = 1 if astwhage <= 51

* Add in 0 if reported no to ever question at that sweep or after and not a 1 
* Remove those who didn't respond to that wave 

replace astwh_51 = 0 if astwh_51_e == 0 & astwh_51 ==.
replace astwh_51 = .m if astwh_51_e == .m & astwh_51 ==.
replace astwh_51 = . if astwh_51_e == .
lab val astwh_51 bin1
lab var astwh_51 "Ever had asthma or wheezy bronchitis by age 51"
tab astwh_51, m

replace astwh_46 = 0 if astwh_46_e == 0 & astwh_46 ==.
replace astwh_46 = 0 if astwh_51_e == 0 & astwh_46 ==.
replace astwh_46 = .m if (astwh_46_e==.m | astwh_51_e==.m) & astwh_46==.
replace astwh_46 = . if astwh_46_e == .
lab val astwh_46 bin1 
lab var astwh_46 "Ever had asthma or wheezy bronchitis by age 46"
tab astwh_46, m 

replace astwh_42 = 0 if astwh_42_e == 0 & astwh_42 ==.
replace astwh_42 = 0 if astwh_46_e == 0 & astwh_42 ==.
replace astwh_42 = 0 if astwh_51_e == 0 & astwh_42 ==.
replace astwh_42 = .m if (astwh_42_e==.m |astwh_46_e==.m |astwh_51_e==.m) & astwh_42==.
replace astwh_42 = . if astwh_42_e == .
lab val astwh_42 bin1 
lab var astwh_42 "Ever had asthma or wheezy bronchitis by age 42"
tab astwh_42, m 

replace astwh_34 = 0 if astwh_34_e == 0 & astwh_34 ==.
replace astwh_34 = 0 if astwh_42_e == 0 & astwh_34 ==.
replace astwh_34 = 0 if astwh_46_e == 0 & astwh_34 ==.
replace astwh_34 = 0 if astwh_51_e == 0 & astwh_34 ==.
replace astwh_34 = .m if (astwh_34_e ==.m | astwh_42_e==.m |astwh_46_e==.m |astwh_51_e==.m) & astwh_34==.
replace astwh_34 = . if astwh_34_e == .
lab val astwh_34 bin1 
lab var astwh_34 "Ever had asthma or wheezy bronchitis by age 34"
tab astwh_34, m 

replace astwh_16 = 0 if astwh_16_e == 0 & astwh_16 ==.
replace astwh_16 = 0 if astwh_16_ed == 0 & astwh_16 ==.
replace astwh_16 = 0 if astwh_34_e == 0 & astwh_16 ==.
replace astwh_16 = 0 if astwh_42_e == 0 & astwh_16 ==.
replace astwh_16 = 0 if astwh_46_e == 0 & astwh_16 ==.
replace astwh_16 = 0 if astwh_51_e == 0 & astwh_16 ==.
replace astwh_16 = .m if (astwh_16_e ==.m | astwh_34_e ==.m | astwh_42_e==.m |astwh_46_e==.m |astwh_51_e==.m) & astwh_16==.
replace astwh_16 = . if astwh_16_e == .
lab val astwh_16 bin1 
lab var astwh_16 "Ever had asthma or wheezy bronchitis by age 16"
tab astwh_16, m 

replace astwh_10 = 0 if astwh_10_e == 0 & astwh_10 ==.
replace astwh_10 = 0 if astwh_10_ed == 0 & astwh_10 ==.
replace astwh_10 = 0 if astwh_16_e == 0 & astwh_10 ==.
replace astwh_10 = 0 if astwh_16_ed == 0 & astwh_10 ==.
replace astwh_10 = 0 if astwh_34_e == 0 & astwh_10 ==.
replace astwh_10 = 0 if astwh_42_e == 0 & astwh_10 ==.
replace astwh_10 = 0 if astwh_46_e == 0 & astwh_10 ==.
replace astwh_10 = 0 if astwh_51_e == 0 & astwh_10 ==.
replace astwh_10 = .m if (astwh_10_e ==.m | astwh_16_e ==.m | astwh_34_e ==.m | astwh_42_e==.m |astwh_46_e==.m |astwh_51_e==.m) & astwh_10==.
replace astwh_10 = . if astwh_10_e == .
lab val astwh_10 bin1 
lab var astwh_10 "Ever had asthma or wheezy bronchitis by age 10"
tab astwh_10, m 

replace astwh_5 = 0 if astwh_5_e == 0 & astwh_5 ==.
replace astwh_5 = 0 if astwh_10_e == 0 & astwh_5 ==.
replace astwh_5 = 0 if astwh_10_ed == 0 & astwh_5 ==.
replace astwh_5 = 0 if astwh_16_e == 0 & astwh_5 ==.
replace astwh_5 = 0 if astwh_16_ed == 0 & astwh_5 ==.
replace astwh_5 = 0 if astwh_34_e == 0 & astwh_5 ==.
replace astwh_5 = 0 if astwh_42_e == 0 & astwh_5 ==.
replace astwh_5 = 0 if astwh_46_e == 0 & astwh_5 ==.
replace astwh_5 = .m if (astwh_5_e ==.m | astwh_10_e ==.m | astwh_16_e ==.m | astwh_34_e ==.m | astwh_42_e==.m |astwh_46_e==.m |astwh_51_e==.m) & astwh_5==.
replace astwh_5 = . if astwh_5_e == .
lab val astwh_5 bin1 
lab var astwh_5 "Ever had asthma or wheezy bronchitis by age 5"
tab astwh_5, m 

keep BCSID asthma_5_e asthma_5_c asthma_10_e asthma_10_c asthma_10_ed asthma_10_cd ///
asthma_16_e asthma_16_c asthma_16_ed asthma_16_cd  asthma_26_e asthma_26_c asthma_30_e asthma_30_c ///
asthma_50_c1 asthma_50_c2 asthma_51_c3 ///
astwh_5_e astwh_5_c astwh_10_e astwh_10_c astwh_10_ed astwh_10_cd astwh_16_e astwh_16_c astwh_16_ed astwh_16_cd  ///
astwh_34_e astwh_34_c astwh_38_c astwh_42_e astwh_46_e astwh_51_e astwh_50_c1 astwh_50_c2 astwh_51_c3 ///
asthma_5 asthma_10 asthma_16 asthma_26 asthma_30 ///
astwh_5 astwh_10 astwh_16 astwh_34 astwh_42 astwh_46 astwh_51

order BCSID asthma_5_e asthma_5_c asthma_10_e asthma_10_c asthma_10_ed asthma_10_cd ///
asthma_16_e asthma_16_c asthma_16_ed asthma_16_cd  asthma_26_e asthma_26_c asthma_30_e asthma_30_c ///
asthma_50_c1 asthma_50_c2 asthma_51_c3 ///
astwh_5_e astwh_5_c astwh_10_e astwh_10_c astwh_10_ed astwh_10_cd astwh_16_e astwh_16_c astwh_16_ed astwh_16_cd  ///
astwh_34_e astwh_34_c astwh_38_c astwh_42_e astwh_46_e astwh_51_e astwh_50_c1 astwh_50_c2 astwh_51_c3 ///
asthma_5 asthma_10 asthma_16 asthma_26 asthma_30 ///
astwh_5 astwh_10 astwh_16 astwh_34 astwh_42 astwh_46 astwh_51 

save "$working_path/BCS_asthma.dta", replace


********************************************************************************
*********************** REFORMAT INDICATORS TO DEPOSIT *************************
********************************************************************************

use "$working_path/BCS_asthma.dta", replace

rename (asthma_5_e asthma_5_c asthma_10_e asthma_10_c asthma_10_ed asthma_10_cd ///
asthma_16_e asthma_16_c asthma_16_ed asthma_16_cd  asthma_26_e asthma_26_c asthma_30_e asthma_30_c ///
asthma_50_c1 asthma_50_c2 asthma_51_c3 ///
astwh_5_e astwh_5_c astwh_10_e astwh_10_c astwh_10_ed astwh_10_cd astwh_16_e astwh_16_c astwh_16_ed astwh_16_cd  ///
astwh_34_e astwh_34_c astwh_38_c astwh_42_e astwh_46_e astwh_51_e astwh_50_c1 astwh_50_c2 astwh_51_c3 ///
asthma_5 asthma_10 asthma_16 asthma_26 asthma_30 ///
astwh_5 astwh_10 astwh_16 astwh_34 astwh_42 astwh_46 astwh_51) ///
(asthma_5_ever asthma_5_current asthma_10_ever asthma_10_current asthma_10_everdoc asthma_10_currentdoc ///
asthma_16_ever asthma_16_current asthma_16_everdoc asthma_16_currentdoc  asthma_26_ever asthma_26_current asthma_30_ever asthma_30_current ///
asthma_50_current1 asthma_50_current2 asthma_51_current3 ///
asthmabronc_5_ever asthmabronc_5_current asthmabronc_10_ever asthmabronc_10_current asthmabronc_10_everdoc asthmabronc_10_currentdoc asthmabronc_16_ever asthmabronc_16_current asthmabronc_16_everdoc asthmabronc_16_currentdoc  ///
asthmabronc_34_ever_ltd asthmabronc_34_current asthmabronc_38_current asthmabronc_42_ever_ltd asthmabronc_46_ever_ltd asthmabronc_51_ever_ltd asthmabronc_50_current1 asthmabronc_50_current2 asthmabronc_51_current3 ///
asthma_5_cumul asthma_10_cumul asthma_16_cumul asthma_26_cumul asthma_30_cumul ///
asthmabronc_5_cumul asthmabronc_10_cumul asthmabronc_16_cumul asthmabronc_34_cumul_ltd asthmabronc_42_cumul_ltd asthmabronc_46_cumul_ltd asthmabronc_51_cumul_ltd)

rename BCSID bcsid
lab var bcsid "BCSID - Cohort Member ID"	

* Sweep-specific indicators 
lab define depositlab1 1 "Asthma reported in sweep" ///
					   2 "No asthma reported in sweep" ///
					   -1 "No information provided" ///
					   -9 "Not in sweep"
foreach var in asthma_5_ever asthma_5_current asthma_10_ever asthma_10_current asthma_10_everdoc asthma_10_currentdoc ///
asthma_16_ever asthma_16_current asthma_16_everdoc asthma_16_currentdoc  asthma_26_ever asthma_26_current asthma_30_ever asthma_30_current ///
asthma_50_current1 asthma_50_current2 asthma_51_current3 ///
asthmabronc_5_ever asthmabronc_5_current asthmabronc_10_ever asthmabronc_10_current asthmabronc_10_everdoc asthmabronc_10_currentdoc asthmabronc_16_ever asthmabronc_16_current asthmabronc_16_everdoc asthmabronc_16_currentdoc  ///
asthmabronc_34_ever_ltd asthmabronc_34_current asthmabronc_38_current asthmabronc_42_ever_ltd asthmabronc_46_ever_ltd asthmabronc_51_ever_ltd /// 
asthmabronc_50_current1 asthmabronc_50_current2 asthmabronc_51_current3 {   	
	recode `var' 0=2 .m=-1 .=-9			
	lab val `var' depositlab1 			
}
   
lab var asthma_5_ever "Ever had asthma age 5 [Sweep 2]"
lab var asthma_5_current "Currently has asthma age 5 [Sweep 2]"
lab var asthma_10_ever "Ever had asthma age 10 [Sweep 3]"
lab var asthma_10_current "Currently has asthma age 10 [Sweep 3]"
lab var asthma_10_everdoc "Ever had asthma age 10 doctor report [Sweep 3]"
lab var asthma_10_currentdoc "Currently has asthma age 10 doctor report [Sweep 3]"
lab var asthma_16_ever "Ever had asthma age 16 [Sweep 4]"
lab var asthma_16_current "Currently has asthma age 16 [Sweep 4]"
lab var asthma_16_everdoc "Ever had asthma age 16 doctor report [Sweep 4]"
lab var asthma_16_currentdoc "Currently has asthma age 16 doctor report [Sweep 4]"
lab var asthma_26_ever "Ever had asthma age 26 [Sweep 5]"
lab var asthma_26_current "Currently has asthma age 26 [Sweep 5]"
lab var asthma_30_ever "Ever had asthma age 30 [Sweep 6]"
lab var asthma_30_current "Currently has asthma age 30 [Sweep 6]"
lab var asthma_50_current1 "Currently has asthma age 50 [Covid survey 1]"
lab var asthma_50_current2 "Currently has asthma age 50 [Covid survey 2]"
lab var asthma_51_current3 "Currently has asthma age 51 [Covid survey 3]"
lab var asthmabronc_5_ever "Ever had asthma or wheezy bronchitis age 5 [Sweep 2]"
lab var asthmabronc_5_current "Currently has asthma or wheezy bronchitis age 5 [Sweep 2]"
lab var asthmabronc_10_ever "Ever had asthma or wheezy bronchitis age 10 [Sweep 3]"
lab var asthmabronc_10_current "Currently has asthma or wheezy bronchitis age 10 [Sweep 3]"
lab var asthmabronc_10_everdoc "Ever had asthma or wheezy bronchitis age 10 doctor report [Sweep 3]"
lab var asthmabronc_10_currentdoc "Currently has asthma or wheezy bronchitis age 10 doctor report [Sweep 3]"
lab var asthmabronc_16_ever "Ever had asthma or wheezy bronchitis age 16 [Sweep 4]"
lab var asthmabronc_16_current "Currently has asthma or wheezy bronchitis age 16 [Sweep 4]"
lab var asthmabronc_16_everdoc "Ever had asthma or wheezy bronchitis age 16 doctor report [Sweep 4]"
lab var asthmabronc_16_currentdoc "Currently has asthma or wheezy bronchitis age 16 doctor report [Sweep 4]"
lab var asthmabronc_34_ever_ltd "Ever had asthma or wheezy bronchitis age 34 [Sweep 7, limited information]"
lab var asthmabronc_34_current "Currently has asthma or wheezy bronchitis age 34 [Sweep 7]"
lab var asthmabronc_38_current "Currently has asthma or wheezy bronchitis age 38 [Sweep 8]"
lab var asthmabronc_42_ever_ltd "Ever had asthma or wheezy bronchitis age 42 [Sweep 9, limited information]"
lab var asthmabronc_46_ever_ltd "Ever had asthma or wheezy bronchitis age 46 [Sweep 10, limited information]"
lab var asthmabronc_51_ever_ltd "Ever had asthma or wheezy bronchitis age 51 [Sweep 11, limited information]"
lab var asthmabronc_50_current1 "Currently has asthma or wheezy bronchitis age 50 [Covid survey 1]"
lab var asthmabronc_50_current2 "Currently has asthma or wheezy bronchitis age 50 [Covid survey 2]"
lab var asthmabronc_51_current3 "Currently has asthma or wheezy bronchitis age 51 [Covid survey 3]"

* Cumulative indicators 
lab define depositlab2 1 "Asthma ever reported up to and including current sweep" ///
					   2 "No asthma reported up to and including current sweep" ///
					   -1 "Not enough information provided" ///
					   -9 "Not in sweep"
foreach var in asthma_5_cumul asthma_10_cumul asthma_16_cumul asthma_26_cumul asthma_30_cumul ///
asthmabronc_5_cumul asthmabronc_10_cumul asthmabronc_16_cumul asthmabronc_34_cumul_ltd ///
asthmabronc_42_cumul_ltd asthmabronc_46_cumul_ltd asthmabronc_51_cumul_ltd {
	recode `var' 0=2 .m=-1 .=-9			
	lab val `var' depositlab2			   	
}
lab var asthma_5_cumul "Ever asthma by age 5 [cumulative]"
lab var asthma_10_cumul "Ever asthma by age 10 [cumulative]"
lab var asthma_16_cumul "Ever asthma by age 16 [cumulative]"
lab var asthma_26_cumul "Ever asthma by age 26 [cumulative]"
lab var asthma_30_cumul "Ever asthma by age 30 [cumulative]"
lab var asthmabronc_5_cumul "Ever asthma or wheezy bronchitis by age 5 [cumulative]"
lab var asthmabronc_10_cumul "Ever asthma or wheezy bronchitis by age 10 [cumulative]"
lab var asthmabronc_16_cumul "Ever asthma or wheezy bronchitis by age 16 [cumulative]"
lab var asthmabronc_34_cumul_ltd "Ever asthma or wheezy bronchitis by age 34 [cumulative, limited information]"
lab var asthmabronc_42_cumul_ltd "Ever asthma or wheezy bronchitis by age 42 [cumulative, limited information]"
lab var asthmabronc_46_cumul_ltd "Ever asthma or wheezy bronchitis by age 46 [cumulative, limited information]"
lab var asthmabronc_51_cumul_ltd "Ever asthma or wheezy bronchitis by age 51 [cumulative, limited information]"

* REMOVE THIS BEFORE DEPOSITING 	
log using "$working_path/BCS Codebook", replace 
codebook 
log close 

save "$working_path/harmonised_asthma_bcs.dta", replace
