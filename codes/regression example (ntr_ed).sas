* Nilupa Gunaratna;
* Analysis of food bank pre- and post-test scores;
* Last modified August 28, 2025;

libname pubh 'C:\Users\gunaratn\Box\Randomized Trials\content\Topic 01 Intro and Review'; 

data nutr_ed; set pubh.nutr_ed; run;

proc contents data=nutr_ed; run;

proc freq data=nutr_ed; run;

proc means data=nutr_ed; 
	var pretest posttest;
run;

proc univariate data=nutr_ed plot;
	var pretest posttest;
	histogram pretest posttest;
run;

symbol1 v=dot c=blue i=rl;
proc gplot data=nutr_ed;
	plot posttest*pretest;
run;

proc sgplot data=nutr_ed;
    scatter x=pretest y=posttest / markerattrs=(symbol=circlefilled color=blue);
    reg     x=pretest y=posttest / lineattrs=(color=blue);
	yaxis min=0 max=100;
run;

proc corr data=nutr_ed;
	var pretest posttest;
run;

proc reg data=nutr_ed;
	model posttest = pretest;
run;

quit;
