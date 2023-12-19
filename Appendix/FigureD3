*Figure D3
use "rdd_sample.dta",clear
egen bin10 = cut(age2), at(30(1)41)
foreach y of var perday_matched_num  gap_different_salary {
    rdplot `y' bin10 if age>=30 & age<40, ci(95) c(35.1) p(2) kernel(uni) graph_options(title() legend(off) ytitle("`var'") xtitle() scheme(plotplainblind))
    graph export "`y'_f1.png" , replace
}
