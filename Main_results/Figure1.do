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

gen dummy=1 if age>35
replace dummy=0 if age<=35

foreach y of var jobopp_companies jobopp_jd{
reg `y' dummy age if age<=40 & age>=30, robust
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
 (line m_jobopp_companies if age<=35 & age>=30, sort lcolor(blue) lwidth(thick)) ///
 (line m_jobopp_companies if age<=40 &age>35, sort lcolor(red) lwidth(thick)) ///
(scatter fit_jobopp_companies age if age<=40 & age>=30, msize(medlarge) mcolor(black)  msymbol(circle_hollow)), ///
ytitle("`var'") xtitle("Age (cutoff: 35.5)") xline(35.5, lcolor(black)) legend(order(1 "95% CI, age<=35" 2 "95% CI, age>35" 3 "Mean, age<=35" 4 "Mean,age>35" 5 "Fitted_value")) xlabel(30(1)40) title("Fuzzy RDD")

*-(d)
twoway (rarea upfitjobopp_jd downfitjobopp_jd age if age<=35 & age>=30, sort fcolor(blue%20) lcolor(blue%20)) ///
(rarea upfitjobopp_jd downfitjobopp_jd age if age<=40 & age>35, sort fcolor(red%20) lcolor(red%20)) ///
 (line m_jobopp_jd age if age<=35 & age>=30, sort lcolor(blue) lwidth(thick)) ///
 (line m_jobopp_jd age if age<=40 &age>35, sort lcolor(red) lwidth(thick)) ///
(scatter fit_jobopp_jd age1 if age<=40 & age>=30, msize(medlarge) mcolor(black)  msymbol(circle_hollow)), ///
ytitle("`var'") xtitle("Age (cutoff: 35.5)") xline(35.5, lcolor(black)) legend(order(1 "95% CI, age<=35" 2 "95% CI, age>35" 3 "Mean, age<=35" 4 "Mean,age>35" 5 "Fitted_value")) xlabel(30(1)40) title("Fuzzy RDD")
