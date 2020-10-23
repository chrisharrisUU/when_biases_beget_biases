### Setup----
# Dependencies
if (!require(needs)) {install.packages("needs"); library(needs)}
if (!require(goallabr)) {
  if (!require(devtools)) {install.packages("devtools"); library(devtools)}
  install_github("chrisharrisUU/goallabr")
}
needs(BayesFactor, dplyr, ggplot2, ggsci, goallabr, gridExtra, here, lme4, lmerTest, magrittr, papaja, tidyr)
prioritize(dplyr)

# Data import
source("Auxiliary/Exp3_import.r")
rm(as.data.frame.avector, `[.avector`)

# Remove not completed cases
data3 %<>%
  filter(MODE == "interview") %>% # exclude early test cases
  mutate(date = as.numeric(format(LASTDATA, format = "%d"))) %>% # get day
  mutate(time = abs(as.numeric(format(LASTDATA, format = "%M")) - as.numeric(format(STARTED, format = "%M")))) %>%
  # absolute value for times around the full hour
  filter(date > 2 & date < 10) %>% # exclude test phase
  filter(DM04_01 != 999) %>% # last test cases
  filter(time > 5 & time < 55) # took less than 5 minutes

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
  colnames(freeselection) <- paste("week", 5:100, sep = "")
  # Create selection index
  freeselection <- freeselection %>%
    mutate(choiceindex_raw = rowSums(., na.rm = TRUE))
  
  # DV Preference
  # street |--------| park
  preference_raw <- data %>%
    mutate(adjusted = DV01_01 - 1) %>%
    select(adjusted) %>%
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
  data.frame(Participant.id, session_id, condition, primacy, account, freeselection, preference_raw, conditionals, confidence, control, predictability, dem)
}
df3 <- column.rename(data3)
rm(column.rename)

# Color palette for graphs
pal <- ggsci::pal_uchicago()(5)[c(3, 5, 1)]

### Functions----
source("Auxiliary/functions.R")

### Canonical sorting----

df3 %<>%
  # frequent
  mutate(postpref1        = ifelse(primacy == "street", 100 - preference_raw, preference_raw),
         choiceindex_freq = ifelse(primacy == "street", choiceindex_raw * (-1), choiceindex_raw),
         postcond_freq    = ifelse(primacy == "street", street_cond, park_cond),
         postcond_infreq  = ifelse(primacy == "street", park_cond, street_cond),
         postconf_freq    = ifelse(primacy == "street", street_conf, park_conf),
         postconf_infreq  = ifelse(primacy == "street", park_conf, street_conf),
         postctrl_freq    = ifelse(primacy == "street", street_ctrl, park_ctrl),
         postctrl_infreq  = ifelse(primacy == "street", park_ctrl, street_ctrl),
         postpred_freq    = ifelse(primacy == "street", street_pred, park_pred),
         postpred_infreq  = ifelse(primacy == "street", park_pred, street_pred)) %>%
  # delta p
  mutate(postcond_1       = postcond_freq - postcond_infreq,
         postconf_1       = postconf_freq - postconf_infreq,
         postctrl_1       = postctrl_freq - postctrl_infreq,
         postpred_1       = postpred_freq - postpred_infreq) %>%
  # shift
  mutate(postpref_freq    = postpref1 - 50,
         postcond_dp      = postcond_1 / 100,
         postconf_dp      = postconf_1 / 100,
         postctrl_dp      = postctrl_1 / 100,
         postpred_dp      = postpred_1 / 100) %>%
  # dominant
  mutate(postpref_dom     = ifelse(condition == "rich", postpref_freq, postpref_freq * (-1)),
         choiceindex_dom  = ifelse(condition == "rich", choiceindex_freq, choiceindex_freq * (-1)),
         postcond_dp_dom  = ifelse(condition == "rich", postcond_dp, postcond_dp * (-1)),
         postconf_dp_dom  = ifelse(condition == "rich", postconf_dp, postconf_dp * (-1)),
         postctrl_dp_dom  = ifelse(condition == "rich", postctrl_dp, postctrl_dp * (-1)),
         postpred_dp_dom  = ifelse(condition == "rich", postpred_dp, postpred_dp * (-1))) %>%
  # sampling as percentage
  mutate(choiceindex_per  = (choiceindex_freq + 96) / (96 * 2))

