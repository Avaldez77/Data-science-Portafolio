# Recidivism Survival Intelligence (Kaplan–Meier + Cox Modeling)

## 🔍 Overview
This project builds an end-to-end **survival analysis** workflow to study **time-to-arrest (recidivism)**. It combines high-quality exploratory visuals, **Kaplan–Meier estimation**, **Log-Rank testing**, and **Cox proportional hazards models** to quantify how individual-level factors shape event risk over time.

## 🎯 Objective
- Estimate the probability of remaining **arrest-free over time** (`week` until `arrest`).
- Compare survival trajectories across key predictors (e.g., `wexp`, `fin`, `race`, `mar`, `paro`).
- Fit interpretable hazard models (Cox PH) and validate assumptions for portfolio-grade reporting.

## 🧠 Methodology
1. **Reproducible setup**
   - Loads required libraries: `survival`, `survminer`, `dplyr`, `ggplot2`, `scales`, `broom`.
   - Creates a structured output folder and standardized plotting theme for consistency.
2. **Survival object definition**
   - Constructs the survival target using: `Surv(time = week, event = arrest)`.
3. **Descriptive + diagnostic visuals**
   - Portfolio-standard ggplot graphics with consistent typography and labeling.
   - Includes categorical/binary distribution checks to confirm variability and event support.
4. **Kaplan–Meier analysis**
   - Fits KM curves with `survfit()` for group-level survival comparisons (notably `wexp`).
   - Produces publication-ready survival plots via `survminer::ggsurvplot()`.
5. **Hypothesis testing**
   - Uses `survdiff()` (Log-Rank test) to evaluate whether group survival curves differ statistically.
6. **Cox proportional hazards modeling**
   - Fits Cox models with `coxph()` to estimate hazard ratios for covariates such as:
     - `fin`, `race`, `wexp`, `mar`, `paro`, `prio`, `educ`
   - Summarizes results into clean tables using `broom`.
7. **Model validity checks**
   - Tests the proportional hazards assumption using `cox.zph()` and corresponding diagnostics.

## 📊 Key Results
- **Group separation is visible in KM curves:** Survival trajectories differ across key predictors (especially work experience `wexp`), indicating meaningful variation in time-to-event risk.
- **Log-Rank supports differences:** The Log-Rank test quantifies whether group-level survival differences are statistically consistent with non-random separation.
- **Cox models provide interpretable risk signals:** Hazard ratios translate covariate effects into direction/magnitude of recidivism risk, enabling ranking of risk drivers.
- **Assumption diagnostics are included:** PH checks (`cox.zph`) provide evidence for model suitability and flag any variables that may require caution or extensions.

## 🛠 Technologies & Skills
- **R**
- Packages: `survival`, `survminer`, `dplyr`, `ggplot2`, `scales`, `broom`
- Skills:
  - Survival object construction (`Surv`)
  - Kaplan–Meier estimation (`survfit`) + visual reporting (`ggsurvplot`)
  - Log-Rank testing (`survdiff`)
  - Cox proportional hazards modeling (`coxph`)
  - Hazard ratio interpretation and tidy model summaries
  - Proportional hazards diagnostics (`cox.zph`)
  - Exporting clean, reproducible outputs for portfolio artifacts

## 🧩 Why This Project Matters
Time-to-event modeling is essential in settings where **timing** is as important as occurrence—e.g., **recidivism**, **customer churn**, **loan default**, or **equipment failure**. This project demonstrates the ability to:
- Build a rigorous survival workflow end-to-end,
- Produce executive-ready, interpretable risk insights,
- Validate assumptions and communicate results with professional visual standards.
