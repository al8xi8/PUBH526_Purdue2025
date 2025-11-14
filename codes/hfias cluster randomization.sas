libname example 'C:\Users\gunaratn\Box\Randomized Trials\content\Topic 11 Cluster Randomized Trials';

data hfias; set example.hfias_cluster;
run;

proc freq data=hfias;
run;

proc sort data=hfias; by village; run;

symbol1 v=dot i=none;
proc gplot data=hfias;
	plot hfias*village=intervention;
run;

quit;

proc mixed data=hfias cl;
	class village intervention;
	model hfias = intervention / ddfm=kr;
	random intercept / subject=village vcorr=1;
	lsmeans intervention / cl;
run;

quit;
