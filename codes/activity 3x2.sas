* 3 x 2 factorial;
* response is number of active minutes in a day, measured by a fitness tracker;
* intervention 1 (trt):  encouragement to be active, delivered 3 different ways;
* intervention 2 (sleep):  encouragement to sleep adequately and on a regular schedule vs. no sleep intervention;


libname active 'C:\Users\gunaratn\Box\Randomized Trials\content\Topic 15 Factorial Designs';

data active; set active.active; run;

proc freq data=active;
	tables trt sleep trt*sleep age activity;
run;

proc sort data=active; by sleep trt;
run;

proc means data=active; 
	by sleep trt; 
	var activity; 
run;

proc glm data=active plots=all;
	class trt sleep;
	model activity=trt sleep trt*sleep;
	lsmeans trt*sleep / slice=sleep adjust=tukey stderr tdiff;
run;

quit;

proc glm data=active plots=all;
	class trt sleep;
	model activity=	trt sleep trt*sleep 
					age 
					age*trt age*sleep age*trt*sleep;
run;

quit;

proc glm data=active plots=all;
	class trt sleep;
	model activity=	trt sleep trt*sleep
					age;
	lsmeans trt*sleep / slice=sleep adjust=tukey stderr tdiff;
run;

quit;
