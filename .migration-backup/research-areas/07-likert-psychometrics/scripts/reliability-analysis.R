# ==============================================================================
# Reliability Analysis for Likert Scales
# ==============================================================================
# Purpose: Assess internal consistency using Cronbach's alpha
# ==============================================================================

library(tidyverse)
library(psych)

# ------------------------------------------------------------------------------
# 1. PREPARE SCALE ITEMS
# ------------------------------------------------------------------------------

# Define your scale items (adjust variable names to your survey)
# Include reversed items (_rev suffix) for negatively-worded items

prepare_scale <- function(data, item_vars, reverse_items = NULL, max_value = 5) {
  # Reverse code specified items
  if (!is.null(reverse_items)) {
    for (item in reverse_items) {
      rev_name <- paste0(item, "_rev")
      data[[rev_name]] <- (max_value + 1) - data[[item]]
    }
    # Replace original with reversed in item list
    item_vars <- sapply(item_vars, function(x) {
      if (x %in% reverse_items) paste0(x, "_rev") else x
    })
  }

  # Select scale items
  scale_items <- data %>% select(all_of(item_vars))

  return(list(data = data, scale_items = scale_items, item_vars = item_vars))
}

# ------------------------------------------------------------------------------
# 2. CALCULATE CRONBACH'S ALPHA
# ------------------------------------------------------------------------------

run_reliability_analysis <- function(scale_items, scale_name = "Scale") {
  cat("==============================================================================\n")
  cat(paste("Reliability Analysis:", scale_name, "\n"))
  cat("==============================================================================\n\n")

  # Run alpha
  alpha_result <- alpha(scale_items)

  # Print summary
  cat("Overall Cronbach's Alpha:", round(alpha_result$total$raw_alpha, 3), "\n")
  cat("Standardized Alpha:", round(alpha_result$total$std.alpha, 3), "\n\n")

  # Interpretation
  alpha_val <- alpha_result$total$raw_alpha
  interpretation <- case_when(
    alpha_val >= 0.90 ~ "Excellent",
    alpha_val >= 0.80 ~ "Good",
    alpha_val >= 0.70 ~ "Acceptable",
    alpha_val >= 0.60 ~ "Questionable",
    alpha_val >= 0.50 ~ "Poor",
    TRUE ~ "Unacceptable"
  )
  cat("Interpretation:", interpretation, "\n\n")

  # Item statistics
  cat("Item Statistics:\n")
  cat("----------------\n")
  item_stats <- alpha_result$item.stats %>%
    as_tibble(rownames = "item") %>%
    select(item, r, r.drop)

  print(item_stats)

  # Alpha if item dropped
  cat("\n\nAlpha if Item Dropped:\n")
  cat("-----------------------\n")
  alpha_drop <- alpha_result$alpha.drop %>%
    as_tibble(rownames = "item") %>%
    select(item, raw_alpha) %>%
    mutate(
      change = raw_alpha - alpha_result$total$raw_alpha,
      recommendation = if_else(change > 0.05, "Consider removing", "Keep")
    )

  print(alpha_drop)

  # Flag problematic items
  cat("\n\nItem Review:\n")
  cat("------------\n")

  # Low item-total correlation
  low_corr <- item_stats %>% filter(r.drop < 0.30)
  if (nrow(low_corr) > 0) {
    cat("Items with low item-total correlation (<0.30):\n")
    print(low_corr$item)
  }

  # Items that would improve alpha if removed
  improve <- alpha_drop %>% filter(change > 0.05)
  if (nrow(improve) > 0) {
    cat("\nItems that would improve alpha if removed:\n")
    print(improve$item)
  }

  return(alpha_result)
}

# ------------------------------------------------------------------------------
# 3. USAGE EXAMPLE
# ------------------------------------------------------------------------------

# Example with Food Security Perception Scale:
#
# # Define items
# fsp_items <- c("fsp_1", "fsp_2", "fsp_3", "fsp_4", "fsp_5", "fsp_6", "fsp_7", "fsp_8")
# reverse_items <- c("fsp_3", "fsp_5", "fsp_7")  # Negatively-worded items
#
# # Prepare data
# prepared <- prepare_scale(data, fsp_items, reverse_items, max_value = 5)
#
# # Run analysis
# alpha_result <- run_reliability_analysis(prepared$scale_items, "Food Security Perception Scale")

# ------------------------------------------------------------------------------
# 4. CALCULATE SCALE SCORE
# ------------------------------------------------------------------------------

calculate_scale_score <- function(data, item_vars, min_items = NULL) {
  n_items <- length(item_vars)
  if (is.null(min_items)) min_items <- ceiling(n_items * 0.75)  # Default: 75% of items

  data %>%
    rowwise() %>%
    mutate(
      n_items_answered = sum(!is.na(c_across(all_of(item_vars)))),
      scale_mean = if_else(
        n_items_answered >= min_items,
        mean(c_across(all_of(item_vars)), na.rm = TRUE),
        NA_real_
      ),
      scale_sum = if_else(
        n_items_answered >= min_items,
        sum(c_across(all_of(item_vars)), na.rm = TRUE),
        NA_real_
      )
    ) %>%
    ungroup()
}

# Uncomment and run:
# data <- calculate_scale_score(prepared$data, prepared$item_vars, min_items = 6)
