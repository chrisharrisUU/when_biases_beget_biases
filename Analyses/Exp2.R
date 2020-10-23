### Setup----
# Dependencies
if (!require(needs)) {install.packages("needs"); library(needs)}
if (!require(goallabr)) {
  if (!require(devtools)) {install.packages("devtools"); library(devtools)}
  install_github("chrisharrisUU/goallabr")
}
needs(BayesFactor, dplyr, ggplot2, ggsci, goallabr, gridExtra, here, lme4, lmerTest, magrittr, papaja, tidyr)
prioritize(dplyr)

### Data import
source("Auxiliary/Exp2_import.r")
rm(as.data.frame.avector, `[.avector`)

# Remove not completed cases
data2 %<>%
  filter(LASTPAGE == 20)

# Rename necessary columns from Sosci to my names
column.rename <- function(data) {
  # Prolific ID
  # Self-report
  Participant.id <- data %>%
    transmute(Participant.id  = ifelse(grepl("@", DM04_01), substr(DM04_01, start = 1, stop = regexpr("@", DM04_01) - 1), DM04_01))
  
  # Read out from link
  session_id <- data %>%
    transmute(ID = as.character(substr(IV04_REF, start = 37, stop = 100)))
  
  # Condition
  # 1 -> rich, 75% wins
  # 2 -> impoverished, 75% losses
  condition <- data %>%
    transmute(condition = factor(UR01, levels = c(1,2), labels = c("rich", "impoverished")))
  
  # Balancing
  # 1 -> frequent street
  # 2 -> frequent park
  primacyfunction <- function(x) {
    x[which(x == 1)] <- -1
    x[which(x == 2)] <- 1
    x
  }
  primacy <- data %>%
    transmute(primacy = ifelse(UR02 == 1, -1, 1)) %>%
    mutate(primacy = factor(primacy, levels = c(-1,1), labels = c("street", "park")))
  
  # Points earned
  account <- data %>%
    select(contains("IV02"), contains("IV03")) %>%
    select(-c("IV02_17", "IV02_18")) %>%
    mutate(across(everything(), as.integer)) %>%
    mutate(account = rowSums(., na.rm = TRUE)) %>%
    rename_with(., ~gsub("IV03_", "output", .x))
  
  # Helper function for converting characters to numbers
  converter <- function(x) {
    x <- gsub("%place1%", -1, x)
    x <- gsub("%place2%", 1, x)
    x %>%
      as.integer %>%
      return
  }
  # Choices in free selection phase
  freeselection <- data %>%
    select(contains("TR02")) %>%
    select(everything(), -contains("a")) %>%
    mutate_all(converter)
  # Assign useful column names
  colnames(freeselection) <- paste("week", 17:100, sep = "")
  # Create selection index
  freeselection <- freeselection %>%
    mutate(choiceindex_raw = rowSums(., na.rm = TRUE))
  
  # Initial DVs
  # Preference
  prepref_raw <- data %>%
    transmute(adjusted = DV06_01 - 1) %>%
    unlist
  # Conditionals
  precond <- data %>%
    transmute(street_precond = DV07_01 - 1,
              park_precond = DV07_02 - 1)
  # Confidence
  preconf <- data %>%
    transmute(street_preconf = DV08_01 - 1,
              park_preconf = DV08_02 - 1)
  
  # DV Preference
  # street |--------| park
  preference_raw <- data %>%
    transmute(adjusted = DV01_01 - 1) %>%
    unlist
  
  # Conditional estimates
  conditionals <- data %>%
    transmute(street_cond = DV02_01 - 1,
              park_cond = DV02_02 - 1)
  
  # Confidence estimates
  confidence <- data %>%
    transmute(street_conf = DV03_01 - 1,
              park_conf = DV03_02 - 1)
  
  # Control estimates
  control <- data %>%
    transmute(street_ctrl = DV04_01 - 1,
              park_ctrl = DV04_02 - 1)
  
  # Predictability estimates
  predictability <- data %>%
    transmute(street_pred = DV05_01 - 1,
              park_pred = DV05_02 - 1)
  
  # Demographics
  dem <- data %>%
    select(age = DM01,
           gender = DM02,
           psych = DM03,
           attcheck = DM06,
           edu = DM07)
  
  # Return dataframe
  data.frame(Participant.id, session_id, condition, primacy, account,
             prepref_raw, precond, preconf,
             freeselection, preference_raw, conditionals, confidence, control, predictability,
             dem)
}
df2 <- column.rename(data2)
rm(column.rename)

