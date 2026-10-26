validate_series <- function(values) {
  if (!is.numeric(values) || length(values) < 2 ||
      anyNA(values) || any(!is.finite(values))) {
    stop("values must contain at least two finite numeric observations")
  }
}

rolling_origin_backtest <- function(
  values,
  initial_window = 56,
  horizon = 4,
  step = 4,
  seasonal_period = 52
) {
  validate_series(values)
  parameters <- c(initial_window, horizon, step, seasonal_period)
  if (anyNA(parameters) || any(!is.finite(parameters)) ||
      any(parameters < 1) || any(parameters != as.integer(parameters))) {
    stop("window, horizon, step, and seasonal period must be positive integers")
  }
  if (initial_window < seasonal_period) {
    stop("initial_window must include at least one seasonal period")
  }
  if (length(values) < initial_window + horizon) {
    stop("series must extend beyond the initial training window and horizon")
  }

  origins <- seq(
    from = initial_window,
    to = length(values) - horizon,
    by = step
  )
  forecasts <- lapply(origins, function(origin) {
    target_weeks <- seq.int(origin + 1, origin + horizon)
    rbind(
      data.frame(
        origin = origin,
        week = target_weeks,
        actual = values[target_weeks],
        method = "last_observation",
        prediction = rep(values[origin], length(target_weeks))
      ),
      data.frame(
        origin = origin,
        week = target_weeks,
        actual = values[target_weeks],
        method = "seasonal_naive",
        prediction = values[target_weeks - seasonal_period]
      )
    )
  })
  predictions <- do.call(rbind, forecasts)
  rownames(predictions) <- NULL

  metrics <- do.call(
    rbind,
    lapply(split(predictions, predictions$method), function(forecast) {
      errors <- forecast$actual - forecast$prediction
      data.frame(
        method = forecast$method[[1]],
        forecasts = length(errors),
        mae = mean(abs(errors)),
        rmse = sqrt(mean(errors^2))
      )
    })
  )
  rownames(metrics) <- NULL
  list(predictions = predictions, metrics = metrics)
}

if (sys.nframe() == 0) {
  set.seed(2026)
  week <- seq_len(104)
  series <- 100 + 0.4 * week + 8 * sin(2 * pi * week / 52) + rnorm(104, sd = 2)
  result <- rolling_origin_backtest(series)
  cat("Rolling-origin metrics (synthetic weekly series)\n")
  print(result$metrics, row.names = FALSE, digits = 3)
}
