🔍 Overview

This project demonstrates a practical approach to combining inherently interpretable models with post-hoc explainability techniques to understand income prediction outcomes using structured demographic data. It balances transparency and predictive power by applying global and local interpretability methods on real-world tabular data.

🎯 Objective

Build a reliable income classification pipeline that enables both high-level model transparency and instance-level explainability, supporting informed decision-making and model trust in sensitive prediction contexts.

🧠 Methodology

The workflow begins with structured data preprocessing, including categorical encoding and train-test splitting. A Decision Tree classifier is trained to provide global interpretability through tree visualization and feature importance analysis. To complement this, a Random Forest model is trained to capture more complex patterns. Local explanations for individual predictions are generated using LIME, highlighting the most influential features per instance.

📊 Key Results

The Decision Tree reveals that variables such as education level, capital gains, relationship status, and age play a dominant role in income prediction. Local LIME explanations on the Random Forest model confirm that individual predictions are driven by consistent feature interactions, while still varying across personal profiles.

🛠 Technologies & Skills

Python, Pandas, NumPy, scikit-learn, Decision Trees, Random Forests, LIME, Model Interpretability, Explainable AI (XAI), Data Preprocessing, Feature Encoding, Data Visualization

🧩 Why This Project Matters

In domains where predictive decisions impact individuals, understanding *why* a model produces a result is as critical as accuracy. This project showcases a practical, production-ready approach to combining transparent models with explainability tools, reinforcing responsible and trustworthy machine learning practices.