### Demographic data----
# Summary of most relevant demographic data
df3 %>%
  mutate(age = as.integer(as.character(age))) %>%
  summarise(N = n(),
            female = length(which(gender == "female")),
            age_mean = mean(age, na.rm = TRUE),
            age_sd = sd(age, na.rm = TRUE),
            Psychstudents_percent = length(which(psych == "Yes")) / n(),
            Attention_Check_percent = length(which(attcheck == "I disagree")) / n())

# Level of education
df3 %>%
  group_by(edu) %>%
  summarise(count = length(edu))
# Percentage degree
length(which(as.integer(df3$edu) > 2)) / nrow(df3)

### Sampling ----------------------------------------------------------------

# Graph over trials
time_series(df3)
# ggsave(filename = "Output/Graphs/Exp3_timeseries.svg", device = "svg")

# Choice model
m1 <- lmmtests(.data = df3,
               dv = "choice",
               between = "condition * (trial_reduced + I(trial_reduced^2))")
summary(m1)

m2 <- lmmtests(.data = df3, dv = "shift", between = "condition * bin_out")
m3 <- lmmtests(.data = df3, dv = "shift", between = "condition + bin_out + extremity")
m4 <- lmmtests(.data = df3, dv = "shift", between = "condition * bin_out * extremity")
anova(m2, m4)
summary(m3)
summary(m4)

# Formatted coefficient table
# m4 %>% summary() %>% coeftable()

### Relative contingency estimate -----------------------------------------------------

exp3_pg1 <- df3 %>%
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

exp3_pg2 <- df3 %>%
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

# grid.arrange(exp3_pg1, exp3_pg2, ncol = 2) %>%
#   ggsave(plot = ., filename = "Output/Graphs/Exp3_postprefcond.svg", device = "svg", dpi = 320, width = 9.08, height = 5.72)

## Descriptives

# Means and sds
df3 %>%
  group_by(condition) %>%
  summarise(post_avg = printnum(mean(postpref_freq)),
            post_SD = printnum(sd(postpref_freq)))

## Rich
df3 %>%
  filter(condition == "rich") %>%
  as.data.frame() %$%
  ttestBF(postpref_freq,
          mu = 0,
          nullInterval = c(0, Inf)) %>%
  printBFt()
ttest(data = df3,
      y = postpref_freq,
      x = condition,
      mu = 0,
      sub = "rich",
      dir = "greater")

## Impoverished
df3 %>%
  filter(condition == "impoverished") %>%
  as.data.frame() %$%
  ttestBF(postpref_freq,
          mu = 0,
          nullInterval = c(-Inf, Inf)) %>%
  printBFt()
ttest(data = df3,
      y = postpref_freq,
      x = condition,
      mu = 0,
      sub = "impoverished",
      dir = "two.sided")

## Strength
df3 %>%
  mutate(postpref_freq = ifelse(condition == "rich", postpref_freq, (-1) * postpref_freq)) %>%
  as.data.frame() %>%
  ttestBF(formula = postpref_freq ~ condition,
          nullInterval = c(0, Inf),
          data = .) %>%
  printBFt()
df3 %>%
  mutate(postpref_freq = ifelse(condition == "rich", postpref_freq, (-1) * postpref_freq)) %>%
  ttest(data = .,
        y = postpref_freq,
        x = condition,
        dir = "greater")

## Overall
df3 %>%
  as.data.frame() %$%
  ttestBF(postpref_freq,
          mu = 0,
          nullInterval = c(0, Inf)) %>%
  printBFt()
ttest(data = df3,
      y = postpref_freq,
      x = condition,
      mu = 0,
      dir = "greater")

### Conditional probability estimates -----------------------------------------------------

## Descriptives

# Means and sds
df3 %>%
  group_by(condition) %>%
  summarise(post_avg = printnum(mean(postcond_dp)),
            post_SD = printnum(sd(postcond_dp)))

df3 %>%
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
df3 %>%
  filter(condition == "rich") %>%
  as.data.frame() %$%
  ttestBF(postcond_dp,
          mu = 0,
          nullInterval = c(0, Inf)) %>%
  printBFt()
ttest(data = df3,
      y = postcond_dp,
      x = condition,
      mu = 0,
      sub = "rich",
      dir = "greater")

## Impoverished
df3 %>%
  filter(condition == "impoverished") %>%
  as.data.frame() %$%
  ttestBF(postcond_dp,
          mu = 0,
          nullInterval = c(-Inf, Inf)) %>%
  printBFt()
