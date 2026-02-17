############################################################
# Tarea 2 (Portfolio) — Longitudinal Mixed-Effects Modeling
# Workflow:
#   1) Load dataset (preferred) OR generate demo dataset (fallback)
#   2) EDA + visualizations
#   3) Mixed-effects models (RI vs RI+RS; interactions)
#   4) Diagnostics + predictions + holdout metrics
#   5) Printed Results Panels
############################################################

# =========================
# 0) Setup
# =========================
suppressPackageStartupMessages({
  library(tidyverse)
  library(nlme)
  library(broom.mixed)
  library(performance)
  library(ggpubr)
  library(patchwork)
  library(scales)
  library(MASS)
})

set.seed(42)

# Output folder for plots
out_dir <- "outputs_tarea2"
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

# =========================
# 1) Data ingestion (real data preferred; demo fallback)
# =========================
# Expected schema:
#   Subject (id), Sex (Male/Female), Group (Control/Treatment), age (numeric), distance (numeric)

data_path <- file.path("data", "orthodont_long.csv")

make_demo_dataset <- function(seed = 42) {
  set.seed(seed)

  n_subjects <- 27
  subjects <- sprintf("S%02d", 1:n_subjects)

  subject_meta <- tibble(
    Subject = subjects,
    Sex     = sample(c("Male", "Female"), n_subjects, replace = TRUE, prob = c(0.55, 0.45)),
    Group   = sample(c("Control", "Treatment"), n_subjects, replace = TRUE, prob = c(0.60, 0.40))
  )

  ages <- c(8, 10, 12, 14)

  sigma_intercept <- 1.6
  sigma_slope     <- 0.25
  rho             <- -0.35
  Sigma_b <- matrix(
    c(sigma_intercept^2, rho*sigma_intercept*sigma_slope,
      rho*sigma_intercept*sigma_slope, sigma_slope^2),
    nrow = 2, byrow = TRUE
  )

  beta_0 <- 16.5
  beta_age <- 0.55
  beta_sex_female <- -0.60
  beta_group_treat <- 0.30
  beta_age_sex_female <- 0.08
  beta_age_group_treat <- 0.05
  sigma_eps <- 0.9

  panel <- expand_grid(Subject = subjects, age = ages) %>%
    left_join(subject_meta, by = "Subject") %>%
    arrange(Subject, age)

  B <- MASS::mvrnorm(n = n_subjects, mu = c(0, 0), Sigma = Sigma_b)
  rand_eff <- tibble(Subject = subjects, b0 = B[, 1], b1 = B[, 2])

  df <- panel %>%
    left_join(rand_eff, by = "Subject") %>%
    mutate(
      Sex = factor(Sex),
      Group = factor(Group),
      age_c = age - 8,
      mu = beta_0 +
        beta_age * age_c +
        ifelse(Sex == "Female", beta_sex_female, 0) +
        ifelse(Group == "Treatment", beta_group_treat, 0) +
        ifelse(Sex == "Female", beta_age_sex_female * age_c, 0) +
        ifelse(Group == "Treatment", beta_age_group_treat * age_c, 0) +
        b0 + b1 * age_c,
      distance = mu + rnorm(n(), mean = 0, sd = sigma_eps)
    ) %>%
    select(Subject, Sex, Group, age, distance)

  return(df)
}

if (file.exists(data_path)) {
  df <- read_csv(data_path, show_col_types = FALSE) %>%
    mutate(
      Subject = as.character(Subject),
      Sex = factor(Sex),
      Group = factor(Group),
      age = as.numeric(age),
      distance = as.numeric(distance)
    )

  cat("\n====================\nDATA SOURCE\n====================\n")
  cat("Loaded dataset from:", normalizePath(data_path), "\n")

} else {
  df <- make_demo_dataset(seed = 42)

  cat("\n====================\nDATA SOURCE\n====================\n")
  cat("Using a demo dataset (fallback) because no file was found at:", data_path, "\n")
  cat("To use real data, place a CSV at that path with columns:\n")
  cat("Subject, Sex, Group, age, distance\n")
}

