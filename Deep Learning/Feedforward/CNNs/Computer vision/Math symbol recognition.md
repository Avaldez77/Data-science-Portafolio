# 🔍 Overview
This project trains a **convolutional neural network (CNN)** in **PyTorch** to recognize **handwritten digits and basic math symbols/operators** from images. It uses a folder-based image dataset, applies a consistent preprocessing pipeline (resize, grayscale, normalization), and trains an AlexNet-inspired CNN to classify each image into one of the supported symbol classes.

# 🎯 Objective
- Build an end-to-end **image classification** pipeline for handwritten math symbols.
- Standardize inputs so the model can handle images with different original sizes.
- Train a CNN that predicts the correct class among digits and operators (e.g., `0–9`, `add`, `sub`, `mul`, `eq`, etc.).
- Evaluate performance using accuracy and weighted precision/recall/F1.

# 🧠 Methodology
1. **Data preparation**
   - Load images using `torchvision.datasets.ImageFolder` (folder-per-class).
   - Create a train/test split with `random_split` since no split is provided.
2. **Preprocessing pipeline (torchvision transforms)**
   - `Resize(100×100)` to enforce a fixed input size.
   - `Grayscale(1 channel)` to simplify computation and match the dataset style.
   - `ToTensor()` to convert images to tensors.
   - `Normalize(mean=0.5, std=0.5)` for more stable and efficient training.
3. **Model architecture**
   - AlexNet-inspired CNN adapted for **(1, 100, 100)** grayscale inputs.
   - Convolution + ReLU + MaxPool blocks for feature extraction.
   - Fully connected classifier head producing **logits** for `num_classes` outputs.
4. **Training**
   - Loss: `CrossEntropyLoss` (softmax handled internally).
   - Optimizer: `Adam` (lr = 1e-3).
   - GPU acceleration when available.
5. **Evaluation & visualization**
   - Compute accuracy + weighted precision/recall/F1.
   - Visualize sample predictions to qualitatively validate performance.

# 📊 Key Results
- Produces a working CNN classifier for handwritten digits and math operators.
- The pipeline addresses key real-world challenges:
  - **variable image sizes** → solved via resizing
  - **single-channel input** → grayscale conversion
  - **training stability** → normalization
- Outputs measurable performance via standard classification metrics (accuracy, precision, recall, F1) and visual sanity checks.

# 🛠 Technologies & Skills
- **Python**
- **PyTorch** (`torch`, `torch.nn`, `DataLoader`)
- **torchvision** (`ImageFolder`, `transforms`)
- **scikit-learn** (metrics: accuracy, precision/recall/F1)
- **Matplotlib** (visualization of predictions)
- Concepts demonstrated:
  - CNNs for computer vision
  - preprocessing pipelines for image data
  - training on GPU
  - multi-class classification with cross-entropy

# 🧩 Why This Project Matters
Handwritten symbol recognition is a core building block behind products like **math note-taking apps**, document digitization, and intelligent input systems. This project demonstrates the practical skills required to deploy a vision model:
- building a robust preprocessing pipeline,
- designing a CNN that matches the input constraints,
- training and evaluating a multi-class classifier,
- and validating results both quantitatively and visually.
