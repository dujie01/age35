*Figure 3 
*(a)-(b)
use "rdd_sample.dta",clear
egen bin5 = cut(age2), at(30(0.5)40)
foreach y of var nonexpected_cities_searched cities_searched_km{
    rdplot `y' bin5 if age>=30 & age<40, ci(95) c(35.1) p(2) kernel(uni) graph_options(title() legend(off) ytitle("`var'") xtitle() scheme(plotplainblind))
    graph export "`y'_f1.png" , replace
}
