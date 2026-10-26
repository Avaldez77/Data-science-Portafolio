set.seed(2026)

sample_size <- 800
segment <- sample(c("A", "B"), sample_size, replace = TRUE)
income <- round(pmax(800, rnorm(sample_size, mean = 3400, sd = 900)))
late_payments <- rpois(sample_size, lambda = 0.8)
log_odds <- -2.7 + (5000 - income) * 0.00035 + late_payments * 0.6 +
  ifelse(segment == "B", 0.25, 0)
default <- rbinom(sample_size, size = 1, prob = plogis(log_odds))
records <- data.frame(
  default = default,
  income = income,
  late_payments = late_payments,
  segment = factor(segment)
)

training_rows <- sample(
  seq_len(nrow(records)),
  size = floor(0.8 * nrow(records))
)
training <- records[training_rows, ]
testing <- records[-training_rows, ]
model <- glm(
  default ~ income + late_payments + segment,
  data = training,
  family = binomial()
)
probability <- predict(model, newdata = testing, type = "response")

safe_ratio <- function(numerator, denominator) {
  if (is.na(numerator) || is.na(denominator) || denominator == 0) {
    NA_real_
  } else {
    numerator / denominator
  }
}

roc_auc <- function(actual, probability) {
  positive_count <- sum(actual == 1)
  negative_count <- sum(actual == 0)
  if (positive_count == 0 || negative_count == 0) return(NA_real_)
  ranks <- rank(probability, ties.method = "average")
  (sum(ranks[actual == 1]) - positive_count * (positive_count + 1) / 2) /
    (positive_count * negative_count)
}

classification_metrics <- function(actual, probability, threshold) {
  predicted <- as.integer(probability >= threshold)
  true_positive <- sum(actual == 1 & predicted == 1)
  false_positive <- sum(actual == 0 & predicted == 1)
  false_negative <- sum(actual == 1 & predicted == 0)
  true_negative <- sum(actual == 0 & predicted == 0)
  precision <- safe_ratio(true_positive, true_positive + false_positive)
  recall <- safe_ratio(true_positive, true_positive + false_negative)
  f1 <- safe_ratio(2 * precision * recall, precision + recall)

  data.frame(
    threshold = threshold,
    accuracy = safe_ratio(true_positive + true_negative, length(actual)),
    precision = precision,
    recall = recall,
    f1 = f1,
    roc_auc = roc_auc(actual, probability)
  )
}

actual <- testing$default
thresholds <- c(0.3, 0.5)
metrics <- do.call(
  rbind,
  lapply(thresholds, function(value) {
    classification_metrics(actual, probability, value)
  })
)
cat("Holdout metrics (synthetic data)\n")
print(metrics, row.names = FALSE, digits = 3)

predicted_at_default <- as.integer(probability >= 0.5)
subgroup_recall <- do.call(
  rbind,
  lapply(levels(testing$segment), function(group) {
    selected <- testing$segment == group
    data.frame(
      segment = group,
      records = sum(selected),
      recall = safe_ratio(
        sum(actual[selected] == 1 & predicted_at_default[selected] == 1),
        sum(actual[selected] == 1)
      )
    )
  })
)
cat("\nRecall by synthetic segment at threshold 0.5\n")
print(subgroup_recall, row.names = FALSE, digits = 3)