# Delete cases with too many missing choices
df2$choiceNAs <- df2 %>%
  select(contains("week")) %>%
  apply(., 2, function(x) {
    y <- rep(0, length(x))
    y[which(is.na(x))] <- 1
    y
  }) %>%
  rowSums
excluded <- which(df2$choiceNAs > 10)
df2 %<>%
  filter(choiceNAs < 10)

# Color palette for graphs
pal <- ggsci::pal_uchicago()(5)[c(3, 5, 1)]


### Functions----
source("Auxiliary/functions.R")

### Canonical sorting----
df2 %<>%
  # frequent
  mutate(prepref1         = ifelse(primacy == "street", 100 - prepref_raw, prepref_raw),
         precond_freq     = ifelse(primacy == "street", street_precond, park_precond),
         precond_infreq   = ifelse(primacy == "street", park_precond, street_precond),
         preconf_freq     = ifelse(primacy == "street", street_preconf, park_preconf),
         preconf_infreq   = ifelse(primacy == "street", park_preconf, street_preconf),
         choiceindex_freq = ifelse(primacy == "street", choiceindex_raw * (-1), choiceindex_raw),
         postpref1        = ifelse(primacy == "street", 100 - preference_raw, preference_raw),
         postcond_freq    = ifelse(primacy == "street", street_cond, park_cond),
         postcond_infreq  = ifelse(primacy == "street", park_cond, street_cond),
         postconf_freq    = ifelse(primacy == "street", street_conf, park_conf),
         postconf_infreq  = ifelse(primacy == "street", park_conf, street_conf),
         postctrl_freq    = ifelse(primacy == "street", street_ctrl, park_ctrl),
         postctrl_infreq  = ifelse(primacy == "street", park_ctrl, street_ctrl),
         postpred_freq    = ifelse(primacy == "street", street_pred, park_pred),
         postpred_infreq  = ifelse(primacy == "street", park_pred, street_pred)) %>%
  # delta p
  mutate(precond_1        = precond_freq - precond_infreq,
         preconf_1        = preconf_freq - preconf_infreq,
         postcond_1       = postcond_freq - postcond_infreq,
         postconf_1       = postconf_freq - postconf_infreq,
         postctrl_1       = postctrl_freq - postctrl_infreq,
         postpred_1       = postpred_freq - postpred_infreq) %>%
  # shift
  mutate(prepref_freq     = prepref1 - 50,
         precond_dp       = precond_1 / 100,
         preconf_dp       = preconf_1 / 100,
         postpref_freq    = postpref1 - 50,
         postcond_dp      = postcond_1 / 100,
         postconf_dp      = postconf_1 / 100,
         postctrl_dp      = postctrl_1 / 100,
         postpred_dp      = postpred_1 / 100) %>%
  # dominant
  mutate(prepref_dom      = ifelse(condition == "rich", prepref_freq, prepref_freq * (-1)),
         precond_dp_dom   = ifelse(condition == "rich", precond_dp, precond_dp * (-1)),
         preconf_dp_dom   = ifelse(condition == "rich", preconf_dp, preconf_dp * (-1)),
         choiceindex_dom  = ifelse(condition == "rich", choiceindex_freq, choiceindex_freq * (-1)),
         postpref_dom     = ifelse(condition == "rich", postpref_freq, postpref_freq * (-1)),
         postcond_dp_dom  = ifelse(condition == "rich", postcond_dp, postcond_dp * (-1)),
         postconf_dp_dom  = ifelse(condition == "rich", postconf_dp, postconf_dp * (-1)),
         postctrl_dp_dom  = ifelse(condition == "rich", postctrl_dp, postctrl_dp * (-1)),
         postpred_dp_dom  = ifelse(condition == "rich", postpred_dp, postpred_dp * (-1))) %>%
  # sampling as percentage
  mutate(choiceindex_per  = (choiceindex_freq + 84) / (84 * 2))

