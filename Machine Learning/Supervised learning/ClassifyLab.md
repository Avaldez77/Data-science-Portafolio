# Procesamiento de Datos & Clasificación Predictiva (Portfolio Project)

## 🔍 Overview
End-to-end data processing and supervised classification workflow designed to transform raw operational data into a model-ready dataset, train multiple candidate classifiers, and deliver an executive-ready validation package (ROC/PR, confusion matrices, threshold tuning, and model comparison).

## 🎯 Objective
Build a reliable classification model that predicts the target class from engineered features derived from the processed dataset, with emphasis on:
- Robust preprocessing and reproducibility  
- Objective model selection using cross-validation  
- Clear decision-ready evaluation (F1 / ROC-AUC / PR-AUC)  
- Operational threshold selection to align model performance with decision needs  

## 🧠 Methodology
1. **Data Processing & Cleaning**
   - Standardized data types, handled missing values, and removed inconsistent records where needed
   - Encoded categorical variables and ensured consistent feature representations
   - Prepared a clean modeling table suitable for scikit-learn pipelines

2. **Feature Engineering**
   - Constructed modeling features from transformed variables
   - Ensured modeling inputs were aligned between train and test sets
   - Reduced leakage risk by keeping transformations inside the pipeline when applicable

3. **Modeling Strategy**
   - Trained and evaluated multiple classifiers (baseline + stronger candidates)
   - Used stratified cross-validation to estimate generalization performance
   - Selected the best model based on a metric hierarchy (typically F1 and ROC-AUC)

4. **Executive Validation & Decision Panels**
   - Model comparison leaderboard (sorted by F1 / ROC-AUC)
   - Confusion matrix (counts + normalized)
   - ROC curve with AUC and Precision–Recall curve with AUC
   - Threshold tuning table (precision/recall/F1 across candidate thresholds)
   - Feature importance / coefficients (top drivers)
   - Brief executive interpretation aligned to decision-making

## 📊 Key Results
- Delivered a complete validation package showing:
  - **Discrimination performance** (ROC-AUC) and **decision performance** (F1)
  - **Class-level behavior** through normalized confusion matrices
  - **Threshold optimization** to improve operational outcomes beyond the default 0.50
  - **Interpretability** via feature drivers to support stakeholder trust
- Identified key limitations and next steps to improve minority-class performance and stability.

## 🛠 Technologies & Skills
- **Python:** pandas, numpy  
- **Machine Learning:** scikit-learn (pipelines, cross-validation, metrics, calibration)  
- **Visualization:** matplotlib  
- **Model Evaluation:** ROC/PR curves, confusion matrices, threshold tuning, stability checks (bootstrap-style when applicable)  
- **Portfolio Craft:** executive framing, reproducibility, decision-focused reporting  

## 🧩 Why This Project Matters
Many real-world ML projects fail not because models are “bad”, but because the pipeline is not reproducible, evaluation is not decision-ready, and thresholds are not aligned to business costs. This project demonstrates a production-oriented approach:

**Clean data → consistent features → rigorous validation → threshold decisions → interpretable outputs**  

so stakeholders can confidently move from analysis to deployment and monitoring.