# Quick EDA
cat("\n====================\nDATA OVERVIEW\n====================\n")
print(glimpse(df))
cat("\nSummary:\n")
print(summary(df))

# =========================
# 2) Exploratory Plots
# =========================
p_box_subject_sex <- ggplot(df, aes(x = interaction(Subject, Sex), y = distance, fill = Sex)) +
  geom_boxplot(outlier.alpha = 0.35) +
  labs(title = "Distance Distribution by Subject and Sex", x = "Subject × Sex", y = "Distance") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))

ggsave(file.path(out_dir, "01_boxplot_subject_sex.png"), p_box_subject_sex,
       width = 14, height = 6, dpi = 220)

p_box_age_sex <- ggplot(df, aes(x = interaction(age, Sex), y = distance, fill = Sex)) +
  geom_boxplot(outlier.alpha = 0.35) +
  labs(title = "Distance Distribution by Age and Sex", x = "Age × Sex", y = "Distance") +
  theme_bw()

ggsave(file.path(out_dir, "02_boxplot_age_sex.png"), p_box_age_sex,
       width = 10, height = 5, dpi = 220)

p_spaghetti <- ggplot(df, aes(x = age, y = distance, color = Group)) +
  geom_point(alpha = 0.75) +
  geom_line(aes(group = Subject), alpha = 0.60) +
  facet_wrap(~ Subject) +
  labs(title = "Longitudinal Distance Trajectories by Subject", x = "Age", y = "Distance") +
  theme_bw() +
  theme(legend.position = "bottom")

ggsave(file.path(out_dir, "03_spaghetti_by_subject.png"), p_spaghetti,
       width = 14, height = 10, dpi = 220)

print(p_box_subject_sex)
print(p_box_age_sex)
print(p_spaghetti)

# =========================
# 3) Mixed-Effects Models (nlme::lme)
# =========================
cat("\n====================\nMODEL FITTING\n====================\n")

m1 <- lme(distance ~ age, random = ~ 1 | Subject, data = df, method = "REML")
cat("\n--- Model 1 (Random Intercept) ---\n")
print(summary(m1))

m2 <- lme(distance ~ age, random = ~ age | Subject, data = df, method = "REML")
cat("\n--- Model 2 (Random Intercept + Slope) ---\n")
print(summary(m2))

m1_ml <- update(m1, method = "ML")
m2_ml <- update(m2, method = "ML")
cat("\n--- Likelihood Ratio Test: m1 vs m2 (ML) ---\n")
print(anova(m1_ml, m2_ml))

m_full <- lme(
  distance ~ age * Sex + age * Group,
  random = ~ age | Subject,
  data = df,
  method = "REML"
)

cat("\n--- Full Model (age*Sex + age*Group, random slope) ---\n")
print(summary(m_full))

# =========================
# 4) Diagnostics
# =========================
cat("\n====================\nDIAGNOSTICS\n====================\n")

resid_df <- tibble(
  fitted = fitted(m_full),
  resid  = resid(m_full, type = "pearson")
)

p_resid_fitted <- ggplot(resid_df, aes(x = fitted, y = resid)) +
  geom_point(alpha = 0.55) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  labs(title = "Residuals vs Fitted (Pearson)", x = "Fitted", y = "Residuals") +
  theme_bw()

p_qq <- ggplot(resid_df, aes(sample = resid)) +
  stat_qq(alpha = 0.5) +
  stat_qq_line() +
  labs(title = "Q-Q Plot (Pearson Residuals)", x = "Theoretical Quantiles", y = "Sample Quantiles") +
  theme_bw()

ggsave(file.path(out_dir, "04_residuals_vs_fitted.png"), p_resid_fitted, width = 7, height = 5, dpi = 220)
ggsave(file.path(out_dir, "05_qq_plot.png"), p_qq, width = 7, height = 5, dpi = 220)

print(p_resid_fitted)
print(p_qq)

re <- ranef(m_full); re$Subject <- rownames(re)

p_re_int <- ggplot(re, aes(x = reorder(Subject, `(Intercept)`), y = `(Intercept)`)) +
  geom_col(alpha = 0.85) +
  coord_flip() +
  labs(title = "Random Intercepts by Subject", x = "Subject", y = "Random Intercept") +
  theme_bw()

