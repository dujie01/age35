*Table F5
use "industry_ap_index.dta",clear

forvalues i=1/84 {
  reg ap_index age age_sqr dummy_age if industry_id==`i'
}
