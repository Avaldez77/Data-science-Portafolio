
suppressPackageStartupMessages({
  library(readxl)
  library(dplyr)
  library(ggplot2)
  library(scales)
  library(viridis)
  library(gstat)
  library(sp)
})

# Data source
realstate <- "C:/Realstate.xlsx"
datos <- read_excel(realstate)

# -------------------------
# Helper: consistent theme
# -------------------------
portfolio_theme <- function() {
  theme_minimal(base_size = 12) +
    theme(
      plot.title = element_text(face = "bold"),
      panel.grid.minor = element_blank()
    )
}

# -------------------------
# Univariate distributions
# -------------------------

# logSellingPr
media_log <- mean(datos$logSellingPr, na.rm = TRUE)

ggplot(datos, aes(x = logSellingPr)) +
  geom_histogram(bins = 16) +
  geom_vline(xintercept = media_log, linewidth = 0.9) +
  labs(
    title = "Distribution of log(Selling Price)",
    x = "log(Selling Price)",
    y = "Count"
  ) +
  portfolio_theme()

# LivingArea
media_living <- mean(datos$LivingArea, na.rm = TRUE)

ggplot(datos, aes(x = LivingArea)) +
  geom_histogram(bins = 16) +
  geom_vline(xintercept = media_living, linewidth = 0.9) +
  labs(
    title = "Distribution of Living Area",
    x = "Living Area",
    y = "Count"
  ) +
  portfolio_theme()

# Age
media_age <- mean(datos$Age, na.rm = TRUE)

ggplot(datos, aes(x = Age)) +
  geom_histogram(bins = 16) +
  geom_vline(xintercept = media_age, linewidth = 0.9) +
  labs(
    title = "Distribution of Property Age",
    x = "Age",
    y = "Count"
  ) +
  portfolio_theme()

# OtherArea
media_other_area <- mean(datos$OtherArea, na.rm = TRUE)

ggplot(datos, aes(x = OtherArea)) +
  geom_histogram(bins = 16) +
  geom_vline(xintercept = media_other_area, linewidth = 0.9) +
  labs(
    title = "Distribution of Other Area",
    x = "Other Area",
    y = "Count"
  ) +
  portfolio_theme()

# -------------------------
# Discrete counts (bars)
# -------------------------

# Bedrooms

datos %>%
  count(Bedrooms) %>%
  ggplot(aes(x = factor(Bedrooms), y = n)) +
  geom_col() +
  labs(
    title = "Bedrooms Frequency",
    x = "Bedrooms",
    y = "Count"
  ) +
  portfolio_theme()

# Bathrooms

datos %>%
  count(Bathrooms) %>%
  ggplot(aes(x = factor(Bathrooms), y = n)) +
  geom_col() +
  labs(
    title = "Bathrooms Frequency",
    x = "Bathrooms",
    y = "Count"
  ) +
  portfolio_theme()

# HalfBaths

datos %>%
  count(HalfBaths) %>%
  ggplot(aes(x = factor(HalfBaths), y = n)) +
  geom_col() +
  labs(
    title = "Half Baths Frequency",
    x = "Half Baths",
    y = "Count"
  ) +
  portfolio_theme()

# -------------------------
# Binned geospatial inputs
# -------------------------

# Latitude (binned)

datos %>%
  mutate(Latitude_bin = cut(Latitude, breaks = 5, include.lowest = TRUE)) %>%
  count(Latitude_bin) %>%
  ggplot(aes(x = Latitude_bin, y = n)) +
  geom_col() +
  labs(
    title = "Latitude Distribution (Binned)",
    x = "Latitude (bins)",
    y = "Count"
  ) +
  portfolio_theme() +
  theme(axis.text.x = element_text(angle = 25, hjust = 1))

# Longitude (binned)

datos %>%
  mutate(Longitude_bin = cut(Longitude, breaks = 5, include.lowest = TRUE)) %>%
  count(Longitude_bin) %>%
  ggplot(aes(x = Longitude_bin, y = n)) +
  geom_col() +
  labs(
    title = "Longitude Distribution (Binned)",
    x = "Longitude (bins)",
    y = "Count"
  ) +
  portfolio_theme() +
  theme(axis.text.x = element_text(angle = 25, hjust = 1))

# logSellingPr (binned)

datos %>%
  mutate(logSellingPr_bin = cut(logSellingPr, breaks = 5, include.lowest = TRUE)) %>%
  count(logSellingPr_bin) %>%
  ggplot(aes(x = logSellingPr_bin, y = n)) +
  geom_col() +
  labs(
    title = "log(Selling Price) Distribution (Binned)",
    x = "log(Selling Price) (bins)",
    y = "Count"
  ) +
  portfolio_theme() +
  theme(axis.text.x = element_text(angle = 25, hjust = 1))

# LivingArea (binned)

datos %>%
  mutate(LivingArea_bin = cut(LivingArea, breaks = 5, include.lowest = TRUE)) %>%
  count(LivingArea_bin) %>%
  ggplot(aes(x = LivingArea_bin, y = n)) +
  geom_col() +
  labs(
    title = "Living Area Distribution (Binned)",
    x = "Living Area (bins)",
    y = "Count"
  ) +
  portfolio_theme() +
  theme(axis.text.x = element_text(angle = 25, hjust = 1))

