* Power for two independent samples t-test;
* Nilupa Gunaratna;
* Last modified January 24, 2018;

/* two-sided test, H0: mean1=mean2, equal sample size in each group */

ods trace on;
title1 'Specifying specific group means';
proc power;
	twosamplemeans
		groupmeans  = (160 158) (160 156) (160 154) (160 152)
		stddev      = 7
		power       = 0.8
		alpha		= 0.05
		sides		= 2
		nulldiff	= 0
		npergroup   = .;
run;
title1;
ods trace off;

title1 'Specifying specific group means with ODS statement';
proc power;
	twosamplemeans
		groupmeans  = (160 158) (160 156) (160 154) (160 152)
		stddev      = 7
		power       = 0.8
		alpha		= 0.05
		sides		= 2
		nulldiff	= 0
		npergroup   = .;
	ods output output=output_groupmeans;
run;
title1;

title1 'Specifying differences between means - same result';
proc power;
	twosamplemeans
		meandiff   	= 2 to 8 by 2
		stddev      = 7
		power       = 0.8
		alpha		= 0.05
		sides		= 2
		nulldiff	= 0
		npergroup   = .;
	ods output output=output_meandiffs;
run;
title1;

/* as the difference in the group means increases, fewer participants are needed */

symbol1 v=dot i=join;
proc gplot data=output_meandiffs;
	plot npergroup*MeanDiff;
run;

quit;

/* Power increases if sample size increases - note the diminishing returns of increasing sample size */

title1 'Effect of sample size on power';
proc power;
	twosamplemeans
		meandiff   	= 3
		stddev      = 7
		power       = .
		alpha		= 0.05
		sides		= 2
		nulldiff	= 0
		npergroup   = 10 to 200 by 5;
    plot interpol=join yopts=(ref=0.80);
run;
title1;

/* Power increases if variability decreases */

title1 'Effect of SD on power';
proc power;
	twosamplemeans
		meandiff   	= 3
		stddev      = 1 to 10 by 1
		power       = .
		alpha		= 0.05
		sides		= 2
		nulldiff	= 0
		npergroup   = 50;
	ods output output=powerout;
run;
title1;

symbol1 v=dot i=join;
proc gplot data=powerout;
	plot power*stddev;
run;

quit;

/* Power increases if alpha increases */

title1 'Effect of significance level on power';
proc power;
	twosamplemeans
		meandiff   	= 3
		stddev      = 7
		power       = .
		alpha		= 0.05 0.10
		sides		= 2
		nulldiff	= 0
		npergroup   = 50;
run;
title1;

/* power calculation for effect sizes */

title1 'Power calculation for effect sizes';
proc power;
	twosamplemeans
		meandiff   	= 0.1 to 1.0 by 0.1
		stddev      = 1
		power       = .
		alpha		= 0.05
		sides		= 2
		nulldiff	= 0
		npergroup   = 50;
	ods output output=powerout;
run;
title1;

symbol1 v=dot i=join;
proc gplot data=powerout;
	plot power*meandiff;
run;

quit;
