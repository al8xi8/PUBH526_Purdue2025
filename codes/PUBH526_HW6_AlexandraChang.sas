/**************************************************************************
 * PUBH 526 – Design and Analysis of Randomized Trials in Public Health
 * Homework 6
 * Alexandra Chang
 * Dataset: hw4.sas7bdat
 **************************************************************************/

libname mydata '/home/u64258127/sasuser.v94';

proc format;
    value yes12no  1 = "yes"  2 = "no";
    value sex      1 = "female"  2 = "male";
    value trt      1 = "treatment"  0 = "control";
run;


/**************************************************************************
 * Question 1: Does the physical activity intervention affect BMI?
 * Outcome: endlineBMI
 * Comparison: treatment vs. control
 * Test: Nonparametric (Wilcoxon Rank-Sum Test)
 **************************************************************************/

proc npar1way data=mydata.hw4 wilcoxon;
    class treatment;
    var endlineBMI;
    format treatment trt.;
    title "Question 1: Wilcoxon Rank-Sum Test for Endline BMI by Treatment Group";
run;


/**************************************************************************
 * Question 2: Does the intervention change a person’s chance of being overweight?
 * Outcome: Overweight status at endline (BMI ≥ 25)
 * Test: Chi-Square Test of Independence
 **************************************************************************/

/* Create indicator variable for overweight status */
data hw4_overwt;
    set mydata.hw4;
    if not missing(endlineBMI) then do;
        if endlineBMI >= 25 then overweight = 1;
        else overweight = 0;
    end;
run;

/* Frequency table and Chi-Square test */
proc freq data=hw4_overwt;
    tables treatment*overweight / chisq expected norow nocol nopercent;
    format treatment trt.;
    title "Question 2: Chi-Square Test of Independence for Overweight Status by Treatment Group";
run;


/**************************************************************************
 * Question 3: Nonparametric test for overweight status by treatment group
 * Outcome: Overweight status at endline (BMI ≥ 25)
 * Test: Fisher’s Exact Test (nonparametric alternative to Chi-Square)
 **************************************************************************/

proc freq data=hw4_overwt;
    tables treatment*overweight / fisher expected norow nocol nopercent;
    format treatment trt.;
    title "Question 3: Fisher's Exact Test for Overweight Status by Treatment Group";
run;


/**************************************************************************
 * Question 4: Does BMI change over time among the control group?
 * Dataset: hw4.sas7bdat
 * Test: Paired t-test (parametric)
 **************************************************************************/

/* Restrict to control group only */
proc ttest data=mydata.hw4;
    where treatment = 0;
    paired endlineBMI*baselineBMI;
    format treatment trt.;
    title "Question 4: Paired t-test for Change in BMI Over Time – Control Group Only";
run;


/**************************************************************************
 * Question 5: Does BMI change over time among the treatment group?
 * Dataset: hw4.sas7bdat
 * Test: Wilcoxon Signed-Rank Test (nonparametric paired test)
 **************************************************************************/

/* Step 1: Create the difference variable */
data trt_only;
    set mydata.hw4;
    where treatment = 1;
    diff_bmi = endlineBMI - baselineBMI;
run;

/* Step 2: Perform Wilcoxon Signed-Rank Test */
proc univariate data=trt_only mu0=0;
    var diff_bmi;
    title "Question 5: Wilcoxon Signed-Rank Test for Change in BMI – Treatment Group Only";
run;


/**************************************************************************
 * Question 6: Sample size for a completely randomized 2-arm RCT
 * Goal: Detect Δ = 1 kg/m^2 difference in BMI (two-sided α = 0.05)
 * Use baseline BMI to estimate SD, assume equal SD in both arms
 **************************************************************************/

/**************************************************************************
 * Step 1: Estimate SD of baseline BMI (overall)
 **************************************************************************/
proc means data=mydata.hw4 n mean stddev;
    var baselineBMI;
    title "Question 6: Baseline BMI Summary (Use SD for Power Calculation)";
run;

/**************************************************************************
 * Step 2: Power analysis for 2-sample comparison of means
 * Goal: Detect Δ = 1 kg/m^2 difference in BMI
 * Assumptions:
 *   - Equal allocation (1:1)
 *   - α = 0.05 (two-sided)
 *   - σ = 1.7933 (from Step 1)
 **************************************************************************/

proc power;
    twosamplemeans
        test = diff
        meandiff = 1          /* Δ = 1 kg/m^2 */
        stddev   = 1.7933     /* estimated from baseline BMI */
        alpha    = 0.05
        power    = 0.80 0.90  /* solve for these power levels */
        sides    = 2
        ntotal   = .;         /* tell SAS to compute total sample size */
    title "Question 6: Required Sample Size for Δ = 1 in BMI (Two-Sided α = 0.05)";
run;

/* Compute N per arm */
data Q6_final;
    set Q6_power;
    N_per_arm = ceil(NTotal/2);
run;

proc print data=Q6_final noobs label;
    label N_per_arm = "Required N per arm (rounded up)";
    title "Question 6: Final Sample Size per Arm";
run;
