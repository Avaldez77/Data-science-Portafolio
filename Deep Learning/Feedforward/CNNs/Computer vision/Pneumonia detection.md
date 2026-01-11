# 🔍 Overview
This project trains a **convolutional neural network (CNN)** in **PyTorch** to classify **chest X-ray images** into two categories: **Normal** vs **Pneumonia**. The notebook demonstrates an end-to-end computer vision workflow, from data loading and preprocessing to training, evaluation, and qualitative inspection of predictions.

# 🎯 Objective
- Build a binary image classifier that detects **pneumonia** from chest X-rays.
- Apply a clean data pipeline suitable for medical imaging:
  - consistent resizing
  - grayscale handling (single-channel)
  - normalization for stable training
- Train and evaluate the model with standard classification metrics.

# 🧠 Methodology
1. **Dataset loading**
   - Load the X-ray dataset using `torchvision.datasets.ImageFolder` (folder-per-class structure).
2. **Preprocessing (torchvision transforms)**
   - Resize images to a fixed resolution (e.g., 224×224) so the CNN receives a consistent input size.
   - Convert to grayscale (X-rays do not require RGB).
   - Convert to tensors and normalize pixel intensities to improve optimization stability.
3. **Model**
   - A CNN with convolutional layers for feature extraction and a classifier head for binary prediction.
   - Output uses logits with `CrossEntropyLoss` (softmax handled internally).
4. **Training**
   - Mini-batch training using `DataLoader`.
   - Optimizer (e.g., Adam) + cross-entropy loss.
   - GPU acceleration when available.
5. **Evaluation**
   - Compute accuracy and a classification report (precision/recall/F1).
   - Inspect predictions on sample images to validate behavior qualitatively.

# 📊 Key Results
- Produces a working CNN model that learns discriminative patterns from chest X-rays.
- Provides measurable performance using:
  - **accuracy**
  - **precision / recall / F1-score** (useful to understand false negatives vs false positives)
- Includes qualitative checks via sample predictions to confirm the model is behaving sensibly.

# 🛠 Technologies & Skills
- **Python**
- **PyTorch**:
  - `nn.Module`, convolutional layers, activation functions
  - `DataLoader` for mini-batches
  - training loop with backpropagation
- **torchvision**:
  - `ImageFolder` dataset loader
  - `transforms` for preprocessing
- **scikit-learn**:
  - classification metrics (precision, recall, F1, accuracy)
- **Matplotlib**:
  - visualization of sample predictions
- Concepts demonstrated:
  - CNNs for medical image classification
  - preprocessing pipelines for vision models
  - evaluation beyond accuracy (medical relevance)

# 🧩 Why This Project Matters
Medical image classification is a high-impact application of deep learning. Even a simple pneumonia classifier demonstrates essential real-world skills:
- building a robust image preprocessing pipeline,
- training a CNN efficiently (often on GPU),
- evaluating results with the right metrics (recall matters when missing positives is costly),
- and validating predictions visually.

This is the same foundation used in many production healthcare AI workflows, where model reliability and evaluation are critical.
