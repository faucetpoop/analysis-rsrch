# ==============================================================================
# Calculate Reduced Coping Strategies Index (rCSI)
# ==============================================================================
# Purpose: Calculate rCSI using standard weights and IPC thresholds
# Reference: FSCluster rCSI Handbook
# ==============================================================================

library(tidyverse)

# ------------------------------------------------------------------------------
# 1. rCSI COPING STRATEGY WEIGHTS
# ------------------------------------------------------------------------------
# Standard universal weights

rcsi_weights <- list(
  less_preferred = 1,    # Rely on less preferred, less expensive food
  borrow_food = 2,       # Borrow food or rely on help from friends/relatives
  limit_portion = 1,     # Limit portion size at mealtime
  restrict_adult = 3,    # Restrict consumption by adults for small children
  reduce_meals = 1       # Reduce number of meals eaten per day
)

# ------------------------------------------------------------------------------
# 2. CALCULATE rCSI SCORE
# ------------------------------------------------------------------------------
# Input: Number of days each strategy was used in past 7 days (0-7)

calculate_rcsi <- function(data,
                           less_preferred_var = "coping_less_preferred",
                           borrow_food_var = "coping_borrow_food",
                           limit_portion_var = "coping_limit_portion",
                           restrict_adult_var = "coping_restrict_adult",
                           reduce_meals_var = "coping_reduce_meals") {

  data %>%
    mutate(
      # Cap days at 7
      across(c(!!sym(less_preferred_var), !!sym(borrow_food_var),
               !!sym(limit_portion_var), !!sym(restrict_adult_var),
               !!sym(reduce_meals_var)),
             ~pmin(., 7, na.rm = TRUE)),

      # Calculate weighted score
      rcsi_score = (!!sym(less_preferred_var) * rcsi_weights$less_preferred) +
                   (!!sym(borrow_food_var) * rcsi_weights$borrow_food) +
                   (!!sym(limit_portion_var) * rcsi_weights$limit_portion) +
                   (!!sym(restrict_adult_var) * rcsi_weights$restrict_adult) +
                   (!!sym(reduce_meals_var) * rcsi_weights$reduce_meals),

      # IPC Phase classification
      rcsi_ipc_phase = case_when(
        rcsi_score <= 3 ~ "Phase 1 (Minimal)",
        rcsi_score <= 18 ~ "Phase 2 (Stressed)",
        rcsi_score >= 19 ~ "Phase 3+ (Crisis or worse)"
      ),

      # Binary indicator
      rcsi_crisis = rcsi_score >= 19
    )
}

# ------------------------------------------------------------------------------
# 3. USAGE EXAMPLE
# ------------------------------------------------------------------------------

# Uncomment and run:
# data <- readRDS("data/processed/survey_clean.rds")
# data <- calculate_rcsi(data)

# ------------------------------------------------------------------------------
# 4. QUALITY CHECKS
# ------------------------------------------------------------------------------

check_rcsi <- function(data) {
  cat("rCSI Quality Checks\n")
  cat("===================\n\n")

  # Score distribution
  cat("Score Distribution:\n")
  print(summary(data$rcsi_score))

  # IPC Phase distribution
  cat("\nIPC Phase Distribution:\n")
  print(table(data$rcsi_ipc_phase, useNA = "ifany"))

  # Crisis proportion
  crisis_pct <- mean(data$rcsi_crisis, na.rm = TRUE) * 100
  cat(paste("\nHouseholds in crisis (Phase 3+):", round(crisis_pct, 1), "%\n"))

  # Check range (theoretical max = 56: all 5 strategies used all 7 days)
  out_of_range <- sum(data$rcsi_score < 0 | data$rcsi_score > 56, na.rm = TRUE)
  if (out_of_range > 0) {
    warning(paste(out_of_range, "values outside theoretical range (0-56)"))
  }
}

# Uncomment and run:
# check_rcsi(data)
