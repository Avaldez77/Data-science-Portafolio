# 🔍 Overview
This project runs **baseline image classification experiments on CIFAR-10** using a simple **fully-connected neural network (MLP) in PyTorch**. The notebook focuses on practical training behavior—such as the impact of **input normalization** and **optimizer choice (SGD vs Adam)**—rather than maximizing state-of-the-art accuracy.

# 🎯 Objective
- Build an interpretable **MLP baseline** for CIFAR-10 image classification.
- Compare training dynamics under different settings:
  - **With vs without input normalization**
  - **SGD vs Adam** optimization
- Track and visualize training/validation loss to understand convergence and generalization.

# 🧠 Methodology
1. **Dataset and preprocessing**
   - Load CIFAR-10 (10-class image dataset).
   - Convert images into a vector form suitable for an MLP (flattening).
   - Run experiments **with and without normalization** to evaluate stability and convergence speed.
2. **Model**
   - A **multi-layer perceptron (MLP)**: stacked `Linear` layers with non-linear activations.
   - This is a baseline architecture for image classification (not convolutional).
3. **Training**
   - Mini-batch training using `DataLoader`.
   - Compare optimizers:
     - **SGD** (typically needs tuning but can generalize well)
     - **Adam** (often faster convergence with less tuning)
4. **Evaluation and visualization**
   - Monitor **training and validation loss curves**.
   - Compare runs to see how normalization and optimizer selection affect overfitting and convergence.

# 📊 Key Results
- Demonstrates that:
  - **Normalization** usually improves training stability and can speed up convergence.
  - **Adam** often reduces loss faster early on, while **SGD** can be competitive with proper hyperparameter tuning.
- Provides clear loss curves to diagnose:
  - underfitting vs overfitting
  - unstable training (e.g., exploding/plateauing loss)
  - generalization gap between train and validation

# 🛠 Technologies & Skills
- **Python**
- **PyTorch**:
  - `nn.Module`, `Linear`, activations
  - `DataLoader` for mini-batch training
  - `SGD`, `Adam`
- **Data handling / preprocessing**
  - normalization strategies
  - flattening images for MLP input
- **Visualization**
  - training/validation curves with Matplotlib
- Concepts demonstrated:
  - MLP baselines for image tasks
  - optimization behavior
  - generalization monitoring

# 🧩 Why This Project Matters
Before moving to more advanced architectures like CNNs or Transformers, having a strong baseline is valuable:
- It provides a **reference point** for performance and training stability.
- It helps you understand **what preprocessing and optimizers change** in practice.
- It builds intuition for diagnosing training issues using loss curves.
- It demonstrates core deep learning workflow skills that transfer directly to CNNs (same training loop, same optimization concepts).
