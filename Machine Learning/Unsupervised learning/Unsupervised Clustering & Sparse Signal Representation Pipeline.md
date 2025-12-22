# Unsupervised Learning & Sparse Signal Processing Pipeline

## 🔍 Overview

This project presents an end-to-end analytical pipeline that combines **unsupervised learning** and **sparse signal processing** to explore structure, redundancy, and information compaction in high-dimensional data.

The work emphasizes **algorithmic transparency** and **numerical understanding**, implementing core methods **from scratch** rather than relying on black-box libraries. The pipeline integrates clustering, transform-based representations, and controlled reconstruction to study convergence behavior, sparsity, and interpretability.

---

## 🎯 Objective

- Implement unsupervised learning techniques with full control over the optimization process  
- Analyze clustering behavior, convergence dynamics, and sensitivity to initialization  
- Evaluate sparse representations using signal transforms under aggressive coefficient reduction  
- Compare reconstruction quality and information loss across different sparsity levels  

---

## 🧠 Methodology

The project is structured into two main stages:

### 1. Unsupervised Learning

- Manual implementation of **K-Means clustering**
- Explicit centroid initialization
- Iterative label assignment using **Euclidean distance**
- Centroid updates via cluster means
- Objective function tracking to analyze **convergence and stability**

### 2. Sparse Signal Processing

- Data normalization and preprocessing
- Sparse representation using:
  - **Haar Wavelets**
  - **Discrete Cosine Transform (DCT)**
- Coefficient magnitude ranking
- **Best k-term approximation** under extreme sparsity regimes
- Signal reconstruction with qualitative and quantitative evaluation

This modular design enables controlled experimentation and clear interpretation of each pipeline component.

---

## 📊 Key Results

- Clear visualization of clustering dynamics and centroid convergence behavior  
- Empirical evidence of how initialization impacts convergence speed and final cluster quality  
- Strong energy compaction observed in transform domains with low coefficient retention  
- Identified trade-offs between sparsity, reconstruction fidelity, and structural preservation  

---

## 🛠 Technologies & Skills

- **Python** (NumPy, Pandas, Matplotlib)
- **Unsupervised Learning** (K-Means from scratch)
- **Numerical Linear Algebra**
- **Sparse Representations**
- **Signal Processing** (Haar Wavelets, DCT)
- **Data Visualization**
- **Algorithmic Optimization & Analysis**

---

## 🧩 Why This Project Matters

This project demonstrates the ability to:

- Build analytical pipelines from **first principles**
- Understand and control numerical behavior beyond library abstractions
- Bridge **machine learning**, **linear algebra**, and **signal processing**
- Communicate technical results clearly and professionally

It reflects a problem-solving mindset focused on **robustness**, **interpretability**, and **methodological rigor**, which is critical for real-world data science, applied research, and advanced analytics roles.
