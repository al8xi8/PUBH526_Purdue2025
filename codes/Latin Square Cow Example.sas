/*
Consider an experiment to investigate the effect of 4 diets ("trt") on cows' milk 
production ("resp").  There are 4 cows ("cow") in this study, and each cow has 4 
lactation periods ("period").  The 4 diets are randomized across cows and lactation 
periods in a Latin square design.  After each lactation period, there is a "washout 
period" so the previous diet does not affect the results of the next diet.
*/

data cow;
input cow period trt resp;
cards;
1 1 1 38
1 2 2 32
1 3 3 35
1 4 4 33
2 1 2 39
2 2 3 37
2 3 4 36
2 4 1 30
3 1 3 45
3 2 4 38
3 3 1 37
3 4 2 35
4 1 4 41
4 2 1 30
4 3 2 32
4 4 3 33
;
run;

/* Why would cow or period affect milk yield? */

symbol1 v=dot i=none;

proc sort data=cow; by trt; run;
proc gplot data=cow;
	plot resp*trt;
run;

proc sort data=cow; by cow; run;
proc gplot data=cow;
	plot resp*cow;
run;

proc sort data=cow; by period; run;
proc gplot data=cow;
	plot resp*period;
run;

quit;

/* This mixed model uses a random effect for cow and iid errors to create the compound symmetry/exchangeable
   covariance structure. */
title1 'proc mixed - random statement';
proc mixed data=cow;
	class cow trt period;
	model resp=trt period / ddfm=kr; 	* kr: recommended df adjustment option;
	random cow; 						* creates a compound symmetry / exchangeable covariance structure;
	lsmeans trt / diff; 				* adjust for multiple comparisons if desired;
run;
title1;

/* This model uses a different parameterization to directly specify the compound symmetry/exchangeable 
   covariance structure at the level of the errors. */
title1 'proc mixed - repeated statement with type=cs';
proc mixed covtest cl data=cow;
	class cow trt period;
	model resp=trt period / ddfm=kr outp=diag;
	repeated period / subject=cow type=cs r=1;
	lsmeans trt / diff;
run;
title1;

/* Try a different error structure */
title1 'proc mixed - ar(1)';
proc mixed covtest cl data=cow;
	class cow trt period;
	model resp=trt period / ddfm=kr outp=diag;
	repeated period / subject=cow type=ar(1) r=1;
	lsmeans trt / diff;
run;
title1;

/* This covariance structure is too complex for our data */
title1 'proc mixed - unstructured correlation structure';
proc mixed covtest cl data=cow;
	class cow trt period;
	model resp=trt period / ddfm=kr outp=diag;
	repeated period / subject=cow type=un;
	lsmeans trt / diff;
run;
title1;

quit;