ttest(data = df3,
      y = postcond_dp,
      x = condition,
      mu = 0,
      sub = "impoverished",
      dir = "two.sided")

## Strength
df3 %>%
  mutate(postcond_dp = ifelse(condition == "rich", postcond_dp, (-1) * postcond_dp)) %>%
  as.data.frame() %>%
  ttestBF(formula = postcond_dp ~ condition,
          nullInterval = c(0, Inf),
          data = .) %>%
  printBFt()
df3 %>%
  mutate(postcond_dp = ifelse(condition == "rich", postcond_dp, (-1) * postcond_dp)) %>%
  ttest(data = .,
        y = postcond_dp,
        x = condition,
        dir = "greater")

## Overall
df3 %>%
  as.data.frame() %$%
  ttestBF(postcond_dp,
          mu = 0,
          nullInterval = c(0, Inf)) %>%
  printBFt()
ttest(data = df3,
      y = postcond_dp,
      x = condition,
      mu = 0,
      dir = "greater")

### Confidence----

# Means and sds
df3 %>%
  group_by(condition) %>%
  summarise(post_avg = mean(postconf_dp),
            post_SD = sd(postconf_dp))

conf <- df3 %>%
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

### Inference tests
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
df3 %>%
  group_by(condition) %>%
  summarise(post_avg = printnum(mean(postpred_dp)),
            post_SD = printnum(sd(postpred_dp)))

## Rich
df3 %>%
  filter(condition == "rich") %>%
  as.data.frame() %$%
  ttestBF(postpred_dp,
          mu = 0,
          nullInterval = c(0, Inf)) %>%
  printBFt()
ttest(data = df3,
      y = postpred_dp,
      x = condition,
      mu = 0,
      sub = "rich",
      dir = "greater")

## Impoverished

df3 %>%
  filter(condition == "impoverished") %>%
  as.data.frame() %$%
  ttestBF(postpred_dp,
          mu = 0,
          nullInterval = c(-Inf, Inf)) %>%
  printBFt()
ttest(data = df3,
      y = postpred_dp,
      x = condition,
      mu = 0,
      sub = "impoverished",
      dir = "two.sided")

## Strength

df3 %>%
  as.data.frame() %>%
  ttestBF(formula = postpred_dp ~ condition,
          nullInterval = c(0, Inf),
          data = .) %>%
  printBFt()
ttest(data = df3,
      y = postpred_dp,
      x = condition,
      dir = "greater")

## Overall

df3 %>%
  as.data.frame() %$%
  ttestBF(postpred_dp,
          mu = 0,
          nullInterval = c(0, Inf)) %>%
  printBFt()
ttest(data = df3,
      y = postpred_dp,
      x = condition,
      mu = 0,
      dir = "greater")

### Control -----------------------------------------------------

## Descriptives

# Means and sds
df3 %>%
  group_by(condition) %>%
  summarise(post_avg = printnum(mean(postctrl_dp)),
            post_SD = printnum(sd(postctrl_dp)))

## Rich
df3 %>%
  filter(condition == "rich") %>%
  as.data.frame() %$%
  ttestBF(postctrl_dp,
          mu = 0,
          nullInterval = c(0, Inf)) %>%
  printBFt()
ttest(data = df3,
      y = postctrl_dp,
      x = condition,
      mu = 0,
      sub = "rich",
      dir = "greater")

## Impoverished

df3 %>%
  filter(condition == "impoverished") %>%
  as.data.frame() %$%
  ttestBF(postctrl_dp,
          mu = 0,
          nullInterval = c(-Inf, Inf)) %>%
  printBFt()
ttest(data = df3,
      y = postctrl_dp,
      x = condition,
      mu = 0,
      sub = "impoverished",
      dir = "two.sided")

## Strength

df3 %>%
  as.data.frame() %>%
  ttestBF(formula = postctrl_dp ~ condition,
          nullInterval = c(0, Inf),
          data = .) %>%
  printBFt()
ttest(data = df3,
      y = postctrl_dp,
      x = condition,
      dir = "greater")

## Overall

df3 %>%
  as.data.frame() %$%
  ttestBF(postctrl_dp,
          mu = 0,
          nullInterval = c(0, Inf)) %>%
  printBFt()
ttest(data = df3,
      y = postctrl_dp,
      x = condition,
      mu = 0,
      dir = "greater")
