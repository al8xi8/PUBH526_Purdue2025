/**************************************************************************
 * PUBH 526 – Design and Analysis of Randomized Trials in Public Health
 * Homework 11
 * Author:  Alexandra Chang
 * Datasets: hfias.sas7bdat, hfias_cluster.sas7bdat, backpain.sas7bdat
 **************************************************************************/

libname mydata '/home/u64258127/sasuser.v94';

***********************************************************************
* Question 1: AEZ × garden ANOVA
***********************************************************************;

/* Load HFIAS dataset */
data hfias;
    set mydata.hfias;
run;

/* Recode AEZ × garden into a single factor */
data hfias;
    set hfias;

    if AEZ = "high" and garden = 0 then AEZgarden = "high0";
    if AEZ = "high" and garden = 1 then AEZgarden = "high1";

    if AEZ = "med"  and garden = 0 then AEZgarden = "med0";
    if AEZ = "med"  and garden = 1 then AEZgarden = "med1";

    if AEZ = "low"  and garden = 0 then AEZgarden = "low0";
    if AEZ = "low"  and garden = 1 then AEZgarden = "low1";
run;

/* Original two-way ANOVA model */
proc glm data=hfias;
    class AEZ garden;
    model foodsec = AEZ garden AEZ*garden;
    title "Original ANOVA: AEZ, garden, and AEZ*garden Interaction";
run;
quit;

/* One-way ANOVA using combined AEZgarden factor */
proc glm data=hfias;
    class AEZgarden;
    model foodsec = AEZgarden;
    lsmeans AEZgarden / stderr tdiff adjust=tukey lines;
    title "One-Way ANOVA: AEZgarden (Combined AEZ × garden Factor)";
run;
quit;

***********************************************************************
* Question 2: Cluster Randomized Trial
***********************************************************************;

/* Load clustered HFIAS dataset */
data hfias; 
    set mydata.hfias_cluster;
run;

/* Frequencies for key variables */
proc freq data=hfias;
run;

/* Sort by village */
proc sort data=hfias; 
    by village; 
run;

/* Plot outcome by village */
symbol1 v=dot i=none;
proc gplot data=hfias;
    plot hfias * village = intervention;
run;
quit;

/* Mixed model with clustering accounted for */
proc mixed data=hfias cl;
    class village intervention;
    model hfias = intervention / ddfm=kr;
    random intercept / subject=village vcorr=1;
    lsmeans intervention / cl;
run;
quit;

/* Mixed model ignoring clustering (CRD) */
proc mixed data=hfias cl;
    class intervention;
    model hfias = intervention / ddfm=kr;
    lsmeans intervention / cl;
run;
quit;

***********************************************************************
* Question 3: Crossover Trial – Back Pain Exercise Data
***********************************************************************;

/* Load backpain dataset */
data backpain;
    set mydata.backpain;
run;

/* Dataset structure and descriptive summaries */
proc contents data=backpain; run;
proc means data=backpain; 
    var Y; 
    class treatment period; 
run;

/* Crossover analysis using PROC MIXED */
proc mixed data=backpain;
    class person treatment period;
    model Y = treatment period / ddfm=kr;
    random person;
    lsmeans treatment / cl;
run;

**************************************************************************
* End of Homework 11 SAS Code
**************************************************************************/
