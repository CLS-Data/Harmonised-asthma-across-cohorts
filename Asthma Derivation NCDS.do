
****************************************************************
**** Coding for Harmonisation of physcial variables: ASTHMA ****
**** For NCDS (National Child Development Study) ***************
**** Martina Narayanan, Last updated: 11/12/2024 ****************
****************************************************************

**** Set paths ****
*******************

* Set input path to the folder that contain all NCDS data files downloaded from UKDS *

global input_path "C:\Users\qtnvmna\OneDrive - University College London\CLS raw data recent\NCDS"
global input_path2 "C:\Users\qtnvmna\OneDrive - University College London\CLS_studies_raw_data\COVID web survey"

* Set working path to store files

global working_path "C:\Users\qtnvmna\OneDrive - University College London\Harmonisation health\Coding\Asthma"

* Set paths to access each data file

global response "UKDA-5560-stata\stata\stata11\ncds_response.dta"
global age7_11_16 "UKDA-5565-stata\stata\stata11\ncds0123.dta"
global age23 "UKDA-5566-stata\stata\stata9\ncds4.dta"
global age33 "UKDA-5567-stata\stata\stata11_se\ncds5cmi.dta"
global age42 "UKDA-5578-stata\stata\stata9_se\ncds6.dta"
global age46 "UKDA-5579-stata\stata\stata9\ncds7.dta"
global age50 "UKDA-6137-stata\stata\stata9_se\ncds_2008_followup.dta"
global age55 "UKDA-7669-stata\stata\stata11\ncds_2013_flatfile.dta"
global covid1 "UKDA-8658-stata\stata\stata13\covid-19_wave1_survey_cls.dta"
global covid2 "UKDA-8658-stata\stata\stata13\covid-19_wave2_survey_cls.dta"
global covid3 "UKDA-8658-stata\stata\stata13\covid-19_wave3_survey_cls.dta"

* Prepare Covid waves to be merged later

use "$input_path2/$covid1", clear
keep if CW1_COHORT==1
keep NCDSID CW1_LLI_3 CW1_LLI_5 CW1_COHORT
save "$working_path/NCDS_covid1.dta", replace

use "$input_path2/$covid2", clear
keep if CW2_COHORT==1
keep NCDSID CW2_LLI1_3 CW2_LLI1_5 CW2_COHORT
save "$working_path/NCDS_covid2.dta", replace

use "$input_path2/$covid3", clear
keep if CW3_COHORT==1
keep NCDSID CW3_LLI1_3 CW3_LLI1_5 CW3_COHORT
save "$working_path/NCDS_covid3.dta", replace


**** Merge variables ****
*************************

*** Start with response data file to make sure we have the complete sample 

use "$input_path/$response", replace
keep NCDSID N622 OUTCME00 OUTCME01 OUTCME02 OUTCME03 OUTCME04 OUTCME05 OUTCME06 OUTCMEBM OUTCME07 OUTCME08 OUTCME09
rename NCDSID ncdsid 

merge 1:1 ncdsid using "$input_path/$age7_11_16", ///
keepusing(n259 n260 n1484 n1306 n1305 n2662 n2663 n2664 n2665 n2666 n2667 n2623 n2622 n2621 n2618 n2619 n2620 n2617 n2618 n2619 n2620 n1850 n1484) nogen keep(match master)

merge 1:1 ncdsid using "$input_path/$age23", ///
keepusing(n5773 n5772 n5771 n5770 n6458 n6461 n5740 n6464 n6467 n6558 n5873 n5741) nogen keep(match master)

merge 1:1 ncdsid using "$input_path/$age33", ///
keepusing(n504021 n504023 n504024 n504025 n503915 n503918 n503919 n503920 n509031 n509034 n509037 n509040) nogen keep(match master)

merge 1:1 ncdsid using "$input_path/$age42", ///
keepusing(hhfbane1 hhfbane2 hhfbane3 hhfbane4 hhfbane5 cl1age4 cl112m4 cl1doc4 inhaler) nogen keep(match master)

merge 1:1 ncdsid using "$input_path/$age46", ///
keepusing(n7xlsa n7xlsb n7xlsc n7xlsd n7xlse n7xlsa2 n7xlsb2 n7xlsc2 n7xlsd2 ///
n7xlsa3 n7xlsb3 n7xlsc3 n7xlsa4 n7xlsb4 n7xlsc4 n7xlsa5 n7xlsb5 ///
n7xlsa6 n7xlsa7 n7xlsa8 n7xhpa n7xhpb n7xhpc n7xhpd n7xhpa2 ///
n7xhpb2 n7xhpc2 n7xhpa3 n7xhpa4 n7xhpa5 n7lsiany n7lsge n7lsge2 n7lsge3 n7lsge4 n7lsge5 n7lsge6 n7lsge7 n7lsge8) nogen keep(match master)

rename ncdsid NCDSID
merge 1:1 NCDSID using "$input_path/$age50", /// 
keepusing(N8KHPB01 N8ASTDOC N8XLSA01 N8XLSA02 N8XLSA03 N8XLSA04 N8XLSA05 N8XLSA06 N8XLSA07 ///
N8XLSA08 N8XLSA09 N8XLSA10 N8XLSA11 N8XKHP01 N8XASTDC) nogen keep(match master)

merge 1:1 NCDSID using "$input_path/$age55", ///
keepusing(N9KHPB01 N9KHPB02) nogen keep(match master)

merge 1:1 NCDSID using "$working_path/NCDS_covid1.dta", ///
nogen keep(match master)

merge 1:1 NCDSID using "$working_path/NCDS_covid2.dta", ///
nogen keep(match master)

merge 1:1 NCDSID using "$working_path/NCDS_covid3.dta", ///
nogen keep(match master)


**** Indicators for asthma at each time point ****
**************************************************

label define yesno 0 "No" 1 "Yes" .m "DK/refused/not answered"

* General note: Since asthma is grouped with wheezy bronchitis at multiple time points we create indicator variables for both asthma and asthma grouped with wheezy bronchitis when possible

**** No information at wave 0 (birth) ****************************************

**** Age 7 *******************************************************************

* Creating an indicator for asthma
tab n259 
tab n259, nolab

gen asthma_7_e = n259
recode asthma_7_e (-1 1=.m)(3=0)(2=1)
replace asthma_7_e = .m if asthma_7_e ==. & OUTCME01==1
label values asthma_7_e yesno
label var asthma_7_e "Ever had asthma aged 7"
tab asthma_7_e
tab asthma_7_e OUTCME01, m

* Creating an indicator for asthma and wheezy bronchitis grouped together
tab n260
tab n260, nolab
gen astwh_7_e = asthma_7_e
replace astwh_7_e = 1 if n260 == 2
replace astwh_7_e = 0 if n260 == 3 & asthma_7_e == 0
replace astwh_7_e = .m if n260 == 1 & asthma_7_e != 1
replace astwh_7_e = .m if n260 == -1 & asthma_7_e != 1
lab val astwh_7_e yesno
lab var astwh_7_e "Ever had asthma or wheezy bronchitis aged 7"
tab astwh_7_e
tab astwh_7_e OUTCME01, m