# Make preference binary
df2 %<>%
  mutate(binaryprepref = ifelse(prepref_dom > 0,
                                1,
                                ifelse(prepref_dom < 0, 0, NA)),
         binarypostpref = ifelse(postpref_dom > 0,
                                 1,
                                 ifelse(postpref_dom < 0, 0, NA))) %>%
  mutate(binarypostpref = factor(binarypostpref, levels = c(1, 0)),
         binaryprepref = factor(binaryprepref, levels = c(1, 0)))

### Demographic data----
df2 %>%
  mutate(age = as.integer(as.character(age))) %>%
  summarise(N = n(),
            female = length(which(gender == "female")),
            age_mean = mean(age, na.rm = TRUE),
            age_sd = sd(age, na.rm = TRUE),
            Psychstudents_percent = length(which(psych == "Yes")) / n(),
            Attention_Check_percent = length(which(attcheck == "I disagree")) / n())

# Level of education
df2 %>%
  group_by(edu) %>%
  summarise(count = length(edu))
# Percentage degree
length(which(as.integer(df2$edu) > 2)) / nrow(df2)

### Relative contingency estimate pre -----------------------------------------------------

exp2_pg1 <- df2 %>%
  ggplot(aes(x = condition,
             y = prepref_freq,
             fill = condition)) +
  geom_violin() + 
  geom_boxplot(width = 0.2) +
  geom_jitter(size = 0.5, width = 0.2) +
  geom_hline(yintercept = 0, linetype = 2) +
  scale_fill_manual(values = pal) +
  theme_apa() +
  labs(x = "Condition",
       y = "Relative contingency estimates") +
  theme(legend.position = "none")

exp2_pg2 <- df2 %>%
  ggplot(aes(x = condition,
             y = precond_dp,
             fill = condition)) +
  geom_violin() + 
  geom_boxplot(width = 0.2) +
  geom_jitter(size = 0.5, width = 0.2) +
  geom_hline(yintercept = 0, linetype = 2) +
  scale_fill_manual(values = pal) +
  theme_apa() +
  labs(x = "Condition",
       y = expression(Delta*"P from conditional probability estimates")) +
  theme(legend.position = "none")

# grid.arrange(exp2_pg1, exp2_pg2, ncol = 2) %>%
#   ggsave(plot = ., filename = "Output/Graphs/Exp2_preprefcond.svg", device = "svg", dpi = 320, width = 9.08, height = 5.72)


## Descriptives

# Graph
df2 %>%
  ggplot(aes(x = condition,
             y = prepref_freq,
             fill = condition)) +
  geom_violin() + 
  geom_boxplot(width = 0.2) +
  geom_jitter(size = 0.5, width = 0.2) +
  geom_hline(yintercept = 0, linetype = 2) +
  scale_fill_manual(values = pal) +
  theme_apa() +
  labs(x = "Condition",
       y = "Relative contingency estimates premeasure") +
  theme(legend.position = "none")

# Means and sds
df2 %>%
  group_by(condition) %>%
  summarise(pre_avg = printnum(mean(prepref_freq)),
            pre_SD = printnum(sd(prepref_freq)))

## Rich
df2 %>%
  filter(condition == "rich") %>%
  as.data.frame() %$%
  ttestBF(prepref_freq,
          mu = 0,
          nullInterval = c(0, Inf)) %>%
  printBFt()
ttest(data = df2,
      y = prepref_freq,
      x = condition,
      mu = 0,
      sub = "rich",
      dir = "greater")

## Impoverished
df2 %>%
  filter(condition == "impoverished") %>%
  as.data.frame() %$%
  ttestBF(prepref_freq,
          mu = 0,
          nullInterval = c(-Inf, 0)) %>%
  printBFt()
ttest(data = df2,
      y = prepref_freq,
      x = condition,
      mu = 0,
      sub = "impoverished",
      dir = "less")

## Strength
df2 %>%
  as.data.frame() %>%
  ttestBF(formula = prepref_freq ~ condition,
          nullInterval = c(-Inf, Inf),
          data = .) %>%
  printBFt()
ttest(data = df2,
      y = prepref_freq,
      x = condition,
      dir = "two.sided")

## Overall
df2 %>%
  as.data.frame() %$%
  ttestBF(prepref_freq,
          mu = 0,
          nullInterval = c(0, Inf)) %>%
  printBFt()
