# Bayesian Hierarchical Analysis of Blood Pressure Reduction

## 🔍 Overview
This project presents a production-grade Bayesian hierarchical modeling solution designed to evaluate blood pressure reduction outcomes across multiple healthcare institutions. The model captures both individual patient variability and hospital-level performance, enabling statistically sound comparisons in environments with heterogeneous data quality and sample sizes.

## 🎯 Objective
To deliver reliable, uncertainty-aware estimates of blood pressure reduction by hospital, supporting comparative performance analysis while avoiding bias from small sample effects or overfitting.

## 🧠 Methodology
A Bayesian hierarchical framework was implemented to model patient-level blood pressure reduction with partial pooling at the hospital level. This approach allows hospitals with limited data to borrow statistical strength from the broader population while preserving meaningful institutional differences. Inference was performed using Hamiltonian Monte Carlo, and model quality was assessed through posterior predictive checks and convergence diagnostics to ensure robustness and interpretability.

## 📊 Key Results
- Substantial variability in treatment effectiveness was observed across hospitals.
- Hierarchical pooling stabilized estimates for low-volume hospitals without masking true performance differences.
- Credible intervals provided transparent uncertainty quantification for all estimates.
- Distributional visualizations validated model assumptions and highlighted inter-hospital contrasts.

## 🛠 Technologies & Skills
- Bayesian Hierarchical Modeling  
- Probabilistic Inference  
- Statistical Diagnostics  
- R (rstan, tidyverse, bayesplot, loo)  
- Data Visualization  
- Healthcare Analytics  

## 🧩 Why This Project Matters
In real-world healthcare analytics, decision-making often relies on incomplete and uneven data. This project demonstrates how Bayesian hierarchical models produce more reliable and defensible insights than traditional methods, enabling fairer institutional comparisons and better-informed clinical and operational decisions.
