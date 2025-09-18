* Malaria1 study: Analysis of hemoglobin at delivery;
* Nilupa Gunaratna;
* Last modified September 18, 2025;

libname malaria 'C:\Users\gunaratn\Box\Randomized Trials\content\Topic 04 CRD with two arms';

data hemo; set malaria.hb_2020_01_28; run;

/* check and explore your data first */

proc contents data=hemo; run;

proc freq data=hemo;
	tables treatment;
run;

proc sort data=hemo; by treatment; run;

proc means data=hemo; by treatment; 
	var hemoglobin;
run;

proc univariate normal plot data=hemo;
	var hemoglobin;
	histogram hemoglobin / midpoints=4 to 17 by 1;
run;

/* Does taking iron during pregnancy affect hemoglobin at delivery? */

proc ttest data=hemo;
	class treatment;
	var hemoglobin;
run;

proc glm data=hemo plots=all;
	class treatment;
	model hemoglobin = treatment;
	output out=diagnostics r=residual p=predicted rstudent=student;
run;

symbol1 v=circle;
proc gplot data=diagnostics;
	plot residual*predicted;
run;

proc gplot data=diagnostics;
	plot student*predicted;
run;

proc univariate normal plot data=diagnostics;
	var residual student;
run;

/* regression approach */

/* BEWARE MISSING VALUES WHEN RECODING VARIABLES */

proc freq data=hemo; 
	tables treatment;
run;

/* note this changes your working dataset, not the original that is in your SAS library */
data hemo; set hemo;
	if treatment="Iron" then iron=1;
	else iron=0;
run;

proc reg data=hemo;
	model hemoglobin = iron;
run;

proc glm data=hemo;
	class treatment;
	model hemoglobin = treatment / solution;
	output out=diagnostics r=residual p=predicted rstudent=student;
run;

/* nonparametric test */

title1 'Wilcoxon Rank-Sum / Mann-Whitney Test';
proc npar1way data=hemo wilcoxon;
	class treatment;
	var hemoglobin;
run;
title1;

/* categorical outcome */

data hemo; set hemo;
	if hemoglobin=. then anemia=.;
		else if hemoglobin < 11 then anemia=1;
		else anemia=0;
run;

proc freq data=hemo;
	tables anemia treatment*anemia;
run;

proc freq data=hemo;
	tables treatment*anemia / nopercent nocol;
run;

proc freq data=hemo;
	tables treatment*anemia / nopercent nocol chisq fisher;
run;

quit;
