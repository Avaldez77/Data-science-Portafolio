# 🔍 Overview

This project implements a Bayesian linear regression framework to model adult human height as a function of body weight, using multiple prior assumptions to evaluate robustness, uncertainty, and interpretability. The solution contrasts regularization-based priors with domain-informed expert priors, providing a transparent probabilistic view of parameter behavior and model performance.

# 🎯 Objective

To build and compare Bayesian regression models that quantify the relationship between height and weight in adults, assess uncertainty through posterior distributions, and evaluate competing modeling assumptions using principled Bayesian model comparison.

# 🧠 Methodology

The workflow begins with exploratory data analysis to validate linear assumptions and variable relevance. Three Bayesian models are then specified and estimated using Stan:

- A **ridge-like (L2) prior model** with multivariate normal priors on coefficients.
- A **lasso-like (L1) prior model** using double exponential priors for shrinkage and variable selection.
- An **expert prior model** incorporating domain-informed beliefs about expected height and weight effects.

Posterior inference is performed via MCMC sampling. Model diagnostics include trace inspection and convergence checks. Competing models are evaluated using Bayes Factors derived from bridge sampling, complemented by BIC for additional comparison.

# 📊 Key Results

- Height shows a strong, stable linear relationship with weight across all models.
- Shrinkage priors reduce parameter variance while preserving predictive structure.
- Expert priors shift posterior estimates toward domain expectations without degrading fit.
- Bayesian model comparison favors the expert-informed specification over purely regularized alternatives.
- Posterior uncertainty is explicitly quantified, enabling reliable interpretation beyond point estimates.

# 🛠 Technologies & Skills

- Bayesian Modeling & Probabilistic Inference  
- Stan (rstan) and MCMC Sampling  
- Model Regularization (L1 / L2 Priors)  
- Bayesian Model Comparison (Bayes Factors, BIC)  
- Data Visualization & Diagnostic Analysis  
- R, tidyverse, bayesplot, bridgesampling  

# 🧩 Why This Project Matters

This project demonstrates how Bayesian methods can be applied in real-world analytical settings to balance data-driven learning with prior knowledge. By explicitly modeling uncertainty and comparing assumptions transparently, the approach supports more trustworthy decision-making in scenarios where interpretability and robustness are critical.
