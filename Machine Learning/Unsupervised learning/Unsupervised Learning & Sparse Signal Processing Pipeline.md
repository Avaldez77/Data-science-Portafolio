# Unsupervised Learning & Sparse Signal Processing Pipeline

## 🔍 Overview
This project implements an end-to-end analytical pipeline that combines **unsupervised learning** and **sparse signal processing**, fully developed from scratch using Python and numerical libraries.  
The work focuses on understanding clustering behavior, convergence properties, and sparsity-driven image compression **without relying on black-box machine learning models**.

---

## 🎯 Objective
- Implement the **K-means algorithm from scratch**, including assignment, centroid updates, and convergence criteria  
- Analyze **sparsity and energy compaction** using Haar wavelets and Discrete Cosine Transform (DCT)  
- Compare reconstruction quality under **extreme coefficient reduction** scenarios  

---

## 🧠 Methodology

### Stage 1 — K-means (From Scratch)
- Manual centroid initialization using the first *k* samples (`Z0`)  
- Iterative label assignment based on **Euclidean distance minimization**  
- Centroid updates via cluster-wise means  
- Objective function computation:

  J_clust = (1/n) * sum ||x_i - z_label_i||^2

- Convergence detection based on:
  - Centroid displacement tolerance  
  - Label stability  
  - Maximum number of iterations  

**Datasets used:**
- Synthetic clustering dataset (`datakmeans.csv`)
- Handwritten digits dataset (flattened 8×8 images)

Visual outputs include cluster scatter plots, centroid visualization, and objective convergence curves.

---

### Stage 2 — Sparse Representation & Compression
- Image loading, grayscale conversion, normalization, and orientation correction  
- Sparse transforms:
  - **Haar Wavelet decomposition**
  - **Discrete Cosine Transform (DCT)**
- Global coefficient magnitude ranking  
- Best *k*-term approximation retaining:
  - 1%
  - 5%
  - 10% of total coefficients  
- Image reconstruction via inverse transforms  
- Visual and qualitative comparison of sparsity efficiency  

---

## 📊 Key Results
- Consistent and stable convergence across all K-means experiments  
- Monotonic decrease of the clustering objective function  
- DCT demonstrates faster coefficient magnitude decay compared to Haar wavelets  
- High-fidelity image reconstructions achieved using **≤10% of coefficients**, highlighting strong sparsity properties  

---

## 🛠 Technologies & Skills
**Python · NumPy · SciPy · scikit-learn (datasets) · Signal Processing · Linear Algebra · Unsupervised Learning**

---

## 🧩 Why This Project Matters
This project demonstrates the ability to:
- Implement **core machine learning algorithms from first principles**
- Analyze optimization behavior beyond library abstractions
- Apply mathematical and signal-processing concepts to real compression problems
- Design **clean, modular, and reproducible** analytical pipelines suitable for research or production prototyping  

---

## 🔗 Source Code
All experiments, visualizations, and results are fully reproducible using the provided Python scripts.