ttest(data = df2,
      y = prepref_freq,
      x = condition,
      mu = 0,
      dir = "greater")

### Conditional probability estimates pre -----------------------------------------------------

## Descriptives

# Means and sds
df2 %>%
  group_by(condition) %>%
  summarise(pre_avg = printnum(mean(precond_dp)),
            pre_SD = printnum(sd(precond_dp)))

df2 %>%
  mutate(frequent = precond_freq,
         infrequent = precond_infreq) %>%
  group_by(condition) %>%
  summarise(freq_loc = printnum(mean(frequent)),
            freq_sd = printnum(sd(frequent)),
            infreq_loc = printnum(mean(infrequent)),
            infreq_sd = printnum(sd(infrequent)),
            # test:
            dp = printnum((mean(frequent) - mean(infrequent)) / 100))

## Rich
df2 %>%
  filter(condition == "rich") %>%
  as.data.frame() %$%
  ttestBF(precond_dp,
          mu = 0,
          nullInterval = c(0, Inf)) %>%
  printBFt()
ttest(data = df2,
      y = precond_dp,
      x = condition,
      mu = 0,
      sub = "rich",
      dir = "greater")

## Impoverished
df2 %>%
  filter(condition == "impoverished") %>%
  as.data.frame() %$%
  ttestBF(precond_dp,
          mu = 0,
          nullInterval = c(-Inf, 0)) %>%
  printBFt()
ttest(data = df2,
      y = precond_dp,
      x = condition,
      mu = 0,
      sub = "impoverished",
      dir = "less")

## Strength
df2 %>%
  as.data.frame() %>%
  ttestBF(formula = precond_dp ~ condition,
          nullInterval = c(-Inf, Inf),
          data = .) %>%
  printBFt()
ttest(data = df2,
      y = precond_dp,
      x = condition,
      dir = "two.sided")

## Overall
df2 %>%
  as.data.frame() %$%
  ttestBF(precond_dp,
          mu = 0,
          nullInterval = c(0, Inf)) %>%
  printBFt()
ttest(data = df2,
      y = precond_dp,
      x = condition,
      mu = 0,
      dir = "greater")

### Confidence pre ----

# Descriptives
conf <- df2 %>%
  group_by(condition) %>%
  mutate(conf_pre_fr = preconf_freq,
         conf_pre_in = preconf_infreq) %>%
  ungroup %>%
  select(condition, conf_pre_fr, conf_pre_in) %>%
  pivot_longer(cols = c(conf_pre_fr, conf_pre_in),
               names_to = "type",
               values_to = "confidence")
conf %>%
  group_by(type) %>%
  summarize(pre_conf_avg = printnum(mean(confidence)),
            pre_conf_sd  = printnum(sd(confidence)))

# Inference tests
conf %>%
  as.data.frame() %>%
  ttestBF(data = .,
          formula = confidence ~ type,
          nullInterval = c(-Inf, Inf)) %>%
  printBFt()
ttest(data = conf,
      y = confidence,
      x = type,
      dir = "two.sided")


### Sampling ----------------------------------------------------------------

# Graph over trials
time_series(df2)
# ggsave(filename = "Output/Graphs/Exp2_timeseries.svg", device = "svg")

# Choice model
m1 <- lmmtests(.data = df2,
               dv = "choice",
               between = "condition * (trial_reduced + I(trial_reduced^2))")
summary(m1)

m2 <- lmmtests(.data = df2, dv = "shift", between = "condition * bin_out")
m3 <- lmmtests(.data = df2, dv = "shift", between = "condition + bin_out + extremity")
m4 <- lmmtests(.data = df2, dv = "shift", between = "condition * bin_out * extremity")
anova(m2, m4)
summary(m3)
summary(m4)

# Formatted coefficient table
# m4 %>% summary() %>% coeftable()

### Relative contingency estimate -----------------------------------------------------

exp2_pg3 <- df2 %>%
  ggplot(aes(x = condition,
             y = postpref_freq,
             fill = condition)) +
  geom_violin() + 
  geom_boxplot(width = 0.2) +
  geom_jitter(size = 0.5, width = 0.2) +
  geom_hline(yintercept = 0, linetype = 2) +
  scale_fill_manual(values = pal) +
  theme_apa() +
  labs(x = "Condition",
       y = "Relative contingency estimates") +
  theme(legend.position = "none")

