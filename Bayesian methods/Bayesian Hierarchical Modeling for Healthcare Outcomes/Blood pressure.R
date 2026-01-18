# ==============================
# Bayesian Hierarchical Analysis with Stan
# Dataset: presionarterial
# ==============================

# ---- Libraries ----
library(rstan)
library(tidyverse)
library(bayesplot)
library(loo)
library(gridExtra)
library(bayesrules)
library(tidybayes)
library(coda)

# ---- Stan configuration ----
options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

# ==============================
# 1) Data
# ==============================
datos <- presionarterial %>%
  mutate(hospital_id = as.integer(as.factor(hospital)))

n_hospitals <- length(unique(datos$hospital_id))

# ==============================
# 2) Exploratory Analysis
# ==============================
hist(
  datos$reduccion,
  main = "Distribution of Blood Pressure Reduction",
  xlab = "Reduction"
)

print(
  ggplot(datos, aes(x = factor(hospital_id), y = reduccion)) +
    geom_boxplot(alpha = 0.5) +
    theme_minimal() +
    labs(
      title = "Blood Pressure Reduction by Hospital",
      x = "Hospital",
      y = "Reduction"
    )
)

print(
  ggplot(datos, aes(x = edad, y = reduccion, color = factor(severidad))) +
    geom_point(alpha = 0.5) +
    geom_smooth(method = "lm", se = TRUE) +
    theme_minimal() +
    labs(
      title = "Reduction vs Age by Baseline Severity",
      x = "Age",
      y = "Reduction",
      color = "Severity"
    )
)

print(
  ggplot(datos, aes(x = factor(severidad), y = reduccion)) +
    geom_boxplot(alpha = 0.5) +
    theme_minimal() +
    labs(
      title = "Reduction by Baseline Severity",
      x = "Severity",
      y = "Reduction"
    )
)

summary_by_hospital <- datos %>%
  group_by(hospital_id) %>%
  summarise(
    n = n(),
    mean_reduction = mean(reduccion),
    sd_reduction = sd(reduccion),
    min_reduction = min(reduccion),
    max_reduction = max(reduccion),
    .groups = "drop"
  )

summary_by_hospital
# If you want it as a spreadsheet-style view:
# View(summary_by_hospital)

# ==============================
# 3) Hierarchical Model (Stan)
# ==============================
stan_code <- "
data {
  int<lower=0> N;
  int<lower=0> J;
  int<lower=1,upper=J> hospital[N];
  vector[N] y;
}

parameters {
  real mu_0;
  vector[J] eta;
  real<lower=0> sigma_hospital;
  real<lower=0> sigma;
}

transformed parameters {
  vector[J] alpha;
  alpha = sigma_hospital * eta;
}

model {
  mu_0 ~ normal(10, 5);
  eta ~ normal(0, 1);
  sigma_hospital ~ cauchy(0, 2.5);
  sigma ~ cauchy(0, 2.5);

  y ~ normal(mu_0 + alpha[hospital], sigma);
}

generated quantities {
  vector[N] y_pred;
  real icc;

  for (i in 1:N)
    y_pred[i] = normal_rng(mu_0 + alpha[hospital[i]], sigma);

  icc = square(sigma_hospital) /
        (square(sigma_hospital) + square(sigma));
}
"

stan_data <- list(
  N = nrow(datos),
  J = n_hospitals,
  hospital = datos$hospital_id,
  y = datos$reduccion
)

# Compile directly from the string (no .stan file needed)
compiled_model <- rstan::stan_model(model_code = stan_code)

fit <- rstan::sampling(
  compiled_model,
  data = stan_data,
  chains = 4,
  iter = 2000,
  warmup = 1000,
  seed = 123
)

# ==============================
# 4) Diagnostics and Results
# ==============================
print(fit, pars = c("mu_0", "sigma_hospital", "sigma", "icc"))

print(
  bayesplot::mcmc_trace(
    as.array(fit),
    pars = c("mu_0", "sigma_hospital", "sigma")
  )
)

posterior <- rstan::extract(fit)

# alpha is [iterations x J]
effects_df <- tibble(
  hospital = rep(1:n_hospitals, each = nrow(posterior$alpha)),
  effect = as.vector(posterior$alpha)
)

print(
  ggplot(effects_df, aes(x = factor(hospital), y = effect)) +
    geom_violin(alpha = 0.5) +
    geom_hline(yintercept = 0, linetype = "dashed") +
    theme_minimal() +
    labs(
      title = "Posterior Distribution of Hospital Effects",
      x = "Hospital",
      y = "Effect"
    )
)
