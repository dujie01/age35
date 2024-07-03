
*Figure 1
*(a)Age distribution for baidu search keywords-midlife crisis
use "baidu_index.dta",clear
gen age1=age+0.4

twoway (bar Midlife_crisis age,barw(0.4)) (scatter TGI age,msymbol(S) connect(l) yaxis(2))   ///
(bar Online_average age1, barw(0.4)), xlabel(1 "less than 19" 2 "age20-29" 3 "age30-39" 4 "age40-49" 5 "more than 50")  legend(cols(1) ring(0) pos(11)) 


*(b)Inverted U-shaped curve for Age popularity index
use "ap_index.dta",clear

reg ap_index age c.age#c.age if age>=30 & age<=40, robust noconstant
marginscontplot age if age>=30 & age<=40, ci
graph save Graph "ap_curve.gph", replace

*(c)-(d) Job opportunity gap at age35 of companies and jd posting
use "job_opportunity.dta",clear
// replace age=age+1
gen dummy=1 if age>35
replace dummy=0 if age<=35

gen age_c=age-36
gen age2=age_c^2
gen age_dummy=age_c*dummy
gen age2_dummy=age2*dummy

foreach y of var jobopp_companies jobopp_jd{
reg `y' dummy age_c age2 age_dummy age2_dummy if age<=40 & age>=30
outreg2 using "jopopp.xls", excel dec(4) append 
reghdfe `y' dummy age_c age2 age_dummy age2_dummy if age<=40 & age>=30,absorb(city_id) cluster(city_id)
outreg2 using "jopopp.xls", excel dec(4) append
bys age: egen m_`y'=mean(`y')
predict fit_`y'
predict fitsd_`y', stdp
gen upfit`y'=fit_`y'+1.96*fitsd_`y'
gen downfit`y'=fit_`y'-1.96*fitsd_`y'
}

keep age m_jobopp_companies fit_jobopp_companies upfitjobopp_companies downfitjobopp_companies m_jobopp_jd fit_jobopp_jd upfitjobopp_jd downfitjobopp_jd
duplicates drop

*-(c)
twoway (rarea upfitjobopp_companies downfitjobopp_companies age if age<=35 & age>=30, sort fcolor(blue%20) lcolor(blue%20)) ///
(rarea upfitjobopp_companies downfitjobopp_companies age if age<=40 & age>35, sort fcolor(red%20) lcolor(red%20)) ///
 (line fit_jobopp_companies age if age<=35 & age>=30, sort lcolor(blue) lwidth(thick)) ///
 (line fit_jobopp_companies age if age<=40 &age>35, sort lcolor(red) lwidth(thick)) ///
(scatter fit_jobopp_companies age if age<=40 & age>=30, msize(medlarge) mcolor(black)  msymbol(circle_hollow)), ///
 xline(35.5, lcolor(black)) legend(order(1 "95% CI, age<=35" 2 "95% CI, age>35" 3 "Fitted value, age<=35" 4 "Fitted value,age>35" 5 "Fitted_value")) xlabel(30(1)40) 

*-(d)
twoway (rarea upfitjobopp_jd downfitjobopp_jd age if age<=35 & age>=30, sort fcolor(blue%20) lcolor(blue%20)) ///
(rarea upfitjobopp_jd downfitjobopp_jd age if age<=40 & age>35, sort fcolor(red%20) lcolor(red%20)) ///
 (line fit_jobopp_jd age if age<=35 & age>=30, sort lcolor(blue) lwidth(thick)) ///
 (line fit_jobopp_jd age if age<=40 &age>35, sort lcolor(red) lwidth(thick)) ///
(scatter fit_jobopp_jd age if age<=40 & age>=30, msize(medlarge) mcolor(black)  msymbol(circle_hollow)), ///
xline(35.5, lcolor(black)) legend(order(1 "95% CI, age<=35" 2 "95% CI, age>35" 3 "Fitted value, age<=35" 4 "Fitted value,age>35" 5 "Fitted_value")) xlabel(30(1)40)

*Figure B2
*(a)Histogram and Kernel Density of Age
use "sample_rdd.dta", clear
egen bin_age = cut(age), at(30(0.1)40)