p_re_slope <- ggplot(re, aes(x = reorder(Subject, age), y = age)) +
  geom_col(alpha = 0.85) +
  coord_flip() +
  labs(title = "Random Slopes (Age) by Subject", x = "Subject", y = "Random Slope") +
  theme_bw()

ggsave(file.path(out_dir, "06_random_intercepts.png"), p_re_int, width = 8, height = 10, dpi = 220)
ggsave(file.path(out_dir, "07_random_slopes.png"), p_re_slope, width = 8, height = 10, dpi = 220)

print(p_re_int)
print(p_re_slope)

# =========================
# 5) Predictions & Holdout Metrics
# =========================
cat("\n====================\nPREDICTIONS & METRICS\n====================\n")

subjects <- unique(df$Subject)

pred_grid <- expand_grid(
  age = seq(min(df$age), max(df$age), by = 0.25),
  Sex = levels(df$Sex),
  Group = levels(df$Group),
  Subject = subjects[1]
)

pred_grid$pred_fixed <- predict(m_full, newdata = pred_grid, level = 0)

p_pred <- ggplot(pred_grid, aes(x = age, y = pred_fixed, color = Sex, linetype = Group)) +
  geom_line(linewidth = 1.2) +
  labs(title = "Fixed-Effects Predictions (Marginal Trends)",
       x = "Age", y = "Predicted Distance", color = "Sex", linetype = "Group") +
  theme_bw() +
  theme(legend.position = "bottom")

ggsave(file.path(out_dir, "08_fixed_effect_predictions.png"), p_pred, width = 10, height = 6, dpi = 220)
print(p_pred)

set.seed(42)
test_subjects <- sample(subjects, size = ceiling(0.25 * length(subjects)))
train <- df %>% filter(!Subject %in% test_subjects)
test  <- df %>% filter(Subject %in% test_subjects)

m_full_train <- lme(distance ~ age * Sex + age * Group, random = ~ age | Subject, data = train, method = "REML")
test$pred_fixed <- predict(m_full_train, newdata = test, level = 0)

rmse <- sqrt(mean((test$distance - test$pred_fixed)^2))
mae  <- mean(abs(test$distance - test$pred_fixed))
r2   <- 1 - sum((test$distance - test$pred_fixed)^2) / sum((test$distance - mean(test$distance))^2)

metrics <- tibble(
  metric = c("RMSE (fixed-effects)", "MAE (fixed-effects)", "R2 (fixed-effects)"),
  value  = c(rmse, mae, r2)
)

cat("\nHoldout Metrics (fixed-effects predictions):\n")
print(metrics)

# =========================
# 6) Printed Results Panels
# =========================
cat("\n====================\nPRINTED RESULTS PANELS\n====================\n")

cmp <- tibble(
  model  = c("m1: RI", "m2: RI+RS", "m_full: RI+RS + interactions"),
  AIC    = c(AIC(m1), AIC(m2), AIC(m_full)),
  BIC    = c(BIC(m1), BIC(m2), BIC(m_full)),
  logLik = c(logLik(m1)[1], logLik(m2)[1], logLik(m_full)[1])
) %>% arrange(AIC)

cat("\nModel Comparison (sorted by AIC):\n")
print(cmp)

cat("\nBest Model by AIC:\n")
print(cmp[1, ])

cat("\nFull Model Fixed Effects:\n")
print(tidy(m_full, effects = "fixed", conf.int = TRUE) %>%
        mutate(across(where(is.numeric), ~round(.x, 4))))

cat("\nFull Model Random Effects (Std Dev / Corr):\n")
print(VarCorr(m_full))

cat("\nFull Model Fit Metrics:\n")
print(metrics)

write.csv(cmp, file.path(out_dir, "model_comparison.csv"), row.names = FALSE)
write.csv(metrics, file.path(out_dir, "holdout_metrics.csv"), row.names = FALSE)

cat("\nAll plots saved to:", normalizePath(out_dir), "\n")