* doctor reported item
tab n1850 
gen asthma_7_ed = n1850
recode asthma_7_ed (-1 1=.m)(2=1)(3=0)
replace asthma_7_ed = .m if asthma_7_ed ==. & OUTCME01==1
label values asthma_7_ed yesno
label var asthma_7_ed "Ever had asthma aged 7 doctor report"
tab asthma_7_ed

**** Age 11 ******************************************************************

* Indicator for asthma
tab n1305
tab n1305, nolab
gen asthma_11_e = n1305
recode asthma_11_e (-1 4=.m) (1=1)(2 3=0)
replace asthma_11_e= .m if OUTCME02==1 & asthma_11_e==.
label values asthma_11_e yesno
label var asthma_11_e "Ever had asthma aged 11"
tab asthma_11_e
tab asthma_11_e OUTCME02, m

* Creating another indicator variable asthma grouped with wheezy bronchitis 
gen astwh_11_e = n1305
recode astwh_11_e (-1 4=.m) (1 2=1)(3=0)
replace astwh_11_e= .m if OUTCME02==1 & astwh_11_e==.
label values astwh_11_e yesno
label var astwh_11_e "Ever had asthma or wheezy bronchitis aged 11"
tab astwh_11_e
tab astwh_11_e OUTCME02, m

* n1306 for frequency of attacks, not useful

* Time period variable for later use, before or after 7
tab n1484 
gen astwhage_11 = n1484
recode astwhage_11 (-1 5=.m)(1=0)(2 6 7=1)(3=2)(4=3)(8 9 10=4)(11=5)(12=6)
replace astwhage_11= .m if OUTCME02==1 & astwhage_11==.
label define age11 0 "No asthma/wheezy bron chitis after infancy" 1 "Before 7th year only" 2 "After 7th year, not now" 3 "Before & after 7th year, not now" 4 "After 7th year and now" 5 "Asthma, no detail" 6 "Query diagnosis" .m "DK/refused/not answered"
label values astwhage_11 age11
label var astwhage_11 "Had asthma or wheezy bronchitis other than in infancy, age 11"
tab astwhage_11 OUTCME02, m

* n1321 - n1325 for five reasons why absent from school for more than a week, asthma and wheeziness one of the categories, not including in this round because it's based on school absence

* doctor reported item
tab n1484
gen astwh_11_ed = n1484
recode astwh_11_ed (-1 -9 5 12 = .m)(1=0) (2 3 4 6 7 8 9 10 11=1)
replace astwh_11_ed= .m if OUTCME02==1 & astwh_11_ed==.
label values astwh_11_ed yesno
label var astwh_11_ed "Ever had asthma or wheezy bronchitis aged 11 doctor report"
tab astwh_11_ed

gen astwh_11_cd = n1484
recode astwh_11_cd (8 9 10=1)(-1 -9 5 12 = .m)(1 2 3 4 6 7 11=0)
replace astwh_11_cd= .m if OUTCME02==1 & astwh_11_cd==.
label values astwh_11_cd yesno
label var astwh_11_cd "Current asthma or wheezy bronchitis aged 11 doctor report"
tab astwh_11_cd


**** Age 16 ******************************************************************

* Information on asthma and wheezy bronchitis grouped together

tab n2617
gen astwh_16_e = n2617
recode astwh_16_e (-1 3=.m) (2=0)
replace astwh_16_e = .m if OUTCME03==1 & astwh_16_e==.
label values astwh_16_e yesno
label var astwh_16_e "Ever had asthma or wheezy bronchitis aged 16"
tab astwh_16_e OUTCME03, m

* now code whether visited doctor for asthma in the last 12 months
* since these are routed, they only provide additional information, not useful for contributing to diagnostic status
* not possible to differentiate NA and no asthma, so both are .m
/*
tab n2618
tab n2619 
tab n2620
recode n2618 n2619 n2620 (-1 2=.m)(0 1=0)(3 4 5=1), into(n2618_r n2619_r n2620_r)
gen astwhdoc_16 = n2618_r
replace astwhdoc_16 = 2 if n2619_r==2 | n2620_r==2
replace astwhdoc_16 = .n if astwh_16_e==0
replace astwhdoc_16 = .m if OUTCME03==1 & astwhdoc_16==.
label define doc .n "No asthma" 0 "No doctor visit" 1 "Yes doctor visit" .m "DK/refused/not answered"
label values astwhdoc_16 
label var astwhdoc_16 "Seen a doctor for asthma or wheezy bronchitis age 16"
tab astwhdoc_16 OUTCME03, m
*/

* Age asthma started
tab n2621 
gen astwhage_16 = n2621
recode astwhage_16 (-1 7=.m)
replace astwhage_16 = .m if OUTCME03==1 & astwhage_16==.
replace astwhage_16 = .n if astwh_16_e==0
label define age16 .n "No asthma" 1 "Before 1 year" 2 "Between 1&2 yrs" 3 "Between 2&5 yrs" 4 "Between 5&7 yrs" 5 "Between 7&11 yrs" 6 "Since 11th year" .m "DK/refused/not answered"
label values astwhage_16 age16
label var astwhage_16 "First attack of asthma or wheezy bronchitis"
tab astwhage_16 OUTCME03, m
replace astwh_16_e = 1 if astwhage_16!=. & astwhage_16!=.n & astwhage_16!=.m /// one case where first attack valid value but previous NA to asthma question

* Current asthma or wheezy bronchitis

tab n2622
recode n2622 (-1 8=.m)(1 2 3 4 5 6=0)(7=1), into(n2622_r)
gen astwh_16_c = astwh_16_e
replace astwh_16_c = 0 if n2622_r==0
replace astwh_16_c = .m if astwh_16_e==1 & n2622_r==.m
replace astwh_16_c = .m if OUTCME03==1 & astwh_16_c==.
label values astwh_16_c yesno
label var astwh_16_c "Current asthma or wheezy bronchitis aged 16"
tab astwh_16_c OUTCME03, m

* n2623 information on frequency, not included in this round

* Here information is routed in the variable labbelled 'Is the child handicapped or disabled'
* prevalence very small compared to previous time points so clearly not all asthma cases captured 

