# 🔍 Overview
This project trains a **tabular water-quality safety classifier** using a **multi-layer perceptron (MLP) in PyTorch**. It covers the full pipeline from data cleaning and normalization to model design (BatchNorm + Dropout), training with different optimizers, and evaluation with classification metrics.

# 🎯 Objective
- Build a neural network that predicts whether a water sample is **safe (1)** or **unsafe (0)** from measured chemical concentrations.
- Apply best practices for tabular deep learning:
  - train/validation/test splits
  - feature normalization
  - regularization (Dropout)
  - stabilization (Batch Normalization)
  - handling class imbalance (weighted loss)
- Compare **SGD vs Adam** to observe optimization behavior and convergence differences.

# 🧠 Methodology
1. **Data preparation (pandas)**
   - Load CSV, replace invalid placeholders, remove missing values.
   - Separate features `X` and target `y` (`is_safe`).
2. **Splitting + scaling (scikit-learn)**
   - Stratified split into **train/validation/test** to preserve class proportions.
   - Fit `StandardScaler` on the training set and apply to validation/test to prevent leakage.
3. **Modeling (PyTorch)**
   - MLP architectures with stacked `Linear` layers.
   - **ReLU** activations for non-linearity.
   - **BatchNorm1d** to stabilize and speed up training.
   - **Dropout** for regularization and improved generalization.
   - Output is **logits** (no final sigmoid layer), compatible with `BCEWithLogitsLoss`.
4. **Training and evaluation**
   - Train loops with mini-batches using `DataLoader`.
   - Loss: **BCEWithLogitsLoss** with `pos_weight` for class imbalance.
   - Compare optimizers:
     - **SGD + momentum**
     - **Adam**
   - Evaluate with `classification_report` (precision/recall/F1).

# 📊 Key Results
- Produces a working binary classifier for water safety.
- Shows how:
  - **normalization** improves optimization stability,
  - **BatchNorm + Dropout** help generalization,
  - **pos_weight** helps handle imbalanced classes,
  - **Adam** often converges faster, while **SGD + momentum** can be competitive with tuning.
- Delivers interpretable evaluation via **precision, recall, and F1-score** (not only accuracy).

# 🛠 Technologies & Skills
- **Python**
- **pandas**: data loading and cleaning
- **NumPy**: numerical operations
- **scikit-learn**: splitting, scaling, metrics
- **PyTorch**:
  - `nn.Module`, `Linear`, `BatchNorm1d`, `Dropout`, `ReLU`
  - `DataLoader`, mini-batch training
  - `SGD`, `Adam`, `BCEWithLogitsLoss`
- **Matplotlib / Seaborn**: distributions, correlations, and training curves

# 🧩 Why This Project Matters
This is a realistic example of deep learning on **tabular environmental data**, demonstrating skills that transfer directly to production ML work:
- Building robust pipelines (cleaning, scaling, proper splits)
- Designing networks that generalize (regularization + normalization)
- Dealing with imbalanced outcomes (weighted losses)
- Comparing optimizers and diagnosing training behavior
- Producing evaluation outputs that matter for safety-critical scenarios (recall/F1)