# Age (binned)

datos %>%
  mutate(Age_bin = cut(Age, breaks = 5, include.lowest = TRUE)) %>%
  count(Age_bin) %>%
  ggplot(aes(x = Age_bin, y = n)) +
  geom_col() +
  labs(
    title = "Age Distribution (Binned)",
    x = "Age (bins)",
    y = "Count"
  ) +
  portfolio_theme() +
  theme(axis.text.x = element_text(angle = 25, hjust = 1))

# OtherArea (binned)

datos %>%
  mutate(OtherArea_bin = cut(OtherArea, breaks = 5, include.lowest = TRUE)) %>%
  count(OtherArea_bin) %>%
  ggplot(aes(x = OtherArea_bin, y = n)) +
  geom_col() +
  labs(
    title = "Other Area Distribution (Binned)",
    x = "Other Area (bins)",
    y = "Count"
  ) +
  portfolio_theme() +
  theme(axis.text.x = element_text(angle = 25, hjust = 1))

# -------------------------
# Empirical semivariogram
# -------------------------

# Convert to SpatialPointsDataFrame (required for gstat)
datos_sp <- datos
coordinates(datos_sp) <- c("Longitude", "Latitude")

variograma <- variogram(logSellingPr ~ 1, datos_sp)

# Empirical variogram
plot(
  variograma,
  main = "Empirical Semivariogram for log(Selling Price)",
  xlab = "Distance",
  ylab = "Semivariance",
  pch = 16
)

# -------------------------
# Fitted variogram models
# -------------------------

# Spherical
variograma_spherical <- vgm(psill = 0.09, model = "Sph", range = 0.15, nugget = 0.03)
ajuste_spherical <- fit.variogram(variograma, variograma_spherical, fit.sills = TRUE, fit.ranges = FALSE)

plot(
  variograma,
  model = ajuste_spherical,
  main = "Fitted Spherical Variogram",
  xlab = "Distance",
  ylab = "Semivariance",
  pch = 16,
  lwd = 2,
  lty = 1
)

# Exponential
variograma_exponential <- vgm(psill = 0.08, model = "Exp", range = 0.15, nugget = 0.06)
ajuste_exponential <- fit.variogram(variograma, variograma_exponential, fit.sills = TRUE, fit.ranges = TRUE)

plot(
  variograma,
  model = ajuste_exponential,
  main = "Fitted Exponential Variogram",
  xlab = "Distance",
  ylab = "Semivariance",
  pch = 16,
  lwd = 2,
  lty = 1
)

# -------------------------
# Kriging maps (spherical vs exponential)
# -------------------------

# Grid
bbox_vals <- bbox(datos_sp)

grilla <- expand.grid(
  Longitude = seq(bbox_vals["Longitude", "min"], bbox_vals["Longitude", "max"], length.out = 100),
  Latitude  = seq(bbox_vals["Latitude",  "min"], bbox_vals["Latitude",  "max"], length.out = 100)
)
coordinates(grilla) <- ~ Longitude + Latitude

# Use fitted models when available; fall back to nominal if fit fails
sph_model <- if (inherits(ajuste_spherical, "variogramModel")) ajuste_spherical else vgm(psill = 1, model = "Sph", range = 1, nugget = 0.1)
exp_model <- if (inherits(ajuste_exponential, "variogramModel")) ajuste_exponential else vgm(psill = 1, model = "Exp", range = 1, nugget = 0.1)

kriging_sph <- gstat(formula = logSellingPr ~ 1, locations = datos_sp, model = sph_model)
kriging_exp <- gstat(formula = logSellingPr ~ 1, locations = datos_sp, model = exp_model)

sph_result <- predict(kriging_sph, newdata = grilla)
exp_result <- predict(kriging_exp, newdata = grilla)

# Tidy for ggplot

grilla_df <- as.data.frame(grilla)
grilla_df$sph_prediction <- sph_result$var1.pred
grilla_df$exp_prediction <- exp_result$var1.pred

# Map: Spherical

ggplot(grilla_df, aes(x = Longitude, y = Latitude, fill = sph_prediction)) +
  geom_tile() +
  coord_equal() +
  scale_fill_viridis_c(labels = label_number(accuracy = 0.01)) +
  labs(
    title = "Ordinary Kriging Surface (Spherical Model)",
    x = "Longitude",
    y = "Latitude",
    fill = "Predicted log(Selling Price)"
  ) +
  portfolio_theme()

# Map: Exponential

ggplot(grilla_df, aes(x = Longitude, y = Latitude, fill = exp_prediction)) +
  geom_tile() +
  coord_equal() +
  scale_fill_viridis_c(labels = label_number(accuracy = 0.01)) +
  labs(
    title = "Ordinary Kriging Surface (Exponential Model)",
    x = "Longitude",
    y = "Latitude",
    fill = "Predicted log(Selling Price)"
  ) +
  portfolio_theme()
