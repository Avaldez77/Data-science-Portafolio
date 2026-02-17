suppressPackageStartupMessages({
  library(survival)
  library(survminer)
  library(dplyr)
  library(ggplot2)
  library(scales)
  library(broom)
})

# Output folder
out <- "outputs_T4"
if (!dir.exists(out)) dir.create(out, recursive = TRUE)

th <- function() {
  theme_minimal(base_size = 12) +
    theme(
      plot.title = element_text(face = "bold"),
      legend.position = "bottom",
      panel.grid.minor = element_blank()
    )
}

savep <- function(p, name, w=8, h=5, dpi=220) {
  ggsave(file.path(out, name), p, width=w, height=h, dpi=dpi)
  p
}

# Data (expects Rossi.txt)
d <- read.table("Rossi.txt", header = TRUE)

# Prep
d <- d %>%
  mutate(
    fin  = factor(fin,  levels=c(0,1), labels=c("No","Yes")),
    wexp = factor(wexp, levels=c(0,1), labels=c("No","Yes")),
    mar  = factor(mar,  levels=c(0,1), labels=c("No","Yes")),
    paro = factor(paro, levels=c(0,1), labels=c("No","Yes")),
    race = factor(race),
    educ = factor(educ),
    week = as.numeric(week),
    arrest = as.integer(arrest)
  )

stopifnot(all(d$week > 0), all(d$arrest %in% c(0,1)))

# Shares (simple)
share <- function(x) {
  tibble(v=x) %>%
    count(v) %>%
    mutate(p = n/sum(n)) %>%
    arrange(desc(n))
}

bar_share <- function(x, ttl, file) {
  t <- share(x)
  p <- ggplot(t, aes(v, p, fill=v)) +
    geom_col(alpha=.9) +
    geom_text(aes(label=percent(p,1)), vjust=-.25, size=3.6) +
    scale_y_continuous(labels=percent_format(1), expand=expansion(mult=c(0, .10))) +
    labs(title=ttl, x=NULL, y="Share") +
    guides(fill="none") +
    th()
  savep(p, file, w=7, h=4.5)
}

bar_share(d$fin,  "fin",  "01_fin.png")
bar_share(d$race, "race", "02_race.png")
bar_share(d$wexp, "wexp", "03_wexp.png")
bar_share(d$mar,  "mar",  "04_mar.png")
bar_share(d$paro, "paro", "05_paro.png")

# educ as bar (ordered)
ed <- share(d$educ) %>% mutate(ed = as.numeric(as.character(v)))
p_educ <- ggplot(ed, aes(ed, p)) +
  geom_col(alpha=.9) +
  scale_x_continuous(breaks=sort(unique(ed$ed))) +
  scale_y_continuous(labels=percent_format(1), expand=expansion(mult=c(0, .10))) +
  labs(title="educ", x="educ", y="Share") +
  th()
savep(p_educ, "06_educ.png", w=8, h=4.5)

# prio boxplot
p_prio <- ggplot(d, aes(x="", y=prio)) +
  geom_boxplot(outlier.alpha=.35) +
  labs(title="prio", x=NULL, y="Count") +
  th()
savep(p_prio, "07_prio.png", w=6.5, h=4.5)

# KM + log-rank
p_lr <- function(f, data) {
  s <- survdiff(f, data=data)
  pchisq(s$chisq, df=length(s$n)-1, lower.tail=FALSE)
}

km <- function(var, file) {
  f <- as.formula(paste0("Surv(week, arrest) ~ ", var))
  fit <- survfit(f, data=d)
  pv <- p_lr(f, d)

  g <- ggsurvplot(
    fit, data=d,
    risk.table=TRUE, conf.int=FALSE,
    pval=paste0("p = ", signif(pv, 3)),
    ggtheme=th()
  )

  ggsave(file.path(out, paste0(file, ".png")), g$plot,  width=8, height=5,   dpi=220)
  ggsave(file.path(out, paste0(file, "_rt.png")), g$table, width=8, height=3, dpi=220)
  invisible(g)
}

km("fin",  "08_km_fin")
km("race", "09_km_race")
km("wexp", "10_km_wexp")
km("mar",  "11_km_mar")
km("paro", "12_km_paro")

# Cox
m <- coxph(Surv(week, arrest) ~ fin + wexp + mar + paro + race + educ + prio, data=d)
print(summary(m))

hr <- broom::tidy(m, exponentiate=TRUE, conf.int=TRUE) %>%
  select(term, estimate, conf.low, conf.high, p.value) %>%
  rename(HR=estimate, low=conf.low, high=conf.high, p=p.value)

write.csv(hr, file.path(out, "cox_hr.csv"), row.names=FALSE)

# PH test
z <- cox.zph(m)
print(z)
capture.output(z, file=file.path(out, "cox_ph.txt"))

png(file.path(out, "cox_ph.png"), width=1200, height=900, res=150)
plot(z)
dev.off()