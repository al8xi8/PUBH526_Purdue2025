/**************************************************************************
 * PUBH 526 – Design and Analysis of Randomized Trials in Public Health
 * Homework 4
 * Alexandra Chang
 * Dataset: hw4.sas7bdat
 **************************************************************************/

/* STEP 1: Assign correct library */
libname mydata '/home/u64258127/sasuser.v94';

/* STEP 2: Define formats */
proc format;
    value yes12no  1 = "yes"  2 = "no";
    value sex      1 = "female"  2 = "male";
    value trt      1 = "treatment"  0 = "control";
run;

/* STEP 3: View dataset structure */
proc contents data=mydata.hw4; run;

/* STEP 4: Preview first 10 observations */
proc print data=mydata.hw4 (obs=10);
    format sex sex. treatment trt.;
    title "Table 1: First 10 Observations in hw4 Dataset";
run;

/* STEP 5: Check for missing values in treatment */
proc freq data=mydata.hw4;
    tables treatment / missing;
    title "Check for Missing Values in Treatment Variable";
run;

/* STEP 6: Descriptive statistics by treatment group */
proc means data=mydata.hw4 mean std min max;
    class treatment;
    var endlineBMI;
    title "Descriptive Statistics for Endline BMI by Treatment Group";
run;

/* STEP 7: Check normality of endline BMI within each group */
proc univariate data=mydata.hw4 normal;
    class treatment;
    var endlineBMI;
    histogram endlineBMI / normal;
    qqplot endlineBMI / normal(mu=est sigma=est);
    title "Histogram and QQ Plot of Endline BMI by Treatment Group";
run;

/* STEP 8: Two-sample t-test for difference in endline BMI */
proc ttest data=mydata.hw4;
    class treatment;
    var endlineBMI;
    title "Two-Sample t-test Comparing Endline BMI by Treatment Group";
run;
