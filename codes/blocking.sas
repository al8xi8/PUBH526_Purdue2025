libname block 'C:\Users\gunaratn\Box\Randomized Trials\content\Topic 09 RCBD';

data blk; set block.blocking; run;

/* "treatment" - randomization regardless of baseline score:  completely randomized design (CRD) */

/* 25 participants for each treatment */
title1 'CRD';
proc freq data=blk;
	tables treatment;
run;

/* as we would expect, baseline values seem comparable across arms on average.
   however, baseline values generally seem fairly variable */
proc sort data=blk; by treatment; run;
proc means data=blk; by treatment;
	var baseline;
run;

proc univariate data=blk; 
	var baseline; 
	histogram baseline; 
run;

/* what is the distribution of low baseline values in each arm?  lowBL=1 if low baseline value and =0 if not */
proc freq data=blk;
	tables treatment*lowBL / nopercent nocol;
run;

/* "strat_trt" - stratify based on baseline value [low baseline score (lowBL) vs. not], then randomize within each stratum.  randomized complete block design (RCBD) */

/* still have 25 participants/treatment.  how many of these should be low baseline in each arm? */
title1 'RCBD';
proc freq data=blk;
	tables strat_trt;
run;

proc sort data=blk; by strat_trt; run;
proc means data=blk; by strat_trt;
	var baseline;
run;

proc freq data=blk;
	tables strat_trt*lowBL / nopercent nocol;
run;

