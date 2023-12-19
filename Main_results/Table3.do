*Table3
use "rdd_sample.dta",clear
local kernelfn "epa tri uni"   
global z "degree_id gender work_years"
foreach y of var perday_searched_num_recruiters{	
	foreach kvar of local kernelfn { 
		rdrobust `y' age if manufacture==1 , c(35.99) kernel(`kvar') all fuzzy(dummy_age) covs($z)
		outreg2 using "/Users/table3.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}

local kernelfn " epa tri uni"   
global z "degree_id gender work_years"
foreach y of var perday_searched_num_recruiters{	
	foreach kvar of local kernelfn { 
		rdrobust `y' age if cap_tech_intensive==1, c(35.99) kernel(`kvar') all fuzzy(dummy_age) covs($z)
		outreg2 using "/Users/table3.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}

local kernelfn " epa tri uni"   
global z "degree_id gender work_years"
foreach y of var perday_searched_num_recruiters{	
	foreach kvar of local kernelfn { 
		rdrobust `y' age if labor_intensive==1, c(35.99) kernel(`kvar') all fuzzy(dummy_age) covs($z)
		outreg2 using "/Users/table3.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}


local kernelfn " epa tri uni"   
global z "degree_id gender work_years"
foreach y of var num_searched_labor_intensive num_searched_manufacturing{	
	foreach kvar of local kernelfn { 
		rdrobust `y' age if cap_tech_intensive==1, c(35.99) kernel(`kvar') all fuzzy(dummy_age) covs($z)
		outreg2 using "/Users/table3.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}
