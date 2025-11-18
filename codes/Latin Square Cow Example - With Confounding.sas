/*
3 cows, 3 periods, 3 treatments, but every cow does treatment 1 in period 1
*/

data cow;
input cow period trt resp;
cards;
1 1 1 38
1 2 2 32
1 3 3 35
2 1 1 39
2 2 3 37
2 3 2 36
3 1 1 45
3 2 2 38
3 3 3 37
;
run;

/* mixed model with cow as random effect */
title1 'proc mixed - random statement';
proc mixed data=cow;
	class cow trt period;
	model resp=trt period / ddfm=kr; * recommended df adjustment option;
	random cow;
	lsmeans trt / diff; * adjust for multiple comparisons if desired;
run;
title1;

/* same results with different syntax / conceptual difference */
title1 'proc mixed - repeated statement with type=cs';
proc mixed covtest cl data=cow;
	class cow trt period;
	model resp=trt period / ddfm=kr outp=diag;
	repeated period / subject=cow type=cs r=1;
	lsmeans trt / diff;
run;
title1;
