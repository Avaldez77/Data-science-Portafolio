import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn import datasets

# ============================================================
# SECTION 1 — K-means clustering (from scratch)
# ============================================================

def compute_labels(X, Z):
    """
    Assign each sample in X to the closest centroid in Z.
    X: (n_samples, n_features)
    Z: (k, n_features)
    Returns:
      labels: (n_samples,) in {0,...,k-1}
    """
    n = X.shape[0]
    labels = np.zeros(n, dtype=int)
    for i in range(n):
        d = np.linalg.norm(X[i] - Z, axis=1)
        labels[i] = np.argmin(d)
    return labels

def compute_centroids(X, labels, k, rng=None):
    """
    Compute centroids as the mean of points in each cluster.
    If a cluster is empty, reinitialize its centroid with a random data point.
    """
    n, d = X.shape
    Z = np.zeros((k, d), dtype=float)

    if rng is None:
        rng = np.random.default_rng()

    for j in range(k):
        cluster_points = X[labels == j]
        if cluster_points.shape[0] > 0:
            Z[j] = cluster_points.mean(axis=0)
        else:
            Z[j] = X[rng.integers(0, n)]
    return Z

def compute_jclust(X, Z, labels):
    """
    K-means objective:
      J_clust = (1/n) * sum_i || X_i - Z_{labels_i} ||^2
    """
    n = X.shape[0]
    jclust = 0.0
    for i in range(n):
        j = labels[i]
        jclust += np.linalg.norm(X[i] - Z[j]) ** 2
    return jclust / n

def k_means_fit(X, Z0, NITERMAX, tol=1e-6, seed=None):
    """
    Run K-means starting from initial centroids Z0.
    Returns:
      Z_final: final centroids
      labels_final: final labels
      jclust_history: objective values per iteration
      n_iters: iterations executed
    """
    k = Z0.shape[0]
    rng = np.random.default_rng(seed)

    jclust_history = []
    labels_prev = None

    Z = np.array(Z0, dtype=float, copy=True)

    it = 0
    while it < NITERMAX:
        # 1) assignment step
        labels_new = compute_labels(X, Z)

        # 2) update step
        Z_new = compute_centroids(X, labels_new, k, rng=rng)

        # 3) objective
        J = compute_jclust(X, Z_new, labels_new)
        jclust_history.append(J)

        # stopping checks
        max_center_shift = np.max(np.linalg.norm(Z_new - Z, axis=1))
        labels_unchanged = (labels_prev is not None) and np.array_equal(labels_new, labels_prev)

        Z = Z_new
        labels_prev = labels_new
        it += 1

        if (max_center_shift < tol) or labels_unchanged:
            break

    return Z, labels_prev, jclust_history, it


# ============================================================
# SECTION 1A — Test with datakmeans.csv (k = 4)
# ============================================================

df_kmeans = pd.read_csv("datakmeans.csv")
X = df_kmeans.values  # (n_samples, n_features)

k = 4
NITERMAX = 1000

Z0 = X[:k].copy()  # initial centroids from first k samples

Z_final, labels_final, jclust_hist, n_iters = k_means_fit(
    X, Z0=Z0, NITERMAX=NITERMAX, tol=1e-6, seed=42
)

print("Final centroids (k=4):")
print(Z_final)
print("\nIterations executed:", n_iters)
print("Final jclust:", jclust_hist[-1])

# Plot data + centroids only if 2D
if X.shape[1] == 2:
    plt.figure(figsize=(6, 6))
    for j in range(k):
        pts = X[labels_final == j]
        plt.scatter(pts[:, 0], pts[:, 1], s=12, label=f"Cluster {j}")
    plt.scatter(Z_final[:, 0], Z_final[:, 1], marker="X", s=160, c="black", label="Centroids")
    plt.title("K-means: data by label + centroids")
    plt.xlabel("x1")
    plt.ylabel("x2")
    plt.legend()
    plt.grid(True)
    plt.show()

plt.figure(figsize=(6, 4))
plt.plot(range(1, len(jclust_hist) + 1), jclust_hist, marker="o")
plt.xlabel("Iteration")
plt.ylabel("jclust")
plt.title("Objective vs iterations (datakmeans.csv)")
plt.grid(True)
plt.show()


# ============================================================
# SECTION 1B — Test with sklearn digits (k = 10)
# ============================================================

digits = datasets.load_digits()
X_digits = np.array([img.flatten() for img in digits.images], dtype=float)  # (n_samples, 64)

k2 = 10
NITERMAX = 1000

Z0_digits = X_digits[:k2].copy()

Z_digits, labels_digits, jclust_digits, n_iters_digits = k_means_fit(
    X_digits, Z0=Z0_digits, NITERMAX=NITERMAX, tol=1e-6, seed=42
)

print("\nDigits (k=10)")
print("Iterations executed:", n_iters_digits)
print("Final jclust:", jclust_digits[-1])

plt.figure(figsize=(6, 4))
plt.plot(range(1, len(jclust_digits) + 1), jclust_digits, marker="o")
plt.xlabel("Iteration")
plt.ylabel("jclust")
plt.title("Objective vs iterations (digits)")
plt.grid(True)
plt.show()

