# 🔍 Overview
This project builds a **small neural network from scratch using NumPy**, covering the full training pipeline: **forward pass → loss → backpropagation → gradient descent updates**. It’s designed as a compact, readable reference for understanding how core deep learning pieces work under the hood.

# 🎯 Objective
- Implement a fully working **feedforward neural network (MLP)** without using deep learning frameworks.
- Demonstrate:
  - **Activation functions** (Identity, Sigmoid)
  - **Loss function** (Mean Squared Error)
  - **Backpropagation** through neurons and layers
  - **Parameter updates** via gradient descent
- Validate learning on:
  - **AND** logic gate
  - **XOR** logic gate (requires a hidden layer)
  - A small **regression** task: \(f(x_1,x_2)=x_1^2+x_2^2\)

# 🧠 Methodology
- **Core components implemented**
  - `Neuron`: computes \(z = XW + b\) and applies an activation; stores gradients `dw`, `db`.
  - `Layer`: stacks multiple neurons in parallel.
  - `NeuralNetwork`: chains layers and performs forward + backward passes.
- **Training loop**
  1. Forward pass to compute predictions
  2. Compute **MSE loss**
  3. Compute gradient \(dL/d\hat{y}\)
  4. Backpropagate gradients through the network
  5. Update weights/biases using learning rate \(lr\)
- **Visualization**
  - Loss curves for each training run
  - 3D surface comparison for the regression task (true surface vs model prediction)

# 📊 Key Results
- **AND gate:** learns the correct mapping after training and reaches high binary accuracy.
- **XOR gate:** succeeds using a **2–2–1** architecture (hidden layer required for non-linear separability).
- **Regression (\(x_1^2+x_2^2\)):** approximates the surface from sampled points; quality depends on random initialization and training dynamics (re-running may improve convergence).

# 🛠 Technologies & Skills
- **Python**, **NumPy**: vectorized linear algebra, gradient calculations
- **Matplotlib**: loss curves and 3D surface visualization
- Concepts practiced:
  - Feedforward MLP architecture
  - Activation functions + derivatives
  - Loss functions + gradients
  - Backpropagation (chain rule)
  - Gradient descent optimization
  - Shape handling for batch computations

# 🧩 Why This Project Matters
Most deep learning work hides the mechanics behind high-level libraries. This project makes the fundamentals explicit:
- You see exactly how **weights, biases, activations, and gradients** flow through the model.
- It’s a strong base for understanding and debugging:
  - deeper MLPs,
  - CNNs and Transformers (same gradient principles),
  - training instabilities (learning rate, saturation, initialization).
- It also works as a clear portfolio artifact showing **from-scratch implementation ability**.