tab n2662
tab n2663
tab n2664 
tab n2665 
tab n2666 
tab n2667
global LSIDiag n2663 n2664 n2665 n2666 n2667
gen LSIAsthma =.
foreach diag in $LSIDiag {
	replace LSIAsthma = 1 if `diag' == 10 
} 
gen asthma_16_l = .
replace asthma_16_l = 1 if LSIAsthma==1
replace asthma_16_l = 0 if n2662==2 & asthma_16_l!=1
replace asthma_16_l = 0 if n2662==1 & asthma_16_l!=1
replace asthma_16_l = .m if OUTCME03==1 & asthma_16_l==.
label values asthma_16_l yesno
label var asthma_16_l "Disabled - asthma age 16"
tab asthma_16_l OUTCME03, m 

* Longstanding illness information on asthma can feed back into the current indicator for asthma and wheezy bronchitis

replace astwh_16_e = 1 if asthma_16_l==1 & OUTCME03==1
replace astwh_16_c = 1 if asthma_16_l==1 & OUTCME03==1
tab astwh_16_e
tab astwh_16_c


**** Age 23 ******************************************************************

* information asthma grouped with wheezy bronchitis
* again resulting in higher prevalence compared to just asthma earlier and later time points
* since 16th birthday, so feeding in age 16 information

tab n5770 
gen astwh_23_e = n5770
recode astwh_23_e (8 9=.m)(2=0)
replace astwh_23_e = 1 if astwh_16_e==1 & OUTCME04==1
replace astwh_23_e = .m if OUTCME04==1 & astwh_23_e==.
label values astwh_23_e yesno
label var astwh_23_e "Ever had asthma or wheezy bronchitis aged 23"
tab astwh_23_e OUTCME04, m

tab n5771
gen astwh_23_c = astwh_23_e
replace astwh_23_c = 0 if n5771==2
replace astwh_23_c = .m if astwh_23_e==1 & n5771==.
replace astwh_23_c = .m if OUTCME04==1 & astwh_23_c==.
label values astwh_23_c yesno
label var astwh_23_c "Current asthma or wheezy bronchitis aged 23"
tab astwh_23_c OUTCME04, m

* Additional information on medication use and doctor visits
* Not used in the derivation of our asthma indicators
/*
tab n5772 
gen astwhmed_23 = n5772
recode astwhmed_23 (8=.m)
replace astwhmed_23 = .n if astwh_23_e==0
replace astwhmed_23 = .m if OUTCME04==1 & astwhmed_23==.
label define med 1 "yes, medication" 2 "no medication" .m "DK/refused/not answered" .n "no asthma"
label values astwhmed_23 med
label var astwhmed_23 "Taking medication for asthma or wheezy bronchitis age 23"
tab astwhmed_23 OUTCME04, m

tab n5773 
gen astwhdoc_23 = n5773
recode astwhdoc_23 (9=.m)(2=0)
replace astwhdoc_23 = .n if astwh_23_e==0
replace astwhdoc_23 = .m if OUTCME04==1 & astwhdoc_23==.
label values astwhdoc_23 doc
label var astwhdoc_23 "Visited doctor for asthma or wheezy bronchitis age 23"
tab astwhdoc_23 OUTCME04, m
*/

***Additional work including longstanding illness type questions to identify asthma only

tab n6458
tab n6461 
* Start with limiting longstanding condition 
gen asthma_23_l =.  // whether reports asthma as a longstanding condition 
replace asthma_23_l = 1 if n6458 == 493 | n6461 == 493 
replace asthma_23_l = 0 if n5740 == 2 & asthma_23_l!=1  
replace asthma_23_l =. if OUTCME04 == 0  
replace asthma_23_l =.m if OUTCME04 == 1 & asthma_23_l ==. 
tab asthma_23_l OUTCME04, m 

* Age onset
tab n5741 if asthma_23_l == 1, m
gen asthmaage_23_l =. 
replace asthmaage_23_l = n5741 if asthma_23_l == 1
replace asthmaage_23_l = .n if asthma_23_l == 0 
replace asthmaage_23_l = .m if asthma_23_l == .m 
lab val asthmaage_23_l agelab
tab asthmaage_23_l OUTCME04, m 

* Now move onto medical supervision questions (here don't take NOs because 
* no medical supervision isn't the same as not having the condition)
replace asthma_23_l = 1 if n6464 == 493 | n6467 == 493 
tab asthma_23_l OUTCME04, m  

* Now incorporate any other conditions 
replace asthma_23_l = 1 if n6558 == 493 
replace asthma_23_l = 0 if n5873 == 0 & asthma_23_l == .m 	
tab asthma_23_l OUTCME04, m 

lab val asthma_23_l bin

* Update missingness in age variable 
tab asthmaage_23_l asthma_23_l, m 
replace asthmaage_23_l = .m if asthma_23_l == 1 & asthmaage_23_l == .n
tab asthmaage_23_l asthma_23_l, m 

* feed back in identified cases of asthma for our asthma indicator variables
replace astwh_23_e = 1 if asthma_23_l==1 & OUTCME04==1
replace astwh_23_c = 1 if asthma_23_l==1 & OUTCME04==1


**** Age 33 ******************************************************************

tab n504021 
gen asthma_33_e = n504021
recode asthma_33_e (2=0)(1=1)
replace asthma_33_e = .m if OUTCME05==1 & asthma_33_e==.
label values asthma_33_e yesno
label var asthma_33_e "Ever had asthma aged 33"
tab asthma_33_e OUTCME05, m

* cannot create an ever for asthma and bronchitis combined because here asked for bronchitis, and not for wheezy bronchitis
/*
tab n503918
gen astwh_33_e = asthma_33_e
replace astwh_33_e = 1 if n503918==1
label values astwh_33_e yesno
label var astwh_33_e "Ever had asthma or wheezy bronchitis age 33"
tab astwh_33_e OUTCME05, m
*/

* n504024 n504025 more information on impaired speech and hospitalisation due to asthma and wheezing, not useful

* look into long standing illness to supplement indicator
tab n509031
tab n509034
tab n509037
tab n509040
global LSIDiag n509031 n509034 n509037 n509040 // find any additional cases
gen LSIAsthma2 =.
foreach diag in $LSIDiag {
	replace LSIAsthma2 = 1 if `diag' == 493 
} 
* Identify 136 cases 

tab asthma_33_e LSIAsthma2, m
* 1 new case that stated no to ever had asthma
replace asthma_33_e = 1 if LSIAsthma2==1


**** Age 42 ******************************************************************

* Indicator for asthma

tab hhfbane1 
tab hhfbane2 
tab hhfbane3 
tab hhfbane4 
tab hhfbane5

gen asthma_42_e = hhfbane1
recode asthma_42_e (1 2 3 5 6= 0)(4=1)(8 9=.m)
replace asthma_42_e = 1 if hhfbane2==4|hhfbane3==4|hhfbane4==4|hhfbane5==4
replace asthma_42_e = .m if OUTCME06==1 & asthma_42_e==.
label values asthma_42_e yesno
label var asthma_42_e "Ever had asthma aged 42"
tab asthma_42_e OUTCME06, m

* How old were you when this started
tab cl1age4
recode cl1age4 (99=.)
gen asthmaage_42 = cl1age4
replace asthmaage_42 = .n if asthma_42_e==0
replace asthmaage_42 = .m if OUTCME06==1 & asthmaage_42==.
lab def agelab .m "DK/refused/not answered" .n "Not applicable (never asthma)"
label values asthmaage_42 agelab
label var asthmaage_42 "First attack asthma age 42"
tab asthmaage_42 OUTCME06, m

