# 🔍 Overview

This project implements a hybrid recommender system using DeepCTR-Torch, combining collaborative signals with content and contextual features to predict user preferences at scale. The solution demonstrates how deep learning–based CTR architectures can be adapted for recommendation tasks beyond simple interaction modeling.

# 🎯 Objective

Build and compare multiple recommender model configurations that progressively integrate user-item interactions, content attributes, and lightweight contextual signals, and evaluate their impact on prediction accuracy and learning behavior.

# 🧠 Methodology

The workflow follows a production-oriented pipeline:
- Data preparation from MovieLens-100K
- Content feature analysis (user demographics and item genres)
- Context feature engineering (weekday vs weekend behavior)
- Training three DeepCTR-based models with increasing feature richness
- Evaluation using regression and ranking metrics across epochs

The models are trained under comparable settings to ensure a fair performance comparison.

# 📊 Key Results

- The interaction-only baseline provides a solid starting point but underperforms richer models.
- Adding content features improves predictive accuracy and convergence stability.
- Incorporating a simple contextual signal (day type) achieves the lowest MSE among all configurations.
- Results confirm that even minimal context can meaningfully enhance recommendation quality.

# 🛠 Technologies & Skills

- Python
- DeepCTR-Torch
- PyTorch
- Pandas & NumPy
- Feature engineering
- Recommender system modeling
- Model evaluation (MSE, AUC)
- Data visualization

# 🧩 Why This Project Matters

Modern recommender systems rarely rely on interactions alone. This project demonstrates a practical, extensible approach to hybrid recommendation modeling, showing how content and context can be integrated into deep learning architectures to produce more accurate and behavior-aware predictions in real-world systems.
