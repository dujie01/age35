*Figure2
use "rdd_sample.dta",clear
egen bin10 = cut(age2), at(30(1)41)
foreach y of var perday_searched_num_jobseekers rate_matched_recruiters perday_searched_num_recruiters rate_matched_jobseekers {
    rdplot `y' bin10 if age>=30 & age<40, ci(95) c(35.1) p(2) kernel(uni) graph_options(title() legend(off) ytitle("`var'") xtitle() scheme(plotplainblind))
    graph export "`y'_f1.png" , replace
}
