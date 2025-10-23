* One-way ANOVA - multiple comparisons;
* Nilupa Gunaratna;
* Last modified February 13, 2023;

libname topic6 'C:\Users\gunaratn\Box\Randomized Trials\content\Topic 06 Treatment Comparisons';

data mc; set topic6.mc; run;

proc sort data=mc; by treatment; run;

proc means data=mc; by treatment;
	var test_score;
run;

proc glm data=mc;
	class treatment;
	model test_score = treatment / solution;
run;

quit;

title1 'Bonferroni';
proc glm data=mc;
	class treatment;
	model test_score = treatment;
	means treatment / lines bon;
run;
title1;

quit;

title1 'LSD';
proc glm data=mc;
	class treatment;
	model test_score = treatment;
	means treatment / alpha=0.05 lines lsd;
run;
title1;

quit;

title1 'Dunnett';
proc glm data=mc;
	class treatment;
	model test_score = treatment;
	means treatment / dunnett;
run;
title1;

quit;

title1 'Tukey';
proc glm data=mc;
	class treatment;
	model test_score = treatment;
	means treatment / lines tukey;
	lsmeans treatment / lines adjust=tukey;
run;
title1;

quit;

title1 'Scheffe';
proc glm data=mc;
	class treatment;
	model test_score = treatment;
	means treatment / lines scheffe;
run;
title1;

quit;
