🔍 Overview

This project implements an end-to-end Responsible AI audit using IBM AIF360 on high-impact classification datasets, including COMPAS. It focuses on identifying, measuring, and mitigating algorithmic bias across protected groups while maintaining model utility.

🎯 Objective

Evaluate baseline fairness and predictive performance, quantify disparities between privileged and unprivileged groups, and apply bias mitigation techniques to reduce unfair outcomes without compromising decision quality.

🧠 Methodology

The workflow loads and preprocesses data with AIF360 utilities, defines protected attributes and group membership, trains baseline classification models, computes performance and fairness metrics, and applies mitigation strategies such as reweighting and post-processing. All models are evaluated under consistent protocols to enable fair comparison.

📊 Key Results

The analysis reveals measurable bias in baseline models across protected attributes. After applying mitigation techniques, fairness metrics improve significantly while preserving acceptable predictive performance, demonstrating practical trade-offs between equity and accuracy.

🛠 Technologies & Skills

Python, Jupyter Notebook, IBM AIF360, Fairness Metrics, Bias Mitigation Techniques, Classification Models, Model Evaluation, Responsible AI.

🧩 Why This Project Matters

As machine learning systems increasingly influence high-stakes decisions, fairness and accountability are mandatory. This project demonstrates a reproducible, production-relevant framework for auditing and mitigating bias, supporting responsible deployment and governance of AI systems.
