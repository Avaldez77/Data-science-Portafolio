# Hybrid Time Series Forecasting of Chilean CPI (IPC)

🔍 **Overview**  
This project presents an end-to-end statistical forecasting pipeline applied to Chile’s Consumer Price Index (IPC).
It combines classical time series decomposition with ARMA-based residual modeling to produce accurate and interpretable
short-term forecasts.

The work consolidates multiple exploratory notebooks into a single, coherent implementation suitable for professional
use and portfolio presentation.

---

🎯 **Objective**  
- Forecast Chile’s monthly CPI for a future horizon using statistically interpretable components  
- Separate deterministic structure (trend and seasonality) from stochastic behavior (noise)  
- Evaluate forecasting performance using both theoretical (AIC) and empirical (MSE) criteria  

---

🧠 **Methodology**  

1. **Data Preparation**
   - Monthly IPC data from April 1989 to June 2023
   - Train/validation split with a hold-out period for evaluation

2. **Time Series Decomposition**
   - Additive decomposition into trend, seasonality, and residuals
   - Visual and statistical inspection of components

3. **Deterministic Modeling**
   - Polynomial regression (degree 3) fitted to the trend component
   - Seasonal reconstruction using average monthly effects

4. **Residual Diagnostics**
   - Ljung–Box test to detect autocorrelation
   - ACF and PACF analysis to guide ARMA order selection

5. **Stochastic Modeling**
   - ARMA models implemented as ARIMA(p,0,q)
   - Model selection via AIC
   - Alternative model search minimizing validation MSE

6. **Evaluation**
   - Forecast reconstruction: trend + seasonality + ARMA residuals
   - Performance measured using Mean Squared Error (MSE)

---

📊 **Key Results**  
- Significant autocorrelation detected in residuals after decomposition  
- ARMA modeling of residuals substantially improves forecast accuracy  
- Hybrid approach outperforms deterministic-only forecasts  
- Final model achieves validation MSE below the defined performance threshold  

---

🛠 **Technologies & Skills**  
- Python  
- Time Series Analysis  
- ARMA / ARIMA Modeling  
- Statistical Diagnostics (Ljung–Box, ACF, PACF)  
- Forecast Evaluation (AIC, MSE)  
- Data Analysis with pandas, NumPy, statsmodels  
- Visualization with Matplotlib  

---

🧩 **Why This Project Matters**  
This project demonstrates the ability to design **interpretable, statistically sound forecasting pipelines**
without relying on black-box models.

It highlights:
- Strong foundations in classical time series analysis  
- Practical model diagnostics and selection  
- The capacity to transform exploratory analysis into production-ready code  

These skills are directly applicable to economic analysis, demand forecasting, and quantitative decision-making
in real-world settings.