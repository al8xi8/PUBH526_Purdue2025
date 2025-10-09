* One-way ANOVA - comparisons among means;
* Nilupa Gunaratna;
* Last modified February 06, 2023;

libname nutr 'C:\Users\gunaratn\Box\Randomized Trials\content\Topic 05 CRD with multiple arms';

data anova1; set nutr.anova2; run;

proc freq data=anova1;
	tables treatment;
run;

proc sort data=anova1; by treatment; run;

proc means data=anova1; by treatment;
	var endline_glucose;
run;

title1 'Standard PROC GLM';
proc glm data=anova1;
	class treatment;
	model endline_glucose = treatment;
run;
title1;

title1 'PROC GLM with "solution" option';
proc glm data=anova1;
	class treatment;
	model endline_glucose = treatment / solution;
run;
title1;

title1 'PROC GLM specifying treatment 1 as the control/comparison group';
proc glm data=anova1;
	class treatment(ref="1");
	model endline_glucose = treatment / solution;
run;
title1;

quit;

