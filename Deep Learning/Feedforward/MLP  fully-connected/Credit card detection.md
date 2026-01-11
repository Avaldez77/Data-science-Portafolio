# 🔍 Overview
This project builds a **credit card fraud detection model** using a **multi-layer perceptron (MLP) in PyTorch**. It demonstrates an end-to-end workflow for **binary classification on highly imbalanced tabular data**, including preprocessing, class-imbalance handling with weighted loss, and training with different optimizers.

# 🎯 Objective
- Train a model that predicts whether a transaction is **fraudulent (1)** or **legitimate (0)** from tabular features.
- Apply practical steps required for reliable fraud detection:
  - stratified train/validation/test splits
  - feature normalization
  - regularization to improve generalization
  - class-imbalance handling via `pos_weight` in `BCEWithLogitsLoss`
- Compare **SGD (with momentum)** vs **Adam** to observe convergence behavior and performance differences.

# 🧠 Methodology
1. **Data loading and inspection**
   - Load the CSV and verify schema and target distribution (fraud is typically rare).
2. **Splitting and scaling (no leakage)**
   - Perform **stratified** splits into train/validation/test.
   - Fit `StandardScaler` on the training set only, then transform validation/test.
3. **Model design (PyTorch MLP)**
   - Stacked `Linear` layers with:
     - **ReLU** activations for non-linearity
     - **Batch Normalization** for stable/fast training
     - **Dropout** for regularization
   - Output is **logits** (no sigmoid at the end).
4. **Training and imbalance handling**
   - Loss: **BCEWithLogitsLoss** with `pos_weight = (#neg / #pos)` to penalize fraud-class mistakes more.
   - Train with mini-batches using `DataLoader`.
   - Two optimizer runs:
     - **SGD + momentum**
     - **Adam**
5. **Evaluation**
   - Generate predictions and report **precision, recall, and F1-score**.
   - Visualize a **confusion matrix** to inspect false positives vs false negatives.

# 📊 Key Results
- Produces a working fraud classifier with full evaluation output.
- Highlights the impact of:
  - **class imbalance** (accuracy can look “good” even when fraud recall is poor)
  - **weighted loss** improving sensitivity to fraud cases
  - **optimizer choice** (Adam often converges faster; SGD can be competitive with tuning)
- Provides metrics that matter for fraud detection: **recall and F1** for the fraud class, not just accuracy.

# 🛠 Technologies & Skills
- **Python**
- **pandas**: loading and basic data handling
- **NumPy**: numerical processing
- **scikit-learn**: stratified splitting, `StandardScaler`, classification metrics
- **PyTorch**:
  - `nn.Module`, `Linear`, `BatchNorm1d`, `Dropout`, `ReLU`
  - `BCEWithLogitsLoss` with `pos_weight`
  - `DataLoader`, mini-batch training
  - `SGD`, `Adam`
- **Matplotlib / Seaborn**: training curves and confusion matrices
- Concepts demonstrated:
  - feedforward MLPs for tabular classification
  - generalization via regularization
  - training stability via normalization
  - imbalanced classification strategy

# 🧩 Why This Project Matters
Fraud detection is a real-world, high-impact problem where mistakes have costs:
- **False negatives** (missed fraud) can cause direct financial losses.
- **False positives** can block legitimate customers and harm user experience.

This project demonstrates the practical ML skills needed to ship robust classifiers:
- building an end-to-end training pipeline,
- preventing data leakage,
- handling imbalanced labels correctly,
- choosing metrics aligned with business risk,
- and comparing optimization strategies for performance and stability.
