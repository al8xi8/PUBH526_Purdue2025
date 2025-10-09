/**************************************************************************
 * PUBH 526 – Design and Analysis of Randomized Trials in Public Health
 * Homework 5
 * Alexandra Chang
 * Dataset: hw4.sas7bdat
 **************************************************************************/

/* STEP 1: Set library path */
libname mydata '/home/u64258127/sasuser.v94';

/* STEP 2: Create value formats */
proc format;
    value yes12no 1 = "yes" 2 = "no";
    value sex      1 = "female" 2 = "male";
    value trt      1 = "treatment" 0 = "control";
run;

/**************************************************************************
 * Question 2: Fit linear regression model for endline BMI by treatment
 **************************************************************************/
proc glm data=mydata.hw4;
    class treatment;
    model endlineBMI = treatment / solution;
    format treatment trt.;
    title "Linear Regression Model for Endline BMI by Treatment Group";
run;
quit;

/**************************************************************************
 * Optional: Check dataset structure and preview (for debugging)
 **************************************************************************/
proc contents data=mydata.hw4;
    title "Check Dataset Structure";
run;

proc print data=mydata.hw4 (obs=10);
    format sex sex. treatment trt. sedentary yes12no. consent yes12no.;
    title "Preview: First 10 Observations from hw4";
run;
