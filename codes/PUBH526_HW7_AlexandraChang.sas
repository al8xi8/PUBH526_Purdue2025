/**************************************************************************
 * PUBH 526 – Design and Analysis of Randomized Trials in Public Health
 * Homework 7
 * Dataset: /home/u64258127/sasuser.v94/milk.sas7bdat
 * Author:  Alexandra Chang
 * Topic:   One-Way ANOVA and Multiple Comparisons
 **************************************************************************/

libname mydata '/home/u64258127/sasuser.v94';

/**************************************************************************
 * Question 1: Does weekly milk consumption differ across treatments?
 * Study: 4 treatment arms randomized to increase milk consumption
 * Model: Completely Randomized Design (CRD)
 **************************************************************************/

title1 "ANOVA for Endline Milk Consumption";
proc glm data=mydata.milk plots=diagnostics;
    class treatment;
    model endline_milk = treatment / solution;
    means treatment / hovtest=levene;
    lsmeans treatment / pdiff=all adjust=tukey;
run;
quit;

/**************************************************************************
 * Post-hoc Comparison: Dunnett’s Test (Treatment 1 as Control)
 **************************************************************************/
title1 "Dunnett’s Comparisons: Treatments vs Control (Treatment 1)";
proc glm data=mydata.milk;
    class treatment;
    model endline_milk = treatment;
    lsmeans treatment / pdiff=control('1') adjust=dunnett;
run;
quit;

/**************************************************************************
 * Model Diagnostics
 **************************************************************************/
title1 "Residual Diagnostics for ANOVA Model";
proc glm data=mydata.milk;
    class treatment;
    model endline_milk = treatment;
    output out=diag r=resid p=pred;
run;
quit;

title2 "Histogram and Density Plot for Residuals";
proc sgplot data=diag;
    histogram resid;
    density resid;
run;

title2 "Normal Q-Q Plot for Residuals";
proc univariate data=diag normal;
    var resid;
    qqplot resid / normal(mu=est sigma=est);
run;

title2 "Residuals vs Predicted Values";
proc sgplot data=diag;
    scatter x=pred y=resid;
    refline 0 / axis=y lineattrs=(color=red);
run;

/**************************************************************************
 * Optional: Box–Cox Transformation (if assumptions violated)
 **************************************************************************/

title1 "Box–Cox Transformation for Endline Milk Consumption";
proc transreg data=mydata.milk;
    model boxcox(endline_milk) = class(treatment);
run;

data milk_log;
    set mydata.milk;
    log_endline = log(endline_milk);
run;

proc glm data=milk_log;
    class treatment;
    model log_endline = treatment / solution;
    lsmeans treatment / pdiff=all adjust=tukey;
run;
quit;
