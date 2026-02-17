# Real Estate Spatial Intelligence with Geostatistics (Kriging)

## 🔍 Overview
This project applies **geostatistical modeling** to real estate data to quantify and visualize **spatial structure in property prices**. Using **empirical semivariograms** and **ordinary kriging**, the workflow builds continuous price surfaces over latitude/longitude and compares alternative variogram assumptions for portfolio-ready spatial insights.

## 🎯 Objective
- Detect and model **spatial dependence** in real estate pricing using semivariograms.
- Fit and compare **theoretical variogram models** (Spherical vs Exponential).
- Produce **ordinary kriging prediction maps** to identify location-driven price patterns and potential hot/cold zones.

## 🧠 Methodology
1. **Data ingestion and feature setup**
   - Load real estate observations from an Excel source.
   - Target variable: `logSellingPr` (log-transformed selling price) for stability and interpretability.
2. **Portfolio-grade visualization layer**
   - Unified theme function for consistent typography, grid styling, and plot polish.
   - Univariate distribution checks for core variables to validate scale and variability.
3. **Spatial data conversion**
   - Convert the dataset into a `SpatialPointsDataFrame` by assigning:
     - `Longitude`, `Latitude` as coordinates (`sp::coordinates()`).
4. **Empirical semivariogram**
   - Compute the empirical semivariogram for `logSellingPr` to quantify how similarity decays with distance.
5. **Variogram model fitting**
   - Specify and fit two theoretical models with `gstat`:
     - **Spherical** (`vgm(..., model = "Sph")`)
     - **Exponential** (`vgm(..., model = "Exp")`)
   - Fit parameters via `fit.variogram()` (sill estimation enabled; ranges held fixed as configured).
   - Plot fitted vs empirical variograms for interpretability and QA.
6. **Ordinary kriging and surface mapping**
   - Generate a prediction grid from the spatial bounding box (`bbox()`) with a 100×100 resolution.
   - Build kriging objects (`gstat(...)`) and predict over the grid (`predict(...)`).
   - Visualize kriging surfaces with `ggplot2::geom_tile()`:
     - **Ordinary Kriging Surface (Spherical Model)**
     - **Ordinary Kriging Surface (Exponential Model)**
   - Implement robust fallbacks if fitted models are not returned as expected.

## 📊 Key Results
- **Spatial dependence is measurable:** The empirical semivariogram provides direct evidence of distance-based structure in `logSellingPr`.
- **Model comparison is visual and practical:** Spherical vs Exponential variograms yield different smoothness and range behaviors, which translate into distinct kriging surfaces.
- **Actionable spatial surfaces:** The kriging maps transform point observations into continuous **spatial intelligence**, enabling clearer identification of location-driven price gradients and clusters.
- **Production-minded robustness:** The workflow includes safety checks that fall back to nominal variogram settings to prevent pipeline failure.

## 🛠 Technologies & Skills
- **R**
- Packages: `readxl`, `dplyr`, `ggplot2`, `scales`, `viridis`, `gstat`, `sp`
- Skills:
  - Geostatistics: empirical semivariograms, theoretical variogram fitting
  - Ordinary kriging prediction workflows
  - Spatial data handling with `sp`
  - Grid construction and surface visualization
  - Portfolio-grade plotting standards (consistent theme + labeling)

## 🧩 Why This Project Matters
Spatial effects often explain a large share of real estate price variation. This project demonstrates the ability to move beyond standard regression by:
- Modeling **spatial autocorrelation** explicitly,
- Producing interpretable geostatistical diagnostics (variograms),
- Delivering **map-based decision artifacts** (kriging surfaces) that are directly useful for pricing strategy, market segmentation, and site selection.
