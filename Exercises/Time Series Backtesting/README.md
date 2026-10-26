# Rolling-origin time-series backtesting

This base-R exercise generates a seeded synthetic weekly series with trend,
seasonality, and noise. It compares a last-observation forecast with a
seasonal-naive forecast using expanding training windows.

Run from the repository root:

```bash
Rscript "Exercises/Time Series Backtesting/rolling_origin.R"
```

The script reports MAE and RMSE across all forecast origins. Each prediction
stores the training origin and target week, making temporal separation
inspectable. The synthetic results are educational and are not evidence of
real-world forecasting performance.

## Extend the exercise

Add a rolling-window model, compare its performance by forecast horizon, and
report uncertainty across origins. Keep all feature selection and tuning
inside each training window.
