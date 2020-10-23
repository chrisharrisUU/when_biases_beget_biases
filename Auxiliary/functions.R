# Mixed model helper function
lmmtests <- function(.data, dv = "nextchoice", between, within = "(1|Participant.id)", filtered) {
  # Catch and build formula
  ivs = paste(between, "+", within)
  full_formula <- paste(dv, "~", ivs)
  
  # Range
  z <- colnames(.data) %>%
    .[grep("week", .)] %>%
    substr(., 5, nchar(.)) %>%
    as.integer(.) %>%
    min(.) - 1
  
  # Prepare data
  .data %>%
    # Counterbalance
    mutate(across(contains("week"), ~ifelse(primacy == "park", .x, (-1) * .x))) %>%
    # Drop unnecessary columns and rename
    select(Participant.id, condition, contains("week"), contains("output")) %>%
    rename_with(., ~gsub("week", "week_", .x)) %>%
    rename_with(., ~gsub("output", "output_", .x)) %>%
    rename_with(~paste0("output_",
                        z + as.double(substr(.x, 8, 9))),
                .cols = contains("output")) %>%
    # Long format
    pivot_longer(cols = -c(Participant.id, condition),
                 names_to = c(".value", "trial"),
                 names_sep = "_",
                 values_drop_na = TRUE) %>%
    rename(choice  = week,
           output_backup = output) %>%
    # Correct output
    group_by(Participant.id) %>%
    mutate(output = lead(output_backup)) %>%
    filter(trial != 100) %>%
    # Format
    mutate(choice = ifelse(choice == -1, 0, choice),
           trial = as.double(trial),
           feedback = case_when(output == 1  ~ -6,
                                output == 2  ~ -5,
                                output == 3  ~ -4,
                                output == 4  ~ -3,
                                output == 5  ~ -2,
                                output == 8  ~ 2,
                                output == 9  ~ 3,
                                output == 10 ~ 4,
                                output == 11 ~ 5,
                                output == 12 ~ 6)) %>%
    mutate(bin_out = ifelse(output < 8, -1, 1),
           extremity = abs(feedback) - 1) %>%
    mutate(nextchoice = lead(choice)) %>%
    mutate(stay = ifelse(choice == nextchoice, 1, 0),
           shift = ifelse(choice != nextchoice, 1, 0)) %>%
    # Determine next choice, relevel condition, scale trial, handle INFs
    mutate(condition = relevel(condition, ref = "impoverished"),
           trial_reduced = (trial - (z + 1)) / 100) %>%
    # Run GLM
    glmer(full_formula, family = binomial, data = ., glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 100000)))
}

# Draw graph for mixed models helper
draw_prep <- function(.data) {
  # Range
  z <- colnames(.data) %>%
    .[grep("week", .)] %>%
    substr(., 5, nchar(.)) %>%
    as.integer(.) %>%
    min(.) - 1
  
  # Prepare data
  .data %>%
    # Counterbalance
    # mutate(across(contains("week"), ~ifelse(primacy == "park", .x, (-1) * .x))) %>%
    # Drop unnecessary columns and rename
    select(Participant.id, condition, contains("week"), contains("output")) %>%
    rename_with(., ~gsub("week", "week_", .x)) %>%
    rename_with(., ~gsub("output", "output_", .x)) %>%
    rename_with(~paste0("output_",
                        z + as.double(substr(.x, 8, 9))),
                .cols = contains("output")) %>%
    # Long format
    pivot_longer(cols = -c(Participant.id, condition),
                 names_to = c(".value", "trial"),
                 names_sep = "_",
                 values_drop_na = TRUE) %>%
    rename(choice  = week,
           output_backup = output) %>%
    # Correct output
    group_by(Participant.id) %>%
    mutate(output = lead(output_backup)) %>%
    filter(trial != 100) %>%
    # Format
    mutate(choice = ifelse(choice == -1, 0, choice),
           trial = as.double(trial),
           feedback = case_when(output == 1  ~ -6,
                                output == 2  ~ -5,
                                output == 3  ~ -4,
                                output == 4  ~ -3,
                                output == 5  ~ -2,
                                output == 8  ~ 2,
                                output == 9  ~ 3,
                                output == 10 ~ 4,
                                output == 11 ~ 5,
                                output == 12 ~ 6)) %>%
    mutate(bin_out = ifelse(output < 8, -1, 1),
           extremity = abs(feedback) - 1) %>%
    mutate(nextchoice = lead(choice)) %>%
    mutate(stay = ifelse(choice == nextchoice, 1, 0),
           shift = ifelse(choice != nextchoice, 1, 0)) %>%
    # Determine next choice, relevel condition, scale trial, handle INFs
    mutate(condition = relevel(condition, ref = "impoverished"),
           trial_reduced = (trial - (z + 1)) / 100)
}

