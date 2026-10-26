# Logistic model validation with synthetic data

This exercise demonstrates a complete validation workflow with fictional
records and base R. It does not use real credit data and is not a credit
decision model.

## Run

```bash
Rscript solution.R
```

The script generates a seeded dataset, creates a holdout split, fits a logistic
regression on training rows only, and reports accuracy, precision, recall,
F1, and ROC-AUC for two thresholds. It also reports recall by synthetic
segment to make subgroup performance visible.

## Exercises

1. Change the threshold and plot the precision/recall trade-off.
2. Add a time-based split and compare it with the random holdout.
3. Add calibration and confidence intervals; document the method and its
   limitations.
4. Compare subgroup metrics with uncertainty intervals before discussing
   disparities.

Do not describe the generated metrics as evidence about real people or a real
financial product.
