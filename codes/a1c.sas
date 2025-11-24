* PUBH 526 Randomized Trials in Public Health;
* Crossover example;
* 3 treatments, measure A1C;

libname xo 'C:\Users\gunaratn\Box\Randomized Trials\content\Topic 13 Crossover Design';

data a1c; set xo.a1c;
run;

proc sort data=a1c; by participant round; run;

proc freq data=a1c; 
	tables treatment round treatment*round;
run;

proc sort data=a1c; by round treatment; run;
proc means data=a1c noprint; by round treatment;
	var a1c;
	output out=out1 mean=a1cmean;
run;

symbol1 v=dot i=join;
proc gplot data=out1;
	plot a1cmean*round=treatment;
run;

quit;

title1 'CS';
proc mixed covtest data=a1c;
	class participant round treatment;
	model a1c = treatment round treatment*round / ddfm=kr outp=diag;
		* ddfm=kr is the recommended degree of freedom method;
		* the dataset "diag" gives you residuals, predicted values, and other variables to check model diagnostics;
	repeated round / subject=participant type=cs r=1;
	lsmeans round / diff tdiff; * this is ok to do b/c treatment*round is not significant;
run;
title1;

title1 'AR(1)';
proc mixed covtest data=a1c;
	class participant round treatment;
	model a1c = treatment round treatment*round / ddfm=kr outp=diag;
	repeated round / subject=participant type=ar(1) r=1;
	lsmeans round / diff tdiff; 
run;
title1;

quit;
