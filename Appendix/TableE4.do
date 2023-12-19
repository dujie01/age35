*for figure E4 and for table E4
use "rdd_sample.dta",clear
local kernelfn "epa tri uni" 
global z "degree_id gender work_years"
foreach y of var rate_matched_recruiters perday_searched_num_recruiters rate_matched_jobseekers perday_matched_num  gap_different_salary{	
	foreach kvar of local kernelfn { 
		rdrobust `y' age if employment_status==1, c(35.99) kernel(`kvar') all fuzzy(dummy_age) covs($z)
		outreg2 using "/Users/table4.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}
local kernelfn "epa tri uni"   // 
global z "degree_id gender work_years"
foreach y of var cities_searched_km {	
	foreach kvar of local kernelfn { 
		rdrobust `y' age if employment_status==1, c(35.5) kernel(`kvar') all fuzzy(dummy_age1) covs($z)
		outreg2 using "/Users/table4.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}


local kernelfn "epa tri uni"  
global z "degree_id gender work_years"
foreach y of var rate_matched_recruiters perday_searched_num_recruiters rate_matched_jobseekers perday_matched_num  gap_different_salary{	
	foreach kvar of local kernelfn { 
		rdrobust `y' age if employment_status==0, c(35.99) kernel(`kvar') all fuzzy(dummy_age) covs($z)
		outreg2 using "/Users/table4.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}
local kernelfn "epa tri uni"  
global z "degree_id gender work_years"
foreach y of var cities_searched_km{	
	foreach kvar of local kernelfn { 
		rdrobust `y' age if employment_status==0, c(35.5) kernel(`kvar') all fuzzy(dummy_age1) covs($z)
		outreg2 using "/Users/table4.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}



local kernelfn "epa tri uni"  
global z "degree_id gender work_years"
foreach y of var rate_matched_recruiters perday_searched_num_recruiters rate_matched_jobseekers perday_matched_num  gap_different_salary{	
	foreach kvar of local kernelfn { 
		rdrobust `y' age if high_edu==1, c(35.99) kernel(`kvar') all fuzzy(dummy_age) covs($z)
		outreg2 using "/Users/admin/Downloads/middle_age/table4_rp1.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}
local kernelfn "tri epa uni"  
global z "degree_id1 gender work_years"
foreach y of var cities_searched_km{	
	foreach kvar of local kernelfn { 
		rdrobust `y' age if high_edu==1, c(35.5) kernel(`kvar') all fuzzy(dummy_age1) covs($z)
		outreg2 using "/Users/admin/Downloads/middle_age/table4_rp1.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}

local kernelfn "epa tri uni"   
global z "degree_id gender work_years"
foreach y of var rate_matched_recruiters perday_searched_num_recruiters rate_matched_jobseekers perday_matched_num  gap_different_salary{	
	foreach kvar of local kernelfn { 
		rdrobust `y' age if high_edu==0, c(35.99) kernel(`kvar') all fuzzy(dummy_age) covs($z)
		outreg2 using "/Users/admin/Downloads/middle_age/table4_rp1.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}
local kernelfn "epa tri uni"   
global z "degree_id gender work_years"
foreach y of var cities_searched_km{	
	foreach kvar of local kernelfn { 
		rdrobust `y' age if high_edu==0, c(35.5) kernel(`kvar') all fuzzy(dummy_age1) covs($z)
		outreg2 using "/Users/admin/Downloads/middle_age/table4_rp1.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}


local kernelfn "epa tri uni"  
global z "degree_id gender work_years"
foreach y of var rate_matched_recruiters perday_searched_num_recruiters rate_matched_jobseekers perday_matched_num  gap_different_salary{	
	foreach kvar of local kernelfn { 
		rdrobust `y' age if city_level<=2, c(35.99) kernel(`kvar') all fuzzy(dummy_age) covs($z)
		outreg2 using "/Users/admin/Downloads/middle_age/table4_rp1.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}
local kernelfn "tri epa uni"  
global z "degree_id1 gender work_years"
foreach y of var cities_searched_km{	
	foreach kvar of local kernelfn { 
		rdrobust `y' age if city_level<=2, c(35.5) kernel(`kvar') all fuzzy(dummy_age) covs($z)
		outreg2 using "/Users/admin/Downloads/middle_age/table4_rp1.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}


local kernelfn "tri epa uni"   
global z "degree_id gender work_years"
foreach y of var rate_matched_recruiters perday_searched_num_recruiters rate_matched_jobseekers perday_matched_num  gap_different_salary{	
	foreach kvar of local kernelfn { 
		rdrobust `y' age if city_level>=3, c(35.99) kernel(`kvar') all fuzzy(dummy_age) covs($z)
		outreg2 using "/Users/admin/Downloads/middle_age/table4_rp1.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}
local kernelfn "tri epa uni"   
global z "degree_id1 gender work_years"
foreach y of var cities_searched_km{	
	foreach kvar of local kernelfn { 
		rdrobust `y' age if city_level>=3, c(35.5) kernel(`kvar') all fuzzy(dummy_age1) covs($z)
		outreg2 using "/Users/admin/Downloads/middle_age/table4_rp1.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}



local kernelfn "tri epa uni"  
global z "degree_id gender work_years"
foreach y of var rate_matched_recruiters perday_searched_num_recruiters rate_matched_jobseekers perday_matched_num  gap_different_salary{	
	foreach kvar of local kernelfn { 
		rdrobust `y' age if gender==1, c(35.99) kernel(`kvar') all fuzzy(dummy_age) covs($z)
		outreg2 using "/Users/admin/Downloads/middle_age/table4_rp1.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}
local kernelfn "tri epa uni"  
global z "degree_id gender work_years"
foreach y of var cities_searched_km{	
	foreach kvar of local kernelfn { 
		rdrobust `y' age if gender==1, c(35.5) kernel(`kvar') all fuzzy(dummy_age1) covs($z)
		outreg2 using "/Users/admin/Downloads/middle_age/table4_rp1.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}

local kernelfn "tri epa uni"  
global z "degree_id gender work_years"
foreach y of var rate_matched_recruiters perday_searched_num_recruiters rate_matched_jobseekers perday_matched_num  gap_different_salary{	
	foreach kvar of local kernelfn { 
		rdrobust `y' age if gender==0, c(35.99) kernel(`kvar') all fuzzy(dummy_age) covs($z)
		outreg2 using "/Users/admin/Downloads/middle_age/table4_rp1.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}
local kernelfn "tri epa uni"  
global z "degree_id1 gender work_years"
foreach y of var cities_searched_km{	
	foreach kvar of local kernelfn { 
		rdrobust `y' age if gender==0, c(35.5) kernel(`kvar') all fuzzy(dummy_age1) covs($z)
		outreg2 using "/Users/admin/Downloads/middle_age/table4_rp1.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}
