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

## Rolling-origin time-series backtesting

The [forecast backtest](./Time%20Series%20Backtesting/README.md) compares a
last-observation baseline with a seasonal-naive baseline using expanding
training windows. Each forecast is evaluated only against observations that
occur after its training origin.

```bash
Rscript "Exercises/Time Series Backtesting/rolling_origin.R"
Rscript "Exercises/Impact Evaluation/difference_in_differences.R"
Rscript "Exercises/Time-to-Event Analysis/survival_analysis.R"
Rscript "Exercises/tests.R"
```

The impact-evaluation and survival examples are seeded and identify their
illustrative data in their individual READMEs. The survival workflow uses
`survival`; the other runnable exercises use base R.

## Difference-in-differences impact evaluation

The [impact evaluation exercise](./Impact%20Evaluation/README.md) estimates a
two-group, multi-period difference-in-differences effect and forms a
unit-cluster bootstrap interval. Review the pre-intervention trend diagnostic
and assumptions before interpreting the estimate causally.

## Time-to-event analysis

The [survival analysis exercise](./Time-to-Event%20Analysis/README.md) uses
`survival::Surv`, Kaplan-Meier curves, a log-rank comparison, and a Cox
proportional-hazards model on seeded right-censored data.

## Further challenges

1. For the classification example, replace the random holdout with a time-based
   split and explain when random splitting would leak future information.
2. Add calibration bins and a Brier score; compare probability quality with
   threshold-specific classification metrics.
3. Add a bootstrap confidence interval for the AUC and report the resampling
   seed and method.
4. For the forecasting example, add a rolling seasonal baseline with a
   different period and document how the period is selected.
5. Compare subgroup recall across thresholds. Discuss sample-size limitations
   and avoid treating parity in one metric as proof of fairness.

**Acceptance criteria:** the data generation is seeded; the test set is never
used for fitting; threshold and subgroup metrics are reported separately; and
the write-up states that synthetic results do not validate a real credit
decision system.
