/*
CRD, 2 arms.
Assess gender attitude score ("score", integers 0-45) for each participant ("ID")
before (time=1) and after (time=2) intervention ("treatment").
*/


libname topic 'C:\Users\gunaratn\Box\Randomized Trials\content\Topic 14 Repeated Measures';
data gender; set topic.gender; run;

/* explore the data */

proc contents data=gender; run;

proc freq data=gender; run;

proc univariate data=gender;
	var score;
	histogram score;
run;

proc sort data=gender; by treatment time; run;
proc means data=gender; by treatment time; 
	var score;
	output out=out1 mean=;
run;

proc print data=out1;
run;

symbol1 v=dot i=join c=black;
symbol2 v=dot i=join c=red;
proc gplot data=out1;
	 plot score*time=treatment;
run;
quit;

title1 'Option 1:  Analyze endpoint data only';
proc glm data=gender plots=all;
	where time=2;
	class treatment (ref=first);
	model score = treatment / solution;
	lsmeans treatment / pdiff cl;
run;
title1;

quit;

title1 'Option 2:  Response=change in outcome over time';
proc sort data=gender; by ID time; run;

data g2;
    set gender;
    by ID;
    lag_score=lag1(score);
    if first.ID then lag_score=.;   *ensure we don’t carry over from previous ID;
    diff=score-lag_score;
run;

data g2;
    set g2;
    if time=2;
    drop time;
run;

proc sort data=g2; by treatment; run;
proc means data=g2; by treatment; 
	var diff; 
run;

proc univariate data=g2;
	var diff;
	histogram diff;
run;

proc glm data=g2 plots=all;
	class treatment (ref=first);
	model diff = treatment / solution;
	lsmeans treatment / pdiff cl;
run;
title1;

quit;

title1 'Option 3:  Longitudinal model';
proc mixed data=gender;
	class ID treatment(ref=first) time(ref=first);
	model score = treatment time treatment*time / ddfm=kr solution;
	repeated time / subject=ID type=cs r=1;
	lsmeans treatment*time / pdiff cl;
	estimate 'diff-in-diff' treatment*time 1 -1 -1 1;
run;

quit;

/* 
Option 4:  ANCOVA

CAUTION -- this is answering a subtly different question: 

“What is the difference in post-scores between groups after adjusting for differences in pre-scores?”
*/

title1 'Option 4:  ANCOVA';
symbol1 v=dot i=rl c=black;
symbol2 v=dot i=rl c=red;
proc gplot data=g2;
	 plot score*lag_score=treatment;
run;
quit;

proc glm data=g2 plots=all;
	class treatment (ref=first);
	model score = treatment lag_score treatment*lag_score / solution;
run;
title1;

quit;
