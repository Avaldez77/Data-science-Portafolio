# ============================================================
# Bayesian Hierarchical Model (Stan) — Simulation + Inference
# Author: (Your Name)
# ============================================================

# ---- Libraries ----
library(rstan)
library(tibble)
library(ggplot2)

# ---- Reproducibility ----
set.seed(123)

# ---- Data generation (synthetic) ----
# Model used to simulate data:
#   theta_i ~ Normal(mu, 1/tau)
#   sigma2_i ~ Inverse-Gamma(a0, b0)  (implemented as 1 / Gamma(a0, b0))
#   y_i ~ Normal(theta_i, sigma2_i)
generate_sample <- function(N, mu, tau, a0, b0) {
  theta  <- rnorm(N, mean = mu, sd = sqrt(1 / tau))
  sigma2 <- 1 / rgamma(N, shape = a0, rate = b0)
  y <- vapply(seq_len(N), function(i) {
    rnorm(1, mean = theta[i], sd = sqrt(sigma2[i]))
  }, numeric(1))
  
  data.frame(y = y, theta = theta, sigma2 = sigma2)
}

# ---- Simulate dataset ----
true_mu  <- 0.5
true_tau <- 5
a0 <- 1
b0 <- 1

simulated_data <- generate_sample(
  N   = 100,
  mu  = true_mu,
  tau = true_tau,
  a0  = a0,
  b0  = b0
)

# ---- Data passed to Stan ----
# NOTE: The Stan model is expected to use:
#   int N;
#   vector[N] x;
#   real v0;
#   real a0;
#   real b0;
stan_data <- list(
  N  = nrow(simulated_data),
  x  = simulated_data$y,
  v0 = 0.5,  # keep if your .stan file uses it
  a0 = a0,
  b0 = b0
)

# ---- Stan compilation + sampling ----
# Update this path if needed
stan_file <- "modelo.stan"

if (!file.exists(stan_file)) {
  stop("Stan file not found: 'modelo.stan'. Place it in the same folder as this script or update 'stan_file'.")
}

rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

stan_mod <- stan_model(file = stan_file)

fit <- sampling(
  object = stan_mod,
  data   = stan_data,
  iter   = 2000,
  chains = 4,
  seed   = 123
)

# ---- Extract draws (with chain + iteration) ----
# extract(..., permuted = FALSE) returns an array: iterations x chains x parameters
draws_array <- rstan::extract(fit, permuted = FALSE, inc_warmup = FALSE)

# Helper to locate parameter slices robustly
param_names <- dimnames(draws_array)$parameters

get_param_matrix <- function(param) {
  idx <- which(param_names == param)
  if (length(idx) != 1) stop(paste0("Parameter not found in Stan output: ", param))
  draws_array[, , idx, drop = TRUE]  # iterations x chains
}

mu_mat  <- get_param_matrix("mu")
tau_mat <- get_param_matrix("tau")

draws_df <- data.frame(
  iteration = rep(seq_len(nrow(mu_mat)), times = ncol(mu_mat)),
  chain     = rep(seq_len(ncol(mu_mat)), each  = nrow(mu_mat)),
  mu        = as.vector(mu_mat),
  tau       = as.vector(tau_mat)
)

# ---- Posterior estimates vs. true values ----
estimated_mu  <- mean(draws_df$mu)
estimated_tau <- mean(draws_df$tau)

comparison <- tibble(
  Parameter       = c("mu", "tau"),
  True_Value      = c(true_mu, true_tau),
  Estimated_Value = c(estimated_mu, estimated_tau),
  Absolute_Error  = abs(c(true_mu, true_tau) - c(estimated_mu, estimated_tau))
)

print(comparison)

# ---- Trace plots ----
trace_plot_mu <- ggplot(draws_df, aes(x = iteration, y = mu, group = chain)) +
  geom_line(alpha = 0.6) +
  labs(
    title = "Trace Plot — mu",
    x = "Iteration",
    y = "mu"
  ) +
  theme_minimal()

trace_plot_tau <- ggplot(draws_df, aes(x = iteration, y = tau, group = chain)) +
  geom_line(alpha = 0.6) +
  labs(
    title = "Trace Plot — tau",
    x = "Iteration",
    y = "tau"
  ) +
  theme_minimal()

print(trace_plot_mu)
print(trace_plot_tau)

# ---- Posterior density plots (mean + 95% credible interval) ----
density_mu <- ggplot(draws_df, aes(x = mu)) +
  geom_density(alpha = 0.4) +
  geom_vline(xintercept = mean(draws_df$mu), linetype = "dashed", linewidth = 1) +
  geom_vline(xintercept = quantile(draws_df$mu, 0.025), linetype = "dotted", linewidth = 1) +
  geom_vline(xintercept = quantile(draws_df$mu, 0.975), linetype = "dotted", linewidth = 1) +
  labs(
    title = "Posterior Density — mu (mean + 95% credible interval)",
    x = "mu",
    y = "Density"
  ) +
  theme_minimal()

density_tau <- ggplot(draws_df, aes(x = tau)) +
  geom_density(alpha = 0.4) +
  geom_vline(xintercept = mean(draws_df$tau), linetype = "dashed", linewidth = 1) +
  geom_vline(xintercept = quantile(draws_df$tau, 0.025), linetype = "dotted", linewidth = 1) +
  geom_vline(xintercept = quantile(draws_df$tau, 0.975), linetype = "dotted", linewidth = 1) +
  labs(
    title = "Posterior Density — tau (mean + 95% credible interval)",
    x = "tau",
    y = "Density"
  ) +
  theme_minimal()

print(density_mu)
print(density_tau)

# ---- Quick fit summary ----
print(fit, pars = c("mu", "tau"), probs = c(0.025, 0.5, 0.975))
