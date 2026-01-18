# Cargar librerías necesarias
library(rstan)
library(ggplot2)
library(dplyr)
library(tidyr)
library(gridExtra)
library(readr)
library(bayesplot)
library(coda)
library(bridgesampling)

# Configurar Stan para usar múltiples cores
options(mc.cores = parallel::detectCores())

# Leer los datos
datos <- read_delim("C:/Users/naiom/Downloads/chimpanzees.csv", 
                    delim = ";", escape_double = FALSE, trim_ws = TRUE)

datos <- data.frame(datos)
head(datos)

# (a) Análisis exploratorio

tabla_prosoc <- table(datos$pulled_left, datos$prosoc_left); tabla_prosoc
prop_prosoc <- prop.table(tabla_prosoc, margin = 2); prop_prosoc

# Crear tabla de contingencia para pulled_left y condition
tabla_condition <- table(datos$pulled_left, datos$condition); tabla_condition
prop_condition <- prop.table(tabla_condition, margin = 2); prop_condition


# Visualización para prosoc_left
ggplot(datos, aes(x = factor(prosoc_left), fill = factor(pulled_left))) +
  geom_bar(position = "fill") +
  labs(x = "Prosocial Left",
       y = "Proporción",
       fill = "Pulled Left") +
  scale_fill_manual(values = c("0" = "skyblue", "1" = "pink")) +
  theme_minimal() +
  ggtitle("Relación entre pulled_left y prosoc_left")

# Visualización para condition
ggplot(datos, aes(x = factor(condition), fill = factor(pulled_left))) +
  geom_bar(position = "fill") +
  labs(x = "Condition",
       y = "Proporción",
       fill = "Pulled Left") +
  scale_fill_manual(values = c("0" = "skyblue", "1" = "pink")) +
  theme_minimal() +
  ggtitle("Relación entre pulled_left y condition")

# Resumen estadístico
est.descrip <- datos %>%
  group_by(prosoc_left, condition) %>%
  summarise(
    n = n(),
    prop_pulled_left = mean(pulled_left),
    .groups = 'drop'
  ); est.descrip


# (b) Modelo básico en Stan
modelo.basico <- "
data {
  int<lower=0> N;
  int<lower=0,upper=1> L[N];  // pulled left
  int<lower=0,upper=1> P[N];  // prosoc left
}

parameters {
  real alpha;
  real betaP;
}

model {
  // Priors
  alpha ~ normal(0, 10);
  betaP ~ normal(0, 10);
  
  // Likelihood
  for (i in 1:N) {
    L[i] ~ bernoulli_logit(alpha + betaP * P[i]);
  }
}"

writeLines(modelo.basico, con = "Modelo Basico Ayudantia P2.stan")
modelo.basico= stan_model(file= "Modelo Basico Ayudantia P2.stan")


# Ajustamos el modelo
stan.ModeloBasico <- list(
  N = nrow(datos),
  L = datos$pulled_left,
  P = datos$prosoc_left
)

set.seed(2542)
fit.ModeloBasico <- sampling(modelo.basico, 
                             data= stan.ModeloBasico, 
                             iter= 30000, 
                             warmup= 8000, 
                             chains= 3)



summary.basico <- summary(fit.ModeloBasico); summary.basico$summary
my_chains <- as_tibble(rstan::extract(fit.ModeloBasico))
fig_IC <- mcmc_intervals(my_chains[c("alpha","betaP")]) + labs(title = "Intervalos de Credibilidad")
show(fig_IC)

heidel.diag(my_chains[35000:66000,])


# (c) Modelo con interacción en Stan

modelo.interaccion <- "
data {
  int<lower=0> N;
  int<lower=0,upper=1> L[N];  // pulled left
  int<lower=0,upper=1> P[N];  // prosoc left
  int<lower=0,upper=1> C[N];  // condition
}

parameters {
  real alpha;
  real beta_P;
  real beta_PC;
}

model {
  // Priors
  alpha ~ normal(0, 10);
  beta_P ~ normal(0, 10);
  beta_PC ~ normal(0, 10);
  
  // Likelihood
  for (i in 1:N) {
    L[i] ~ bernoulli_logit(alpha + (beta_P + beta_PC * C[i]) * P[i]);
  }
}"

writeLines(modelo.interaccion, con = "Modelo Basico Ayudantia P2.stan")
modelo.interaccion= stan_model(file= "Modelo Basico Ayudantia P2.stan")


# Ajustamos el modelo
stan.ModeloInteraccion <- list(
  N = nrow(datos),
  L = datos$pulled_left,
  P = datos$prosoc_left,
  C = datos$condition
)

fit.ModeloInteraccion <- sampling(modelo.interaccion, 
                                  data= stan.ModeloInteraccion, 
                                  iter= 30000, 
                                  warmup= 8000, 
                                  chains= 3)



summary.interaccion <- summary(fit.ModeloInteraccion); summary.interaccion$summary
my_chains <- as_tibble(rstan::extract(fit.ModeloInteraccion))
fig_IC <- mcmc_intervals(my_chains[c("alpha","beta_P", "beta_PC")]) + labs(title = "Intervalos de Credibilidad")
show(fig_IC)

heidel.diag(my_chains[35000:66000,])


# Factor de Bayes
H0.bridge <- bridge_sampler(fit.ModeloBasico, silent = TRUE)
print(H0.bridge)

H1.bridge <- bridge_sampler(fit.ModeloInteraccion, silent = TRUE)
print(H1.bridge)

H0.error <- error_measures(H0.bridge)$percentage
H1.error <- error_measures(H1.bridge)$percentage

BF01 <- bf(H1.bridge, H0.bridge)
print(BF01)


