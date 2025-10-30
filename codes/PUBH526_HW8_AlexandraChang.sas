/**************************************************************************
 * PUBH 526 – Design and Analysis of Randomized Trials in Public Health
 * Homework 8
 * Author:  Alexandra Chang
 * Dataset: milk.sas7bdat / sugar.sas7bdat
 * Purpose: Analyze treatment and covariate effects on milk consumption
 *          and blood glucose outcomes.
 **************************************************************************/

libname mydata '/home/u64258127/sasuser.v94';


/**************************************************************************
 * Question 1(a): Pairwise Comparisons of Treatments at Endline
 * Transformation: λ = 0 (Natural Log)
 **************************************************************************/

data milk_log;
    set mydata.milk;
    log_endline = log(endline_milk);
run;

title1 "ANOVA for Log-Transformed Endline Milk Consumption";
proc glm data=milk_log plots=diagnostics;
    class treatment;
    model log_endline = treatment / solution;
    means treatment / hovtest=levene;
    lsmeans treatment / pdiff=all adjust=tukey;
run;
quit;


/**************************************************************************
 * Question 1(b): Effect of Parent Brochure (Main Effect)
 * Contrast: (Trt 2,4) vs (Trt 1,3)
 **************************************************************************/

title1 "Contrast: Effect of Parent Brochure on Log-Endline Milk Consumption";
proc glm data=milk_log;
    class treatment;
    model log_endline = treatment;
    contrast "Parent Brochure Effect (Trt 2,4 vs Trt 1,3)"
             treatment -1 1 -1 1;
run;
quit;


/**************************************************************************
 * Question 1(c): Effect of Child Activity Booklet (Main Effect)
 * Contrast: (Trt 3,4) vs (Trt 1,2)
 **************************************************************************/

title1 "Contrast: Effect of Child Activity Booklet on Log-Endline Milk Consumption";
proc glm data=milk_log;
    class treatment;
    model log_endline = treatment;
    contrast "Child Activity Effect (Trt 3,4 vs Trt 1,2)"
             treatment -1 -1 1 1;
run;
quit;


/**************************************************************************
 * Question 2(a): Sex Differences in Fasting Blood Glucose
 * Test: Independent Two-Sample t-Test
 **************************************************************************/

title1 "Sex Differences in Fasting Blood Glucose";
proc ttest data=mydata.sugar;
    class sex;            /* 1 = Female, 2 = Male */
    var fasting;
run;
quit;

title1 "ANOVA for Fasting Blood Glucose by Sex";
proc glm data=mydata.sugar plots=diagnostics;
    class sex;
    model fasting = sex;
    means sex / hovtest=levene;
run;
quit;


/**************************************************************************
 * Question 2(b): Relationship Between Income and Fasting Blood Glucose
 * Test: One-Way ANOVA
 **************************************************************************/

title1 "ANOVA for Fasting Blood Glucose by Income Level";
proc glm data=mydata.sugar plots=diagnostics;
    class income;                   /* 1 = Lower, 2 = Middle, 3 = Higher */
    model fasting = income / solution;
    means income / hovtest=levene;
    lsmeans income / pdiff=all adjust=tukey;
run;
quit;


/**************************************************************************
 * Question 2(c): Intention-to-Treat Analysis
 * Model: One-Way ANOVA (Postmeal Blood Glucose)
 **************************************************************************/

title1 "ANOVA for Postmeal Blood Glucose by Treatment (Intention-to-Treat)";
proc glm data=mydata.sugar plots=diagnostics;
    class treatment;
    model postmeal = treatment / solution;
    means treatment / hovtest=levene;
    lsmeans treatment / pdiff=all adjust=tukey;
run;
quit;


/**************************************************************************
 * Question 2(d–f): Effect Modification by Sex (Treatment × Sex)
 * Model: Two-Way ANOVA
 **************************************************************************/

title1 "Two-Way ANOVA: Treatment × Sex Interaction for Postmeal Blood Glucose";
proc glm data=mydata.sugar;
    class treatment sex;
    model postmeal = treatment sex treatment*sex / solution;
    means treatment*sex / hovtest=levene;
run;
quit;

/* --- Interaction Plot --- */
title1 "Interaction Plot: Postmeal Blood Glucose by Treatment and Sex";
proc sgplot data=mydata.sugar;
    vline treatment / response=postmeal group=sex stat=mean markers
                     lineattrs=(thickness=2)
                     markerattrs=(symbol=circlefilled)
                     datalabel=sex;
    xaxis label="Treatment Group";
    yaxis label="Mean Postmeal Blood Glucose (mg/dL)";
    keylegend / title="Sex";
    title2 "Figure: Mean Postmeal Glucose by Treatment and Sex (Interaction Plot)";
run;
quit;


/**************************************************************************
 * Question 2(g): Effect Modification by Income (Treatment × Income)
 * Model: Two-Way ANOVA
 **************************************************************************/

title1 "Two-Way ANOVA: Treatment × Income Interaction for Postmeal Blood Glucose";
proc glm data=mydata.sugar plots=diagnostics;
    class treatment income;
    model postmeal = treatment income treatment*income / solution;
    means treatment*income / hovtest=levene;
run;
quit;

/* --- Interaction Plot --- */
title1 "Interaction Plot: Postmeal Blood Glucose by Treatment and Income";
proc sgplot data=mydata.sugar;
    vline treatment / response=postmeal group=income stat=mean markers
                     lineattrs=(thickness=2)
                     markerattrs=(symbol=circlefilled);
    xaxis label="Treatment Group";
    yaxis label="Mean Postmeal Blood Glucose (mg/dL)";
    keylegend / title="Income Level";
    title2 "Figure: Mean Postmeal Glucose by Treatment and Income (Interaction Plot)";
run;
quit;


/**************************************************************************
 * Question 2(h): Effect Modification by Fasting Blood Glucose
 * Model: ANCOVA (Treatment × Fasting Interaction)
 **************************************************************************/

title1 "ANCOVA: Treatment × Fasting Blood Glucose Interaction for Postmeal Response";
proc glm data=mydata.sugar plots=diagnostics;
    class treatment;
    model postmeal = treatment fasting treatment*fasting / solution;
run;
quit;

/* --- Publication-Quality Graph --- */
title1 "Interaction Plot: Postmeal vs. Fasting Blood Glucose by Treatment";
proc sgplot data=mydata.sugar;
    reg x=fasting y=postmeal / group=treatment;
    xaxis label="Fasting Blood Glucose (mg/dL)";
    yaxis label="Postmeal Blood Glucose (mg/dL)";
    keylegend / title="Treatment Group";
    title2 "Figure: Relationship between Fasting and Postmeal Glucose by Treatment";
run;
quit;
