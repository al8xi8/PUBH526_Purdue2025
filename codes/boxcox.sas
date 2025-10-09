* Box-Cox Transformation;
* Nilupa Gunaratna;
* Last modified 11FEB2021;

libname nutr 'C:\Users\gunaratn\Box\Randomized Trials\content\Topic 05 CRD with multiple arms';

data boxcox; set nutr.boxcox; run;

proc sort data=boxcox; by treatment; run;

proc means data=boxcox; by treatment;
	var endline_glucose;
run;

proc glm data=boxcox plots=all;
	class treatment;
	model endline_glucose = treatment;
	means treatment / hovtest=bf;
	output out=diagnostics r=residual p=predicted student=student;
run;

symbol1 v=circle;
proc gplot data=diagnostics;
	plot residual*predicted;
run;

proc transreg data=boxcox;
	model boxcox(endline_glucose) = class(treatment);
run;

data boxcox; set boxcox;
	sqrt_gluc=sqrt(endline_glucose);
run;

proc glm data=boxcox plots=all;
	class treatment;
	model sqrt_gluc = treatment;
	means treatment / hovtest=bf;
	output out=diagnostics r=residual p=predicted student=student;
run;

symbol1 v=circle;
proc gplot data=diagnostics;
	plot residual*predicted;
run;

quit;