exp2_pg4 <- df2 %>%
  ggplot(aes(x = condition,
             y = postcond_dp,
             fill = condition)) +
  geom_violin() + 
  geom_boxplot(width = 0.2) +
  geom_jitter(size = 0.5, width = 0.2) +
  geom_hline(yintercept = 0, linetype = 2) +
  scale_fill_manual(values = pal) +
  theme_apa() +
  labs(x = "Condition",
       y = expression(Delta*"P from conditional probability estimates")) +
  theme(legend.position = "none")

# grid.arrange(exp2_pg3, exp2_pg4, ncol = 2) %>%
#   ggsave(plot = ., filename = "Output/Graphs/Exp2_postprefcond.svg", device = "svg", dpi = 320, width = 9.08, height = 5.72)

## Descriptives

# Means and sds
df2 %>%
  group_by(condition) %>%
  summarise(post_avg = printnum(mean(postpref_freq)),
            post_SD = printnum(sd(postpref_freq)))

## Rich
df2 %>%
  filter(condition == "rich") %>%
  as.data.frame() %$%
  ttestBF(postpref_freq,
          mu = 0,
          nullInterval = c(0, Inf)) %>%
  printBFt()
ttest(data = df2,
      y = postpref_freq,
      x = condition,
      mu = 0,
      sub = "rich",
      dir = "greater")

## Impoverished
df2 %>%
  filter(condition == "impoverished") %>%
  as.data.frame() %$%
  ttestBF(postpref_freq,
          mu = 0,
          nullInterval = c(-Inf, Inf)) %>%
  printBFt()
ttest(data = df2,
      y = postpref_freq,
      x = condition,
      mu = 0,
      sub = "impoverished",
      dir = "two.sided")

## Strength
df2 %>%
  as.data.frame() %>%
  ttestBF(formula = postpref_freq ~ condition,
          nullInterval = c(0, Inf),
          data = .) %>%
  printBFt()
ttest(data = df2,
      y = postpref_freq,
      x = condition,
      dir = "greater")

## Overall
df2 %>%
  as.data.frame() %$%
  ttestBF(postpref_freq,
          mu = 0,
          nullInterval = c(0, Inf)) %>%
  printBFt()
ttest(data = df2,
      y = postpref_freq,
      x = condition,
      mu = 0,
      dir = "greater")


### Conditional probability estimates -----------------------------------------------------

## Descriptives

# Means and sds
df2 %>%
  group_by(condition) %>%
  summarise(post_avg = printnum(mean(postcond_dp)),
            post_SD = printnum(sd(postcond_dp)))

df2 %>%
  mutate(frequent = postcond_freq,
         infrequent = ifelse(primacy == "street", park_cond, street_cond)) %>%
  group_by(condition) %>%
  summarise(freq_loc = printnum(mean(frequent)),
            freq_sd = printnum(sd(frequent)),
            infreq_loc = printnum(mean(infrequent)),
            infreq_sd = printnum(sd(infrequent)),
            # test:
            dp = printnum((mean(frequent) - mean(infrequent)) / 100))

## Rich
df2 %>%
  filter(condition == "rich") %>%
  as.data.frame() %$%
  ttestBF(postcond_dp,
          mu = 0,
          nullInterval = c(0, Inf)) %>%
  printBFt()
ttest(data = df2,
      y = postcond_dp,
      x = condition,
      mu = 0,
      sub = "rich",
      dir = "greater")

## Impoverished
df2 %>%
  filter(condition == "impoverished") %>%
  as.data.frame() %$%
  ttestBF(postcond_dp,
          mu = 0,
          nullInterval = c(-Inf, Inf)) %>%
  printBFt()
ttest(data = df2,
      y = postcond_dp,
      x = condition,
      mu = 0,
      sub = "impoverished",
      dir = "two.sided")

## Strength
df2 %>%
  as.data.frame() %>%
  ttestBF(formula = postcond_dp ~ condition,
          nullInterval = c(0, Inf),
          data = .) %>%
  printBFt()
