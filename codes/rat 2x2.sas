data rat;
input rat trt $ resp;
cards;
1 A 106
2 A 101
3 A 120
4 A  86
5 A 132
6 A  97
7 a  51
8 a  98
9 a  85
10 a  50
11 a 111
12 a  72
13 B 103
14 B  84
15 B 100
16 B  83
17 B 110
18 B  91
19 b  60
20 b  85
21 b  72
22 b  61
23 b  66
24 b  50
;run;

proc sort data=rat; by trt; run;
proc means data=rat; by trt;
	var resp;
run;

/* one-way ANOVA using contrasts */
proc glm data=rat; 
	class trt; 
	model resp = trt / solution;
	estimate 'hormone' trt 0.5 -0.5 0.5 -0.5;
	estimate 'level' trt 0.5 0.5 -0.5 -0.5; 
	estimate 'interaction (diff in diff)' trt 1 -1 -1 1;
	lsmeans trt / tdiff pdiff lines;
run;

/* note there are no missing data, so recoding is straightforward */
data rat; set rat;
	if trt="b" or trt="B" then hormB=1;
		else hormB=0;	* what would happen if we had a missing value of trt? ;
	if trt="A" or trt="B" then level_high=1;
		else level_high=0;
run;

/* analyzing as 2x2 factorial design */
proc glm data=rat plots=all;
	class hormB(ref=first) level_high(ref=first); 
	model resp = hormB level_high hormB*level_high / solution;
	output out=new1 r=resid p=predict;
run;

proc univariate data=new1 normal plot;
	var resid;
	histogram resid;
run;

symbol1 v=circle; axis1 offset=(5);

proc gplot data=new1;
	plot resid*predict resid*level_high resid*hormB / haxis=axis1;
run;

quit;
