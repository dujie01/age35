use "industry_ap_index.dta",clear

forvalue i=1/8{
graph twoway scatter ap_index age if age >= 35.99 & industry_id==`i', msymbol(circle) mcolor(pink) msize(small) ///
    legend(title("")) || ///
    scatter  ap_index age if age < 35.99 & industry_id==`i', msymbol(circle) mcolor(ltgreen) msize(small) || ///
    qfit  ap_index age  if age >= 35.99 & industry_id==`i',  lc(pink) || ///
    qfit ap_index age  if age < 35.99 & industry_id==`i', lc(ltgreen)
graph save Graph "apindex_ind`i'.gph", replace
}
	
graph twoway scatter y_ind_d_f age2 if age2 >= 35.99 & draw_id==1, msymbol(circle) mcolor(pink) msize(small) ///
 legend(title("Legend Title")) || ///
  scatter y_ind_d_f if age2 < 35.99  & draw_id==1, msymbol(circle) mcolor(ltgreen) msize(small) 
