*Table2 
use "rdd_sample.dta",clear
local kernelfn "epa tri uni"
global z "degree_id gender work_years"
foreach y of var nonexpected_cities_searched cities_searched_km rate_upper_tier_searched rate_lower_tier_searched{	
	foreach kvar of local kernelfn { 
		rdrobust `y' age, c(35.5) kernel(`kvar') all fuzzy(jobopp1)
		outreg2 using "/Users/table2.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}
local kernelfn "epa tri uni"
global z "degree_id gender work_years"
foreach y of var nonexpected_cities_searched cities_searched_km rate_upper_tier_searched rate_lower_tier_searched{	
	foreach kvar of local kernelfn { 
		rdrobust `y' age, c(35.5) kernel(`kvar') all fuzzy(jobopp1) covs($z)
		outreg2 using "/Users/table2.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}
gen dummy_age1=1 if age>=35.5
replace dummy_age1=0 if age<35.5
local kernelfn "epa tri uni"  
global z "degree_id gender work_years"
foreach y of var nonexpected_cities_searched cities_searched_km rate_upper_tier_searched rate_lower_tier_searched{	
	foreach kvar of local kernelfn { 
		rdrobust `y' age, c(35.5) kernel(`kvar') all fuzzy(dummy_age1) 
		outreg2 using "/Users/table2.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}
local kernelfn "epa tri uni" 
global z "degree_id gender work_years"
foreach y of var nonexpected_cities_searched cities_searched_km rate_upper_tier_searched rate_lower_tier_searched {	
	foreach kvar of local kernelfn { 
		rdrobust `y' age, c(35.5) kernel(`kvar') all fuzzy(dummy_age1) covs($z)
		outreg2 using "/Users/table2.xls", excel addtext(Kernel Type, `e(kernel)') addstat(bandwidth, e(h_l)) ctitle(`y'_p) dec(4) append 
	}
}
