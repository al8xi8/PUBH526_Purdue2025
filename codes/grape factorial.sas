data grape;
input variety pest resp @@;
cards;
1 1 49 1 1 39 1 2 50 1 2 55 1 3 43 1 3 38 1 4 85 1 4 73
2 1 55 2 1 41 2 2 67 2 2 58 2 3 53 2 3 42 2 4 53 2 4 48
3 1 66 3 1 68 3 2 85 3 2 92 3 3 69 3 3 62 3 4 85 3 4 99
;run;

* interaction plot;
proc sort data=grape; by pest variety;
run;

proc means noprint data=grape; 
	by pest variety; 
	var resp; 
	output out=new1 mean=mn;
run;

symbol1 v=circle i=join; 

proc gplot data=new1; 
	plot mn*variety=pest;
run;

quit;

* Two-factor analysis;
proc glm data=grape plots=all;
	class variety pest;
	model resp = variety|pest;
	lsmeans variety*pest / slice=variety adjust=tukey stderr tdiff;
	output out=new1 r=res p=pred;
run;

proc glimmix data=grape;
	class variety pest;
	model resp = variety|pest;
	lsmeans variety*pest / slicediff=variety adjust=tukey;
run;

quit;