twoway (histogram bin_age if age<=35 & age >=30, width(1.25) freq fcolor(blue*0.1) lcolor(black)) ///
       (histogram bin_age if age >35 & age <=40, width(1.25) freq fcolor(blue*0.3) lcolor(black)) ///
       (kdensity bin_age if age <= 35 & age>=30, lp(dash) lcolor(blue*0.7)) ///
       (kdensity bin_age if age > 35 & age <=40, lp(solid) lcolor(blue)), ///
       legend(order(1 "Age <= 35, Histogram" 2 "Age > 35, Histogram" 3 "Age <=35, Density" 4 "Age >35, Density"))  ///
       xtitle("Age") ytitle("Density") ///
       title("Histogram and Kernel Density of Age", color(black) size(medium)) ///
       xline(35, lcolor(black) lw(thick))
	   graph export "Histogram and Kernel Density of Age.png" , replace 

*(b)-（d）Continuity test of gender
egen bin0_25 = cut(age2), at(30(0.025)40)
global z "degree_id gender work_years"
foreach y of var $z {
    rdplot `y' age if age>30 & age<40, ci(95) c(35.01) p(1) kernel(uni) graph_options(title("Continuity test of `y'") legend(off) ytitle("`var'") xtitle() scheme(plotplainblind))
    graph export "`y_f1'.png" , replace
}


*Table1:Age-based employment barriers
use "sample_rdd.dta", clear

local kernelfn "epa"   
global z "degree_id gender work_years"
foreach y of var active_chat_recruiter  callback_rate_recruiter{	
	foreach kvar of local kernelfn { 
	rdrobust `y' age, c(35.99) kernel(`kvar') all fuzzy(jobopp) covs($z)
		outreg2 using "table_r1.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append
	}
}

