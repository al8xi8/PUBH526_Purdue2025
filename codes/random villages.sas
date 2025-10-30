libname food 'C:\Users\gunaratn\Box\Randomized Trials\content\Topic 10 Random Effects';

data village; set food.village; run;

proc means data=village n nmiss mean stddev var stderr min max;
	var foodsecurity;
run;

proc mixed data=village cl plots=all;
	class village;
	model foodsecurity = / cl;
	random intercept / subject=village vcorr=1;
run;

proc sort data=village; by village; run;
proc means data=village noprint; by village;
	var foodsecurity;
	output out=fs mean=fs_mean std=fs_std;
run;

proc univariate normal plot data=fs;
	var fs_mean;
run;

quit;