# Time series functions
# Data prep: Counterbalance, long format
prep <- function(x) {
  # Range
  weeks <- colnames(x) %>%
    .[grep("week", .)] %>%
    substr(., 5, nchar(.)) %>%
    as.integer(.)
  from <- min(weeks)
  to <- max(weeks)
  x %>%
    select(Participant.id, condition, primacy, contains("week")) %>%
    # Counterbalancing
    mutate_at(.vars = vars(contains("week")),
              .funs = ~ifelse(primacy == "street", . * (-1), .)) %>%
    # # Dominant
    # mutate_at(.vars = vars(contains("week")),
    #           .funs = funs(ifelse(condition == "rich", ., . * (-1)))) %>%
    # 0 - 1 for percentages
    mutate_at(.vars = vars(contains("week")),
              .funs = ~ifelse(. < 0, 0, 1)) %>%
    group_by(condition) %>%
    # Summarize percentage positive hits
    summarize_at(.vars = vars(contains("week")),
                 .funs = ~mean(., na.rm = TRUE)) %>%
    # Long format
    gather(key = time,
           value = sampling,
    # As integer for time series graph
           paste0("week", from:to)) %>%
    mutate(time = as.integer(substr(time, 5, nchar(time))))
}

time_series <- function(df) {
  # Range
  weeks <- colnames(df) %>%
    .[grep("week", .)] %>%
    substr(., 5, nchar(.)) %>%
    as.integer(.)
  from <- min(weeks)
  to <- max(weeks)
  
  # Data prep
  data <- prep(df)
  
  # Create graph
  ggplot(data,
         aes(x = time,
             y = sampling,
             color = condition)) +
    # geom_hline(yintercept = .5,
    #                alpha = .3) +
    geom_segment(aes(x = 5,
                     xend = 100,
                     y = .5,
                     yend = .5),
                 color = "#999999",
                 size = .1) +
    geom_point(size = .9) +
    geom_line(size = .2,
              alpha = .3) +
    geom_smooth(method = "loess",
                span = 1,
                size = 1,
                formula = "y ~ x") +
    scale_color_manual(values = pal) +
    theme_apa() +
    labs(y = "Percentage sampling frequent option",
         x = "Trial")
}

# Import functions from GitHub
# https://stackoverflow.com/a/35720824/10357426
source_https <- function(u, unlink.tmp.certs = FALSE) {
  # load package
  if (!require(RCurl)) {install.packages("RCurl"); library(RCurl)}

  # read script lines from website using a security certificate
  if (!file.exists(here("Auxiliary/cacert.pem"))) {
    download.file(url = "http://curl.haxx.se/ca/cacert.pem", destfile = here("Auxiliary/cacert.pem"))
  }
  script <- getURL(u, followlocation = TRUE, cainfo = here("Auxiliary/cacert.pem"))
  if (unlink.tmp.certs) {unlink(here("Auxiliary/cacert.pem"))}

  # parase lines and evealuate in the global environement
  eval(parse(text = script), envir = .GlobalEnv)
}

# My functions for outputting inference tests in APAish style
source_https("https://raw.githubusercontent.com/chrisharrisUU/testoutputs/master/functions.R")

# Helper for easy viewing of regression coefficients
coeftable <- function(sum_data) {
  tab <- sum_data$coefficients
  coeffs <- attr(tab, "dimnames")[[1]]
  tab %>%
    as_tibble() %>%
    mutate(across(-c("Pr(>|z|)"), ~round(.x, 2))) %>%
    mutate(across(c("Pr(>|z|)"), ~ifelse(.x < .001, "<.001", as.character(round(.x, 3))))) %>%
    mutate(coefficients = coeffs) %>%
    relocate("coefficients") %>%
    rename(`p value` = `Pr(>|z|)`) %>%
    knitr::kable(caption = "Mixed model") %>%
    kableExtra::kable_styling(bootstrap_options = "hover", full_width = F, position = "center")
}
