# Bias, Variance, and Generalization

## 🔍 Overview

This project demonstrates core statistical learning theory concepts ---
**bias, variance, and generalization** --- using controlled synthetic
datasets and reproducible experiments.

The notebook walks through regression and classification examples to
show: - What underfitting looks like in practice - How overfitting
manifests in training vs test error - How model complexity affects
generalization - Why regularization improves stability - Why accuracy is
misleading in rare-event classification

The project is structured as a portfolio-ready, cell-by-cell analytical
narrative.

------------------------------------------------------------------------

## 🎯 Objective

To provide a practical, experiment-driven explanation of:

-   The Bias--Variance Tradeoff
-   Model Complexity vs Generalization Performance
-   The Role of Regularization
-   Proper Metric Selection for Imbalanced Classification

The goal is not just model training --- but **interpretable model
behavior analysis**.

------------------------------------------------------------------------

## 🧠 Methodology

### 1. Controlled Regression Dataset

-   Generated with `make_regression`
-   Added non-linear signal to force model selection relevance
-   Train/Test split for proper generalization measurement

### 2. Bias (Underfitting) Demonstration

-   Linear Regression on non-linear data
-   Observed: High train MSE + High test MSE
-   Interpretation: Model too simple to capture structure

### 3. Variance (Overfitting) Demonstration

-   Polynomial Regression (degree=15)
-   Observed: Very low train MSE + Higher test MSE
-   Interpretation: Model memorizes noise

### 4. Complexity Sweep

-   Polynomial degrees 1--11 evaluated
-   Compared train vs test MSE
-   Identified optimal complexity range

### 5. Regularization Experiment

-   Compared Polynomial Regression vs Ridge Regression
-   Demonstrated improved test performance stability
-   Controlled model flexibility using L2 penalty

### 6. Rare-Event Classification

-   Synthetic imbalanced dataset (98% vs 2%)
-   Logistic Regression model
-   Compared:
    -   Accuracy
    -   Recall
    -   F1 Score
-   Demonstrated why accuracy alone is misleading

------------------------------------------------------------------------

## 📊 Key Results

-   Underfitting: Persistent high error across train and test sets
-   Overfitting: Large train-test performance gap
-   Tradeoff Curve: Clear optimal complexity zone minimizing test error
-   Regularization: Reduced generalization error at fixed complexity
-   Imbalanced Classification: Accuracy inflated despite low recall

Core Insight: \> Generalization performance --- not training performance
--- determines model quality.

------------------------------------------------------------------------

## 🛠 Technologies & Skills

**Languages & Libraries** - Python - NumPy - Pandas - Matplotlib -
Scikit-learn

**Concepts Demonstrated** - Bias--Variance Tradeoff - Polynomial Feature
Engineering - Regularization (Ridge) - Model Evaluation Metrics -
Imbalanced Classification Analysis - Reproducible Experiment Design

**Professional Competencies** - Model diagnostics - Error decomposition
analysis - Experimental design - Metric selection strategy -
Portfolio-grade analytical reporting

------------------------------------------------------------------------

## 🧩 Why This Project Matters

Many ML portfolios focus on predictive accuracy.\
This project demonstrates something more valuable:

-   Deep understanding of model behavior
-   Ability to diagnose underfitting vs overfitting
-   Structured experimentation
-   Metric literacy in imbalanced systems
-   Executive-level interpretability

This is foundational knowledge for: - Machine Learning Engineering -
Applied Data Science - Model Governance - Production ML Systems

It reflects the ability to move beyond training models and toward
**designing reliable learning systems**.