* Have you had this problem in the past 12 months?
* Labels are off, in original questionnaire it's not obvious, just yesno, but looking at who's visited doctor for asthma in last 12 months it becomes clear
tab cl112m4 
gen asthma_42_c = asthma_42_e
replace asthma_42_c = 0 if cl112m4==2
label values asthma_42_c yesno
label var asthma_42_c "Current asthma aged 42"
tab asthma_42_c OUTCME06, m

* seen doctor for asthma in last 12 months, additional information, not useful
/*
tab cl1doc4 
gen asthmadoc_42 = cl1doc4 
recode asthmadoc_42 (2=0)
replace asthmadoc_42 = .n if asthma_42_e==0
replace asthmadoc_42 = .m if OUTCME06==1 & asthmadoc_42==.
label values asthmadoc_42 doc
label var asthmadoc_42 "Visited doctor for asthma age 42"
tab asthmadoc_42 OUTCME06, m
*/

* cannot create another indicator variable for asthma grouped with wheezy bronchitis because here asked for bronchitis
/*
gen astwh_42_e = hhfbane1
recode astwh_42_e (1 2 5 6= 0)(3 4=1)(8 9=.m)
replace astwh_42_e = 1 if hhfbane2==4|hhfbane3==4|hhfbane4==4|hhfbane5==4|hhfbane2==3|hhfbane3==3|hhfbane4==3|hhfbane5==3
replace astwh_42_e = .m if OUTCME06==1 & astwh_42_e==.
label values astwh_42_e yesno
label var astwh_42_e "Ever had asthma or wheezy bronchitis age 42"
tab astwh_42_e OUTCME06, m

* How old were you when this started
tab cl1age4
gen astwhage_42 = cl1age4
replace astwhage_42 = .n if astwh_42_e==0
replace astwhage_42 = .m if OUTCME06==1 & astwhage_42==.
lab def agelab2 .m "DK/refused/not answered" .n "Not applicable (never asthma or wheezy bronchitis)"
label values astwhage_42 agelab2
label var astwhage_42 "First attack asthma or wheezy bronchitis age 42"
tab astwhage_42 OUTCME06, m

tab inhaler 
gen astwhmed_42 = inhaler 
replace astwhmed_42 = .n if astwh_42_e==0
replace astwhmed_42 = .m if OUTCME06==1 & astwhmed_42==.
label values astwhmed_42 med
label var astwhmed_42 "Taking medication for asthma or wheezy bronchitis age 42"
tab astwhmed_42 OUTCME06, m
*/

**** Age 44 ******************************************************************
* Not enough information to set a clear diagnosis indicator

**** Age 46 ******************************************************************

* use longstanding illness question since no direct questions on asthma
* ICD9 and ICD10 codes for asthma slightly different (ICD10 asthma with obstructive pulmonary disease not included)
* this will not form a indicator variable in its own right, but feed into the cumulative indicator variables in the end

global Diag n7xlsa n7xlsb n7xlsc n7xlsd n7xlse n7xlsa2 n7xlsb2 n7xlsc2 n7xlsd2 ///
			n7xlsa3 n7xlsb3 n7xlsc3 n7xlsa4 n7xlsb4 n7xlsc4 n7xlsa5 n7xlsb5 ///
			n7xlsa6 n7xlsa7 n7xlsa8 n7xhpa n7xhpb n7xhpc n7xhpd n7xhpa2 ///
			n7xhpb2 n7xhpc2 n7xhpa3 n7xhpa4 n7xhpa5
			
gen asthma_46_l = .
foreach diag in $Diag {
	replace asthma_46_l = 1 if `diag' == "J45"
}
replace asthma_46_l = 0 if n7lsiany==2 & asthma_46_l!=1 // replace with no if report no LSI
replace asthma_46_l = 0 if n7lsiany==1 & asthma_46_l!=1 // replace with no if LSI but not asthma 
replace asthma_46_l =.m if OUTCME07==1 & asthma_46_l==.
lab val asthma_46_l yesno
label var asthma_46_l "Longstanding illness - asthma age 46"
tab asthma_46_l OUTCME07, m 

* Now find age at first diag attached to each diag above
rename n7lsge n7lsge1 // renaming so easier to loop
forval i = 1/8 {
	recode n7lsge`i' -9/-8=.m -1=.n 
}
global lsi1 n7xlsa n7xlsb n7xlsc n7xlsd n7xlse
global lsi2 n7xlsa2 n7xlsb2 n7xlsc2 n7xlsd2
global lsi3 n7xlsa3 n7xlsb3 n7xlsc3 
global lsi4 n7xlsa4 n7xlsb4 n7xlsc4 
global lsi5 n7xlsa5 n7xlsb5
global lsi6 n7xlsa6 
global lsi7 n7xlsa7 
global lsi8 n7xlsa8 
gen asthage1 =. 
foreach diag in $lsi1 {
	replace asthage1 = n7lsge1 if `diag' == "J45" 
	}
gen asthage2 =.m 
foreach diag in $lsi2 {
	replace asthage2 = n7lsge2 if `diag' == "J45"
	}
gen asthage3 =.m 
foreach diag in $lsi3 {
	replace asthage3 = n7lsge3 if `diag' == "J45"
	}
gen asthage4 =.m 
foreach diag in $lsi4 {
	replace asthage4 = n7lsge4 if `diag' == "J45"
	}
gen asthage5 =.m 
foreach diag in $lsi5 {
	replace asthage5 = n7lsge5 if `diag' == "J45"
	}
gen asthage6 =.m 
foreach diag in $lsi6 {
	replace asthage6 = n7lsge6 if `diag' == "J45"
	}
gen asthage7 =.m 
foreach diag in $lsi7 {
	replace asthage7 = n7lsge7 if `diag' == "J45"
	}
gen asthage8 =.m 
foreach diag in $lsi8 {
	replace asthage8 = n7lsge8 if `diag' == "J45"
	}
egen asthmaage_46_l = rowmin(asthage1 asthage2 asthage3 asthage4 asthage5 asthage6 ///
						 asthage7 asthage8) 
replace asthmaage_46_l = .n if asthma_46_l == 0
replace asthmaage_46_l = .m if OUTCME07 == 1 & asthmaage_46_l==.
lab val asthmaage_46_l agelab
label var asthmaage_46_l "Age at first diagnosis for asthma age 46"
tab asthmaage_46_l asthma_46_l, m 
tab asthmaage_46_l OUTCME07, m

* Cannot use these variables to derive asthma and wheezy bronchitis, because no ICD code for wheezy bronchitis specifically


**** Age 50 ******************************************************************

tab N8KHPB01 N8XKHP01, m

