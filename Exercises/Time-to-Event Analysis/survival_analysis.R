generate_survival_data <- function(n = 600, seed = 2026) {
  if (length(n) != 1 || is.na(n) || n < 20 || n != as.integer(n)) {
    stop("n must be an integer of at least 20")
  }
  set.seed(seed)
  group <- sample(c("control", "treatment"), n, replace = TRUE)
  age <- round(pmin(85, pmax(18, rnorm(n, mean = 55, sd = 12))))
  treatment <- as.integer(group == "treatment")
  event_time <- rexp(n, rate = 0.035 * exp(-0.35 * treatment + 0.015 * (age - 55)))
  censor_time <- rexp(n, rate = 0.018)
  data.frame(
    time = pmin(event_time, censor_time),
    event = as.integer(event_time <= censor_time),
    group = factor(group, levels = c("control", "treatment")),
    age = age
  )
}

fit_survival_analysis <- function(data) {
  required <- c("time", "event", "group", "age")
  if (!all(required %in% names(data))) {
    stop("data must include time, event, group, and age")
  }
  if (!is.numeric(data$time) || !is.numeric(data$age) || !is.numeric(data$event)) {
    stop("time, event, and age must be numeric")
  }
  if (nrow(data) == 0 || anyNA(data[required]) ||
      any(!is.finite(data$time)) || any(data$time <= 0) ||
      any(!is.finite(data$age)) || any(data$age <= 0)) {
    stop("time and age must be complete, finite, and positive")
  }
  if (!all(data$event %in% c(0, 1)) || sum(data$event) == 0) {
    stop("event must contain 0/1 indicators and at least one observed event")
  }
  if (length(unique(data$group)) != 2) {
    stop("group must contain exactly two observed levels")
  }

  survival_object <- survival::Surv(data$time, data$event)
  kaplan_meier <- survival::survfit(survival_object ~ group, data = data)
  log_rank <- survival::survdiff(survival_object ~ group, data = data)
  cox_model <- survival::coxph(
    survival_object ~ group + age,
    data = data,
    ties = "efron",
    x = TRUE
  )
  proportional_hazards <- survival::cox.zph(cox_model)
  group_term <- grep("^grouptreatment$", names(stats::coef(cox_model)), value = TRUE)
  if (length(group_term) != 1) {
    stop("Unable to identify the treatment coefficient in the Cox model")
  }

  list(
    records = nrow(data),
    observed_events = sum(data$event),
    censored_records = sum(data$event == 0),
    log_rank_p_value = stats::pchisq(
      log_rank$chisq,
      df = length(log_rank$n) - 1,
      lower.tail = FALSE
    ),
    treatment_hazard_ratio = exp(stats::coef(cox_model)[[group_term]]),
    treatment_coefficient = stats::coef(cox_model)[[group_term]],
    proportional_hazards = proportional_hazards,
    kaplan_meier = kaplan_meier,
    cox_model = cox_model
  )
}

if (sys.nframe() == 0) {
  result <- fit_survival_analysis(generate_survival_data())
  cat("Illustrative right-censored time-to-event analysis\n")
  print(data.frame(
    records = result$records,
    observed_events = result$observed_events,
    censored_records = result$censored_records,
    log_rank_p_value = result$log_rank_p_value,
    treatment_hazard_ratio = result$treatment_hazard_ratio
  ), row.names = FALSE, digits = 3)
  cat("\nProportional-hazards diagnostics:\n")
  print(result$proportional_hazards$table)
}