ttest(data = df2,
      y = postcond_dp,
      x = condition,
      dir = "greater")

## Overall
df2 %>%
  as.data.frame() %$%
  ttestBF(postcond_dp,
          mu = 0,
          nullInterval = c(0, Inf)) %>%
  printBFt()
ttest(data = df2,
      y = postcond_dp,
      x = condition,
      mu = 0,
      dir = "greater")

### Confidence post----

# Descriptives
conf <- df2 %>%
  group_by(condition) %>%
  mutate(conf_post_fr = postconf_freq,
         conf_post_in = postconf_infreq) %>%
  ungroup %>%
  select(condition, conf_post_fr, conf_post_in) %>%
  pivot_longer(cols = c(conf_post_fr, conf_post_in),
               names_to = "type",
               values_to = "confidence")

conf %>%
  group_by(type) %>%
  summarize(post_conf_avg = printnum(mean(confidence)),
            post_conf_sd  = printnum(sd(confidence)))

# Inference tests
conf %>%
  as.data.frame() %$%
  ttestBF(data = .,
          formula = confidence ~ type,
          nullInterval = c(-Inf, Inf)) %>%
  printBFt()
ttest(data = conf,
      y = confidence,
      x = type,
      dir = "two.sided")

### Predictability -----------------------------------------------------

## Descriptives

# Means and sds
df2 %>%
  group_by(condition) %>%
  summarise(post_avg = printnum(mean(postpred_dp)),
            post_SD = printnum(sd(postpred_dp)))

## Rich
df2 %>%
  filter(condition == "rich") %>%
  as.data.frame() %$%
  ttestBF(postpred_dp,
          mu = 0,
          nullInterval = c(0, Inf)) %>%
  printBFt()
ttest(data = df2,
      y = postpred_dp,
      x = condition,
      mu = 0,
      sub = "rich",
      dir = "greater")

## Impoverished

df2 %>%
  filter(condition == "impoverished") %>%
  as.data.frame() %$%
  ttestBF(postpred_dp,
          mu = 0,
          nullInterval = c(-Inf, Inf)) %>%
  printBFt()
ttest(data = df2,
      y = postpred_dp,
      x = condition,
      mu = 0,
      sub = "impoverished",
      dir = "two.sided")

## Strength

df2 %>%
  as.data.frame() %>%
  ttestBF(formula = postpred_dp ~ condition,
          nullInterval = c(0, Inf),
          data = .) %>%
  printBFt()
ttest(data = df2,
      y = postpred_dp,
      x = condition,
      dir = "greater")

## Overall

df2 %>%
  as.data.frame() %$%
  ttestBF(postpred_dp,
          mu = 0,
          nullInterval = c(0, Inf)) %>%
  printBFt()
ttest(data = df2,
      y = postpred_dp,
      x = condition,
      mu = 0,
      dir = "greater")

### Control -----------------------------------------------------

## Descriptives

# Means and sds
df2 %>%
  group_by(condition) %>%
  summarise(post_avg = printnum(mean(postctrl_dp)),
            post_SD = printnum(sd(postctrl_dp)))

## Rich
df2 %>%
  filter(condition == "rich") %>%
  as.data.frame() %$%
  ttestBF(postctrl_dp,
          mu = 0,
          nullInterval = c(0, Inf)) %>%
  printBFt()
ttest(data = df2,
      y = postctrl_dp,
      x = condition,
      mu = 0,
      sub = "rich",
      dir = "greater")

## Impoverished

df2 %>%
  filter(condition == "impoverished") %>%
  as.data.frame() %$%
  ttestBF(postctrl_dp,
          mu = 0,
          nullInterval = c(-Inf, Inf)) %>%
  printBFt()
ttest(data = df2,
      y = postctrl_dp,
      x = condition,
      mu = 0,
      sub = "impoverished",
      dir = "two.sided")

## Strength

df2 %>%
  as.data.frame() %>%
  ttestBF(formula = postctrl_dp ~ condition,
          nullInterval = c(0, Inf),
          data = .) %>%
  printBFt()
ttest(data = df2,
      y = postctrl_dp,
      x = condition,
      dir = "greater")

## Overall

df2 %>%
  as.data.frame() %$%
  ttestBF(postctrl_dp,
          mu = 0,
          nullInterval = c(0, Inf)) %>%
  printBFt()
