# Survival Analysis of Recidivism Risk (Rossi Dataset)

## 🔍 Overview
This project applies **survival analysis** to study **time-to-arrest (recidivism)** after release, using the Rossi dataset. The workflow combines exploratory diagnostics with **Kaplan–Meier curves**, **Log-Rank testing**, and **Cox proportional hazards modeling** to assess how individual characteristics relate to event risk over time.

## 🎯 Objective
- Quantify how key covariates (e.g., financial aid, race indicator, work experience, marital status, parole status) relate to **time until arrest**.
- Compare **survival trajectories across groups** and validate whether group differences are statistically meaningful.
- Produce a portfolio-ready, reproducible set of plots and model diagnostics.

## 🧠 Methodology
1. **Data preparation**
   - Standardized binary fields (yes/no and category encodings) into **0/1** indicators for modeling consistency.
2. **Exploratory visualization**
   - **Boxplot** to validate distributions and variability for binary predictors and the outcome.
   - **Dual-axis time series** to compare the scale and variability of *prior arrests (prio)* vs *education (educ)* over weeks.
3. **Survival analysis**
   - Defined a unified survival object: `Surv(time = week, event = arrest)`.
   - Fit **univariate Cox models** for each covariate to estimate hazard ratios.
   - Built **survival curves** derived from fitted Cox models for multi-variable comparison.
4. **Kaplan–Meier + statistical testing**
   - Estimated **Kaplan–Meier curves by group** (focused on work experience, `wexp`).
   - Performed **Log-Rank test** to evaluate differences between group survival functions.
5. **Model diagnostics**
   - Computed **hazard ratios** via `exp(coef(coxph))`.
   - Tested the **proportional hazards assumption** using `cox.zph()`.

## 📊 Key Results
- **Binary variable distribution check (Boxplot):** The primary categorical predictors show adequate variability; the event rate supports survival modeling without obvious coding imbalance.
- **Prio vs Educ (Dual Axis):** Prior arrests (*prio*) display wider variability than education (*educ*), suggesting they capture different profile dimensions relevant for risk.
- **Survival curve separation (Cox-based curves):** Several covariates show visible separation in survival probability over time, indicating meaningful differences in event-free trajectories.
- **Work experience effect (KM + Log-Rank):** Kaplan–Meier curves for `wexp` show measurable divergence; the Log-Rank test supports a statistically significant difference in survival trajectories between groups.
- **Assumption checks:** Proportional hazards diagnostics (`cox.zph`) were generated to verify model suitability and flag any covariates requiring caution or extension.

## 🛠 Technologies & Skills
- **R**
- Packages: `survival`, `survminer`, `ggplot2`, `scales`
- Skills:
  - Survival object construction (`Surv`)
  - Kaplan–Meier estimation (`survfit`)
  - Log-Rank testing (`survdiff`)
  - Cox modeling (`coxph`)
  - Hazard ratio interpretation
  - Proportional hazards diagnostics (`cox.zph`)
  - Portfolio-grade visualization and labeling

## 🧩 Why This Project Matters
Time-to-event modeling is critical in domains where *when* something happens matters as much as *if* it happens—such as **recidivism**, **churn**, **default risk**, and **equipment failure**. This project demonstrates the ability to:
- Build a coherent survival workflow end-to-end,
- Translate statistical modeling into interpretable risk insights,
- Validate assumptions and communicate results with professional visual outputs.
