*Figure B2
*(a)Histogram and Kernel Density of Age
use "rdd_sample.dta",clear
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

*Due to space limitations, we did not present the smoothing test regression results for the control variables in the main text. The corresponding codes are as follows.
// local kernelfn "epa tri uni"   
// global z "degree_id gender work_years"
// foreach y of var $z {	
// 	foreach kvar of local kernelfn { 	
// 		rdrobust `y' age, c(35.99) kernel(`kvar') all fuzzy(dummy_age)
// 		outreg2 using "/Users/admin/Downloads/results_robust_fff.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
// 	}
// }

// local kernelfn "epa tri uni" 
// global z "degree_id gender work_years"
// foreach y of var $z {	
// 	foreach kvar of local kernelfn { 
// 		rdrobust `y' age, c(35.99) kernel(`kvar') all fuzzy(jobopp)
// 		outreg2 using "/Users/admin/Downloads/results_robust_fff.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
// 	}
// }
