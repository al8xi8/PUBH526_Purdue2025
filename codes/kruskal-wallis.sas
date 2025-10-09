* Kruskal Wallis Example;
* Nilupa Gunaratna;
* Last modified 08OCT2025;

libname nutr 'C:\Users\gunaratn\Box\Randomized Trials\content\Topic 05 CRD with multiple arms';

data noparam; set nutr.anova2; run;

proc npar1way data=noparam wilcoxon;
	class treatment;
	var endline_glucose;
run;

quit;
