* Effect modification;

libname example 'C:\Users\gunaratn\Box\Randomized Trials\content\Topic 08 Effect Modification';

proc format;
	value yesno	1="no"
				2="yes";
run;

data em; set example.em; run;

proc sort data=em; by treatment; run;
proc means data=em; by treatment;
	var test_score;
run;

proc sort data=em; by tutoring; run;
proc means data=em; by tutoring;
	var test_score;
run;

proc sort data=em; by treatment tutoring; run;
proc means data=em; by treatment tutoring;
	var test_score;
	output out=testmeans mean=score_mean stderr=score_se;
run;

symbol1 v=dot;
proc gplot data=testmeans;
	plot score_mean*tutoring=treatment;
run;

quit;

title1 'intention to treat analysis';
proc glm data=em;
	class treatment;
	model test_score = treatment / solution;
	lsmeans treatment;
run;
title1;

title1 'tutoring as effect modifier';
proc glm data=em plots=all;
	class treatment(ref="1") tutoring(ref="no");
	model test_score = treatment tutoring treatment*tutoring / solution;
	lsmeans treatment*tutoring / cl;
run;
title1;

quit;