ttest(data = df2,
      y = postctrl_dp,
      x = condition,
      mu = 0,
      dir = "greater")

### Post hoc analyses----
### Conditions
df2_post <- df2 %>%
  mutate(dummy1 = ifelse(prepref_freq > 0, 1, 0),
         dummy2 = condition) %>%
  mutate(cond = ifelse(dummy2 == "rich", 2, dummy1)) %>%
  mutate(cond = factor(cond,
                       levels = c(2, 1, 0),
                       labels = c("rich", "impRB", "impPC"))) %>%
  select(-c(dummy1, dummy2))

### Graph
df2_post %>%
  mutate(condition = cond) %>%
  time_series()
# ggsave(filename = "Output/Graphs/Exp2_posthoc.svg", device = "svg")

### Sampling

# Strength
df2_post %>%
  filter(cond != "rich") %>%
  mutate(cond = factor(cond)) %>%
  mutate(choiceindex_per = ifelse(cond == "impRB", choiceindex_per, 1 - choiceindex_per)) %>%
  as.data.frame() %>%
  ttestBF(formula = choiceindex_per ~ cond,
          nullInterval = c(0, Inf),
          data = .) %>%
  printBFt()
df2_post %>%
  filter(cond != "rich") %>%
  mutate(cond = factor(cond)) %>%
  mutate(choiceindex_per = ifelse(cond == "impRB", choiceindex_per, 1 - choiceindex_per)) %>%
  ttest(data = .,
        y = choiceindex_per,
        x = cond,
        dir = "greater")

### Relative contingency estimate

# impRB
df2_post %>%
  filter(cond == "impRB") %>%
  as.data.frame()  %$%
  ttestBF(postpref_freq,
          mu = 0,
          nullInterval = c(0, Inf)) %>%
  printBFt()
df2_post %>%
  ttest(data = .,
        y = postpref_freq,
        x = cond,
        mu = 0,
        sub = "impRB",
        dir = "greater")

# impPC
df2_post %>%
  filter(cond == "impPC") %>%
  as.data.frame()  %$%
  ttestBF(postpref_freq,
          mu = 0,
          nullInterval = c(-Inf, Inf)) %>%
  printBFt()
df2_post %>%
  ttest(data = .,
        y = postpref_freq,
        x = cond,
        mu = 0,
        sub = "impPC",
        dir = "two.sided")

# Strength
df2_post %>%
  filter(cond != "rich") %>%
  mutate(cond = factor(cond)) %>%
  as.data.frame() %>%
  ttestBF(formula = postpref_freq ~ cond,
          nullInterval = c(0, Inf),
          data = .) %>%
  printBFt()
df2_post %>%
  filter(cond != "rich") %>%
  mutate(cond = factor(cond)) %>%
  ttest(data = .,
        y = postpref_freq,
        x = cond,
        dir = "greater")

### Conditional probability estimates
# impRB
df2_post %>%
  filter(cond == "impRB") %>%
  as.data.frame()  %$%
  ttestBF(postcond_dp,
          mu = 0,
          nullInterval = c(0, Inf)) %>%
  printBFt()
df2_post %>%
  ttest(data = .,
        y = postcond_dp,
        x = cond,
        mu = 0,
        sub = "impRB",
        dir = "greater")

# impPC
df2_post %>%
  filter(cond == "impPC") %>%
  as.data.frame()  %$%
  ttestBF(postcond_dp,
          mu = 0,
          nullInterval = c(-Inf, Inf)) %>%
  printBFt()
df2_post %>%
  ttest(data = .,
        y = postcond_dp,
        x = cond,
        mu = 0,
        sub = "impPC",
        dir = "two.sided")

# Strength
df2_post %>%
  filter(cond != "rich") %>%
  mutate(cond = factor(cond)) %>%
  as.data.frame() %>%
  ttestBF(formula = postcond_dp ~ cond,
          nullInterval = c(0, Inf),
          data = .) %>%
  printBFt()
df2_post %>%
  filter(cond != "rich") %>%
  mutate(cond = factor(cond)) %>%
  ttest(data = .,
        y = postcond_dp,
        x = cond,
        dir = "greater")
