/* In this example, a baseline assessment is done on all participants ("baseline").
Participants are then randomized into treatment 1 or treatment 2.  After
intervention, two outcomes are measured on each person:  test1 and test2.
We will analyze each outcome separately, testing for treatment effects while
adjusting for the baseline assessment. */

libname example 'C:\Users\gunaratn\Box\Randomized Trials\content\Topic 07 Analysis of Covariance';

data ancova; set example.ancova; run;

proc means data=ancova; 
	var baseline test1 test2;
run;

proc sort data=ancova; by treatment; run;
proc means data=ancova; by treatment; 
	var baseline test1 test2;
run;

title1 'test1 - no baseline adjustment ';
proc glm data=ancova;
	class treatment;
	model test1 = treatment / solution;
	means treatment;
	lsmeans treatment;
run;
title1;

proc sort data=ancova; by baseline; run;

symbol1 v=dot i=rl;
symbol2 v=dot i=rl;
proc gplot data=ancova;
	plot test1*baseline = treatment;
run;

quit;

title1 'test1 - baseline adjustment ';
proc glm data=ancova;
	class treatment;
	model test1 = treatment baseline / solution;
	means treatment;
	lsmeans treatment;
run;
title1;

quit;

/* TEST 2 */

proc gplot data=ancova;
	plot test2*baseline = treatment;
run;

title1 'test2 - no baseline adjustment ';
proc glm data=ancova;
	class treatment;
	model test2 = treatment / solution;
	means treatment;
	lsmeans treatment;
run;
title1;

title1 'test2 - baseline adjustment ';
proc glm data=ancova;
	class treatment;
	model test2 = treatment baseline / solution;
	means treatment;
	lsmeans treatment;
run;
title1;

title1 'test2 - baseline adjustment with interaction';
title2 'i.e., slope depends on the treatment';
proc glm data=ancova;
	class treatment;
	model test2 = treatment baseline treatment*baseline / solution;
	means treatment;
	lsmeans treatment;
run;
title1;
title2;

quit;

