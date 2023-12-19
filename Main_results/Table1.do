*Table1
use "rdd_sample.dta",clear
local kernelfn "epa tri uni"   
global z "degree_id gender work_years"
foreach y of var perday_searched_num_jobseekers rate_matched_recruiters perday_searched_num_recruiters rate_matched_jobseekers {	
	foreach kvar of local kernelfn { 
	rdrobust `y' age, c(35.99) kernel(`kvar') all fuzzy(jobopp)
		outreg2 using "/Users/table1.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}
local kernelfn "epa tri uni"   // 
global z "degree_id gender work_years"
foreach y of var perday_searched_num_jobseekers rate_matched_recruiters perday_searched_num_recruiters rate_matched_jobseekers {	
	foreach kvar of local kernelfn { 
	rdrobust `y' age, c(35.99) kernel(`kvar') all fuzzy(jobopp) covs($z)
		outreg2 using "/Users/table1.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}
gen dummy_age=1 if age>=35.99
replace dummy_age=0 if age<35.99
local kernelfn "epa tri uni"   
global z "degree_id gender work_years"
foreach y of var perday_searched_num_jobseekers rate_matched_recruiters perday_searched_num_recruiters rate_matched_jobseekers {	
	foreach kvar of local kernelfn { 
	rdrobust `y' age, c(35.99) kernel(`kvar') all fuzzy(dummy_age)
		outreg2 using "/Users/table1.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}
local kernelfn "epa tri uni"   // 
global z "degree_id gender work_years"
foreach y of var perday_searched_num_jobseekers rate_matched_recruiters perday_searched_num_recruiters rate_matched_jobseekers {	
	foreach kvar of local kernelfn { 
	rdrobust `y' age, c(35.99) kernel(`kvar') all fuzzy(dummy_age) covs($z)
		outreg2 using "/Users/table1.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}
