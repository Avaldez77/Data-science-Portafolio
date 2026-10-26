generate_did_panel <- function(
  n_units = 80,
  periods = 8,
  intervention_period = 5,
  treatment_effect = 5,
  seed = 2026
) {
  if (length(n_units) != 1 || is.na(n_units) || n_units < 4 ||
      n_units != as.integer(n_units) || n_units %% 2 != 0) {
    stop("n_units must be an even integer of at least 4")
  }
  if (length(periods) != 1 || is.na(periods) || periods < 4 ||
      periods != as.integer(periods)) {
    stop("periods must be an integer of at least 4")
  }
  if (length(intervention_period) != 1 || is.na(intervention_period) ||
      intervention_period < 3 || intervention_period > periods ||
      intervention_period != as.integer(intervention_period)) {
    stop("intervention_period must leave at least two pre-periods")
  }
  if (length(treatment_effect) != 1 || is.na(treatment_effect) ||
      !is.finite(treatment_effect)) {
    stop("treatment_effect must be finite")
  }

  set.seed(seed)
  treated <- sample(rep(c(0, 1), each = n_units / 2))
  unit_effect <- rnorm(n_units, mean = 0, sd = 4)
  panel <- expand.grid(
    unit_id = seq_len(n_units),
    period = seq_len(periods),
    KEEP.OUT.ATTRS = FALSE
  )
  panel$treated <- treated[panel$unit_id]
  panel$outcome <- unit_effect[panel$unit_id] +
    1.5 * panel$period +
    treatment_effect * (panel$treated == 1 & panel$period >= intervention_period) +
    rnorm(nrow(panel), mean = 0, sd = 1.5)
  panel
}

estimate_did <- function(
  data,
  intervention_period = 5,
  bootstrap_replicates = 500,
  seed = 2026
) {
  required <- c("unit_id", "period", "treated", "outcome")
  if (!all(required %in% names(data))) {
    stop("data must include unit_id, period, treated, and outcome")
  }
  if (!is.numeric(data$period) || !is.numeric(data$outcome)) {
    stop("period and outcome must be numeric")
  }
  if (length(intervention_period) != 1 || is.na(intervention_period) ||
      !is.finite(intervention_period)) {
    stop("intervention_period must be a single finite value")
  }
  if (nrow(data) == 0 || anyNA(data[required]) ||
      any(!is.finite(data$period)) || any(!is.finite(data$outcome))) {
    stop("data must contain complete finite observations")
  }
  if (!all(data$treated %in% c(0, 1))) {
    stop("treated must contain only 0 and 1")
  }
  if (anyDuplicated(data[c("unit_id", "period")])) {
    stop("unit_id and period combinations must be unique")
  }
  if (length(bootstrap_replicates) != 1 || is.na(bootstrap_replicates) ||
      !is.finite(bootstrap_replicates) || bootstrap_replicates < 100 ||
      bootstrap_replicates != as.integer(bootstrap_replicates)) {
    stop("bootstrap_replicates must be an integer of at least 100")
  }
  periods <- sort(unique(data$period))
  if (length(periods[periods < intervention_period]) < 2 ||
      length(periods[periods >= intervention_period]) < 1) {
    stop("data must include at least two pre-periods and one post-period")
  }
  unit_periods <- split(data$period, data$unit_id)
  if (!all(vapply(unit_periods, function(value) identical(sort(value), periods), logical(1)))) {
    stop("data must be a balanced panel with the same periods for every unit")
  }
  unit_treatment <- split(data$treated, data$unit_id)
  if (!all(vapply(unit_treatment, function(value) length(unique(value)) == 1, logical(1)))) {
    stop("treatment assignment must remain constant within each unit")
  }
  if (!all(c(0, 1) %in% unique(data$treated))) {
    stop("data must include treated and comparison units")
  }

  pre <- aggregate(
    outcome ~ unit_id + treated,
    data = data[data$period < intervention_period, ],
    FUN = mean
  )
  post <- aggregate(
    outcome ~ unit_id + treated,
    data = data[data$period >= intervention_period, ],
    FUN = mean
  )
  changes <- merge(pre, post, by = c("unit_id", "treated"), suffixes = c("_pre", "_post"))
  changes$change <- changes$outcome_post - changes$outcome_pre
  treated_changes <- changes$change[changes$treated == 1]
  comparison_changes <- changes$change[changes$treated == 0]
  estimate <- mean(treated_changes) - mean(comparison_changes)

  pre_means <- aggregate(
    outcome ~ period + treated,
    data = data[data$period < intervention_period, ],
    FUN = mean
  )
  pre_slopes <- lapply(split(pre_means, pre_means$treated), function(group) {
    unname(coef(lm(outcome ~ period, data = group))[["period"]])
  })
  pretrend_slope_gap <- pre_slopes[["1"]] - pre_slopes[["0"]]

  set.seed(seed)
  bootstrap <- replicate(bootstrap_replicates, {
    sampled_treated <- treated_changes[
      sample.int(length(treated_changes), replace = TRUE)
    ]
    sampled_comparison <- comparison_changes[
      sample.int(length(comparison_changes), replace = TRUE)
    ]
    mean(sampled_treated) - mean(sampled_comparison)
  })
  interval <- unname(quantile(bootstrap, probs = c(0.025, 0.975), names = FALSE))
  list(
    estimate = estimate,
    confidence_interval_95 = interval,
    pretrend_slope_gap = pretrend_slope_gap,
    bootstrap_replicates = bootstrap_replicates,
    unit_changes = changes
  )
}

if (sys.nframe() == 0) {
  panel <- generate_did_panel()
  result <- estimate_did(panel)
  cat("Illustrative difference-in-differences estimate\n")
  print(data.frame(
    estimate = result$estimate,
    ci_lower = result$confidence_interval_95[[1]],
    ci_upper = result$confidence_interval_95[[2]],
    pretrend_slope_gap = result$pretrend_slope_gap,
    bootstrap_replicates = result$bootstrap_replicates
  ), row.names = FALSE, digits = 3)
}
