🔍 Overview

This project delivers a comprehensive comparison between Bayesian and frequentist linear regression approaches, focusing on uncertainty estimation and coefficient stability. Multiple Bayesian shrinkage priors—Normal, Laplace, and Horseshoe—are implemented using Hamiltonian Monte Carlo (HMC) in Stan to evaluate how prior assumptions influence posterior behavior in a real-world regression setting.

🎯 Objective

Provide robust and interpretable coefficient estimates under uncertainty by leveraging Bayesian regression with advanced MCMC techniques, and benchmark these results against a frequentist ordinary least squares baseline.

🧠 Methodology

A linear regression framework is implemented using R and Stan, embedding multiple Bayesian models with different shrinkage priors. Posterior inference is performed via HMC/NUTS with multiple chains. Results are summarized through posterior credible intervals and compared directly with frequentist confidence intervals to assess shrinkage effects, sparsity, and uncertainty control.

📊 Key Results

Bayesian models exhibit stronger control over coefficient variability compared to the frequentist approach. The Horseshoe prior demonstrates the most effective shrinkage, preserving dominant signals while suppressing weak or noisy predictors. Interval comparisons highlight meaningful differences in uncertainty quantification across prior choices.

🛠 Technologies & Skills

- R  
- Stan (rstan)  
- Bayesian Linear Regression  
- Markov Chain Monte Carlo (MCMC)  
- Hamiltonian Monte Carlo (HMC / NUTS)  
- Shrinkage Priors (Normal, Laplace, Horseshoe)  
- Statistical Modeling & Uncertainty Quantification  
- Data Visualization  

🧩 Why This Project Matters

This project showcases the practical value of Bayesian methods for regression problems where uncertainty, multicollinearity, or high-dimensional predictors are present. It demonstrates the ability to design, implement, and interpret advanced probabilistic models that improve reliability and decision-making beyond traditional frequentist techniques.
