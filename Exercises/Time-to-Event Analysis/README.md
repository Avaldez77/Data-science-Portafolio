# Time-to-event analysis with `survival`

This R workflow uses the established `survival` package to create and analyze a
seeded right-censored example. It fits Kaplan-Meier curves, a log-rank
comparison, and a Cox proportional-hazards model with age adjustment. The
records are illustrative; the estimated effect is not clinical or business
evidence.

Run from the repository root:

```bash
Rscript "Exercises/Time-to-Event Analysis/survival_analysis.R"
```

R 4.4.3 and the recommended `survival` package are used in CI. The script
checks its required columns and valid event times before model fitting. Assess
censoring, functional form, proportional hazards, and external validation
before applying these methods to real studies.
