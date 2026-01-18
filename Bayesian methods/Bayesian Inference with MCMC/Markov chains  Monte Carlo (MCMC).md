🔍 Overview

This project implements a complete Bayesian inference workflow using Markov Chain Monte Carlo (MCMC) methods with Hamiltonian Monte Carlo (HMC) via Stan. The solution covers synthetic data generation, probabilistic model specification, posterior sampling, convergence diagnostics, and uncertainty quantification, delivered as a clean, portfolio-ready analysis.

🎯 Objective

Estimate latent parameters of a probabilistic model with high reliability using Bayesian inference, ensuring robust posterior estimation through advanced MCMC techniques and validating results with diagnostic and uncertainty visualizations.

🧠 Methodology

A synthetic dataset is generated from a hierarchical probabilistic process. The Bayesian model is defined and compiled in Stan, and posterior inference is performed using HMC with multiple chains. Posterior samples are extracted and analyzed through trace plots to verify convergence and mixing, followed by posterior density plots to assess uncertainty and credible intervals.

📊 Key Results

The posterior estimates closely align with the true underlying parameters used in data generation. Trace plots confirm stable chain mixing and convergence, while posterior density plots provide clear uncertainty bounds through 95% credible intervals, supporting reliable Bayesian inference.

🛠 Technologies & Skills

- R  
- Stan (rstan)  
- Bayesian Inference  
- Markov Chain Monte Carlo (MCMC)  
- Hamiltonian Monte Carlo (HMC / NUTS)  
- Probabilistic Modeling  
- Statistical Data Visualization  

🧩 Why This Project Matters

This project demonstrates the practical application of modern Bayesian methods for parameter estimation under uncertainty. It highlights the ability to implement, diagnose, and interpret advanced MCMC-based models—skills directly applicable to real-world decision-making, risk analysis, and probabilistic modeling in data-driven environments.
