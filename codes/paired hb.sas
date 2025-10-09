* Paired samples;
* Nilupa Gunaratna;
* Last modified Sept 03, 2024;

libname hb 'C:\Users\gunaratn\Box\Randomized Trials\content\Topic 04 CRD with two arms';

data paired_hb; set hb.paired_hb; run;

data paired_hb; set paired_hb;
	diff_hb = cbc - hemocue;
run;

/* paired t-test */
proc ttest plots(showh0) data=paired_hb;
	var diff_hb;
run;

/* Wilcoxon signed-rank test */
proc univariate data=paired_hb;
	var diff_hb;
run;

quit;
