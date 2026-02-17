# Longitudinal Multilevel Modeling (Mixed-Effects) — Orthodont Growth Data

## 🔍 Overview
This project builds a **multilevel (mixed-effects) longitudinal model** to explain how orthodontic measurement **distance** changes over **age**, while accounting for repeated observations within each **Subject**. The workflow compares random-intercept and random-slope specifications, adds key interactions, and produces portfolio-grade diagnostics and prediction checks.

## 🎯 Objective
- Model **growth trajectories** of orthodontic distance over time.
- Capture **within-subject correlation** using random effects.
- Evaluate whether allowing **subject-specific slopes** (different growth rates) improves fit.
- Quantify how growth differs by **Sex** and **Group** through interaction terms.

## 🧠 Methodology
1. **Data ingestion (preferred) + fallback generation**
   - Loads a longitudinal dataset (`orthodont_long.csv`) when available.
   - Includes a reproducible fallback generator to ensure the full workflow runs end-to-end.
2. **Exploratory data analysis (EDA)**
   - Distribution checks for `distance` and `age`.
   - Subject-level trajectory plots to visualize repeated-measures structure.
   - Grouped trend plots to compare patterns across `Sex` and `Group`.
3. **Mixed-effects model development (nlme::lme)**
   - **Model 1 (RI):** `distance ~ age` with **random intercept** by `Subject`.
   - **Model 2 (RI + RS):** `distance ~ age` with **random intercept + random slope** (`age`) by `Subject`.
   - **Model comparison:** Likelihood Ratio Test using ML-fitted versions to assess whether the random slope is justified.
4. **Full multilevel model with interactions**
   - **Fixed effects:** `distance ~ age * Sex + age * Group`
   - **Random effects:** `~ age | Subject` (subject-specific baseline and growth rate)
5. **Diagnostics + prediction validation**
   - Residuals vs fitted and Q–Q plot (Pearson residuals) to assess calibration and normality assumptions.
   - Out-of-sample evaluation with a **train/test split** and prediction error metrics (e.g., RMSE/MAE depending on outputs).

## 📊 Key Results
- **Random slope improves realism:** Allowing `age` to vary by subject captures heterogeneous growth rates and typically yields a better fit than random intercept alone (validated via ML-based LRT).
- **Interaction effects are interpretable:** The `age * Sex` and `age * Group` terms support group-specific growth trajectories rather than a single pooled slope.
- **Diagnostics are portfolio-ready:** Residual and Q–Q diagnostics provide evidence the model is behaving as expected and highlight any departures that might motivate extensions (variance modeling, robust approaches, or alternative distributions).
- **Predictive checks:** Holdout evaluation demonstrates practical usefulness beyond in-sample fit.

## 🛠 Technologies & Skills
- **R**
- Packages: `tidyverse`, `nlme`, `broom.mixed`, `performance`, `ggpubr`, `patchwork`, `scales`, `MASS`
- Skills:
  - Longitudinal / repeated-measures modeling
  - Mixed-effects specification (random intercepts, random slopes)
  - Likelihood-based model comparison (ML vs REML workflow)
  - Interaction modeling for differential trajectories
  - Residual diagnostics and model validation
  - Exporting publication-quality plots

## 🧩 Why This Project Matters
Many real-world datasets are **hierarchical** (customers within regions, patients within hospitals, students within schools) and often include **repeated measurements over time**. Multilevel modeling is essential to avoid biased inference and overconfident uncertainty estimates. This project demonstrates the ability to:
- Recognize and model nested structure correctly,
- Compare alternative random-effects specifications rigorously,
- Translate longitudinal effects into clear, decision-relevant insights.