local kernelfn "epa"   // 
global z "degree_id gender work_years"
foreach y of var active_chat_recruiter  callback_rate_recruiter {	
	foreach kvar of local kernelfn { 
	rdrobust `y' age, c(35.99) kernel(`kvar') all fuzzy(dummy_age) covs($z)
		outreg2 using "table_r1.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}

local kernelfn "epa"   
global z "degree_id gender work_years"
foreach y of var active_chat_recruiter  callback_rate_recruiter{	
	foreach kvar of local kernelfn { 
	rdrobust `y' age, c(35.99) kernel(`kvar') all fuzzy(jobopp)
		outreg2 using "/Users/admin/Downloads/middle_age/table_r0628.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}

local kernelfn "epa"   
global z "degree_id gender work_years"
foreach y of var active_chat_recruiter  callback_rate_recruiter{	
	foreach kvar of local kernelfn { 
	rdrobust `y' age, c(35.99) kernel(`kvar') all fuzzy(dummy_age)
		outreg2 using "table_r1.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}

**Figure 2(a):Age-based employment barriers 
egen bin25 = cut(age2), at(30(0.4)40)

rdplot pactive_chat_recruiter bin25  if age2>30 & age2<40, ci(95) c(35.75) p(4) kernel(uni) shade	
rdplot callback_rate_recruiter bin25  if age2>30 & age2<40, ci(95) c(35.75) p(4) kernel(uni) shade	


**multi period difference-in-difference-in-difference 
**Figure 2(b)
*(1) recruiters' active chats
use "panel_dataset_did.dta",clear
ren geek_id id
ren after did
ren time1 year

xtset id year

csdid active_chat_recruiter, ivar(id) time(year) gvar(birth_date) notyet
estat event, estore(cs) 
event_plot cs, default_look graph_opt(xtitle("Periods since the event") ytitle("Average causal effect") xlabel(-14(1)5) ///
	title("Callaway and Sant'Anna (2020)")) stub_lag(Tp#) stub_lead(Tm#) together


gen birth_date1=birth_date
replace birth_date1=. if birth_date==0


did_imputation active_chat_recruiter id year birth_date1, allhorizons pretrend(5) autosample
event_plot, default_look graph_opt(xtitle("Periods since the event") ytitle("Average causal effect") ///
	title("Borusyak et al. (2021) imputation estimator") xlabel(-5(1)5))

estimates store bjs // storing the estimates for later


did_multiplegt active_chat_recruiter  id year did, robust_dynamic dynamic(4) placebo(4) breps(10) cluster(id) 


event_plot e(estimates)#e(variances), default_look graph_opt(xtitle("Periods since the event") ytitle("Average causal effect") ///
	title("de Chaisemartin and D'Haultfoeuille (2020)") xlabel(-5(1)5)) stub_lag(Effect_#) stub_lead(Placebo_#) together

matrix dcdh_b = e(estimates) // storing the estimates for later
matrix dcdh_v = e(variances)


forvalues l = 0/7 {
	gen L`l'event = dif==`l'
}
forvalues l = 1/6 {
	gen F`l'event = dif==-`l'
}
gen lastcohort = birth_date==r(max) // dummy for the latest- or never-treated cohort

drop F1event // normalize K=-1 (and also K=-15) to zero
eventstudyinteract active_chat_recruiter L*event F*event, vce(cluster id) absorb(id year) cohort(birth_date) control_cohort(lastcohort)
event_plot e(b_iw)#e(V_iw), default_look graph_opt(xtitle("Periods since the event") ytitle("Average causal effect") xlabel(-14(1)5) ///
	title("Sun and Abraham (2020)")) stub_lag(L#event) stub_lead(F#event) together
	
matrix sa_b = e(b_iw) // storing the estimates for later
matrix sa_v = e(V_iw)

	
	
reghdfe active_chat_recruiter F*event L*event, a(id year) cluster(id)
event_plot, default_look stub_lag(L#event) stub_lead(F#event) together graph_opt(xtitle("Days since the event") ytitle("OLS coefficients") xlabel(-14(1)5) ///
	title("OLS"))

estimates store ols // saving the estimates for later


event_plot bjs dcdh_b#dcdh_v cs sa_b#sa_v ols, ///
	stub_lag(tau# Effect_# Tp# L#event L#event) stub_lead(pre# Placebo_# Tm# F#event F#event) plottype(scatter) ciplottype(rcap) ///
	together perturb(-0.325(0.13)0.325) trimlag(4) trimlead(4) noautolegend ///
	graph_opt(title("Event study estimators in a panel dataset (Dif-in-Dif Estimate)", size(medlarge)) ///
		xtitle("Periods since the event") ytitle("Average causal effect") xlabel(-4(1)4) ylabel(-0.05(0.05)0.1) ///
		legend(order( 2 "Borusyak et al." 4 "de Chaisemartin-D'Haultfoeuille" ///
				6 "Callaway-Sant'Anna" 8 "Sun-Abraham" 10 "OLS") rows(3) region(style(none))) ///
	/// the following lines replace default_look with something more elaborate
		xline(-0.5, lcolor(gs8) lpattern(dash)) yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ylabel(, angle(horizontal)) ///
	) ///
	lag_opt2(msymbol(O) color(cranberry)) lag_ci_opt2(color(cranberry)) ///
	lag_opt3(msymbol(Dh) color(navy)) lag_ci_opt3(color(navy)) ///
	lag_opt4(msymbol(Th) color(forest_green)) lag_ci_opt4(color(forest_green)) ///
	lag_opt5(msymbol(Sh) color(dkorange)) lag_ci_opt5(color(dkorange)) ///
	lag_opt6(msymbol(Oh) color(purple)) lag_ci_opt6(color(purple))


graph export "5waystogo1.png",replace


*(2) recruiters' callback rate
ren geek_id id
ren after did
ren time1 year
xtset id year

csdid callback_rate_recruiter, ivar(id) time(year) gvar(birth_date) notyet
estat event, estore(cs) // this produces and stores the estimates at the same time
event_plot cs, default_look graph_opt(xtitle("Periods since the event") ytitle("Average causal effect") xlabel(-14(1)5) ///
	title("Callaway and Sant'Anna (2020)")) stub_lag(Tp#) stub_lead(Tm#) together


gen birth_date1=birth_date
replace birth_date1=. if birth_date==0


did_imputation callback_rate_recruiter id year birth_date1, allhorizons pretrend(5) autosample
event_plot, default_look graph_opt(xtitle("Periods since the event") ytitle("Average causal effect") ///
	title("Borusyak et al. (2021) imputation estimator") xlabel(-5(1)5))

estimates store bjs // storing the estimates for later


did_multiplegt callback_rate_recruiter id year did, robust_dynamic dynamic(5) placebo(5) breps(10) cluster(id) 


event_plot e(estimates)#e(variances), default_look graph_opt(xtitle("Periods since the event") ytitle("Average causal effect") ///
	title("de Chaisemartin and D'Haultfoeuille (2020)") xlabel(-5(1)5)) stub_lag(Effect_#) stub_lead(Placebo_#) together

matrix dcdh_b = e(estimates) // storing the estimates for later
matrix dcdh_v = e(variances)


forvalues l = 0/7 {
	gen L`l'event = dif==`l'
}
forvalues l = 1/6 {
	gen F`l'event = dif==-`l'
}
gen lastcohort = birth_date==r(max) // dummy for the latest- or never-treated cohort

drop F1event // normalize K=-1 (and also K=-15) to zero
eventstudyinteract callback_rate_recruiter L*event F*event, vce(cluster id) absorb(id year) cohort(birth_date) control_cohort(lastcohort)
event_plot e(b_iw)#e(V_iw), default_look graph_opt(xtitle("Periods since the event") ytitle("Average causal effect") xlabel(-14(1)5) ///
	title("Sun and Abraham (2020)")) stub_lag(L#event) stub_lead(F#event) together
	
matrix sa_b = e(b_iw) // storing the estimates for later
matrix sa_v = e(V_iw)

	
	
reghdfe callback_rate_recruiter F*event L*event, a(id year) cluster(id)
event_plot, default_look stub_lag(L#event) stub_lead(F#event) together graph_opt(xtitle("Days since the event") ytitle("OLS coefficients") xlabel(-14(1)5) ///
	title("OLS"))

estimates store ols // saving the estimates for later

event_plot bjs dcdh_b#dcdh_v cs sa_b#sa_v ols, ///
	stub_lag(tau# Effect_# Tp# L#event L#event) stub_lead(pre# Placebo_# Tm# F#event F#event) plottype(scatter) ciplottype(rcap) ///
	together perturb(-0.325(0.13)0.325) trimlag(4) trimlead(4) noautolegend ///
	graph_opt(title("Event study estimators in a panel dataset (Dif-in-Dif Estimate)", size(medlarge)) ///
		xtitle("Periods since the event") ytitle("Average causal effect") xlabel(-4(1)4) ylabel(-0.05(0.05)0.1) ///
		legend(order( 2 "Borusyak et al." 4 "de Chaisemartin-D'Haultfoeuille" ///
				6 "Callaway-Sant'Anna" 8 "Sun-Abraham" 10 "OLS") rows(3) region(style(none))) ///
	/// the following lines replace default_look with something more elaborate
		xline(-0.5, lcolor(gs8) lpattern(dash)) yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ylabel(, angle(horizontal)) ///
	) ///
	lag_opt2(msymbol(O) color(cranberry)) lag_ci_opt2(color(cranberry)) ///
	lag_opt3(msymbol(Dh) color(navy)) lag_ci_opt3(color(navy)) ///
	lag_opt4(msymbol(Th) color(forest_green)) lag_ci_opt4(color(forest_green)) ///
	lag_opt5(msymbol(Sh) color(dkorange)) lag_ci_opt5(color(dkorange)) ///
	lag_opt6(msymbol(Oh) color(purple)) lag_ci_opt6(color(purple))


graph export "5waystogo2.png",replace

*Tablex and figure x(3) benchmark regression and rolling regression 
use "panel_dataset_did.dta",clear
xtset geek_id time1

foreach var in active_chat_recruiter  callback_rate_recruiter{
reghdfe `var' after,absorb(geek_id year_month)
outreg2 using "table_did.xls", excel append adjr2 dec(3) 
}

local start_year = 24270
local end_year = 24278


foreach y of var active_dc_rate_1 perday_passive_kl_num{
forvalues i = 0/3 {
    local start = `start_year' + `i'
    local end = `end_year' + `i'
    
    preserve
    keep if time1 >= `start' & time1 <= `end'
    reghdfe `y' after,absorb(geek_id year_month)
    estimates store time`i'
    outreg2 using  "table_did.xls", excel append adjr2 r2  dec(3) 
    restore
	coefplot time0 time1 time2 time3 , keep(after) ci(95)
graph export "time robustness_`y'.png",replace
}
}



*Table2 Job seeking behaviour of job seekers
use "sample_rdd.dta", clear
local kernelfn "epa"   
global z "degree_id gender work_years"
foreach y of var active_chat_jobseeker  callback_rate_jobseeker{	
	foreach kvar of local kernelfn { 
	rdrobust `y' age, c(35.99) kernel(`kvar') all fuzzy(jobopp) covs($z)
		outreg2 using "table_j1.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}

local kernelfn "epa"   // 
global z "degree_id gender work_years"
foreach y of var active_chat_jobseeker  callback_rate_jobseeker {	
	foreach kvar of local kernelfn { 
	rdrobust `y' age, c(35.99) kernel(`kvar') all fuzzy(dummy_age) covs($z)
		outreg2 using "table_j1.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}


local kernelfn "epa"   
global z "degree_id gender work_years"
foreach y of var active_chat_jobseeker  callback_rate_jobseeker{	
	foreach kvar of local kernelfn { 
	rdrobust `y' age, c(35.99) kernel(`kvar') all fuzzy(jobopp)
		outreg2 using "table_j1.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}

local kernelfn "epa"   
global z "degree_id gender work_years"
foreach y of var  active_chat_jobseeker  callback_rate_jobseeker {	
	foreach kvar of local kernelfn { 
	rdrobust `y' age, c(35.99) kernel(`kvar') all fuzzy(dummy_age)
		outreg2 using "table_j1.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}



**table and Figure for salary


local kernelfn "epa"   // 
global z "degree_id gender work_years"
foreach y of var  dc_avg_job_salary dc_exp_salary_gap {	
	foreach kvar of local kernelfn { 
	rdrobust `y' age, c(35.99) kernel(`kvar') all fuzzy(dummy_age) covs($z)
		outreg2 using "table_s1.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append
	}
}


local kernelfn "epa"   
global z "degree_id gender work_years"
foreach y of var  dc_avg_job_salary dc_exp_salary_gap {	
	foreach kvar of local kernelfn { 
	rdrobust `y' age, c(35.99) kernel(`kvar') all fuzzy(dummy_age)
		outreg2 using "table_s1.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}


egen bin25 = cut(age2), at(30(0.4)40)
	 
rdplot dc_avg_job_salary bin25 if age2>30 & age2<40, ci(95) c(35.75) p(4) kernel(uni) shade	
rdplot dc_exp_salary_gap bin25 if age2>30 & age2<40, ci(95) c(35.75) p(4) kernel(uni) shade	

**Figure for senior and entry-level position

**(1)AS index

use "senior_level_age.dta", clear

drop age age_sqr dummy_age
gen dummy_age=1 if age_year>=36
replace dummy_age=0 if age_year<=35
gen age=age_year+age_month/12
gen age1=age_year+age_month/12-36
gen age1_sqr=age1^2
gen age1_inter=age1*dummy_age
gen age12_inter=age1^2*dummy_age

foreach y of var perchat*{
reg `y' age1 age1_sqr dummy_age  age1_inter 
outreg2 using "entry_senior_rg.xls", excel append 
}


graph twoway scatter perchat age if age1 >= -0.01 & age1>-6 & age1<4, msymbol(circle) mcolor(pink) msize(small) ///
    legend(title("")) || ///
    scatter  perchat age if age1 < -0.01 & age1>-6 & age1<4, msymbol(circle) mcolor(green) msize(small) || ///
    qfit  perchat age  if age1 >= -0.01 & age1>-6 & age1<4,  lc(pink) || ///
    qfit perchat age  if age1 < -0.01 & age1>-6& age1<4 , lc(green)

use "entry_level_age.dta", clear
drop age age_sqr dummy_age
gen dummy_age=1 if age_year>=36
replace dummy_age=0 if age_year<=35
gen age=age_year+age_month/12
gen age1=age_year+age_month/12-36
gen age1_sqr=age1^2
gen age1_inter=age1*dummy_age
gen age12_inter=age1^2*dummy_age

foreach y of var perchat*{
reg `y' age1 age1_sqr dummy_age  age1_inter 
outreg2 using "entry_senior_rg.xls", excel append 
}


graph twoway scatter perchat2 age if age1 >= -0.01 & age1>-6 & age1<4, msymbol(circle) mcolor(pink) msize(small) ///
    legend(title("")) || ///
    scatter  perchat2 age if age1 < -0.01 & age1>-6 & age1<4, msymbol(circle) mcolor(green) msize(small) || ///
    qfit  perchat2 age  if age1 >= -0.01 & age1>-6 & age1<4,  lc(pink) || ///
    qfit perchat2 age  if age1 < -0.01 & age1>-6& age1<4 , lc(green)



**(2)RDD results
use "sample_rdd.dta", clear
local kernelfn "epa"   
global z "degree_id gender work_years"
foreach y of var active_chat_recruiter_entry  callback_rate_recruiter_entry active_chat_recruiter_senior  callback_rate_recruiter_senior {	
	foreach kvar of local kernelfn { 
		
		rdrobust `y' age, c(35.99) kernel(`kvar') all fuzzy(dummy_age) covs($z)
		outreg2 using "table_rdd_entry_senior.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}


local kernelfn "epa"   
global z "degree_id gender work_years"
foreach y of var  active_chat_jobseeker_entry  callback_rate_jobseeker_entry active_chat_jobseeker_senior  callback_rate_jobseeker_senior {	
	foreach kvar of local kernelfn { 
		
		rdrobust `y' age, c(35.99) kernel(`kvar') all fuzzy(dummy_age) covs($z)
		outreg2 using "table_rdd_entry_senior.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}


rdplot per_sum_geek5_dq bin25 if age2>30 & age2<40, ci(95) c(35.9) p(4) kernel(epa) shade	
rdplot per_sum_geek1_dq bin25 if age2>30 & age2<39.5, ci(95) c(35.9) p(4) kernel(uni) shade	




**table-mobility intention

use "sample_rdd.dta", clear
local kernelfn "epa"  
global z "degree_id gender work_years"
foreach y of var nonexpected_cities_seeking cities_km_seeking rate_upper_tier_seeking rate_lower_tier_seeking {	
	foreach kvar of local kernelfn { 
	rdrobust `y' age, c(35.5) kernel(`kvar') all fuzzy(jobopp1) covs($z)
		outreg2 using "table_m1.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}

local kernelfn "epa"     
global z "degree_id gender work_years"
foreach y of var  nonexpected_cities_seeking cities_km_seeking rate_upper_tier_seeking rate_lower_tier_seeking  {	
	foreach kvar of local kernelfn { 
		
	rdrobust `y' age, c(35.5) kernel(`kvar') all fuzzy(dummy_age1) covs($z)
	 outreg2 using "table_m1.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}

local kernelfn "epa"   
global z "degree_id gender work_years"
foreach y of var  nonexpected_cities_seeking cities_km_seeking rate_upper_tier_seeking rate_lower_tier_seeking  {	
	foreach kvar of local kernelfn { 
		
	rdrobust `y' age, c(35.5) kernel(`kvar') all fuzzy(jobopp1)
		outreg2 using "table_m1.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}


local kernelfn "epa"   
global z "degree_id gender work_years"
foreach y of var  nonexpected_cities_seeking cities_km_seeking rate_upper_tier_seeking rate_lower_tier_seeking {	
	foreach kvar of local kernelfn { 
		
	rdrobust `y' age, c(35.5) kernel(`kvar') all fuzzy(dummy_age1)
		 outreg2 using "table_m1.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}


**Table for career path transition 
use "sample_rdd.dta", clear
local kernelfn "epa"   // 
global z "degree_id gender work_years"
foreach y of var ctive_chat_recruiter {	
	foreach kvar of local kernelfn { 
		
		rdrobust `y' age if service==0, c(35.99) kernel(`kvar') all fuzzy(dummy_age) covs($z)
		outreg2 using "table_cpt1.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}



local kernelfn "epa"   // 
global z "degree_id gender work_years"
foreach y of var ctive_chat_recruiter num_searched_labor_intensive num_searched_manufacturing {	
	foreach kvar of local kernelfn { 
		
		rdrobust `y' age if service==1 & capital_tec==1 , c(35.99) kernel(`kvar') all fuzzy(dummy_age) covs($z)
			outreg2 using "table_cpt1.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}


local kernelfn "epa"   // 
global z "degree_id gender work_years"
foreach y of var ctive_chat_recruiter {	
	foreach kvar of local kernelfn { 
		
		rdrobust `y' age if service==1 & capital_tec==0, c(35.99) kernel(`kvar') all fuzzy(dummy_age) covs($z)
			outreg2 using "table_cpt1.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}

**Heterogeneity Tests

use "sample_rdd.dta", clear
local kernelfn "epa " 
global z "degree_id1 gender work_years"
foreach y1 of var  active_chat_recruiter  callback_rate_recruiter active_chat_jobseeker  callback_rate_jobseeker  {	
 foreach y2 of var employment_status high_edu gender city_big{
  forvalue i=0/1{
	foreach kvar of local kernelfn { 
		rdrobust `y1' age if `y2'==`i', c(35.99) kernel(`kvar') all fuzzy(dummy_age) covs($z)
		outreg2 using "table_ht1.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}
}
}

local kernelfn "epa " 
global z "degree_id gender work_years"
foreach y1 of var  nonexpected_cities_seeking cities_km_seeking{	
 foreach y2 of var employment_status high_edu gender city_big {
  forvalue i=0/1{
	foreach kvar of local kernelfn { 
		rdrobust `y1' age if `y2'==`i', c(35.5) kernel(`kvar') all fuzzy(dummy_age1) covs($z)
		outreg2 using "table_ht1.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}
}
}

local kernelfn "epa " 
global z "degree_id1 gender work_years"
foreach y1 of var num_searched_labor_intensive num_searched_manufacturing {	
 foreach y2 of var employment_status high_edu gender city_big{
  forvalue i=0/1{
	foreach kvar of local kernelfn { 
		rdrobust `y1' age if `y2'==`i' & capital_tec==1 & service==1, c(35.99) kernel(`kvar') all fuzzy(dummy_age) covs($z)
		outreg2 using "table_ht1.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}
}
}
**Ploynominal fit regression of order 2 for different industries 

forvalues i=1/8 {
use "industry_ap_index.dta",clear
keep if age>=30 & age<40
gen y=ap_index
gen v=age-36
gen d=dummy_age
gen vd=v*d
gen v2=v^2
gen v2d=v2*d
  reg y d v v2 vd  v2d  if new_id==`i'
 outreg2 using "table_ind.xls", excel append
}


forvalue i=1/8{
use "industry_ap_index.dta",clear
keep if age>=30 & age<40
gen y=ap_index
gen v=age-36
gen d=dummy_age
gen vd=v*d
gen v2=v^2
gen v2d=v2*d
keep if new_id==`i'
global sizebin 0.4 //
gen bin=floor(v/$sizebin)
gen midbin=bin*$sizebin+0.5*$sizebin+36

bys bin: egen mean=mean(y)
reg y d v v2 vd v2d, robust
predict fit 
predict fitsd, stdp
gen upfit=fit+1.96*fitsd // 
gen downfit=fit-1.96*fitsd // 

preserve 
twoway (rarea upfit downfit age if v<0, sort fcolor(gs12) lcolor(gs12)) ///
(rarea upfit downfit age if v>=0, sort fcolor(gs12) lcolor(gs12)) ///
(line fit age if v<0, sort lcolor(green) lwidth(thick)) ///
(line fit age if v>0, sort lcolor(red) lwidth(thick)) ///
(scatter mean midbin, msize(large) mcolor(black) msymbol(circle_hollow)), ///
ytitle("") xtitle("") xline(35.95, lcolor(black)) ///
legend(off) xlabel(30(1)40) title("")
graph copy all, replace
restore
}
