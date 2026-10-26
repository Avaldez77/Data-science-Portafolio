# Hands-on exercises

## Model validation and threshold review

The [synthetic default-risk exercise](./Model%20Validation/README.md) is an
end-to-end R example using only base R. It creates fictional data, holds out a
test set, fits logistic regression, compares decision thresholds, and reports
subgroup recall.

Run it with:

```bash
Rscript "Exercises/Model Validation/solution.R"
```

## Further challenges

1. Replace the random holdout with a time-based split and explain when random
   splitting would leak future information.
2. Add calibration bins and a Brier score; compare probability quality with
   threshold-specific classification metrics.
3. Add a bootstrap confidence interval for the AUC and report the resampling
   seed and method.
4. Compare subgroup recall across thresholds. Discuss sample-size limitations
   and avoid treating parity in one metric as proof of fairness.

**Acceptance criteria:** the data generation is seeded; the test set is never
used for fitting; threshold and subgroup metrics are reported separately; and
the write-up states that synthetic results do not validate a real credit
decision system.
