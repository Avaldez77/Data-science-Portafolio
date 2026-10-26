source("Exercises/Model Validation/solution.R")
source("Exercises/Time Series Backtesting/rolling_origin.R")

stopifnot(abs(roc_auc(c(0, 1), c(0.1, 0.9)) - 1) < 1e-12)
stopifnot(abs(roc_auc(c(0, 1), c(0.5, 0.5)) - 0.5) < 1e-12)
stopifnot(is.na(roc_auc(c(1, 1), c(0.7, 0.8))))
stopifnot(inherits(
  try(classification_metrics(c(0, 1), c(0.2, 0.8), 1.1), silent = TRUE),
  "try-error"
))

backtest <- rolling_origin_backtest(
  values = seq_len(60),
  initial_window = 52,
  horizon = 2,
  step = 2,
  seasonal_period = 52
)
stopifnot(nrow(backtest$predictions) == 16)
stopifnot(all(backtest$predictions$week > backtest$predictions$origin))
stopifnot(all(backtest$predictions$week - backtest$predictions$origin <= 2))
seasonal <- backtest$predictions[
  backtest$predictions$method == "seasonal_naive" &
    backtest$predictions$origin == 52,
]
stopifnot(identical(seasonal$prediction, c(1, 2)))

cat("R exercise checks passed\n")
