* One-way ANOVA - contrasts;
* Nilupa Gunaratna;
* Last modified September 23, 2024;

libname pubh 'C:\Users\gunaratn\Box\Randomized Trials\content\Topic 06 Treatment Comparisons';

data anova3; set pubh.anova3; run;

proc sort data=anova3; by treatment; run;

proc means data=anova3; by treatment;
	var endline_glucose;
run;

title1 'PROC GLM, comparing treatments 1 and 3 in five different ways';
proc glm data=anova3;
	class treatment;
	model endline_glucose = treatment / solution;
	estimate 'treatment 1 vs. 3' treatment 1 0 -1;
	estimate 'treatment 3 vs. 1' treatment -1 0 1;
	contrast 'treatment 1 vs. 3' treatment 1 0 -1;
	contrast 'treatment 3 vs. 1' treatment -1 0 1;
run;
title1;

title1 'PROC GLM, other pairwise treatment comparisons';
proc glm data=anova3;
	class treatment;
	model endline_glucose = treatment / solution;
	estimate 'treatment 2 vs. 1' treatment -1 1 0;
	estimate 'treatment 3 vs. 2' treatment 0 -1 1;
run;
title1;

title1 'PROC GLM, compare average of trts 2&3 to 1';
proc glm data=anova3;
	class treatment;
	model endline_glucose = treatment / solution;
	estimate 'using -1 0.5 0.5' treatment -1 0.5 0.5;
	estimate 'using -2 1 1' treatment -2 1 1;
	contrast 'using -1 0.5 0.5' treatment -1 0.5 0.5;
	contrast 'using -2 1 1' treatment -2 1 1;
run;
title1;

quit;
