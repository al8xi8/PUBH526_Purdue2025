libname food 'C:\Users\gunaratn\Box\Randomized Trials\content\Topic 09 RCBD';

data hfias; set food.hfias; run;

/* garden=1 is the intervention */
proc sort data=hfias; by aez garden; run;

proc means data=hfias; by aez garden;
	var foodsec;
	output out=out1 mean=fs_mean stderr=fs_se;
run;

/* technically, a bar graph is more appropriate */
symbol1 v=dot i=join;
proc gplot data=out1;
	plot fs_mean*garden=AEZ;
run;

/* are you truly interested in all pairwise comparisons? */
proc glm data=hfias;
	class AEZ garden;
	model foodsec = AEZ garden AEZ*garden / solution;
	lsmeans AEZ*garden / slice=AEZ stderr tdiff adjust=tukey;
run;

quit;
