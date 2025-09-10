/**************************************************************************
 * PUBH 526 – Design and Analysis of Randomized Trials in Public Health
 * Homework 2
 * Alexandra Chang
 * Dataset: activity.sas7bdat
 **************************************************************************/

libname mydata '/home/u64258127';
data activity;
    set mydata.activity;
    improvement = after_intervention - before_intervention;
run;

/**************************************************************************
 * Question 1: Scatterplot of Before vs. After Intervention
 **************************************************************************/
proc sgplot data=activity;
    scatter x=before_intervention y=after_intervention;
    reg x=before_intervention y=after_intervention;
    xaxis label="Before Intervention";
    yaxis label="After Intervention";
    title "Figure 1: Physical Activity Before vs. After Intervention";
run;

/**************************************************************************
 * Question 3: Linear Regression of After vs. Before
 **************************************************************************/
proc reg data=activity;
    model after_intervention = before_intervention;
    title "Table 1: Linear Regression Results";
run;
quit;

/**************************************************************************
 * Question 5: Descriptive Statistics (Mean and Std Dev)
 **************************************************************************/
proc means data=activity mean stddev maxdec=2;
    var before_intervention after_intervention;
    title "Table 2: Summary Statistics for Activity Scores";
run;

/**************************************************************************
 * Question 6: Correlation Between Improvement and Baseline
 **************************************************************************/
proc corr data=activity;
    var before_intervention improvement;
    title "Table 3: Correlation Between Baseline and Improvement";
run;

/**************************************************************************
 * Question 7–8: Residual Diagnostics – Scatter & Q-Q Plot
 **************************************************************************/

/* Output residuals and predicted values */
proc reg data=activity;
    model after_intervention = before_intervention;
    output out=diagnostics r=resid p=pred;
run;

/* Residuals vs. Fitted Values */
proc sgplot data=diagnostics;
    scatter x=pred y=resid;
    refline 0 / axis=y;
    xaxis label="Predicted Values";
    yaxis label="Residuals";
    title "Figure 2: Residuals vs. Fitted Values";
run;

/* Normal Q-Q Plot */
proc univariate data=diagnostics normal;
    var resid;
    qqplot resid / normal(mu=est sigma=est);
    title "Figure 3: Q-Q Plot of Residuals";
run;