# Show centroid + one assigned sample per cluster
fig, axes = plt.subplots(k2, 2, figsize=(4, 2 * k2))
for j in range(k2):
    axes[j, 0].imshow(Z_digits[j].reshape(8, 8), cmap="gray")
    axes[j, 0].set_title(f"Centroid {j}")
    axes[j, 0].axis("off")

    idx = np.where(labels_digits == j)[0]
    if idx.size > 0:
        axes[j, 1].imshow(X_digits[idx[0]].reshape(8, 8), cmap="gray")
        axes[j, 1].set_title(f"Sample in cluster {j}")
    else:
        axes[j, 1].imshow(np.zeros((8, 8)), cmap="gray")
        axes[j, 1].set_title(f"No sample in {j}")
    axes[j, 1].axis("off")

plt.tight_layout()
plt.show()


# ============================================================
# SECTION 2 — Sparse representations & image compression
# ============================================================

from scipy.fft import dctn, idctn
import pywt

# Load and normalize image
X_img = np.flipud(plt.imread("MDS3120_CIN.png"))
X_img = np.mean(X_img, axis=2)
X_img = (X_img - np.min(np.abs(X_img))) / (np.max(np.abs(X_img)) - np.min(np.abs(X_img)))
N = X_img.shape[0]

plt.figure(figsize=(7, 7))
plt.imshow(X_img, vmin=0, vmax=1, origin="lower", cmap="gray")
plt.title("Original image")
plt.colorbar(shrink=0.5)
plt.show()

def wavelet_coordinates(X):
    """
    Return Haar wavelet coefficients as a (N, N) array.
    """
    if X.shape != (N, N):
        raise ValueError(f"Expected {(N, N)}, got {X.shape}")
    WX = pywt.wavedec2(X, "haar", mode="periodic", level=None)
    C, _ = pywt.coeffs_to_array(WX)
    return C

def dct_coordinates(X):
    """
    Return DCT coefficients as a (N, N) array.
    """
    if X.shape != (N, N):
        raise ValueError(f"Expected {(N, N)}, got {X.shape}")
    return dctn(X, norm="ortho")

def sort_coordinate_magnitudes(C):
    """
    Flatten coefficients and return abs values sorted descending.
    """
    mag = np.abs(C).ravel()
    return np.sort(mag)[::-1]

def compute_sorted_haar_magnitudes(X):
    """
    Compute Haar coefficients and return magnitudes sorted descending.
    """
    return sort_coordinate_magnitudes(wavelet_coordinates(X))

def compute_sorted_dct_magnitudes(X):
    """
    Compute DCT coefficients and return magnitudes sorted descending.
    """
    return sort_coordinate_magnitudes(dct_coordinates(X))

c_haar = compute_sorted_haar_magnitudes(X_img)
c_dct = compute_sorted_dct_magnitudes(X_img)

n = np.arange(1, N * N + 1)

plt.figure(figsize=(12, 5))
plt.plot(n, c_haar / c_haar[0], label="Haar wavelets", linewidth=2)
plt.plot(n, c_dct / c_dct[0], label="DCT", linewidth=2)
plt.yscale("log")
plt.grid(True)
plt.legend()
plt.xlabel("Coefficient rank (descending magnitude)")
plt.ylabel("Normalized magnitude")
plt.title("Coefficient magnitude decay: Haar vs DCT")
plt.show()

def best_k_term_approximation(C, k):
    """
    Keep only the k largest-magnitude coefficients (best k-term approximation).
    """
    C = np.asarray(C)
    m = C.size

    if k <= 0:
        return np.zeros_like(C)
    if k >= m:
        return C.copy()

    flat = C.ravel()
    idx = np.argpartition(np.abs(flat), -k)[-k:]
    out = np.zeros_like(flat)
    out[idx] = flat[idx]
    return out.reshape(C.shape)

def wavelet_coordinates_to_image(C):
    """
    Reconstruct image from Haar wavelet coefficient array (N, N).
    """
    if C.shape != (N, N):
        raise ValueError(f"Expected {(N, N)}, got {C.shape}")
    _, bookkeeping = pywt.coeffs_to_array(
        pywt.wavedec2(np.zeros((N, N)), "haar", mode="periodic", level=None)
    )
    return pywt.waverec2(
        pywt.array_to_coeffs(C, bookkeeping, output_format="wavedec2"),
        "haar",
        mode="periodic"
    )

def dct_coordinates_to_image(C):
    """
    Reconstruct image from DCT coefficient array (N, N).
    """
    if C.shape != (N, N):
        raise ValueError(f"Expected {(N, N)}, got {C.shape}")
    return idctn(C, norm="ortho")

# Compression demo: 1%, 5%, 10%
C_haar_full = wavelet_coordinates(X_img)
C_dct_full = dct_coordinates(X_img)

for p in [0.01, 0.05, 0.10]:
    k_keep = int(p * (N * N))

    C_haar_k = best_k_term_approximation(C_haar_full, k_keep)
    C_dct_k = best_k_term_approximation(C_dct_full, k_keep)

    X_haar_rec = np.clip(wavelet_coordinates_to_image(C_haar_k), 0, 1)
    X_dct_rec = np.clip(dct_coordinates_to_image(C_dct_k), 0, 1)

    plt.figure(figsize=(12, 5))
    plt.suptitle(f"Best {int(p*100)}% coefficient approximation (k={k_keep})", fontsize=14)

    plt.subplot(1, 2, 1)
    plt.imshow(X_haar_rec, origin="lower", cmap="gray", vmin=0, vmax=1)
    plt.title("Haar wavelets reconstruction")
    plt.axis("off")

    plt.subplot(1, 2, 2)
    plt.imshow(X_dct_rec, origin="lower", cmap="gray", vmin=0, vmax=1)
    plt.title("DCT reconstruction")
    plt.axis("off")

    plt.show()