gen astwh_50_c = N8KHPB01
recode astwh_50_c (-9 -8 -1=.m)
replace astwh_50_c = 1 if astwh_50_c==.m & N8XKHP01==1
replace astwh_50_c = 0 if astwh_50_c==.m & N8XKHP01==0
replace astwh_50_c = .m if OUTCME08 == 1 & astwh_50_c==.
label values astwh_50_c yesno
label var astwh_50_c "Current asthma or wheezy bronchitis aged 50"
tab astwh_50_c OUTCME08, m

/*
tab N8ASTDOC N8XASTDC, m
gen astwhdoc_50 = N8ASTDOC
recode astwhdoc_50 (-1=.m)(2=0)
replace astwhdoc_50 = .n if astwh_50_c==0
replace astwhdoc_50 = .m if OUTCME08 == 1 & astwhdoc_50==.
label values astwhdoc_50 doc
label var astwhdoc_50 "Visited doctor for asthma or wheezy bronchitis age 50"
tab astwhdoc_50 OUTCME08, m
*/

global LSIDiag N8XLSA01 N8XLSA02 N8XLSA03 N8XLSA04 N8XLSA05 N8XLSA06 N8XLSA07 ///
			   N8XLSA08 N8XLSA09 N8XLSA10 N8XLSA11 
