library(rlang)

robustness <- function(data, variable, cond = "rich", dir = "10", report = "all", mu = .5) {
  # Setup -------------------------------------------------------------------
  if (dir == "+0") {
    interval <- c(0, Inf)
  } else if (dir == "01") {
    interval <- c(-Inf, Inf)
  } else if (dir == "-0") {
    interval <- c(-Inf, 0)
  } else {
    warning("Error with dir")
  }
  
  if (cond == "compare") {
    btest <- function(c = "medium") {
      x <- data %>%
        as.data.frame() %>%
        select(var = {{variable}},
               condition)
      
      ttestBF(formula = var ~ condition,
              nullInterval = interval,
              rscale = c,
              data = x)
    }
  } else if (cond == "all") {
    btest <- function(c = "medium") {
      x <- data %>%
        as.data.frame() %>%
        select(var = {{variable}}) %>%
        unlist()
      
      ttestBF(x,
              mu = mu,
              nullInterval = interval,
              rscale = c)
    }
  } else {
    btest <- function(c = "medium") {
      x <- data %>%
        filter(condition == cond) %>%
        as.data.frame() %>%
        select({{variable}}) %>%
        unlist()
      
      ttestBF(x,
              mu = mu,
              nullInterval = interval,
              rscale = c)
    }
  }
  
  
  # Variables -------------------------------------------------------------------------
  runs <- 100
  BF <- vector(mode = "numeric", length = runs)
  r <- seq(0, 1.5, length.out = runs)
  r[1] <- sqrt(2) / 2
  
  
  # Run robustness tests ----------------------------------------------------
  for (i in 1:runs) {
    output <- btest(r[i])
    if (dir == "10" | dir == "+0" | dir == "-0") {
      BF[i] <- as.vector(output[1]) # BF10
    } else {
      BF[i] <- 1/as.vector(output[1]) # BF01
    }
  }
  
  df <- tibble(r, BF)
  
  
  # Run main test -----------------------------------------------------------
  # Test
  test <- btest() %>%
    printBFt()
  
  # Robustness interval
  if (nrow(filter(df, BF >= 3)) == 0) {
    rob <- c(NA, NA)
  } else {
    rob <- df %>%
      filter(BF >= 3) %>%
      summarize(min = printnum(min(r)),
                max = printnum(max(r))) %>%
      as.vector()
  }
  
  
  # Outputs ------------------------------------------------------------------
  
  # Plot
  p <- ggplot(df) +
    geom_line(aes(x = r,
                  y = BF)) +
    geom_point(data = df[1,],
               aes(x = r,
                   y = BF),
               color = "red") +
    geom_hline(yintercept = 3,
               linetype = "dashed") +
    theme_apa() +
    labs(x = "Cauchy Prior Width (r)",
         y = "Bayes Factor (+0)") +
    annotate(geom = "text",
             x = 1,
             y = 6.5,
             label = "* Default Prior\n- - Stopping Rule")
  
  # Interval
  i <- paste0(test, ", robustness inverval: [", rob[1], ", ", rob[2], "]")
  
  # Report
  if (report == "all") {
    list(p, i)
  } else if (report == "graph") {
    p
  } else if (report == "interval") {
    i
  } else {
    paste("Unknown output")
  }
  
}


# Examples
robustness(df3, choiceindex_per, cond = "rich", dir = "+0", report = "interval")
robustness(df3, choiceindex_per, cond = "impoverished", dir = "01", report = "interval")
robustness(df3, choiceindex_per, cond = "compare", dir = "+0", report = "interval")

robustness(df3, choiceindex_per, cond = "all", dir = "+0", report = "interval")
robustness(df3, postpref_freq, cond = "all", dir = "+0", report = "interval", mu = 0)
robustness(df3, postcond_dp, cond = "all", dir = "+0", report = "interval", mu = 0)
