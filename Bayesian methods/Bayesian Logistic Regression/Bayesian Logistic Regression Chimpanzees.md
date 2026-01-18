🔍 Overview

This project presents an end-to-end Bayesian analysis of decision-making behavior using logistic regression models. It combines exploratory data analysis with probabilistic modeling in Stan to quantify effects, uncertainty, and interaction dynamics, and concludes with principled model comparison using Bayes Factors.

🎯 Objective

To evaluate how prosocial cues influence binary decision outcomes and to determine whether contextual conditions significantly modify this effect, using Bayesian inference to support robust, uncertainty-aware conclusions.

🧠 Methodology

The workflow begins with exploratory analysis using stacked proportion visualizations to identify patterns across experimental conditions. Two Bayesian logistic regression models are then specified in Stan: a baseline model and an interaction model. Posterior inference is performed via MCMC sampling, diagnostics ensure convergence and stability, and competing models are compared through bridge sampling to compute Bayes Factors.

📊 Key Results

The analysis reveals a clear relationship between prosocial cues and decision outcomes, with evidence that contextual conditions can alter the strength of this effect. Bayesian credible intervals provide transparent uncertainty estimates, and Bayes Factor comparison supports model selection beyond point estimates.

🛠 Technologies & Skills

R, Stan, Bayesian Logistic Regression, MCMC Sampling, Model Diagnostics, Bayes Factors, Exploratory Data Analysis, Data Visualization, Statistical Modeling

🧩 Why This Project Matters

This project demonstrates the ability to deliver a complete, production-ready analytical workflow—from data exploration to formal Bayesian model comparison—emphasizing interpretability, statistical rigor, and decision-focused insights suitable for real-world data science applications.