gen LSIDiag =.
foreach diag in $LSIDiag {
	replace LSIDiag = 1 if `diag' == "J45"
}
tab LSIDiag astwh_50_c, m // 2 extra cases

* Enrich current asthma indicator 
replace astwh_50_c = 1 if LSIDiag == 1 
tab astwh_50_c OUTCME08, m 

**** Age 55 ******************************************************************

* WARNING: at age 55 it asks 'have you had asthma or wheezy bronchitis since last wave', and last wave at age 50 only asks for 'do you currently have asthma or wheezy bronchitis', and age 42 and age 33 waves only have asthma because they ask for bronchitis instead of wheezy bronchitis >>> so information on asthma missing between 50 and 42 and information on wheezy bronchitis missing between age 23 and 50

tab N9KHPB01
gen astwh_55_e = N9KHPB01
recode astwh_55_e (-9 -8 -1=.m)(2=0)
replace astwh_55_e = .m if OUTCME09 == 1 & astwh_55_e==.
replace astwh_55_e = 1 if astwh_55_e == 0 & (astwh_50_c==1 | asthma_42_e==1 | astwh_23_e==1) 
replace astwh_55_e = 0 if astwh_55_e == 0 & astwh_50_c==0 & asthma_42_e==0 & astwh_23_e==0 // cummulate with earlier time points since this wave ask "since last wave", but only have information on asthma, not wheezy bronchitis from last wave
label values astwh_55_e yesno
label var astwh_55_e "Ever had asthma or wheezy bronchitis aged 55 (limited information)"
tab astwh_55_e OUTCME09, m

**** Covid wave 1 (62 years old) *********************************************

tab CW1_LLI_3 
gen asthma_62_c1 = .
replace asthma_62_c1 = 1 if CW1_LLI_3==1
replace asthma_62_c1 = 0 if CW1_LLI_3==2
replace asthma_62_c1 = .m if asthma_62_c1==. & CW1_COHORT==1
label values asthma_62_c1 yesno
label var asthma_62_c1 "Current asthma aged 62 (Covid wave 1)"
tab asthma_62_c1, m

tab CW1_LLI_5
gen astwh_62_c1 = asthma_62_c1
replace astwh_62_c1 = 1 if CW1_LLI_5==1
replace astwh_62_c1 = .m if asthma_62_c1==. & CW1_COHORT==1
label values astwh_62_c1 yesno
label var astwh_62_c1 "Current asthma or wheezy bronchitis aged 62 (Covid wave 1)"
tab astwh_62_c1, m

**** Covid wave 2 (62 years old) *********************************************

tab CW1_LLI_3 
tab CW2_LLI1_3 
gen asthma_62_c2 = .
replace asthma_62_c2 = 1 if CW1_LLI_3==1 | CW2_LLI1_3 ==1
replace asthma_62_c2 = 0 if CW1_LLI_3==2 | CW2_LLI1_3 ==2
replace asthma_62_c2 = .m if asthma_62_c2==. & (CW1_COHORT==1 | CW2_COHORT==1)
label values asthma_62_c2 yesno
label var asthma_62_c2 "Current asthma aged 62 (Covid wave 2)"
tab asthma_62_c2, m

tab CW1_LLI_5
tab CW2_LLI1_5
gen astwh_62_c2 = asthma_62_c2
replace astwh_62_c2 = 1 if CW1_LLI_5==1 | CW2_LLI1_5==1
replace astwh_62_c2 = .m if asthma_62_c2==. & (CW1_COHORT==1 | CW2_COHORT==1)
label values astwh_62_c2 yesno
label var astwh_62_c2 "Current asthma or wheezy bronchitis aged 62 (Covid wave 2)"
tab astwh_62_c2, m

**** Covid wave 3 (63 years old) *********************************************

tab CW3_LLI1_3 
gen asthma_63_c = CW3_LLI1_3
recode asthma_63_c (-8 -9 -1=.m)(1=1)(2=0)
replace asthma_63_c = .m if CW3_COHORT==1 & asthma_63_c==.
label values asthma_63_c yesno
label var asthma_63_c "Current asthma aged 63 (Covid wave 3)"
tab asthma_63_c CW3_COHORT, m

tab CW3_LLI1_5
gen astwh_63_c = asthma_63_c
replace astwh_63_c = 1 if CW3_LLI1_5==1
replace astwh_63_c = .m if (CW3_LLI1_5==-8|CW3_LLI1_5==-9|CW3_LLI1_5==-1) & asthma_63_c!=1
label values astwh_63_c yesno
label var astwh_63_c "Current asthma or wheezy bronchitis aged 63 (Covid wave 3)"
tab astwh_63_c CW3_COHORT, m


**** Summary of all created indicator variables *****************************
*****************************************************************************

tab asthma_7_e OUTCME01, m
tab asthma_11_e OUTCME02, m
tab astwh_11_e OUTCME02, m
tab astwhage_11 OUTCME02, m
tab astwh_16_e OUTCME03, m
tab astwhage_16 OUTCME03, m
tab astwh_16_c OUTCME03, m
tab asthma_16_l OUTCME03, m
tab asthmaage_23_l OUTCME04, m
tab asthma_23_l OUTCME04, m 
tab astwh_23_e OUTCME04, m
tab astwh_23_c OUTCME04, m
tab asthma_33_e OUTCME05, m
tab asthma_42_e OUTCME06, m
tab asthmaage_42 OUTCME06, m
tab asthma_42_c OUTCME06, m
tab asthma_46_l OUTCME07, m 
tab asthmaage_46_l OUTCME07, m
tab astwh_50_c OUTCME08, m
tab astwh_55_e OUTCME09, m
tab asthma_62_c1, m
tab asthma_62_c2, m
tab asthma_63_c CW3_COHORT, m
tab astwh_62_c1, m
tab astwh_62_c2, m
tab astwh_63_c CW3_COHORT, m


**** Save file ***************************************************************
******************************************************************************

keep NCDSID N622 OUTCME00 OUTCME01 OUTCME02 OUTCME03 OUTCME04 OUTCME05 OUTCME06 OUTCME09 OUTCME07 OUTCME08 asthma_7_e astwh_7_e asthma_7_ed asthma_11_e astwh_11_e astwh_11_ed astwh_11_cd astwhage_11 ///
astwh_16_e astwhage_16 astwh_16_c asthma_16_l asthmaage_23_l ///
asthma_23_l astwh_23_e astwh_23_c asthma_33_e  ///
asthma_42_e asthmaage_42 asthma_42_c  ///
asthma_46_l asthmaage_46_l astwh_50_c astwh_55_e ///
asthma_62_c1 asthma_62_c2 asthma_63_c astwh_62_c1 astwh_62_c2 astwh_63_c

save "$working_path/NCDS_asthma.dta", replace


*************************** CROSS-SWEEP INDICATORS *****************************



**** Cumulative 'ever measures'

use "$working_path/NCDS_asthma.dta", replace

lab def bin1 0 "No" 1 "Yes" .m "Status uncertain"

*** For asthma 

gen asthma_7 =. 
replace asthma_7 = 1 if asthma_7_e == 1 | asthma_7_ed == 1
gen asthma_11 =. 
replace asthma_11 = 1 if asthma_11_e == 1 | asthma_7 == 1 
gen asthma_16 =.
replace asthma_16 = 1 if asthma_16_l == 1 | asthma_11 == 1
gen asthma_33 =.
replace asthma_33 = 1 if asthma_33_e == 1 | asthma_23_l == 1 | asthma_16 == 1
gen asthma_42 =.
replace asthma_42 = 1 if asthma_42_e == 1 | asthma_42_c == 1 | asthma_33 == 1
* We don't create cumulative indicators after age 42 because no available info on 'have you ever' (only current asthma)

* Age when first found out had asthma

tab astwhage_11
recode astwhage_11 (0=0)(1 3=6)(2 4=10)(5 6=.m), into(astwhage_11_r)
tab astwhage_16 
recode astwhage_16 (1=0)(2=1)(3=4)(4=6)(5=10)(6=11), into(astwhage_16_r)

gen asthmaage =. 
replace asthmaage = .n if asthma_42 != 1 // last cumulative indicator is a no 
replace asthmaage = astwhage_11_r if asthmaage ==. & (astwhage_11_r != .m & astwhage_11_r != .n)
replace asthmaage = astwhage_16_r if asthmaage ==. & (astwhage_16_r != .m & astwhage_16_r != .n) 
replace asthmaage = asthmaage_23_l if asthmaage ==. & (asthmaage_23_l!=.m & asthmaage_23_l!=.m)
replace asthmaage = asthmaage_42 if asthmaage ==. & (asthmaage_42!= .m & asthmaage_42!= .n)

* Use age first found out had asthma
replace asthma_7 = 1 if asthmaage <= 7
replace asthma_11 = 1 if asthmaage <= 11
replace asthma_16 = 1 if asthmaage <= 16
replace asthma_33 = 1 if asthmaage <= 33
replace asthma_42 = 1 if asthmaage <= 42

* Add in 0 if reported no to ever question at that sweep or after and not a 1 
* Remove those who didn't respond to that wave 

replace asthma_42 = 0 if asthma_42_e == 0 & asthma_42 ==.
replace asthma_42 = 0 if astwh_55_e == 0 & asthma_42 ==.
replace asthma_42 = .m if (asthma_42_e == .m | astwh_55_e == .m) & asthma_42 ==.
replace asthma_42 = . if asthma_42_e == .
lab val asthma_42 bin1 
lab var asthma_42 "Ever had asthma by age 42"
tab asthma_42, m 

replace asthma_33 = 0 if asthma_33_e == 0 & asthma_33 == .
replace asthma_33 = 0 if asthma_42_e == 0 & asthma_33 == .
replace asthma_33 = 0 if astwh_55_e == 0 & asthma_33 == .
replace asthma_33 = .m if (asthma_33_e == .m | asthma_42_e == .m | astwh_55_e == .m) & asthma_33 == .
replace asthma_33 = . if asthma_33_e ==.
lab val asthma_33 bin1 
lab var asthma_33 "Ever had asthma by age 33"
tab asthma_33, m 

* We can't really create this for age 16, because based on longstanding illness (current), not on ever
/*
replace asthma_16 = 0 if asthma_16_l == 0 & asthma_16 ==.
replace asthma_16 = 0 if asthma_42_e == 0 & asthma_16 ==.
replace asthma_16 = 0 if asthma_33_e == 0 & asthma_16 ==.
replace asthma_16 = 0 if astwh_55_e == 0 & asthma_16 ==.
replace asthma_16 = 0 if astwh_23_e == 0 & asthma_16 ==.
replace asthma_16 = .m if (asthma_16_l == .m | asthma_33_e == .m | asthma_42_e == .m | astwh_55_e == .m | astwh_23_e == .m) & asthma_16 ==.
replace asthma_16 = . if asthma_16_l == .
lab val asthma_16 bin1
lab var asthma_16 "Ever had asthma by age 16"
tab asthma_16, m // 663 where exit status undetermined
* we will not include asthma_16 in the final deposit of variables as it is based on longstanding illness, and not on ever at the last time point
*/

replace asthma_11 = 0 if asthma_11_e == 0 & asthma_11 ==.
replace asthma_11 = 0 if asthma_33_e == 0 & asthma_11 ==.
replace asthma_11 = 0 if asthma_42_e == 0 & asthma_11 ==.
replace asthma_11 = 0 if astwh_55_e == 0 & asthma_11 ==.
replace asthma_11 = 0 if astwh_23_e == 0 & asthma_11 ==.
replace asthma_11 = 0 if astwh_16_e == 0 & asthma_11 ==.
replace asthma_11 = .m if (asthma_11_e==.m | asthma_33_e==.m | asthma_42_e==.m | astwh_55_e == .m | astwh_23_e == .m | astwh_16_e == .m) & asthma_11 ==.
replace asthma_11 = . if asthma_11_e==.
lab val asthma_11 bin1
lab var asthma_11 "Ever had asthma by age 11"
tab asthma_11, m 

replace asthma_7 = 0 if asthma_7_e == 0 & asthma_7 ==.
replace asthma_7 = 0 if asthma_7_ed == 0 & asthma_7 ==.
replace asthma_7 = 0 if asthma_11_e == 0 & asthma_7 ==.
replace asthma_7 = 0 if asthma_33_e == 0 & asthma_7 ==.
replace asthma_7 = 0 if asthma_42_e == 0 & asthma_7 ==.
replace asthma_7 = 0 if astwh_55_e == 0 & asthma_7 ==.
replace asthma_7 = 0 if astwh_23_e == 0 & asthma_7 ==.
replace asthma_7 = 0 if astwh_16_e == 0 & asthma_7 ==.
replace asthma_7 = .m if (asthma_7_e==.m | asthma_7_ed==.m | asthma_11_e==.m | asthma_33_e==.m | asthma_42_e==.m | astwh_55_e == .m | astwh_23_e == .m | astwh_16_e == .m) & asthma_7 ==.
replace asthma_7 = . if asthma_7_e==.
lab val asthma_7 bin1
lab var asthma_7 "Ever had asthma by age 7"
tab asthma_7, m 


*** For asthma and wheezy bronchitis

gen astwh_7 =. 
replace astwh_7 = 1 if astwh_7_e == 1
gen astwh_11 =.
replace astwh_11 = 1 if astwh_11_e == 1 | astwh_11_ed == 1 | astwh_11_cd == 1 | astwh_7 == 1
gen astwh_16 =.
replace astwh_16 = 1 if astwh_16_e == 1 | astwh_16_c == 1 | asthma_16_l==1 | astwh_11 == 1 
gen astwh_23 =.
replace astwh_23 = 1 if astwh_23_e == 1 | astwh_23_c ==1 | astwh_16 == 1  
gen astwh_55 =.
replace astwh_55 = 1 if astwh_55_e == 1 | astwh_50_c == 1 | asthma_33_e ==1 | asthma_42_e ==1 | asthma_46_l ==1 | astwh_23 == 1 
* Warning again that some information missing for astwh_55
* Not creating cumulative indicator for 62/63 because no more on information on 'ever had', only current

* Age when first found out had asthma or wheezy bronchitis

gen astwhage =. 
replace astwhage = .n if astwh_55 != 1 // last cumulative indicator is a no 
replace astwhage = astwhage_11_r if astwhage ==. & (astwhage_11_r != .m & astwhage_11_r != .n)
replace astwhage = astwhage_16_r if astwhage ==. & (astwhage_16_r != .m & astwhage_16_r != .n) 
replace astwhage = asthmaage_42 if astwhage ==. & (asthmaage_42!= .m & asthmaage_42!= .n)

* Use age first found out had asthma or wheezy bronchitis
replace astwh_7 = 1 if astwhage <= 7
replace astwh_11 = 1 if astwhage <= 11
replace astwh_16 = 1 if astwhage <= 16
replace astwh_23 = 1 if astwhage <= 23

* Add in 0 if reported no to ever question at that sweep or after and not a 1 
* Remove those who didn't respond to that wave 

replace astwh_55 = 0 if astwh_55_e == 0 & astwh_55 ==.
replace astwh_55 = .m if astwh_55_e == .m & astwh_55 ==.
replace astwh_55 = . if astwh_55_e == .
lab val astwh_55 bin1 
lab var astwh_55 "Ever had asthma or wheezy bronchitis by age 55 (limited information)"
tab astwh_55, m 

replace astwh_23 = 0 if astwh_23_e == 0 & astwh_23 ==.
replace astwh_23 = 0 if astwh_55_e == 0 & astwh_23 ==.
replace astwh_23 = .m if (astwh_23_e == .m | astwh_55_e == .m) & astwh_23 ==.
replace astwh_23 = . if astwh_23_e == .
lab val astwh_23 bin1 
lab var astwh_23 "Ever had asthma or wheezy bronchitis by age 23"
tab astwh_23, m 

replace astwh_16 = 0 if astwh_16_e == 0 & astwh_16 ==.
replace astwh_16 = 0 if astwh_23_e == 0 & astwh_16 ==.
replace astwh_16 = 0 if astwh_55_e == 0 & astwh_16 ==.
replace astwh_16 = .m if (astwh_16_e == .m | astwh_23_e == .m | astwh_55_e == .m) & astwh_16 ==.
replace astwh_16 = . if astwh_16_e == .
lab val astwh_16 bin1 
lab var astwh_16 "Ever had asthma or wheezy bronchitis by age 16"
tab astwh_16, m 

replace astwh_11 = 0 if astwh_11_e == 0 & astwh_11 ==.
replace astwh_11 = 0 if astwh_11_ed == 0 & astwh_11 ==.
replace astwh_11 = 0 if astwh_16_e == 0 & astwh_11 ==.
replace astwh_11 = 0 if astwh_23_e == 0 & astwh_11 ==.
replace astwh_11 = 0 if astwh_55_e == 0 & astwh_11 ==.
replace astwh_11 = .m if (astwh_11_e == .m | astwh_11_ed == .m | astwh_16_e == .m | astwh_23_e == .m | astwh_55_e == .m) & astwh_11 ==.
replace astwh_11 = . if astwh_11_e == .
lab val astwh_11 bin1 
lab var astwh_11 "Ever had asthma or wheezy bronchitis by age 11"
tab astwh_11, m 

replace astwh_7 = 0 if astwh_7_e == 0 & astwh_7 ==.
replace astwh_7 = 0 if astwh_11_e == 0 & astwh_7 ==.
replace astwh_7 = 0 if astwh_11_ed == 0 & astwh_7 ==.
replace astwh_7 = 0 if astwh_16_e == 0 & astwh_7 ==.
replace astwh_7 = 0 if astwh_23_e == 0 & astwh_7 ==.
replace astwh_7 = 0 if astwh_55_e == 0 & astwh_7 ==.
replace astwh_7 = .m if (astwh_7_e == .m | astwh_11_e == .m | astwh_11_ed == .m | astwh_16_e == .m | astwh_23_e == .m | astwh_55_e == .m) & astwh_7 ==.
replace astwh_7 = . if astwh_7_e == .
lab val astwh_7 bin1 
lab var astwh_7 "Ever had asthma or wheezy bronchitis by age 7"
tab astwh_7, m 

drop asthmaage astwhage 

keep NCDSID asthma_7_e asthma_7_ed astwh_7_e asthma_11_e astwh_11_e astwh_11_ed astwh_11_cd ///
astwh_16_e astwh_16_c astwh_23_e ///
astwh_23_c asthma_33_e  ///
asthma_42_e asthma_42_c ///
astwh_50_c astwh_55_e ///
asthma_62_c1 asthma_62_c2 asthma_63_c astwh_62_c1 astwh_62_c2 astwh_63_c ///
asthma_7 asthma_11 asthma_33 asthma_42 ///
astwh_7 astwh_11 astwh_16 astwh_23 astwh_55

order NCDSID asthma_7_e asthma_7_ed asthma_11_e asthma_33_e asthma_42_e asthma_42_c asthma_62_c1 asthma_62_c2 asthma_63_c ///
astwh_7_e astwh_11_e astwh_11_ed astwh_11_cd astwh_16_e astwh_16_c astwh_23_e astwh_23_c astwh_50_c astwh_55_e astwh_62_c1 astwh_62_c2 astwh_63_c ///
asthma_7 asthma_11 asthma_33 asthma_42 ///
astwh_7 astwh_11 astwh_16 astwh_23 astwh_55

save "$working_path/NCDS_asthma.dta", replace

********************************************************************************
*********************** REFORMAT INDICATORS TO DEPOSIT *************************
********************************************************************************

use "$working_path/NCDS_asthma.dta", replace

rename (asthma_7_e asthma_7_ed asthma_11_e asthma_33_e asthma_42_e asthma_42_c asthma_62_c1 asthma_62_c2 asthma_63_c ///
astwh_7_e astwh_11_e astwh_11_ed astwh_11_cd astwh_16_e astwh_16_c astwh_23_e astwh_23_c astwh_50_c astwh_55_e astwh_62_c1 astwh_62_c2 astwh_63_c ///
asthma_7 asthma_11 asthma_33 asthma_42 ///
astwh_7 astwh_11 astwh_16 astwh_23 astwh_55) ///
(asthma_7_ever asthma_7_everdoc asthma_11_ever asthma_33_ever asthma_42_ever asthma_42_current asthma_62_current1 asthma_62_current2 /// 
asthma_63_current3 asthmabronc_7_ever asthmabronc_11_ever asthmabronc_11_everdoc asthmabronc_11_currentdoc asthmabronc_16_ever /// 
asthmabronc_16_current asthmabronc_23_ever asthmabronc_23_current ///
asthmabronc_50_current asthmabronc_55_ever_ltd asthmabronc_62_current1 asthmabronc_62_current2 asthmabronc_63_current3 ///
asthma_7_cumul asthma_11_cumul asthma_33_cumul asthma_42_cumul ///
asthmabronc_7_cumul asthmabronc_11_cumul asthmabronc_16_cumul asthmabronc_23_cumul asthmabronc_55_cumul_ltd)

rename NCDSID ncdsid
lab var ncdsid "NCDSID - Cohort Member ID"	

* Sweep-specific indicators 
lab define depositlab1 1 "Asthma reported in sweep" ///
					   2 "No asthma reported in sweep" ///
					   -1 "No information provided" ///
					   -9 "Not in sweep"
foreach var in asthma_7_ever asthma_7_everdoc asthma_11_ever asthma_33_ever asthma_42_ever asthma_42_current asthma_62_current1 asthma_62_current2 asthma_63_current3 ///
asthmabronc_7_ever asthmabronc_11_ever asthmabronc_11_everdoc asthmabronc_11_currentdoc asthmabronc_16_ever asthmabronc_16_current asthmabronc_23_ever asthmabronc_23_current asthmabronc_50_current asthmabronc_55_ever_ltd asthmabronc_62_current1 asthmabronc_62_current2 asthmabronc_63_current3 {   	
	recode `var' 0=2 .m=-1 .=-9			
	lab val `var' depositlab1 			
}
lab var asthma_7_ever "Ever had asthma age 7 [Sweep 2]"
lab var asthma_7_everdoc "Ever had asthma age 7 doctor report [Sweep 2]"
lab var asthma_11_ever "Ever had asthma age 11 [Sweep 3]"
lab var asthma_33_ever "Ever had asthma age 33 [Sweep 6]"
lab var asthma_42_ever "Ever had asthma age 42 [Sweep 7]"
lab var asthma_42_current "Currently has asthma age 42 [Sweep 7]"
lab var asthma_62_current1 "Currently has asthma age 62 [COVID survey 1]"
lab var asthma_62_current2 "Currently has asthma age 62 [COVID survey 2]"  
lab var asthma_63_current3 "Currently has asthma age 63 [COVID survey 3]" 
lab var asthmabronc_7_ever "Ever had asthma or wheezy bronchitis age 7 [Sweep 2]"
lab var asthmabronc_11_ever "Ever had asthma or wheezy bronchitis age 11 [Sweep 3]"
lab var asthmabronc_11_everdoc "Ever had asthma or wheezy bronchitis age 11 doctor report [Sweep 3]"
lab var asthmabronc_11_currentdoc "Currently has asthma or wheezy bronchitis age 11 doctor report [Sweep 3]"
lab var asthmabronc_16_ever "Ever had asthma or wheezy bronchitis age 16 [Sweep 4]"
lab var asthmabronc_16_current "Currently has asthma or wheezy bronchitis age 16 [Sweep 4]"
lab var asthmabronc_23_ever "Ever had asthma or wheezy bronchitis age 23 [Sweep 5]"
lab var asthmabronc_23_current "Currently has asthma or wheezy bronchitis age 23 [Sweep 5]"
lab var asthmabronc_50_current "Currently has asthma or wheezy bronchitis age 50 [Sweep 10]"
lab var asthmabronc_55_ever_ltd "Ever had asthma or wheezy bronchitis age 55 [Sweep 11, limited information]"
lab var asthmabronc_62_current1 "Currently has asthma or wheezy bronchitis age 62 [COVID survey 1]" 
lab var asthmabronc_62_current2 "Currently has asthma or wheezy bronchitis age 62 [COVID survey 2]" 
lab var asthmabronc_63_current3 "Currently has asthma or wheezy bronchitis age 63 [COVID survey 3]"

* Cumulative indicators 
lab define depositlab2 1 "Asthma ever reported up to and including current sweep" ///
					   2 "No asthma reported up to and including current sweep" ///
					   -1 "Not enough information provided" ///
					   -9 "Not in sweep"
foreach var in asthma_7_cumul asthma_11_cumul /// 
asthma_33_cumul asthma_42_cumul asthmabronc_7_cumul asthmabronc_11_cumul asthmabronc_16_cumul asthmabronc_23_cumul asthmabronc_55_cumul_ltd {
	recode `var' 0=2 .m=-1 .=-9			
	lab val `var' depositlab2			   	
}  
lab var asthma_7_cumul "Ever asthma by age 7 [cumulative]"
lab var asthma_11_cumul "Ever asthma by age 11 [cumulative]"
lab var asthma_33_cumul "Ever asthma by age 33 [cumulative]"
lab var asthma_42_cumul "Ever asthma by age 42 [cumulative]"
lab var asthmabronc_7_cumul "Ever asthma or wheezy bronchitis by age 7 [cumulative]"
lab var asthmabronc_11_cumul "Ever asthma or wheezy bronchitis by age 11 [cumulative]"
lab var asthmabronc_16_cumul "Ever asthma or wheezy bronchitis by age 16 [cumulative]"
lab var asthmabronc_23_cumul "Ever asthma or wheezy bronchitis by age 23 [cumulative]"
lab var asthmabronc_55_cumul_ltd "Ever asthma or wheezy bronchitis by age 55 [cumulative, limited information]"

* REMOVE THIS BEFORE DEPOSITING 	
log using "$working_path/NCDS Codebook", replace 
codebook 
log close 

save "$working_path/harmonised_asthma_ncds.dta", replace
