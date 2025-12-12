
/**************************************************************************
 * PUBH 526 – Design and Analysis of Randomized Trials in Public Health
 * Homework 12
 * Topic: Repeated Measures / Longitudinal Analysis
 * Dataset: growth.sas7bdat
 * Author: Alexandra Chang
 **************************************************************************/

/* Reset environment */
options nocenter ls=80 pageno=1 nosyntaxcheck;
ods graphics on;
title;

/**************************************************************************
 * 1. Load Dataset
 **************************************************************************/

libname mydata '/home/u64258127/sasuser.v94';

data growth;
    set mydata.growth;
run;

/**************************************************************************
 * 2. Explore Data Structure
 **************************************************************************/

proc contents data=growth;
run;

/**************************************************************************
 * 3. Descriptive Statistics by Treatment Group and Time
 **************************************************************************/

title "Mean HAZ by Treatment Group and Time";
proc means data=growth mean std;
    class treatment time;
    var haz;
run;

/**************************************************************************
 * 4. Longitudinal Mixed Model (Topic 14 – Option 3)
 *    Treatment × Time interaction estimates intervention effect
 *    Diagnostic plots requested directly from PROC MIXED
 **************************************************************************/

title "Longitudinal Mixed Model with Treatment × Time Interaction";
proc mixed data=growth plots=all;
    class id treatment time;
    model haz = treatment time treatment*time / solution;
    repeated time / subject=id type=cs;
run;

ods graphics off;
