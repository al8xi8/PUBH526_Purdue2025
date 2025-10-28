* 2 study sites, 500 participants in each;
* at each study site, we want 250 participants randomly allocated to treatment 1 and 250 participants randomly 
  allocated to treatment 2;

data rando;
	do participant_id = 1000 to 1499;
		site=1;
	   output;
	end;
	do participant_id = 2500 to 2999;
		site=2;
	   output;
	end;
run;

data rando; set rando;
   u = rand("Uniform");     /* u ~ U(0,1).  you can also specify a seed here, which will allow you to replicate your randomization */
run;

proc sort data=rando; by site u; run;

data rando; set rando;
	ord+1;
run;

data rando; set rando;
	if ord <= 250 then treatment=1;
		else if ord <= 500 then treatment=2;
		else if ord <= 750 then treatment=1;
		else treatment=2;
	drop ord; * you can drop u, but I like to keep it for documentation purposes;
run;

proc sort data=rando; by participant_id; run;

proc freq data=rando;
	tables site*treatment / norow nocol;
run;

/* save your dataset as a SAS library (Excel can be too easily edited).  you can export and format for users as needed */
